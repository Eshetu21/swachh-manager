import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kabadmanager/core/dependency_container.dart';
import 'package:kabadmanager/core/theme/app_pallete.dart';
import 'package:kabadmanager/features/auth/logic/auth_bloc.dart' as auth_bloc;
import 'package:kabadmanager/features/dashboard/widgets/status_bar.dart';
import 'package:kabadmanager/features/delivery/add_delivery_partner.dart';
import 'package:kabadmanager/features/requests/request_list.dart';
import 'package:kabadmanager/models/request.dart';
import 'package:kabadmanager/services/session_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final user = Supabase.instance.client.auth.currentUser;
  int selectedIndex = 0;
  final SessionService _sessionService = sl<SessionService>();

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final isLoggedIn = await _sessionService.isLoggedIn();
    if (!isLoggedIn) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  final List<RequestStatus> visibleStatuses = [
    RequestStatus.requested,
    RequestStatus.pending,
    RequestStatus.accepted,
    RequestStatus.onTheWay,
    RequestStatus.picked,
    RequestStatus.denied,
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        title: const Text("KabadManager"),
      ),
      drawer: isSmallScreen || !isPortrait
          ? Drawer(
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
                    leading: const Icon(Icons.add_box),
                    title: const Text("Add Delivery Partner"),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AddDeliveryPartner()));
                    },
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
            )
          : null,
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
        child: Row(
          children: [
            if (!isSmallScreen && isPortrait)
              Container(
                width: screenWidth * 0.2,
                color: Colors.grey[100],
                child: Column(
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
                        BlocProvider.of<auth_bloc.AuthBloc>(context)
                            .add(auth_bloc.AuthLogout());
                      },
                    ),
                  ],
                ),
              ),
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: isSmallScreen ? 50 : 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 8 : 16,
                      ),
                      itemCount: visibleStatuses.length,
                      itemBuilder: (context, index) {
                        return StatusTab(
                          label: _formatStatus(visibleStatuses[index]),
                          isSelected: selectedIndex == index,
                          onTap: () => setState(() => selectedIndex = index),
                          isSmallScreen: isSmallScreen,
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: RequestList(
                      status: visibleStatuses[selectedIndex].name,
                    ),
                  ),
                ],
              ),
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

