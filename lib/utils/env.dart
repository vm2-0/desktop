import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  /// Load .env file for fallback configuration (build-time vars take precedence)
  static Future<void> loadEnvironmentFile() async {
    const environment = String.fromEnvironment('ENVIRONMENT');

    try {
      await dotenv.load();
      debugPrint(
        'Loaded .env file for fallback config (build environment: ${environment.isEmpty ? 'default' : environment})',
      );
    } catch (e) {
      debugPrint('Failed to load .env: $e');
    }
  }

  // Use build-time constants first, fallback to .env file
  static String get env => const String.fromEnvironment('ENV') != ''
      ? const String.fromEnvironment('ENV')
      : dotenv.env['ENV'] ?? 'dev';

  static String get privacyPolicyUrl =>
      const String.fromEnvironment('PRIVACY_POLICY_URL') != ''
          ? const String.fromEnvironment('PRIVACY_POLICY_URL')
          : dotenv.env['PRIVACY_POLICY_URL'] ?? '';

  static String get baseScanBaseUrl =>
      const String.fromEnvironment('BASESCAN_BASE_URL') != ''
          ? const String.fromEnvironment('BASESCAN_BASE_URL')
          : dotenv.env['BASESCAN_BASE_URL'] ?? '';

  static String get apiWebsiteUrl =>
      const String.fromEnvironment('API_WEBSITE_URL') != ''
          ? const String.fromEnvironment('API_WEBSITE_URL')
          : dotenv.env['API_WEBSITE_URL'] ?? '';

  static String get apiBackendUrl =>
      const String.fromEnvironment('API_BACKEND_URL') != ''
          ? const String.fromEnvironment('API_BACKEND_URL')
          : dotenv.env['API_BACKEND_URL'] ?? '';

  static String get subgraphUrl =>
      const String.fromEnvironment('SUBGRAPH_URL') != ''
          ? const String.fromEnvironment('SUBGRAPH_URL')
          : dotenv.env['SUBGRAPH_URL'] ?? '';
}
