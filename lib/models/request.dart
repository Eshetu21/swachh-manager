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
  final RequestStatus status;
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
      requestDateTime: DateTime.parse(json['requestDateTime']),
      addressId: json['addressId'],
      requestingUserId: json['requestingUserId'],
      scheduleDateTime: DateTime.parse(json['scheduleDateTime']),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      status: requestStatusFromString(json['status']),
      qtyRange: json['qtyRange'],
      deliveryPartnerId: json['deliveryPartnerId'],
      pickupTime: json['pickupTime'] != null
          ? DateTime.parse(json['pickupTime'])
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
