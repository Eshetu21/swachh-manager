import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:kabadmanager/features/delivery/assign_partner_popup.dart';
import 'package:kabadmanager/features/requests/request_detail_page.dart';
import 'package:kabadmanager/models/delivery_partner.dart';
import 'package:kabadmanager/models/request.dart';
import 'package:kabadmanager/models/address.dart';
import 'package:kabadmanager/services/supabase_rpc_service.dart';
import 'package:kabadmanager/shimmering_widgets/request_tile.dart';

class RequestWithAddress {
  final Request request;
  final Address? address;

  RequestWithAddress({required this.request, required this.address});
}

class RequestList extends StatefulWidget {
  final String status;
  const RequestList({super.key, required this.status});

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
    if (oldWidget.status != widget.status) {
      setState(() {
        _requestsWithAddresses = _fetchRequestsAndAddresses();
      });
    }
  }

  Future<List<RequestWithAddress>> _fetchRequestsAndAddresses() async {
    final service = SupabaseRpcService();
    final requests = await service.fetchRequestsByStatus(widget.status);

    final futures = requests.map((req) async {
      final address = await service.fetchAddressById(req.addressId);
      return RequestWithAddress(request: req, address: address);
    }).toList();

    return await Future.wait(futures);
  }

  String formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inDays >= 1) {
      final days = diff.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else if (diff.inHours >= 1) {
      final hours = diff.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (diff.inMinutes >= 1) {
      final minutes = diff.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Colors.green.shade600;
      case 'denied':
        return Colors.red.shade600;
      case 'on_the_way':
        return Colors.blue.shade600;
      default:
        return Colors.orange.shade700;
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _requestsWithAddresses = _fetchRequestsAndAddresses();
    });
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
              itemBuilder: (context, index) {
                return const ShimmeringPickRequestTile();
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text("No requests found."));
          }

          final requestData = snapshot.data!;
          return ListView.builder(
            itemCount: requestData.length,
            itemBuilder: (context, index) {
              final req = requestData[index].request;
              final addr = requestData[index].address;
              final requestDate = req.requestDateTime.toLocal();
              final requestId = requestData[index].request.id;

              final showActions = widget.status == 'requested';

              return showActions
                  ? _buildSlidableRequest(req, addr, requestDate, requestId)
                  : _buildNonSlidableRequest(req, addr, requestDate, requestId);
            },
          );
        },
      ),
    );
  }

  Widget _buildSlidableRequest(
      Request req, Address? addr, DateTime requestDate, String requestId) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => RequestDetailPage(
                    request: req, address: addr, requestId: requestId)))
            .then((_) {
          _refreshData();
        });
      },
      child: Slidable(
        key: ValueKey(req.id),
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.27,
          children: [
            SlidableAction(
              onPressed: (_) async {
                await _rpcService.updateRequestStatus(
                    requestId, RequestStatus.denied);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Request Denied')),
                );
                setState(() {
                  _requestsWithAddresses = _fetchRequestsAndAddresses();
                });
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
                  builder: (context) =>
                      AssignPartnerPopup(requestId: requestId),
                );

                if (partner != null) {
                  try {
                    await _rpcService.acceptRequestWithPartner(
                      requestId: requestId,
                      partnerId: partner.id,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Partner assigned and request accepted')),
                    );

                    setState(() {
                      _requestsWithAddresses = _fetchRequestsAndAddresses();
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${e.toString()}')),
                    );
                  }
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
      Request req, Address? addr, DateTime requestDate, String requestId) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(
          builder: (context) => RequestDetailPage(
            request: req,
            address: addr,
            requestId: requestId,
          ),
        ))
            .then((_) {
          _refreshData();
        });
      },
      child: _buildRequestCard(req, addr, requestDate),
    );
  }

  Widget _buildRequestCard(Request req, Address? addr, DateTime requestDate) {
    return Card(
      color: Colors.grey.shade100,
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMM d, y').format(requestDate),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      formatTimeAgo(requestDate),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 4),
            Text(
              addr != null ? addr.address : 'Address not found',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quantity ${req.qtyRange}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  DateFormat('M/d/y H:mm:ss').format(requestDate),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
          ],
        ),
      ),
    );
  }
/*   Future<void> _showAssignPartnerDialog(BuildContext context, String requestId) async {
  final partner = await showDialog<DeliveryPartner>(
    context: context,
    builder: (context) => AssignPartnerPopup(requestId: requestId),
  );

  if (partner != null) {
    try {
      // First assign the partner
      await _rpcService.from('requests')
        .update({
          'delivery_partner_id': partner.id,
          'status': RequestStatus.accepted.name
        })
        .eq('id', requestId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Partner assigned and request accepted')),
      );
      
      setState(() {
        _requestsWithAddresses = _fetchRequestsAndAddresses();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
} */
}

