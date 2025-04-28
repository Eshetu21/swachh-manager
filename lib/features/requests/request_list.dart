import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:kabadmanager/models/delivery_partner.dart';
import 'package:kabadmanager/models/request.dart';
import 'package:kabadmanager/models/address.dart';
import 'package:kabadmanager/services/supabase_rpc_service.dart';
import 'package:kabadmanager/shared/show_snackbar.dart';
import 'package:kabadmanager/shimmering_widgets/request_tile.dart';
import 'package:kabadmanager/features/delivery/assign_partner_popup.dart';
import 'package:kabadmanager/features/requests/request_detail_page.dart';
import 'package:kabadmanager/features/requests/widgets/request_filter.dart';

class RequestWithAddress {
  final Request request;
  final Address? address;

  RequestWithAddress({required this.request, required this.address});
}

class RequestList extends StatefulWidget {
  final SortOption? sortOption;
  final DateTime? selectedDate;
  final String status;

  const RequestList(
      {super.key, required this.status, this.sortOption, this.selectedDate});

  @override
  State<RequestList> createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  late Future<List<RequestWithAddress>> _requestsWithAddresses;
  final SupabaseRpcService _rpcService = SupabaseRpcService();

  @override
  void initState() {
    super.initState();
    _requestsWithAddresses = _fetchRequestsAndAddresses();
  }

  @override
  void didUpdateWidget(covariant RequestList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.status != widget.status ||
        oldWidget.sortOption != widget.sortOption ||
        oldWidget.selectedDate != widget.selectedDate) {
      setState(() {
        _requestsWithAddresses = _fetchRequestsAndAddresses();
      });
    }
  }

  Future<List<RequestWithAddress>> _fetchRequestsAndAddresses() async {
    List<Request> requests =
        await _rpcService.fetchRequestsByStatus(widget.status);

    if (widget.selectedDate != null) {
      requests = requests.where((req) {
        final requestDate = req.requestDateTime;
        return requestDate.year == widget.selectedDate!.year &&
            requestDate.month == widget.selectedDate!.month &&
            requestDate.day == widget.selectedDate!.day;
      }).toList();
    }

    if (widget.sortOption != null) {
      switch (widget.sortOption) {
        case SortOption.newestFirst:
          requests
              .sort((a, b) => b.requestDateTime.compareTo(a.requestDateTime));
          break;
        case SortOption.oldestFirst:
          requests
              .sort((a, b) => a.requestDateTime.compareTo(b.requestDateTime));
          break;
        case SortOption.highestQuantity:
          requests.sort((a, b) => b.parsedQuantity.compareTo(a.parsedQuantity));
          break;
        case SortOption.lowestQuantity:
          requests.sort((a, b) => a.parsedQuantity.compareTo(b.parsedQuantity));
          break;
        case null:
          break;
      }
    }

    final futures = requests.map((req) async {
      final address = await _rpcService.fetchAddressById(req.addressId);
      return RequestWithAddress(request: req, address: address);
    }).toList();

    return await Future.wait(futures);
  }

  Future<void> _refreshData() async {
    setState(() {
      _requestsWithAddresses = _fetchRequestsAndAddresses();
    });
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Colors.green.shade600;
      case 'denied':
        return Colors.red.shade600;
      case 'ontheway':
        return Colors.blue.shade600;
      default:
        return Colors.orange.shade700;
    }
  }

  String formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    if (diff.inDays >= 1) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: FutureBuilder<List<RequestWithAddress>>(
        future: _requestsWithAddresses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) =>
                  const ShimmeringPickRequestTile(),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No requests found."));
          }

          final requestData = snapshot.data!;
          return ListView.builder(
            itemCount: requestData.length,
            itemBuilder: (context, index) {
              final req = requestData[index].request;
              final addr = requestData[index].address;
              final requestDate = req.requestDateTime.toLocal();
              final showActions =
                  widget.status == 'requested' || widget.status == "pending";

              return showActions
                  ? _buildSlidableRequest(req, addr, requestDate)
                  : _buildNonSlidableRequest(req, addr, requestDate);
            },
          );
        },
      ),
    );
  }

  Widget _buildSlidableRequest(
      Request req, Address? addr, DateTime requestDate) {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => RequestDetailPage(
            request: req,
            address: addr,
            requestId: req.id,
          ),
        ));
        _refreshData();
      },
      child: Slidable(
        key: ValueKey(req.id),
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              onPressed: (_) async {
                await _rpcService.updateRequestStatus(
                    req.id, RequestStatus.denied);
                ShowSnackbar.show(context, isError: true, "Request Denied");
                _refreshData();
              },
              backgroundColor: Colors.red,
              icon: Icons.cancel,
              label: 'Deny',
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              onPressed: (_) async {
                final partner = await showDialog<DeliveryPartner>(
                  context: context,
                  builder: (context) => AssignPartnerPopup(requestId: req.id),
                );
                if (partner != null) {
                  await _rpcService.acceptRequestWithPartner(
                      requestId: req.id, partnerId: partner.id);
                  ShowSnackbar.show(
                      context, "Partner assigned and request accepted");
                  _refreshData();
                }
              },
              backgroundColor: Colors.green,
              icon: Icons.check_circle,
              label: 'Accept',
            ),
          ],
        ),
        child: _buildRequestCard(req, addr, requestDate),
      ),
    );
  }

  Widget _buildNonSlidableRequest(
      Request req, Address? addr, DateTime requestDate) {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => RequestDetailPage(
            request: req,
            address: addr,
            requestId: req.id,
          ),
        ));
        _refreshData();
      },
      child: _buildRequestCard(req, addr, requestDate),
    );
  }

  Widget _buildRequestCard(Request req, Address? addr, DateTime requestDate) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat('MMM d, y').format(requestDate),
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(formatTimeAgo(requestDate),
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              addr?.address ?? 'Address not found',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Quantity ${req.qtyRange ?? '-'}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Text(
                  DateFormat('M/d/y H:mm:ss').format(requestDate),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: getStatusColor(widget.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.status.toUpperCase(),
                style: TextStyle(
                  color: getStatusColor(widget.status),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

