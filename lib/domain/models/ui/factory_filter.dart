import 'package:freezed_annotation/freezed_annotation.dart';

part 'factory_filter.freezed.dart';
part 'factory_filter.g.dart';

@freezed
class FactoryFilter with _$FactoryFilter {
  const factory FactoryFilter({
    String? poolId,
    @JsonKey(includeIfNull: false) String? query,
    @JsonKey(includeIfNull: false) List<String>? categories,
    @JsonKey(includeIfNull: false) bool? hideAdult,
  }) = _FactoryFilter;

  factory FactoryFilter.fromJson(Map<String, dynamic> json) =>
      _$FactoryFilterFromJson(json);
}
