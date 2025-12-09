import 'dart:convert';
import 'package:flutter/foundation.dart';

@immutable
sealed class VideoSource {
  const VideoSource();
}

@immutable
class AssetVideoSource extends VideoSource {
  const AssetVideoSource(this.path);
  final String path;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AssetVideoSource && other.path == path;
  }

  @override
  int get hashCode => path.hashCode;
}

@immutable
class FileVideoSource extends VideoSource {
  const FileVideoSource(this.path);
  final String path;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FileVideoSource && other.path == path;
  }

  @override
  int get hashCode => path.hashCode;
}

@immutable
class Base64VideoSource extends VideoSource {
  const Base64VideoSource(this.dataUri);
  final String dataUri;

  List<int> get videoBytes {
    if (!dataUri.startsWith('data:video/mp4;base64,')) {
      throw ArgumentError('Invalid data URI format');
    }
    final parts = dataUri.split(',');
    if (parts.length != 2) {
      throw ArgumentError('Invalid data URI format');
    }
    final base64String = parts[1];
    return base64Decode(base64String);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Base64VideoSource && other.dataUri == dataUri;
  }

  @override
  int get hashCode => dataUri.hashCode;
}

@immutable
class HttpVideoSource extends VideoSource {
  const HttpVideoSource(this.url);
  final String url;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HttpVideoSource && other.url == url;
  }

  @override
  int get hashCode => url.hashCode;
}
