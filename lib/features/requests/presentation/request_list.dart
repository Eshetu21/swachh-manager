import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kabadmanager/models/request.dart';
import 'package:kabadmanager/services/supabase_rpc_service.dart';

class RequestList extends StatelessWidget {
  final String status;
  const RequestList({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Request>>(
      future: SupabaseRpcService().fetchRequestsByStatus(status),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const Center(child: Text("No requests found."));
        }

        final requests = snapshot.data!;
        return ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final req = requests[index];
            return Slidable(
              key: ValueKey(req.id),
              startActionPane: ActionPane(
                motion: const DrawerMotion(),
                extentRatio: 0.25,
                children: [
                  SlidableAction(
                    onPressed: (_) {
                      SupabaseRpcService().changeRequestStatus(
                        requestId: req.id,
                        newStatus: "denied",
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Request Denied')),
                      );
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
                    onPressed: (_) {
                      SupabaseRpcService().changeRequestStatus(
                        requestId: req.id,
                        newStatus: "accepted",
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Request Accepted')),
                      );
                    },
                    backgroundColor: Colors.green,
                    icon: Icons.check_circle,
                    label: 'Accept',
                  ),
                ],
              ),
              child: Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(req.scheduleDateTime.toLocal().toString().split(' ')[0]),
                  subtitle: Text(req.addressId),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Chip(
                        label: Text(status.toUpperCase()),
                        backgroundColor: Colors.green.shade100,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        req.requestDateTime.toLocal().toString().split('.')[0],
                        style: const TextStyle(fontSize: 12),
                      ),
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
