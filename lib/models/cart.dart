import 'package:kabadmanager/models/scrap.dart';

class Cart {
  final String id;
  final ScrapModel scrap;
  final int qty;

  Cart({
    required this.id,
    required this.scrap,
    required this.qty,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      scrap: ScrapModel.fromJson(json['scrap']),
      qty: json['qty'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scrap': scrap.toJson(),
      'qty': qty,
    };
  }
}

