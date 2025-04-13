class Address {
  final String id;
  final String address;
  final String label;
  final String ownerId;
  final String latlng;
  final String? category;
  final String? houseStreetNo;
  final String? apartmentRoadAreaLandMark;
  final String? phoneNumber;

  Address(
      {required this.id,
      required this.address,
      required this.label,
      required this.ownerId,
      required this.latlng,
      required this.category,
      required this.houseStreetNo,
      required this.apartmentRoadAreaLandMark,
      required this.phoneNumber});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
        id: json["id"],
        address: json["address"],
        label: json["label"],
        ownerId: json["ownerId"],
        latlng: json["latlng"],
        category: json["category"],
        houseStreetNo: json["houseStreetNo"],
        apartmentRoadAreaLandMark: json["apartmentRoadAreaLandMark"],
        phoneNumber: json["phoneNumber"]);
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "address": address,
      "label": label,
      "ownerId": ownerId,
      "latlng": latlng,
      "category": category,
      "houseStreetNo": houseStreetNo,
      "apartmentRoadAreaLandMark": apartmentRoadAreaLandMark,
      "phoneNumber": phoneNumber
    };
  }
}

