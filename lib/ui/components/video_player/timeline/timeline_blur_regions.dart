import 'package:flutter/material.dart';

/// Data model for blur regions that matches the Rust backend structure
class BlurRegion {
  const BlurRegion({
    required this.id,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.startTimeMs,
    required this.endTimeMs,
    required this.intensity,
    required this.blurType,
  });

  final String id;
  final double x; // 0.0 to 1.0 relative to video width
  final double y; // 0.0 to 1.0 relative to video height  
  final double width; // 0.0 to 1.0 relative to video dimensions
  final double height; // 0.0 to 1.0 relative to video dimensions
  final double startTimeMs; // Start time in milliseconds
  final double endTimeMs; // End time in milliseconds
  final int intensity; // 1-10 blur intensity
  final String blurType; // "gaussian", "box", "smart"

  factory BlurRegion.fromJson(Map<String, dynamic> json) {
    return BlurRegion(
      id: json['id'] as String,
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      startTimeMs: (json['start_time_ms'] as num).toDouble(),
      endTimeMs: (json['end_time_ms'] as num).toDouble(),
      intensity: json['intensity'] as int,
      blurType: json['blur_type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'start_time_ms': startTimeMs,
      'end_time_ms': endTimeMs,
      'intensity': intensity,
      'blur_type': blurType,
    };
  }

  BlurRegion copyWith({
    String? id,
    double? x,
    double? y,
    double? width,
    double? height,
    double? startTimeMs,
    double? endTimeMs,
    int? intensity,
    String? blurType,
  }) {
    return BlurRegion(
      id: id ?? this.id,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      startTimeMs: startTimeMs ?? this.startTimeMs,
      endTimeMs: endTimeMs ?? this.endTimeMs,
      intensity: intensity ?? this.intensity,
      blurType: blurType ?? this.blurType,
    );
  }

  /// Check if this blur region contains a specific time in milliseconds
  bool containsTime(double timeMs) {
    return timeMs >= startTimeMs && timeMs <= endTimeMs;
  }

  /// Get the duration of this blur region in milliseconds
  double get durationMs => endTimeMs - startTimeMs;
}

/// Widget that renders blur regions on the timeline
class TimelineBlurRegions extends StatelessWidget {
  const TimelineBlurRegions({
    required this.blurRegions,
    required this.selectedIds,
    required this.durationMs,
    required this.timelineWidth,
    this.onRegionTap,
    super.key,
  });

  final List<BlurRegion> blurRegions;
  final Set<String> selectedIds;
  final double durationMs;
  final double timelineWidth;
  final void Function(BlurRegion)? onRegionTap;

  @override
  Widget build(BuildContext context) {
    if (blurRegions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: blurRegions.map((region) => _buildBlurRegionBar(context, region)).toList(),
    );
  }

  Widget _buildBlurRegionBar(BuildContext context, BlurRegion region) {
    final isSelected = selectedIds.contains(region.id);
    
    // Calculate position and size on timeline
    final startPosition = (region.startTimeMs / durationMs) * timelineWidth;
    final regionWidth = ((region.endTimeMs - region.startTimeMs) / durationMs) * timelineWidth;

    // Ensure minimum visible width
    final displayWidth = regionWidth.clamp(2.0, timelineWidth);

    return Positioned(
      left: startPosition,
      top: 8, // Position below time labels
      child: GestureDetector(
        onTap: () => onRegionTap?.call(region),
        child: Container(
          width: displayWidth,
          height: 24, // Height for blur region bars
          decoration: BoxDecoration(
            color: _getBlurRegionColor(region, isSelected),
            borderRadius: BorderRadius.circular(4),
            border: isSelected
                ? Border.all(color: Colors.white, width: 2)
                : Border.all(color: Colors.white24, width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Row(
              children: [
                // Blur icon
                SizedBox(
                  width: 20,
                  child: Icon(
                    Icons.blur_on,
                    size: 12,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                // Text label if there's space
                if (displayWidth > 50)
                  Expanded(
                    child: Text(
                      'Blur ${region.intensity}',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                // Intensity indicator (right edge)
                Container(
                  width: 3,
                  decoration: BoxDecoration(
                    color: _getIntensityColor(region.intensity),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(3),
                      bottomRight: Radius.circular(3),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getBlurRegionColor(BlurRegion region, bool isSelected) {
    final baseColor = _getBlurTypeColor(region.blurType);
    
    if (isSelected) {
      return baseColor.withValues(alpha: 0.9);
    }
    return baseColor.withValues(alpha: 0.7);
  }

  Color _getBlurTypeColor(String blurType) {
    switch (blurType) {
      case 'gaussian':
        return Colors.blue.shade600;
      case 'box':
        return Colors.purple.shade600;
      case 'smart':
        return Colors.green.shade600;
      default:
        return Colors.blue.shade600; // Default to gaussian color
    }
  }

  Color _getIntensityColor(int intensity) {
    // Color gradient from light to dark based on intensity (1-10)
    final normalizedIntensity = (intensity - 1) / 9.0; // 0.0 to 1.0
    return Color.lerp(
      Colors.yellow.shade400,
      Colors.red.shade700,
      normalizedIntensity,
    ) ?? Colors.orange;
  }
}

/// Compact blur region indicator for small timeline spaces
class CompactBlurRegionIndicator extends StatelessWidget {
  const CompactBlurRegionIndicator({
    required this.region,
    required this.isSelected,
    super.key,
  });

  final BlurRegion region;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: _getBlurTypeColor(region.blurType),
        shape: BoxShape.circle,
        border: isSelected
            ? Border.all(color: Colors.white, width: 2)
            : null,
      ),
      child: const Icon(
        Icons.blur_circular,
        size: 8,
        color: Colors.white,
      ),
    );
  }

  Color _getBlurTypeColor(String blurType) {
    switch (blurType) {
      case 'gaussian':
        return Colors.blue.shade600;
      case 'box':
        return Colors.purple.shade600;
      case 'smart':
        return Colors.green.shade600;
      default:
        return Colors.blue.shade600;
    }
  }
}