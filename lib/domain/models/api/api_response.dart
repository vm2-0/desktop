import 'package:clones_desktop/domain/models/api/api_error_detail.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response.freezed.dart';
part 'api_response.g.dart';

@freezed
class ApiResponse with _$ApiResponse {
  const factory ApiResponse({
    required bool success,
    dynamic data,
    @JsonKey(fromJson: _errorFromJson) ApiErrorDetail? error,
  }) = _ApiResponse;

  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseFromJson(json);
}

/// Custom converter for error field that can be either a string or ApiErrorDetail
ApiErrorDetail? _errorFromJson(dynamic error) {
  if (error == null) return null;
  
  if (error is String) {
    // Handle rate limiter string error
    return ApiErrorDetail(
      code: ErrorCode.rateLimitExceeded,
      message: error,
    );
  }
  
  if (error is Map<String, dynamic>) {
    return ApiErrorDetail.fromJson(error);
  }
  
  return null;
}
