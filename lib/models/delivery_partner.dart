/* class DeliveryPartner {
  final String id;
  final String fullName;

  DeliveryPartner({required this.id, required this.fullName});

  factory DeliveryPartner.fromJson(Map<String, dynamic> json) {
    return DeliveryPartner(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? json['fullName']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
    };
  }
} */

class DeliveryPartner {
  final String id;
  final String fullName;
  final String? avatarUrl;
  final String? phoneNumber;
  final String? email;

  DeliveryPartner({
    required this.id,
    required this.fullName,
    this.avatarUrl,
    this.phoneNumber,
    this.email,
  });

  factory DeliveryPartner.fromJson(Map<String, dynamic> json) {
    return DeliveryPartner(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      avatarUrl: json['avatar_url']?.toString(),
      phoneNumber: json['phone_number']?.toString(),
      email: json['email']?.toString(),
    );
  }
}

