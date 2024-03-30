import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kabadmanager/models/pickup_request_model.dart';

part 'search_param.freezed.dart';
part 'search_param.g.dart';



@freezed
abstract class SearchParamFilter with _$SearchParamFilter {
  const factory SearchParamFilter({
    String? id,
    RequestStatus? status,
    DateTime? dateFilter,
  }) = _SearchParamFilter;
    factory SearchParamFilter.fromJson(Map<String, dynamic> json) =>
      _$SearchParamFilterFromJson(json);

}
