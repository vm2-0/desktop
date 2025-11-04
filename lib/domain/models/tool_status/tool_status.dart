import 'package:freezed_annotation/freezed_annotation.dart';

part 'tool_status.freezed.dart';
part 'tool_status.g.dart';

@freezed
class ToolStatus with _$ToolStatus {
  const factory ToolStatus({
    @JsonKey(fromJson: _statusFromJson, toJson: _statusToString)
    required ToolInitStatus status,
    required String message,
    required int progress,
  }) = _ToolStatus;

  factory ToolStatus.fromJson(Map<String, dynamic> json) =>
      _$ToolStatusFromJson(json);
}

ToolInitStatus _statusFromJson(dynamic value) {
  return ToolInitStatus.fromString(value as String);
}

String _statusToString(ToolInitStatus status) {
  return status.when(
    idle: () => 'idle',
    starting: () => 'starting',
    downloading: () => 'downloading',
    completed: () => 'completed',
    error: () => 'error',
  );
}

@freezed
class ToolInitStatus with _$ToolInitStatus {
  const factory ToolInitStatus.idle() = _Idle;
  const factory ToolInitStatus.starting() = _Starting;
  const factory ToolInitStatus.downloading() = _Downloading;
  const factory ToolInitStatus.completed() = _Completed;
  const factory ToolInitStatus.error() = _Error;

  factory ToolInitStatus.fromString(String status) {
    switch (status) {
      case 'idle':
        return const ToolInitStatus.idle();
      case 'starting':
        return const ToolInitStatus.starting();
      case 'downloading':
        return const ToolInitStatus.downloading();
      case 'completed':
        return const ToolInitStatus.completed();
      case 'error':
        return const ToolInitStatus.error();
      default:
        return const ToolInitStatus.idle();
    }
  }
}
