// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delivery_partner_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DeliveryPartnerModel _$DeliveryPartnerModelFromJson(Map<String, dynamic> json) {
  return _DeliveryPartnerModel.fromJson(json);
}

/// @nodoc
mixin _$DeliveryPartnerModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: "full_name")
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: "avatar_url")
  String? get avatarUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DeliveryPartnerModelCopyWith<DeliveryPartnerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeliveryPartnerModelCopyWith<$Res> {
  factory $DeliveryPartnerModelCopyWith(DeliveryPartnerModel value,
          $Res Function(DeliveryPartnerModel) then) =
      _$DeliveryPartnerModelCopyWithImpl<$Res, DeliveryPartnerModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: "full_name") String name,
      @JsonKey(name: "avatar_url") String? avatarUrl});
}

/// @nodoc
class _$DeliveryPartnerModelCopyWithImpl<$Res,
        $Val extends DeliveryPartnerModel>
    implements $DeliveryPartnerModelCopyWith<$Res> {
  _$DeliveryPartnerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? avatarUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeliveryPartnerModelImplCopyWith<$Res>
    implements $DeliveryPartnerModelCopyWith<$Res> {
  factory _$$DeliveryPartnerModelImplCopyWith(_$DeliveryPartnerModelImpl value,
          $Res Function(_$DeliveryPartnerModelImpl) then) =
      __$$DeliveryPartnerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: "full_name") String name,
      @JsonKey(name: "avatar_url") String? avatarUrl});
}

/// @nodoc
class __$$DeliveryPartnerModelImplCopyWithImpl<$Res>
    extends _$DeliveryPartnerModelCopyWithImpl<$Res, _$DeliveryPartnerModelImpl>
    implements _$$DeliveryPartnerModelImplCopyWith<$Res> {
  __$$DeliveryPartnerModelImplCopyWithImpl(_$DeliveryPartnerModelImpl _value,
      $Res Function(_$DeliveryPartnerModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? avatarUrl = freezed,
  }) {
    return _then(_$DeliveryPartnerModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeliveryPartnerModelImpl implements _DeliveryPartnerModel {
  _$DeliveryPartnerModelImpl(
      {required this.id,
      @JsonKey(name: "full_name") required this.name,
      @JsonKey(name: "avatar_url") this.avatarUrl});

  factory _$DeliveryPartnerModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeliveryPartnerModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: "full_name")
  final String name;
  @override
  @JsonKey(name: "avatar_url")
  final String? avatarUrl;

  @override
  String toString() {
    return 'DeliveryPartnerModel(id: $id, name: $name, avatarUrl: $avatarUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeliveryPartnerModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, avatarUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeliveryPartnerModelImplCopyWith<_$DeliveryPartnerModelImpl>
      get copyWith =>
          __$$DeliveryPartnerModelImplCopyWithImpl<_$DeliveryPartnerModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeliveryPartnerModelImplToJson(
      this,
    );
  }
}

abstract class _DeliveryPartnerModel implements DeliveryPartnerModel {
  factory _DeliveryPartnerModel(
          {required final String id,
          @JsonKey(name: "full_name") required final String name,
          @JsonKey(name: "avatar_url") final String? avatarUrl}) =
      _$DeliveryPartnerModelImpl;

  factory _DeliveryPartnerModel.fromJson(Map<String, dynamic> json) =
      _$DeliveryPartnerModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: "full_name")
  String get name;
  @override
  @JsonKey(name: "avatar_url")
  String? get avatarUrl;
  @override
  @JsonKey(ignore: true)
  _$$DeliveryPartnerModelImplCopyWith<_$DeliveryPartnerModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
