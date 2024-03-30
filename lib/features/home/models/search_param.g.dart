// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SearchParamFilterImpl _$$SearchParamFilterImplFromJson(
        Map<String, dynamic> json) =>
    _$SearchParamFilterImpl(
      id: json['id'] as String?,
      status: $enumDecodeNullable(_$RequestStatusEnumMap, json['status']),
      dateFilter: json['dateFilter'] == null
          ? null
          : DateTime.parse(json['dateFilter'] as String),
    );

Map<String, dynamic> _$$SearchParamFilterImplToJson(
        _$SearchParamFilterImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': _$RequestStatusEnumMap[instance.status],
      'dateFilter': instance.dateFilter?.toIso8601String(),
    };

const _$RequestStatusEnumMap = {
  RequestStatus.requested: 'requested',
  RequestStatus.accepted: 'accepted',
  RequestStatus.onTheWay: 'onTheWay',
  RequestStatus.picked: 'picked',
  RequestStatus.denied: 'denied',
};
