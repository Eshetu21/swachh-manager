import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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

  @override
  void initState() {
    super.initState();
    _cartItems = SupabaseRpcService().getCartItemsByReqId(widget.requestId);
    _contactDetails =
        SupabaseRpcService().getContactDetailsByReqId(widget.requestId);
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
        title: const Text('Request Preview'),
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
                    const Text(
                      'Request Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow('Request ID', widget.request.id),
                    const SizedBox(height: 8),
                    _buildStatusWidget(widget.request.status),
                    const SizedBox(height: 8),
                    if (widget.request.qtyRange != null)
                      _buildDetailRow(
                          'Quantity Range', '${widget.request.qtyRange!} Kg'),
                    _buildDetailRow(
                      'Request Date',
                      DateFormat('MMM d, y H:mm')
                          .format(widget.request.requestDateTime),
                    ),
                    _buildDetailRow(
                      'Schedule Date',
                      DateFormat('MMM d, y H:mm')
                          .format(widget.request.scheduleDateTime),
                    ),
                    if (widget.request.totalPrice > 0)
                      _buildDetailRow(
                        'Total Price',
                        '₹${widget.request.totalPrice.toStringAsFixed(2)}',
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (widget.address != null) _buildAddressCard(widget.address!),
            const SizedBox(height: 20),
            FutureBuilder<Contact>(
              future: _contactDetails,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const SizedBox();
                } else if (snapshot.hasData) {
                  return _buildContactCard(snapshot.data!);
                }
                return const SizedBox();
              },
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cart Items',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
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
                        return Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: cartItems.length,
                              itemBuilder: (context, index) {
                                final item = cartItems[index];
                                return _buildCartItemCard(item);
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildTotalPrice(cartItems),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard(Address address) {
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
              _buildDetailRow('Label', address.label),
            if (address.houseStreetNo?.isNotEmpty ?? false)
              _buildDetailRow('House/Street', address.houseStreetNo!),
            _buildDetailRow('Address', address.address),
            if (address.apartmentRoadAreaLandMark?.isNotEmpty ?? false)
              _buildDetailRow('Landmark', address.apartmentRoadAreaLandMark!),
            if (address.phoneNumber?.isNotEmpty ?? false)
              _buildDetailRow('Phone', address.phoneNumber!),
            if (address.latlng.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(side: BorderSide.none),
                        icon: const Icon(Icons.map, size: 18),
                        label: const Text('Open in Maps'),
                        onPressed: () => _openMap(address.latlng),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(side: BorderSide.none),
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

  Widget _buildContactCard(Contact contact) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (contact.name?.isNotEmpty ?? false)
              _buildDetailRow('Name', contact.name!),
            if (contact.phone?.isNotEmpty ?? false)
              _buildDetailRowWithAction(
                'Phone',
                contact.phone!,
                onTap: () => launchUrl(Uri.parse('tel:${contact.phone!}')),
              ),
            if (contact.email?.isNotEmpty ?? false)
              _buildDetailRowWithAction(
                'Email',
                contact.email!,
                onTap: () => launchUrl(Uri.parse('mailto:${contact.email!}')),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text('$label:',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildDetailRowWithAction(String label, String value,
      {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text('$label:',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Text(
                value,
                style: TextStyle(
                  color: onTap != null ? Colors.blue : null,
                  decoration: onTap != null ? TextDecoration.underline : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildStatusWidget(RequestStatus status) {
  final color = _getStatusColor(status);
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.2),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      status.name.toUpperCase(),
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    ),
  );
}

Widget _buildCartItemCard(Cart item) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 4),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(
        item.scrap.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            item.scrap.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            '₹${item.scrap.price.toStringAsFixed(2)} per ${item.scrap.measure}',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Qty: ${item.qty}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            '₹${(item.scrap.price * item.qty).toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildTotalPrice(List<Cart> cartItems) {
  final total =
      cartItems.fold(0.0, (sum, item) => sum + (item.scrap.price * item.qty));
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'TOTAL',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '₹${total.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ],
    ),
  );
}

Color _getStatusColor(RequestStatus status) {
  switch (status) {
    case RequestStatus.accepted:
      return Colors.green;
    case RequestStatus.denied:
      return Colors.red;
    case RequestStatus.onTheWay:
      return Colors.blue;
    case RequestStatus.picked:
      return Colors.purple;
    case RequestStatus.requested:
      return Colors.orange;
    case RequestStatus.pending:
      return Colors.grey;
  }
}

