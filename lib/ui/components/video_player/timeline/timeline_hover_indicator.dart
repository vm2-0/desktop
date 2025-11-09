import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/utils/format_time.dart';
import 'package:flutter/material.dart';

class TimelineHoverIndicator extends StatelessWidget {
  const TimelineHoverIndicator({
    required this.hoverPosition,
    required this.totalDuration,
    required this.timelineWidth,
    super.key,
  });

  final Offset? hoverPosition;
  final Duration totalDuration;
  final double timelineWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final durationMs = totalDuration.inMilliseconds.toDouble();

    final children = <Widget>[];

    if (hoverPosition != null) {
      children.add(
        Positioned(
          left: hoverPosition!.dx.clamp(0, timelineWidth),
          top: 0,
          bottom: 0,
          child: Container(
            width: 2,
            color: ClonesColors.primary.withValues(alpha: 0.8),
          ),
        ),
      );
    }
    if (hoverPosition != null && durationMs > 0) {
      children.add(
        Positioned(
          top: 10,
          left: (hoverPosition!.dx - 20).clamp(0.0, timelineWidth - 40),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              formatVideoTime(
                Duration(
                  milliseconds:
                      ((hoverPosition!.dx / timelineWidth) * durationMs)
                          .toInt(),
                ),
                includeMilliseconds: true,
              ),
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontSize: 8,
              ),
            ),
          ),
        ),
      );
    }
    return Stack(children: children);
  }
}
