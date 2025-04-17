import 'package:flutter/material.dart';

enum RequestStatus {
  requested,
  accepted,
  onTheWay,
  picked,
  denied,
}

RequestStatus requestStatusFromString(String status) {
  return RequestStatus.values.firstWhere(
    (e) => e.name == status,
    orElse: () => RequestStatus.requested,
  );
}

class PickupRequestModel {
  final String id;
  final DateTime requestDateTime;
  final String requestingUserId;
  final DateTime? scheduleDateTime;
  final DateTime? pickedDateTime;
  final String addressId;
  final String qtyRange;
  final RequestStatus status;
  final String? houseStreetNo;
  final String? addressLabel;
  final String? address;

  PickupRequestModel({
    required this.id,
    required this.requestDateTime,
    required this.requestingUserId,
    this.scheduleDateTime,
    this.pickedDateTime,
    required this.addressId,
    required this.qtyRange,
    required this.status,
    this.houseStreetNo,
    this.addressLabel,
    this.address,
  });

  factory PickupRequestModel.fromJson(Map<String, dynamic> json) {
    return PickupRequestModel(
      id: json['id'] as String,
      requestDateTime: DateTime.parse(json['request_date_time'] as String),
      requestingUserId: json['requesting_user_id'] as String,
      scheduleDateTime: json['schedule_date_time'] != null 
          ? DateTime.parse(json['schedule_date_time'] as String)
          : null,
      pickedDateTime: json['pickup_time'] != null
          ? DateTime.parse(json['pickup_time'] as String)
          : null,
      addressId: json['address_id'] as String,
      qtyRange: json['qty_range'] as String,
      status: requestStatusFromString(json['status'] as String),
      houseStreetNo: json['house_street_no'] as String?,
      addressLabel: json['address_label'] as String?,
      address: json['address'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'request_date_time': requestDateTime.toIso8601String(),
      'requesting_user_id': requestingUserId,
      'schedule_date_time': scheduleDateTime?.toIso8601String(),
      'pickup_time': pickedDateTime?.toIso8601String(),
      'address_id': addressId,
      'qty_range': qtyRange,
      'status': status.name,
      'house_street_no': houseStreetNo,
      'address_label': addressLabel,
      'address': address,
    };
  }

  IconData get statusIcon {
    switch (status) {
      case RequestStatus.picked:
        return Icons.done;
      case RequestStatus.requested:
        return Icons.pending;
      case RequestStatus.denied:
        return Icons.close;
      case RequestStatus.accepted:
        return Icons.check_circle;
      case RequestStatus.onTheWay:
        return Icons.directions_car;
    }
  }

  IconData get statusOutlinedIcon {
    switch (status) {
      case RequestStatus.picked:
        return Icons.done_outlined;
      case RequestStatus.requested:
        return Icons.pending_outlined;
      case RequestStatus.denied:
        return Icons.close_outlined;
      case RequestStatus.accepted:
        return Icons.check_circle_outlined;
      case RequestStatus.onTheWay:
        return Icons.directions_car_outlined;
    }
  }

  Color getStatusColor(BuildContext context) {
    switch (status) {
      case RequestStatus.picked:
        return const Color(0xff5ec792);
      case RequestStatus.requested:
        return Colors.orange;
      case RequestStatus.denied:
        return Theme.of(context).colorScheme.error;
      case RequestStatus.accepted:
        return const Color(0xff5ec792);
      case RequestStatus.onTheWay:
        return Theme.of(context).colorScheme.primary;
    }
  }
}

