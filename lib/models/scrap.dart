enum ScrapMeasurement {
  unit,
  kg,
  gm,
  ltr,
  qntl,
}

ScrapMeasurement scrapMeasurementFromString(String value) {
  return ScrapMeasurement.values.firstWhere(
    (e) => e.name == value,
    orElse: () => ScrapMeasurement.kg,
  );
}

class ScrapModel {
  final String id;
  final String name;
  final String? photoUrl;
  final String description;
  final double price;
  final ScrapMeasurement measure;
  final bool isNegotiable;

  ScrapModel({
    required this.id,
    required this.name,
    this.photoUrl,
    required this.description,
    required this.price,
    this.measure = ScrapMeasurement.kg,
    this.isNegotiable = false,
  });

  factory ScrapModel.fromJson(Map<String, dynamic> json) {
    return ScrapModel(
      id: json['id'],
      name: json['name'],
      photoUrl: json['photoUrl'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      measure: scrapMeasurementFromString(json['measure']),
      isNegotiable: json['isNegotiable'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photoUrl': photoUrl,
      'description': description,
      'price': price,
      'measure': measure.name,
      'isNegotiable': isNegotiable,
    };
  }
}
