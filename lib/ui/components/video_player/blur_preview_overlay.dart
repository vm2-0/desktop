import 'dart:ui';
import 'package:clones_desktop/ui/components/video_player/timeline/timeline_blur_regions.dart';
import 'package:flutter/material.dart';

/// Overlay widget that shows blur preview effects over the video
class BlurPreviewOverlay extends StatelessWidget {
  const BlurPreviewOverlay({
    required this.blurRegions,
    required this.currentTimeMs,
    required this.videoSize,
    required this.recordingResolution,
    super.key,
  });

  final List<BlurRegion> blurRegions;
  final double currentTimeMs;
  final Size videoSize;
  final Size recordingResolution;

  @override
  Widget build(BuildContext context) {
    // Debug: Print blur regions info
    if (blurRegions.isNotEmpty) {
      print('🔍 BlurPreviewOverlay: ${blurRegions.length} total blur regions');
      print('🔍 Current time: ${currentTimeMs}ms');
      for (final region in blurRegions) {
        print(
            '🔍 Region ${region.id}: ${region.startTimeMs}ms - ${region.endTimeMs}ms');
      }
    }

    // Filter blur regions that are active at current time
    final activeBlurRegions = blurRegions.where((region) {
      return currentTimeMs >= region.startTimeMs &&
          currentTimeMs <= region.endTimeMs;
    }).toList();

    print('🔍 Active blur regions: ${activeBlurRegions.length}');

    if (activeBlurRegions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: activeBlurRegions.map(_buildBlurRegion).toList(),
    );
  }

  Widget _buildBlurRegion(BlurRegion region) {
    // Calculate the actual position and size on the video player
    final left = region.x * videoSize.width;
    final top = region.y * videoSize.height;
    final width = region.width * videoSize.width;
    final height = region.height * videoSize.height;

    // Calculate blur intensity (region.intensity is 1-10, convert to sigma values)
    final blurSigma = (region.intensity / 10.0) * 15.0; // Max sigma of 15

    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurSigma,
            sigmaY: blurSigma,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: _getBlurOverlayColor(region.blurType),
              border: Border.all(
                color: Colors.blue.withValues(alpha: 0.3),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.blur_on,
                color: Colors.white.withValues(alpha: 0.4),
                size: (width + height) / 20, // Scale icon with region size
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getBlurOverlayColor(String blurType) {
    switch (blurType.toLowerCase()) {
      case 'gaussian':
        return Colors.black.withValues(alpha: 0.15);
      case 'box':
        return Colors.black.withValues(alpha: 0.1);
      case 'smart':
        return Colors.black.withValues(alpha: 0.2);
      default:
        return Colors.black.withValues(alpha: 0.15);
    }
  }
}
