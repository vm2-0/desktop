import 'dart:ui';

import 'package:clones_desktop/utils/window_alignment.dart';
import 'package:flutter/foundation.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:window_manager/window_manager.dart';

/// Flutter-based window management to replace Tauri window APIs
class FlutterWindowManager {
  /// Resize the Flutter window
  static Future<void> resizeWindow(double width, double height) async {
    if (kIsWeb) return;

    try {
      await windowManager.setSize(Size(width, height));
    } catch (e) {
      debugPrint('Failed to resize window: $e');
      rethrow;
    }
  }

  /// Set window position based on alignment
  static Future<void> setWindowPosition(WindowAlignment alignment) async {
    if (kIsWeb) return;

    try {
      debugPrint('FlutterWindowManager: Setting window position to $alignment');
      final screenSize = await windowManager.getSize();
      final primaryDisplay = await screenRetriever.getPrimaryDisplay();
      final displaySize = primaryDisplay.size;

      late Offset position;

      switch (alignment) {
        case WindowAlignment.topLeft:
          position = Offset.zero;
          break;
        case WindowAlignment.topCenter:
          position = Offset(
            (displaySize.width - screenSize.width) / 2,
            0,
          );
          break;
        case WindowAlignment.topRight:
          position = Offset(
            displaySize.width - screenSize.width,
            0,
          );
          break;
        case WindowAlignment.leftCenter:
          position = Offset(
            0,
            (displaySize.height - screenSize.height) / 2,
          );
          break;
        case WindowAlignment.center:
          position = Offset(
            (displaySize.width - screenSize.width) / 2,
            (displaySize.height - screenSize.height) / 2,
          );
          break;
        case WindowAlignment.rightCenter:
          position = Offset(
            displaySize.width - screenSize.width,
            (displaySize.height - screenSize.height) / 2,
          );
          break;
        case WindowAlignment.bottomLeft:
          position = Offset(
            0,
            displaySize.height - screenSize.height,
          );
          break;
        case WindowAlignment.bottomCenter:
          position = Offset(
            (displaySize.width - screenSize.width) / 2,
            displaySize.height - screenSize.height,
          );
          break;
        case WindowAlignment.bottomRight:
          position = Offset(
            displaySize.width - screenSize.width,
            displaySize.height - screenSize.height,
          );
          break;
      }

      await windowManager.setPosition(position);
      debugPrint('FlutterWindowManager: Window position set to $position');
    } catch (e) {
      debugPrint('Failed to set window position: $e');
      rethrow;
    }
  }

  /// Get current window size
  static Future<({double width, double height})> getWindowSize() async {
    if (kIsWeb) {
      return (width: 1200.0, height: 800.0); // Default for web
    }

    try {
      final size = await windowManager.getSize();
      return (width: size.width, height: size.height);
    } catch (e) {
      debugPrint('Failed to get window size: $e');
      rethrow;
    }
  }

  /// Set window resizable state
  static Future<void> setWindowResizable(bool resizable) async {
    if (kIsWeb) return;

    try {
      await windowManager.setResizable(resizable);
    } catch (e) {
      debugPrint('Failed to set window resizable: $e');
      rethrow;
    }
  }

  /// Get displays size (monitors)
  static Future<List<({double width, double height})>> getDisplaysSize() async {
    if (kIsWeb) {
      return [(width: 1920.0, height: 1080.0)]; // Default for web
    }

    try {
      final displays = await screenRetriever.getAllDisplays();
      return displays
          .map(
            (display) => (
              width: display.size.width,
              height: display.size.height,
            ),
          )
          .toList();
    } catch (e) {
      debugPrint('Failed to get displays size: $e');
      rethrow;
    }
  }
}
