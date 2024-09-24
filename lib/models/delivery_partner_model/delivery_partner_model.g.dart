// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_partner_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeliveryPartnerModelImpl _$$DeliveryPartnerModelImplFromJson(
        Map<String, dynamic> json) =>
    _$DeliveryPartnerModelImpl(
      id: json['id'] as String,
      name: json['full_name'] as String,
      avatarUrl: json['avatar_url'] as String?,
    );

Map<String, dynamic> _$$DeliveryPartnerModelImplToJson(
        _$DeliveryPartnerModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'full_name': instance.name,
      'avatar_url': instance.avatarUrl,
    };
