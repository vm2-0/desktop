import 'dart:convert';
import 'dart:typed_data';

import 'package:clones_desktop/domain/app_info.dart';
import 'package:clones_desktop/domain/models/demonstration/demonstration.dart';
import 'package:clones_desktop/domain/models/recording/recording_meta.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class TauriApiClient {
  TauriApiClient({http.Client? client}) : _client = client ?? http.Client();
  final String _baseUrl = 'http://127.0.0.1:19847';
  final http.Client _client;

  Future<List<RecordingMeta>> listRecordings() async {
    final response = await _client.get(Uri.parse('$_baseUrl/recordings'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => RecordingMeta.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load recordings: ${response.body}');
    }
  }

  Future<void> writeRecordingFile({
    required String recordingId,
    required String filename,
    required String content,
  }) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/recordings/$recordingId/files'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'filename': filename,
        'content': content,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to write recording file: ${response.body}');
    }
  }

  Future<String> getRecordingFile({
    required String recordingId,
    required String filename,
    bool asPath = false,
    bool asBase64 = false,
  }) async {
    final response = await _client.get(
      Uri.parse(
        '$_baseUrl/recordings/$recordingId/files?filename=$filename&asPath=$asPath&asBase64=$asBase64',
      ),
    );
    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    } else {
      throw Exception('Failed to get recording file: ${response.body}');
    }
  }

  Future<void> startRecording({Demonstration? demonstration}) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/recordings/start'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'demonstration': demonstration?.toJson(),
        'fps': 30,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to start recording: ${response.body}');
    }
  }

  // TODO(reddwarf03): If fail, cancel record storage
  Future<String> stopRecording(String status) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/recordings/stop'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'status': status}),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to stop recording: ${response.body}');
    }
  }

  Future<String> deleteRecording(String recordingId) async {
    final response = await _client.delete(
      Uri.parse('$_baseUrl/recordings/$recordingId'),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to delete recording: ${response.body}');
    }
  }

  // TODO(reddwarf03): Not used ?
  Future<List<AppInfo>> listApps() async {
    final response = await _client.get(Uri.parse('$_baseUrl/apps'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => AppInfo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load apps: ${response.body}');
    }
  }

  Future<String> takeScreenshot() async {
    final response = await _client.get(Uri.parse('$_baseUrl/screenshot'));

    if (response.statusCode == 200) {
      // La réponse est directement la chaîne base64
      return response.body;
    } else {
      throw Exception('Failed to take screenshot: ${response.body}');
    }
  }

  Future<void> setUploadDataAllowed(bool allowed) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/settings/upload-allowed'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'allowed': allowed}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to set upload data allowed: ${response.body}');
    }
  }

  Future<bool> getUploadDataAllowed() async {
    final response =
        await _client.get(Uri.parse('$_baseUrl/settings/upload-allowed'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
        'Failed to check upload confirmation allowance: ${response.body}',
      );
    }
  }

  Future<bool> hasAxPerms() async {
    final response = await _client.get(Uri.parse('$_baseUrl/permissions/ax'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['has_permission'] ?? false;
    } else {
      throw Exception(
        'Failed to get accessibility permissions: ${response.body}',
      );
    }
  }

  // --- Permissions & Settings ---

  Future<bool> hasRecordPerms() async {
    final response =
        await _client.get(Uri.parse('$_baseUrl/permissions/record'));
    if (response.statusCode == 200) {
      return (json.decode(response.body)['has_permission']) ?? false;
    }
    throw Exception('Failed to get record permissions: ${response.body}');
  }

  Future<void> requestRecordPerms() async {
    final response =
        await _client.post(Uri.parse('$_baseUrl/permissions/record/request'));
    if (response.statusCode != 200) {
      throw Exception('Failed to request record permissions: ${response.body}');
    }
  }

  Future<void> requestAxPerms() async {
    final response =
        await _client.post(Uri.parse('$_baseUrl/permissions/ax/request'));
    if (response.statusCode != 200) {
      throw Exception(
        'Failed to request accessibility permissions: ${response.body}',
      );
    }
  }

  // --- Tools ---

  Future<void> initTools() async {
    final response = await _client.post(Uri.parse('$_baseUrl/tools/init'));
    if (response.statusCode != 200) {
      throw Exception('Failed to initialize tools: ${response.body}');
    }
  }

  Future<Map<String, bool>> checkTools() async {
    final response = await _client.get(Uri.parse('$_baseUrl/tools/check'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data.map((key, value) => MapEntry(key, value as bool));
    } else {
      throw Exception('Failed to check tools: ${response.body}');
    }
  }

  // --- Recording Actions ---

  Future<void> processRecording(
    String recordingId, {
    String? connectToken,
    required String backendUrl,
  }) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (connectToken != null) {
      headers['x-connect-token'] = connectToken;
    }

    final uri = Uri.parse('$_baseUrl/recordings/$recordingId/process').replace(
      queryParameters: {'backend_url': backendUrl},
    );

    final response = await _client.post(uri, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Failed to process recording: ${response.body}');
    }
  }

  Future<Uint8List> getRecordingZip(String recordingId) async {
    final response =
        await _client.get(Uri.parse('$_baseUrl/recordings/$recordingId/zip'));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to get recording zip: ${response.body}');
    }
  }

  Future<Uint8List> getFilteredRecordingZip(
    String recordingId,
    List<Map<String, double>> deletedRanges,
  ) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/recordings/$recordingId/filtered-zip'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'deleted_ranges': deletedRanges}),
    );
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to get filtered recording zip: ${response.body}');
    }
  }

  // --- Deep Link ---

  Future<String?> getDeepLink() async {
    final response = await _client.get(Uri.parse('$_baseUrl/deeplink'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['url'];
    } else {
      throw Exception('Failed to get deep link: ${response.body}');
    }
  }

  Future<String> getPlatform() async {
    final response = await _client.get(Uri.parse('$_baseUrl/platform'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to get platform: ${response.body}');
    }
  }

  Future<void> openLogsFolder() async {
    final response = await _client.post(Uri.parse('$_baseUrl/logs/open'));
    if (response.statusCode != 200) {
      throw Exception('Failed to open logs folder: ${response.body}');
    }
  }
}
