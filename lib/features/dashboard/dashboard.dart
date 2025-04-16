import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kabadmanager/features/auth/logic/auth_bloc.dart' as auth_bloc;
import 'package:kabadmanager/features/requests/request_list.dart';
import 'package:kabadmanager/models/request.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final user = Supabase.instance.client.auth.currentUser;
  int selectedIndex = 0;

  final List<RequestStatus> visibleStatuses = [
    RequestStatus.requested,
    RequestStatus.accepted,
    RequestStatus.onTheWay,
    RequestStatus.pending,
    RequestStatus.picked,
    RequestStatus.denied,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("KabadManager"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text("Admin"),
              accountEmail: Text(user?.email ?? "No email"),
              currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.admin_panel_settings, size: 30),
              ),
              decoration: const BoxDecoration(color: Colors.green),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                Navigator.pop(context);
                BlocProvider.of<auth_bloc.AuthBloc>(context)
                    .add(auth_bloc.AuthLogout());
              },
            ),
          ],
        ),
      ),
      body: BlocListener<auth_bloc.AuthBloc, auth_bloc.AuthState>(
        listener: (context, state) {
          if (state is auth_bloc.AuthInitial) {
            Navigator.pushReplacementNamed(context, '/login');
          } else if (state is auth_bloc.AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: visibleStatuses.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedIndex = index);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.green : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _formatStatus(visibleStatuses[index]),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: RequestList(status: visibleStatuses[selectedIndex].name),
            ),
          ],
        ),
      ),
    );
  }

  String _formatStatus(RequestStatus status) {
    final name = status.name;
    return "${name[0].toUpperCase()}${name.substring(1)}";
  }
}

