import 'package:flutter/material.dart';
import 'package:kabadmanager/services/supabase_rpc_service.dart';

class AddDeliveryPartner extends StatefulWidget {
  const AddDeliveryPartner({super.key});

  @override
  State<AddDeliveryPartner> createState() => _AddDeliveryPartnerState();
}

class _AddDeliveryPartnerState extends State<AddDeliveryPartner> {
  final SupabaseRpcService _rpcService = SupabaseRpcService();
  List<dynamic> _users = [];
  List<dynamic> _filteredUsers = [];
  bool _isLoading = true;
  String _errorMessage = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    _searchController.addListener(_filterUsers);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterUsers);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchUsers() async {
    try {
      final users = await _rpcService.fetchAllUsers();
      if (!mounted) return;

      setState(() {
        _users = users;
        _filteredUsers = users;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: ${e.toString()}';
      });
      debugPrint('Error fetching users: $e');
    }
  }

  void _filterUsers() {
    if (!mounted) return;

    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredUsers = _users.where((user) {
        final email = user['email']?.toString().toLowerCase() ?? '';
        final name =
            user['user_metadata']?['full_name']?.toString().toLowerCase() ?? '';
        return email.contains(query) || name.contains(query);
      }).toList();
    });
  }

  Future<void> _showAddConfirmation(
      BuildContext context, Map<String, dynamic> user) async {
    final fullName = user['user_metadata']?['full_name'] ?? 'Unknown User';
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade200,
          title: const Text('Add Delivery Partner'),
          content: Text(
              'Are you sure you want to add $fullName as a delivery partner?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () async {
                await _addDeliveryPartner(user);
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added $fullName as delivery partner')),
        );
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add partner: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _addDeliveryPartner(Map<String, dynamic> user) async {

    try {
      final userId = user['id']?.toString();
      if (userId == null) throw Exception('User ID is null');

      final result = await _rpcService.addDeliveryPartner(userId);

      if (result.containsKey('error')) {
        throw Exception(result['error']);
      }
      if (mounted) {
        await _fetchUsers();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Delivery Partner"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterUsers();
                        },
                      )
                    : null,
              ),
              onChanged: (value) => _filterUsers(),
            ),
          ),
          Expanded(
            child: _errorMessage.isNotEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _errorMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  )
                : _filteredUsers.isEmpty
                    ? Center(
                        child: Text(
                          _isLoading ? 'Loading...' : 'No users found',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _fetchUsers,
                        child: ListView.builder(
                          itemCount: _filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = _filteredUsers[index];
                            final email =
                                user['email']?.toString() ?? 'No Email';
                            final userMetadata =
                                (user['user_metadata'] as Map?) ?? {};
                            final fullName =
                                userMetadata['full_name']?.toString() ??
                                    'No Name';

                            final avatarUrl = userMetadata['avatar_url']
                                    ?.toString() ??
                                userMetadata['picture']?.toString() ??
                                'https://ui-avatars.com/api/?name=${Uri.encodeComponent(fullName)}';

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(avatarUrl),
                                child: avatarUrl.contains('ui-avatars.com')
                                    ? Text(fullName.isNotEmpty
                                        ? fullName[0].toUpperCase()
                                        : '?')
                                    : null,
                              ),
                              title: Text(fullName),
                              subtitle: Text(email),
                              trailing: IconButton(
                                icon: const Icon(Icons.add_circle,
                                    color: Colors.green),
                                onPressed: () =>
                                    _showAddConfirmation(context, user),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

