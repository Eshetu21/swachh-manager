import 'package:flutter/material.dart';
import 'package:kabadmanager/models/cart.dart';
import 'package:kabadmanager/models/contact.dart';
import 'package:kabadmanager/models/request.dart';
import 'package:url_launcher/url_launcher.dart';

Widget buildContactCard(Contact contact) {
  return Card(
    color: Colors.grey.shade100,
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
            buildDetailRow('Name', contact.name!),
          if (contact.phone?.isNotEmpty ?? false)
            buildDetailRowWithAction(
              'Phone',
              contact.phone!,
              onTap: () => launchUrl(Uri.parse('tel:${contact.phone!}')),
            ),
          if (contact.email?.isNotEmpty ?? false)
            buildDetailRowWithAction(
              'Email',
              contact.email!,
              onTap: () => launchUrl(Uri.parse('mailto:${contact.email!}')),
            ),
        ],
      ),
    ),
  );
}

Widget buildDetailRow(String label, String value) {
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

Widget buildDetailRowWithAction(String label, String value,
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

Widget buildStatusWidget(RequestStatus status) {
  final color = getStatusColor(status);
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

Widget buildTotalPrice(List<Cart> cartItems) {
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

Widget buildCartItemCard(Cart item) {
  return Card(
    color: Colors.grey.shade300,
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

Color getStatusColor(RequestStatus status) {
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

