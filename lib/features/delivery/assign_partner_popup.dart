/* import 'package:flutter/material.dart';
import 'package:kabadmanager/models/delivery_partner.dart';
import 'package:kabadmanager/services/supabase_rpc_service.dart';

class AssignPartnerPopup extends StatefulWidget {
  final String requestId;
  const AssignPartnerPopup({super.key, required this.requestId});

  @override
  State<AssignPartnerPopup> createState() => _AssignPartnerPopupState();
}

class _AssignPartnerPopupState extends State<AssignPartnerPopup> {
  final TextEditingController _searchController = TextEditingController();
  final SupabaseRpcService _rpcService = SupabaseRpcService();
  List<DeliveryPartner> _partners = [];
  DeliveryPartner? _selectedPartner;
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchPartners(String query) async {
    if (query.isEmpty) {
      setState(() {
        _partners = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final partners = await _rpcService.searchPartnerByName(query);
      setState(() {
        _partners = partners;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching partners: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey.shade100,
      title: const Text('Assign Delivery Partner'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search partner',
                suffixIcon: _isLoading
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white.withOpacity(0.5)
              ),
              onChanged: _searchPartners,
            ),
            const SizedBox(height: 16),
            if (_partners.isNotEmpty)
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: _partners.length,
                  itemBuilder: (context, index) {
                    final partner = _partners[index];
                    return ListTile(
                      shape:  RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                      ),
                      leading: const Icon(Icons.person),
                      title: Text(partner.fullName),
                      onTap: () {
                        setState(() {
                          _selectedPartner = partner;
                        });
                      },
                      tileColor: _selectedPartner?.id == partner.id
                          ? Colors.grey.shade300
                          : null,
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _selectedPartner == null
              ? null
              : () => Navigator.pop(context, _selectedPartner),
          child: const Text('Assign'),
        ),
      ],
    );
  }
}

 */
import 'package:flutter/material.dart';
import 'package:kabadmanager/models/delivery_partner.dart';
import 'package:kabadmanager/services/supabase_rpc_service.dart';
import 'package:kabadmanager/shared/show_snackbar.dart';

class AssignPartnerPopup extends StatefulWidget {
  final String requestId;
  const AssignPartnerPopup({super.key, required this.requestId});

  @override
  State<AssignPartnerPopup> createState() => _AssignPartnerPopupState();
}

class _AssignPartnerPopupState extends State<AssignPartnerPopup> {
  final SupabaseRpcService _rpcService = SupabaseRpcService();
  List<DeliveryPartner> _partners = [];
  DeliveryPartner? _selectedPartner;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllDeliveryPartners();
  }

  Future<void> _fetchAllDeliveryPartners() async {
    try {
      final partners = await _rpcService.fetchAllDeliveryPartners();
      setState(() {
        _partners = partners;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ShowSnackbar.show(context, isError: true, "Error fetching partners: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: const Text('Assign Delivery Partner'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_partners.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No delivery partners available'),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: _partners.length,
                  itemBuilder: (context, index) {
                    final partner = _partners[index];
                    return ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      leading: CircleAvatar(
                        backgroundImage: partner.avatarUrl != null
                            ? NetworkImage(partner.avatarUrl!)
                            : null,
                        child: partner.avatarUrl == null
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      title: Text(partner.fullName),
                      subtitle: partner.phoneNumber != null
                          ? Text(partner.phoneNumber!)
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedPartner = partner;
                        });
                      },
                      tileColor: _selectedPartner?.id == partner.id
                          ? theme.focusColor
                          : null,
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _selectedPartner == null
              ? null
              : () => Navigator.pop(context, _selectedPartner),
          child: const Text('Assign'),
        ),
      ],
    );
  }
}

