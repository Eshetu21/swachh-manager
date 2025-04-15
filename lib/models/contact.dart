class Contact {
  final String? name;
  final String? email;
  final String? phone;

  Contact({
    this.name,
    this.email,
    this.phone,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      name: json['full_name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': name,
      'email': email,
      'phone': phone,
    };
  }
}

