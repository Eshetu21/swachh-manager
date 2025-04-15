import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:kabadmanager/models/request.dart';
import 'package:kabadmanager/models/address.dart';
import 'package:kabadmanager/services/supabase_rpc_service.dart';

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

  @override
  void initState() {
    super.initState();
    _requestsWithAddresses = _fetchRequestsAndAddresses();
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

  String formatDate(DateTime dateTime) {
    return DateFormat('MMM d, y').format(dateTime);
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
      default:
        return Colors.orange.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RequestWithAddress>>(
      future: _requestsWithAddresses,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
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
            final scheduleDate = req.scheduleDateTime.toLocal();
            final requestDate = req.requestDateTime.toLocal();

            return Slidable(
              key: ValueKey(req.id),
              startActionPane: ActionPane(
                motion: const DrawerMotion(),
                extentRatio: 0.25,
                children: [
                  SlidableAction(
                    onPressed: (_) async {
                      await SupabaseRpcService().changeRequestStatus(
                        requestId: req.id,
                        newStatus: "denied",
                      );
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
                      await SupabaseRpcService().changeRequestStatus(
                        requestId: req.id,
                        newStatus: "accepted",
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Request Accepted')),
                      );
                      setState(() {
                        _requestsWithAddresses = _fetchRequestsAndAddresses();
                      });
                    },
                    backgroundColor: Colors.green,
                    icon: Icons.check_circle,
                    label: 'Accept',
                  ),
                ],
              ),
              child: Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 22, color: Colors.blue),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Requested on: ${DateFormat('MMM d, y • h:mm a').format(requestDate)}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.access_time,
                                    size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  formatTimeAgo(requestDate),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Scheduled for: ${DateFormat('MMM d, y • h:mm a').format(scheduleDate)}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                                      Text(
                              addr != null
                                  ? '${addr.label} - ${addr.address}'
                                  : 'Address not found',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: getStatusColor(widget.status)
                                        .withOpacity(0.1),
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
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

