import 'package:freezed_annotation/freezed_annotation.dart';

part 'sft_message.freezed.dart';
part 'sft_message.g.dart';

/// Union type for different SFT message variants
@Freezed(unionKey: 'role', fallbackUnion: 'unknown')
sealed class SftMessage with _$SftMessage {
  /// Assistant message - has role: "assistant"
  const factory SftMessage.assistant({
    required String content,
    required int timestamp,
    String? type,
    Map<String, dynamic>? data,
  }) = AssistantSftMessage;

  /// User message - has role: "user"
  const factory SftMessage.user({
    required SftMessageContent content,
    required int timestamp,
  }) = UserSftMessage;

  /// Context annotation - has type: "context_annotation" (no role)
  @FreezedUnionValue('context_annotation')
  const factory SftMessage.contextAnnotation({
    required int timestamp,
    required Map<String, dynamic> data,
  }) = ContextAnnotationSftMessage;

  /// Unknown/fallback for any other message types
  const factory SftMessage.unknown({
    required int timestamp,
    Map<String, dynamic>? rawData,
  }) = UnknownSftMessage;

  factory SftMessage.fromJson(Map<String, dynamic> json) {
    // Custom deserialization logic to handle the different variants
    final role = json['role'] as String?;
    final type = json['type'] as String?;
    final timestamp = json['timestamp'] as int;

    if (type == 'context_annotation') {
      // Context annotation variant
      return SftMessage.contextAnnotation(
        timestamp: timestamp,
        data: json['data'] as Map<String, dynamic>? ?? {},
      );
    } else if (role == 'assistant') {
      // Assistant variant
      return SftMessage.assistant(
        content: json['content'] as String,
        timestamp: timestamp,
        type: type,
        data: json['data'] as Map<String, dynamic>?,
      );
    } else if (role == 'user') {
      // User variant
      final contentData = json['content'];
      return SftMessage.user(
        content: SftMessageContent.fromJson(
          contentData is Map<String, dynamic>
              ? contentData
              : {'type': 'text', 'data': contentData},
        ),
        timestamp: timestamp,
      );
    } else {
      // Unknown variant - preserve raw data
      return SftMessage.unknown(
        timestamp: timestamp,
        rawData: json,
      );
    }
  }
}

/// Content type for user messages (can be image or text)
@freezed
class SftMessageContent with _$SftMessageContent {
  const factory SftMessageContent.image({
    required String data, // Base64 encoded image
  }) = ImageContent;

  const factory SftMessageContent.text({
    required String data,
  }) = TextContent;

  factory SftMessageContent.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String?;
    final data = json['data'] as String;

    if (type == 'image') {
      return SftMessageContent.image(data: data);
    } else {
      return SftMessageContent.text(data: data);
    }
  }
}

/// Typed data structure for app focus information
@freezed
class AppFocusData with _$AppFocusData {
  const factory AppFocusData({
    required String focusedApp,
    required List<String> availableApps,
    required String appStatus,
    required List<WindowInfo> allWindows,
  }) = _AppFocusData;

  factory AppFocusData.fromJson(Map<String, dynamic> json) {
    return AppFocusData(
      focusedApp: json['focused_app'] as String,
      availableApps: (json['available_apps'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      appStatus: json['app_status'] as String,
      allWindows: (json['all_windows'] as List<dynamic>)
          .map((e) => WindowInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Window information structure
@freezed
class WindowInfo with _$WindowInfo {
  const factory WindowInfo({
    required Map<String, dynamic> bbox,
    required List<dynamic> children,
    required String description,
    required String name,
    required String role,
    required String value,
  }) = _WindowInfo;

  factory WindowInfo.fromJson(Map<String, dynamic> json) =>
      _$WindowInfoFromJson(json);
}
