// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_param.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SearchParamFilter _$SearchParamFilterFromJson(Map<String, dynamic> json) {
  return _SearchParamFilter.fromJson(json);
}

/// @nodoc
mixin _$SearchParamFilter {
  String? get id => throw _privateConstructorUsedError;
  RequestStatus? get status => throw _privateConstructorUsedError;
  DateTime? get dateFilter => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SearchParamFilterCopyWith<SearchParamFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchParamFilterCopyWith<$Res> {
  factory $SearchParamFilterCopyWith(
          SearchParamFilter value, $Res Function(SearchParamFilter) then) =
      _$SearchParamFilterCopyWithImpl<$Res, SearchParamFilter>;
  @useResult
  $Res call({String? id, RequestStatus? status, DateTime? dateFilter});
}

/// @nodoc
class _$SearchParamFilterCopyWithImpl<$Res, $Val extends SearchParamFilter>
    implements $SearchParamFilterCopyWith<$Res> {
  _$SearchParamFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? status = freezed,
    Object? dateFilter = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RequestStatus?,
      dateFilter: freezed == dateFilter
          ? _value.dateFilter
          : dateFilter // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SearchParamFilterImplCopyWith<$Res>
    implements $SearchParamFilterCopyWith<$Res> {
  factory _$$SearchParamFilterImplCopyWith(_$SearchParamFilterImpl value,
          $Res Function(_$SearchParamFilterImpl) then) =
      __$$SearchParamFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? id, RequestStatus? status, DateTime? dateFilter});
}

/// @nodoc
class __$$SearchParamFilterImplCopyWithImpl<$Res>
    extends _$SearchParamFilterCopyWithImpl<$Res, _$SearchParamFilterImpl>
    implements _$$SearchParamFilterImplCopyWith<$Res> {
  __$$SearchParamFilterImplCopyWithImpl(_$SearchParamFilterImpl _value,
      $Res Function(_$SearchParamFilterImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? status = freezed,
    Object? dateFilter = freezed,
  }) {
    return _then(_$SearchParamFilterImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RequestStatus?,
      dateFilter: freezed == dateFilter
          ? _value.dateFilter
          : dateFilter // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchParamFilterImpl implements _SearchParamFilter {
  const _$SearchParamFilterImpl({this.id, this.status, this.dateFilter});

  factory _$SearchParamFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchParamFilterImplFromJson(json);

  @override
  final String? id;
  @override
  final RequestStatus? status;
  @override
  final DateTime? dateFilter;

  @override
  String toString() {
    return 'SearchParamFilter(id: $id, status: $status, dateFilter: $dateFilter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchParamFilterImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.dateFilter, dateFilter) ||
                other.dateFilter == dateFilter));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, status, dateFilter);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchParamFilterImplCopyWith<_$SearchParamFilterImpl> get copyWith =>
      __$$SearchParamFilterImplCopyWithImpl<_$SearchParamFilterImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchParamFilterImplToJson(
      this,
    );
  }
}

abstract class _SearchParamFilter implements SearchParamFilter {
  const factory _SearchParamFilter(
      {final String? id,
      final RequestStatus? status,
      final DateTime? dateFilter}) = _$SearchParamFilterImpl;

  factory _SearchParamFilter.fromJson(Map<String, dynamic> json) =
      _$SearchParamFilterImpl.fromJson;

  @override
  String? get id;
  @override
  RequestStatus? get status;
  @override
  DateTime? get dateFilter;
  @override
  @JsonKey(ignore: true)
  _$$SearchParamFilterImplCopyWith<_$SearchParamFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
