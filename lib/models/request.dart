enum RequestStatus { requested, picked, pending, denied, accepted, onTheWay }

RequestStatus requestStatusFromString(String status) {
  return RequestStatus.values.firstWhere(
    (e) => e.name == status,
    orElse: () => RequestStatus.pending,
  );
}

class Request {
  final String id;
  final DateTime requestDateTime;
  final String addressId;
  final String requestingUserId;
  final DateTime scheduleDateTime;
  final double totalPrice;
  late RequestStatus status;
  final String? qtyRange;
  final String? deliveryPartnerId;
  final DateTime? pickupTime;

  Request({
    required this.id,
    required this.requestDateTime,
    required this.addressId,
    required this.requestingUserId,
    required this.scheduleDateTime,
    required this.totalPrice,
    required this.status,
    this.qtyRange,
    this.deliveryPartnerId,
    this.pickupTime,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json['id'],
      requestDateTime: DateTime.parse(json['request_date_time']),
      addressId: json['address_id'],
      requestingUserId: json['requesting_user_id'],
      scheduleDateTime: DateTime.parse(json['schedule_date_time']),
      totalPrice: (json['total_price'] as num).toDouble(),
      status: requestStatusFromString(json['status']),
      qtyRange: json['qty_range'],
      deliveryPartnerId: json['delivery_partner_id'],
      pickupTime: json['pickup_time'] != null
          ? DateTime.parse(json['pickup_time'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'requestDateTime': requestDateTime.toIso8601String(),
      'addressId': addressId,
      'requestingUserId': requestingUserId,
      'scheduleDateTime': scheduleDateTime.toIso8601String(),
      'totalPrice': totalPrice,
      'status': status.name,
      'qtyRange': qtyRange,
      'deliveryPartnerId': deliveryPartnerId,
      'pickupTime': pickupTime?.toIso8601String(),
    };
  }
}

extension RequestQuantityParsing on Request {
  int get parsedQuantity {
    if (qtyRange == null) return 0;
    if (qtyRange!.contains('+')) {
      return (int.tryParse(
                  qtyRange!.replaceAll('+', '').replaceAll('kg', '').trim()) ??
              0) +
          10;
    }
    if (qtyRange!.contains('-')) {
      final parts = qtyRange!.split('-');
      if (parts.length == 2) {
        return int.tryParse(parts[1].replaceAll('kg', '').trim()) ?? 0;
      }
    }
    return int.tryParse(qtyRange!.replaceAll('kg', '').trim()) ?? 0;
  }

  bool get isHeavy => qtyRange?.contains('+') ?? false;
}

