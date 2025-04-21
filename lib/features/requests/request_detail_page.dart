import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:kabadmanager/features/delivery/assign_partner_popup.dart';
import 'package:kabadmanager/features/requests/pick_request.dart';
import 'package:kabadmanager/features/requests/widgets/request_widgets.dart';
import 'package:kabadmanager/models/delivery_partner.dart';
import 'package:kabadmanager/shared/show_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kabadmanager/models/cart.dart';
import 'package:kabadmanager/models/request.dart';
import 'package:kabadmanager/models/address.dart';
import 'package:kabadmanager/models/contact.dart';
import 'package:kabadmanager/services/supabase_rpc_service.dart';

class RequestDetailPage extends StatefulWidget {
  final Request request;
  final Address? address;
  final String requestId;

  const RequestDetailPage({
    super.key,
    required this.request,
    required this.address,
    required this.requestId,
  });

  @override
  State<RequestDetailPage> createState() => _RequestDetailPageState();
}

class _RequestDetailPageState extends State<RequestDetailPage> {
  late Future<List<Cart>> _cartItems;
  late Future<Contact> _contactDetails;
  final SupabaseRpcService _rpcService = SupabaseRpcService();

  @override
  void initState() {
    super.initState();

    _cartItems = SupabaseRpcService().getCartItemsByReqId(widget.requestId);
    _contactDetails = _rpcService.getContactDetailsByReqId(widget.requestId);
  }

  Future<void> _acceptAndAssignPartner() async {
    final partner = await showDialog<DeliveryPartner>(
        context: context,
        builder: (context) => AssignPartnerPopup(requestId: widget.requestId));
    if (partner != null) {
      try {
        await _rpcService.acceptRequestWithPartner(
            requestId: widget.requestId, partnerId: partner.id);
        ShowSnackbar.show(context, "Request accepted and partner assigned");
        setState(() {
          widget.request.status = RequestStatus.accepted;
        });
      } catch (e) {
        ShowSnackbar.show(context, 'Error: ${e.toString()}', isError: true);
      }
    }
  }

  Future<void> _openMap(String latLng) async {
    final parts = latLng.split(',');
    if (parts.length != 2) return;

    final lat = parts[0].trim();
    final lng = parts[1].trim();
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildDetailRow(context, 'Request ID', widget.request.id),
                    const SizedBox(height: 8),
                    buildStatusWidget(widget.request.status),
                    const SizedBox(height: 8),
                    if (widget.request.qtyRange != null)
                      buildDetailRow(
                          context, 'Quantity Range', widget.request.qtyRange!),
                    buildDetailRow(
                      context,
                      'Request Date',
                      DateFormat('MMM d, y H:mm')
                          .format(widget.request.requestDateTime),
                    ),
                    buildDetailRow(
                      context,
                      'Schedule Date',
                      DateFormat('MMM d, y H:mm')
                          .format(widget.request.scheduleDateTime),
                    ),
                    if (widget.request.totalPrice > 0)
                      buildDetailRow(
                        context,
                        'Total Price',
                        '₹${widget.request.totalPrice.toStringAsFixed(2)}',
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (widget.address != null)
              _buildAddressCard(context, widget.address!),
            const SizedBox(height: 20),
            FutureBuilder<Contact>(
              future: _contactDetails,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const SizedBox();
                } else if (snapshot.hasData) {
                  return buildContactCard(context, snapshot.data!);
                }
                return const SizedBox();
              },
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<Cart>>(
              future: _cartItems,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error loading cart items: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No items in cart');
                }

                final cartItems = snapshot.data!;
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cart Items',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 12),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            return buildCartItemCard(cartItems[index]);
                          },
                        ),
                        const SizedBox(height: 16),
                        buildTotalPrice(context, cartItems),
                      ],
                    ),
                  ),
                );
              },
            ),
            if (widget.request.status == RequestStatus.denied) ...[
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  await _acceptAndAssignPartner();
                  if (mounted) Navigator.pop(context, true);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green.shade600,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  width: double.infinity,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Accept and Assign Partner",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
            if (widget.request.status == RequestStatus.requested) ...[
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  await _rpcService.updateRequestStatus(
                      widget.requestId, RequestStatus.pending);
                  Navigator.pop(context, true);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green.shade600,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  width: double.infinity,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Mark as pending",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (widget.request.status == RequestStatus.accepted) ...[
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  await _rpcService.updateRequestStatus(
                      widget.requestId, RequestStatus.onTheWay);
                  Navigator.pop(context, true);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green.shade600,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  width: double.infinity,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Mark as on the way",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (widget.request.status == RequestStatus.onTheWay) ...[
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  final cartItems = await _cartItems;
                  await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PickOrderPage(
                        address: widget.address!,
                        cartItems: cartItems,
                        request: widget.request),
                  ));
                  if (mounted) setState(() {});
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green.shade600,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  width: double.infinity,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Pick order",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, Address address) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Address Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (address.label.isNotEmpty)
              buildDetailRow(context, 'Label', address.label),
            if (address.houseStreetNo?.isNotEmpty ?? false)
              buildDetailRow(context, 'House/Street', address.houseStreetNo!),
            buildDetailRow(context, 'Address', address.address),
            if (address.apartmentRoadAreaLandMark?.isNotEmpty ?? false)
              buildDetailRow(
                  context, 'Landmark', address.apartmentRoadAreaLandMark!),
            if (address.phoneNumber?.isNotEmpty ?? false)
              buildDetailRow(context, 'Phone', address.phoneNumber!),
            if (address.latlng.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                            side: const BorderSide(width: 0.2)),
                        icon: const Icon(Icons.map, size: 18),
                        label: const Text('Open in Maps'),
                        onPressed: () => _openMap(address.latlng),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                            side: const BorderSide(width: 0.2)),
                        icon: const Icon(Icons.copy, size: 18),
                        label: const Text('Copy Address'),
                        onPressed: () => _copyToClipboard(address.address),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ],
        ),
      ),
    );
  }
}

