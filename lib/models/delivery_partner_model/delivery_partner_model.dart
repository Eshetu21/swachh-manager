import 'package:freezed_annotation/freezed_annotation.dart';

part 'delivery_partner_model.freezed.dart';
part 'delivery_partner_model.g.dart';

@freezed
class DeliveryPartnerModel with _$DeliveryPartnerModel {
  factory DeliveryPartnerModel({
    required String id,
    @JsonKey(name: "full_name")
    required String name,
    @JsonKey(name: "avatar_url")
    String? avatarUrl,
  }) = _DeliveryPartnerModel;

  factory DeliveryPartnerModel.fromJson(Map<String, dynamic> json) =>
      _$DeliveryPartnerModelFromJson(json);
}
