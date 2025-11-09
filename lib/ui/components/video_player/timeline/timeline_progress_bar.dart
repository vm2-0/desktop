import 'package:clones_desktop/assets.dart';
import 'package:flutter/material.dart';

class TimelineProgressBar extends StatelessWidget {
  const TimelineProgressBar({
    required this.currentPosition,
    required this.totalDuration,
    required this.timelineWidth,
    super.key,
  });

  final Duration currentPosition;
  final Duration totalDuration;
  final double timelineWidth;

  @override
  Widget build(BuildContext context) {
    final durationMs = totalDuration.inMilliseconds.toDouble();
    if (durationMs > 0 && timelineWidth > 0) {
      final progressWidth = (currentPosition.inMilliseconds / durationMs) * timelineWidth;
      final clampedWidth = progressWidth.clamp(0.0, timelineWidth);
      
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: clampedWidth,
          height: 4,
          decoration: BoxDecoration(
            color: ClonesColors.secondary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
