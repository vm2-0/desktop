import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/video_player/blur_region_editor.dart';
import 'package:clones_desktop/ui/components/video_player/timeline/timeline_base_track.dart';
import 'package:clones_desktop/ui/components/video_player/timeline/timeline_blur_regions.dart';
import 'package:clones_desktop/ui/components/video_player/timeline/timeline_context_menu_item.dart';
import 'package:clones_desktop/ui/components/video_player/timeline/timeline_editing_elements.dart';
import 'package:clones_desktop/ui/components/video_player/timeline/timeline_event_markers.dart';
import 'package:clones_desktop/ui/components/video_player/timeline/timeline_hover_indicator.dart';
import 'package:clones_desktop/ui/components/video_player/timeline/timeline_playhead.dart';
import 'package:clones_desktop/ui/components/video_player/timeline/timeline_progress_bar.dart';
import 'package:clones_desktop/ui/components/video_player/timeline/timeline_time_labels.dart';
import 'package:clones_desktop/ui/components/video_player/video_state.dart';
import 'package:clones_desktop/ui/views/demo_detail/bloc/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimelineWidget extends ConsumerStatefulWidget {
  const TimelineWidget({
    required this.videoId,
    this.onSeek,
    super.key,
  });

  final String videoId;
  final void Function(Duration)? onSeek;

  @override
  ConsumerState<TimelineWidget> createState() => _TimelineWidgetState();
}

class _TimelineWidgetState extends ConsumerState<TimelineWidget> {
  Offset? _hoverPosition;
  Offset? _lastRightClickGlobal;
  double _lastRightClickTimeMs = 0;
  final FocusNode _timelineFocus = FocusNode(debugLabel: 'timeline');
  Duration? _overridePosition;

  @override
  void dispose() {
    _timelineFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final demoDetail = ref.watch(demoDetailNotifierProvider);
    final canEdit = demoDetail.recording?.submission?.status != 'completed';

    if (!canEdit) {
      return CardWidget(
        variant: CardVariant.transparent,
        child: _buildCustomTimeline(context, ref),
      );
    }

    return CardWidget(
      variant: CardVariant.secondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCustomTimeline(context, ref),
          Padding(
            padding: const EdgeInsets.only(top: 12, left: 8),
            child: Text(
              'You can edit your demo to remove unwanted parts. Click right on the timeline to open the context menu.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTimeline(
    BuildContext context,
    WidgetRef ref,
  ) {
    final videoState = ref.watch(videoStateNotifierProvider(widget.videoId));
    final demoDetail = ref.watch(demoDetailNotifierProvider);
    final canEdit = demoDetail.recording?.submission?.status != 'completed';

    // If video starts playing, clear any override so visuals follow the real player
    if (_overridePosition != null && videoState.isPlaying) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _overridePosition = null;
          });
        }
      });
    }

    // Keep override until playback resumes; do not clear on proximity to avoid visual snap

    // Initialize clips if they are empty (defer to avoid modifying provider during build)
    if (canEdit && demoDetail.clips.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref
              .read(demoDetailNotifierProvider.notifier)
              .initializeClips(videoState.totalDuration);
        }
      });
    }

    final duration = videoState.totalDuration;
    final durationMs = duration.inMilliseconds.toDouble();

    return KeyboardListener(
      focusNode: _timelineFocus,
      onKeyEvent: (KeyEvent event) {
        if (event is! KeyDownEvent) return;
        final key = event.logicalKey;

        if (canEdit) {
          // Only allow editing shortcuts if editing is enabled
          final isCtrlOrCmd = HardwareKeyboard.instance.isControlPressed ||
              HardwareKeyboard.instance.isMetaPressed;
          final notifier = ref.read(demoDetailNotifierProvider.notifier);
          final playheadMs = (_overridePosition ?? videoState.currentPosition)
              .inMilliseconds
              .toDouble();

          if (key == LogicalKeyboardKey.keyB ||
              (isCtrlOrCmd && key == LogicalKeyboardKey.keyB)) {
            notifier.splitClipAt(playheadMs);
          } else if (key == LogicalKeyboardKey.delete ||
              key == LogicalKeyboardKey.backspace) {
            notifier.deleteSelectedClips();
          } else if (isCtrlOrCmd && key == LogicalKeyboardKey.keyZ) {
            // Undo at current playhead position
            notifier.undoDelete(playheadMs);
          }
        }
      },
      child: Container(
        height: 80, // Increased height to accommodate time labels
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final timelineWidth = constraints.maxWidth;

            return RawGestureDetector(
              gestures: {
                TapGestureRecognizer:
                    GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
                  TapGestureRecognizer.new,
                  (instance) {
                    instance.onTapUp = (details) {
                      // Adjust for horizontal padding (8px on each side)
                      final clickPosition = details.localPosition.dx;
                      final seekTime =
                          (clickPosition / timelineWidth * durationMs).round();
                      final seekDuration = Duration(milliseconds: seekTime);

                      if (widget.onSeek != null) {
                        // Snap timeline visuals immediately to the clicked position for precise editing UX
                        setState(() {
                          _overridePosition = seekDuration;
                        });
                        widget.onSeek!(seekDuration);
                      } else {
                        // Intentionally do nothing when onSeek is not provided.
                        // Avoid updating UI position directly to prevent a flash before the player syncs.
                        setState(() {
                          _overridePosition = seekDuration;
                        });
                      }
                      _timelineFocus.requestFocus();

                      // Left-click selects the clip under the cursor (iMovie-like) - only if editing is enabled
                      if (canEdit) {
                        final clips =
                            ref.read(demoDetailNotifierProvider).clips;
                        final ms = clickPosition / timelineWidth * durationMs;
                        final idx = clips
                            .indexWhere((c) => ms >= c.start && ms <= c.end);
                        if (idx != -1) {
                          ref
                              .read(demoDetailNotifierProvider.notifier)
                              .selectClip(idx);
                        }
                      }
                    };
                  },
                ),
                if (canEdit)
                  _CustomRightClickRecognizer:
                      GestureRecognizerFactoryWithHandlers<
                          _CustomRightClickRecognizer>(
                    _CustomRightClickRecognizer.new,
                    (instance) {
                      instance.onRightClick = (details) {
                        // Remember where the context menu should open
                        final global = details.globalPosition;
                        setState(() => _lastRightClickGlobal = global);

                        // Compute playhead time at click
                        final clickPosition = details.localPosition.dx;
                        _lastRightClickTimeMs =
                            (clickPosition / timelineWidth * durationMs)
                                .clamp(0.0, durationMs);

                        _timelineFocus.requestFocus();

                        _openContextMenu(
                          context,
                          ref,
                          durationMs,
                          timelineWidth,
                        );
                      };
                    },
                  ),
              },
              child: MouseRegion(
                onEnter: (_) => _timelineFocus.requestFocus(),
                onHover: (event) =>
                    setState(() => _hoverPosition = event.localPosition),
                onExit: (_) => setState(() => _hoverPosition = null),
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    TimelineTimeLabels(
                      totalDuration: videoState.totalDuration,
                      timelineWidth: timelineWidth,
                    ),
                    const TimelineBaseTrack(),
                    TimelineProgressBar(
                      currentPosition:
                          _overridePosition ?? videoState.currentPosition,
                      totalDuration: videoState.totalDuration,
                      timelineWidth: timelineWidth,
                    ),

                    TimelineEventMarkers(
                      videoId: widget.videoId,
                      timelineWidth: timelineWidth,
                    ),
                    TimelinePlayhead(
                      currentPosition:
                          _overridePosition ?? videoState.currentPosition,
                      totalDuration: videoState.totalDuration,
                      timelineWidth: timelineWidth,
                    ),

                    // Render editing elements if enabled
                    if (canEdit)
                      TimelineEditingElements(
                        durationMs: durationMs,
                        timelineWidth: timelineWidth,
                      ),

                    TimelineHoverIndicator(
                      hoverPosition: _hoverPosition,
                      totalDuration: videoState.totalDuration,
                      timelineWidth: timelineWidth,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _openContextMenu(
    BuildContext context,
    WidgetRef ref,
    double durationMs,
    double timelineWidth,
  ) async {
    final globalPos = _lastRightClickGlobal;
    if (globalPos == null) return;
    final clickTime = _lastRightClickTimeMs;

    final state = ref.read(demoDetailNotifierProvider);
    final clips = state.clips;
    final selectedClips = state.selectedClipIds;
    final deletedClips = state.deletedClipsHistory;
    final blurRegions = state.blurRegions;
    final selectedBlurRegions = state.selectedBlurRegionIds;

    // Find which clip (if any) was clicked
    final clickedClipIndex = clips.indexWhere((c) => c.contains(clickTime));
    final clickedClip = clickedClipIndex != -1 ? clips[clickedClipIndex] : null;

    // Find which blur region (if any) was clicked at this time
    BlurRegion? clickedBlurRegion;
    for (final region in blurRegions) {
      if (clickTime >= region.startTimeMs && clickTime <= region.endTimeMs) {
        clickedBlurRegion = region;
        break;
      }
    }

    // Check if we clicked on a deleted clip zone (any operation's deleted clips)
    final clickedOnDeletedZone = deletedClips.isNotEmpty &&
        deletedClips
            .any((operation) => operation.any((dc) => dc.contains(clickTime)));

    // Check if we're in the middle of a clip (not at the edges)
    final canSplit = clickedClip != null && clickedClip.canSplitAt(clickTime);

    final hasSelection = selectedClips.isNotEmpty;
    final hasBlurSelection = selectedBlurRegions.isNotEmpty;

    final textStyle =
        Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white);

    // Anchor the menu to the overlay
    final overlayBox =
        Overlay.of(context).context.findRenderObject()! as RenderBox;
    final positionRect = RelativeRect.fromLTRB(
      globalPos.dx,
      globalPos.dy,
      overlayBox.size.width - globalPos.dx,
      overlayBox.size.height - globalPos.dy,
    );

    // Build menu items dynamically based on context
    final menuItems = <PopupMenuEntry<int>>[
      // Always show play/pause
      PopupMenuItem<int>(
        value: 100,
        height: 36,
        child: TimelineContextMenuItem(
          icon: Icons.play_arrow,
          text: 'Play/Pause (Space)',
          textStyle: textStyle,
        ),
      ),
      const PopupMenuDivider(height: 8),
      // Split - only if in middle of a clip
      if (canSplit)
        PopupMenuItem<int>(
          value: 1,
          height: 36,
          child: TimelineContextMenuItem(
            icon: Icons.content_cut,
            text: 'Split clip (B)',
            textStyle: textStyle,
          ),
        ),
      // Add Blur Region
      PopupMenuItem<int>(
        value: 8,
        height: 36,
        child: TimelineContextMenuItem(
          icon: Icons.blur_on,
          text: 'Add blur region',
          textStyle: textStyle,
        ),
      ),
      // Delete - only if clips are selected
      if (hasSelection)
        PopupMenuItem<int>(
          value: 2,
          height: 36,
          child: TimelineContextMenuItem(
            icon: Icons.delete_outline,
            text: 'Delete clips (Del)',
            textStyle: textStyle,
          ),
        ),
      // Blur region options
      if (clickedBlurRegion != null) ...[
        PopupMenuItem<int>(
          value: 10,
          height: 36,
          child: TimelineContextMenuItem(
            icon: Icons.edit,
            text: 'Edit blur region',
            textStyle: textStyle,
          ),
        ),
        PopupMenuItem<int>(
          value: 11,
          height: 36,
          child: TimelineContextMenuItem(
            icon: Icons.delete_outline,
            text: 'Delete blur region',
            textStyle: textStyle,
          ),
        ),
      ],
      // Delete selected blur regions
      if (hasBlurSelection)
        PopupMenuItem<int>(
          value: 12,
          height: 36,
          child: TimelineContextMenuItem(
            icon: Icons.delete_outline,
            text: 'Delete selected blur regions',
            textStyle: textStyle,
          ),
        ),
      // Undo - only if we clicked on a deleted clip zone
      if (clickedOnDeletedZone) ...[
        const PopupMenuDivider(height: 8),
        PopupMenuItem<int>(
          value: 9,
          height: 36,
          child: TimelineContextMenuItem(
            icon: Icons.undo,
            text: 'Undo delete (Cmd/Ctrl+Z)',
            textStyle: textStyle,
          ),
        ),
      ],
      // Selection options
      if (clickedClipIndex != -1 || hasSelection) ...[
        const PopupMenuDivider(height: 4),
        // Select this clip - only if we clicked on a clip that is NOT already selected
        if (clickedClipIndex != -1 && !selectedClips.contains(clickedClip!.id))
          PopupMenuItem<int>(
            value: 6,
            height: 36,
            child: TimelineContextMenuItem(
              icon: Icons.check_circle_outline,
              text: 'Select this clip',
              textStyle: textStyle,
            ),
          ),
        // Clear selection - only if something is selected
        if (hasSelection)
          PopupMenuItem<int>(
            value: 7,
            height: 36,
            child: TimelineContextMenuItem(
              icon: Icons.radio_button_unchecked,
              text: 'Clear selection',
              textStyle: textStyle,
            ),
          ),
      ],
    ];

    await showMenu<int>(
      context: context,
      position: positionRect,
      useRootNavigator: true,
      color: Colors.black.withValues(alpha: 0.92),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.white24, width: 0.5),
      ),
      items: menuItems,
      elevation: 0,
    ).then((value) {
      final notifier = ref.read(demoDetailNotifierProvider.notifier);
      final videoStateNotifier =
          ref.read(videoStateNotifierProvider(widget.videoId).notifier);

      if (value == 100) {
        // Play/Pause
        final videoState = ref.read(videoStateNotifierProvider(widget.videoId));
        if (videoState.isPlaying) {
          videoStateNotifier.setPaused();
        } else {
          videoStateNotifier.setPlaying();
        }
      } else if (value == 1) {
        notifier.splitClipAt(clickTime);
      } else if (value == 2) {
        notifier.deleteSelectedClips();
      } else if (value == 9) {
        notifier.undoDelete(clickTime);
      } else if (value == 6) {
        final clips = ref.read(demoDetailNotifierProvider).clips;
        final idx = clips.indexWhere((c) => c.contains(clickTime));
        if (idx != -1) {
          notifier.selectClip(idx);
        }
      } else if (value == 7) {
        notifier.clearSelection();
      } else if (value == 8) {
        // Add Blur Region - create a quick blur region modal
        _showAddBlurRegionModal(context, ref, clickTime, durationMs);
      } else if (value == 10) {
        // Edit blur region
        if (clickedBlurRegion != null) {
          _showEditBlurRegionModal(context, ref, clickedBlurRegion!, durationMs);
        }
      } else if (value == 11) {
        // Delete specific blur region
        if (clickedBlurRegion != null) {
          notifier.removeBlurRegion(clickedBlurRegion!.id);
        }
      } else if (value == 12) {
        // Delete selected blur regions
        for (final regionId in selectedBlurRegions) {
          notifier.removeBlurRegion(regionId);
        }
      }
    });
  }

  Future<void> _showAddBlurRegionModal(
    BuildContext context,
    WidgetRef ref,
    double currentTimeMs,
    double videoDurationMs,
  ) async {
    await showDialog(
      context: context,
      builder: (context) => QuickBlurRegionModal(
        currentTimeMs: currentTimeMs,
        videoDurationMs: videoDurationMs,
        onRegionCreated: (blurRegion) {
          ref.read(demoDetailNotifierProvider.notifier).addBlurRegion(blurRegion);
        },
      ),
    );
  }

  Future<void> _showEditBlurRegionModal(
    BuildContext context,
    WidgetRef ref,
    BlurRegion existingRegion,
    double videoDurationMs,
  ) async {
    await showDialog(
      context: context,
      builder: (context) => QuickBlurRegionModal(
        currentTimeMs: existingRegion.startTimeMs,
        videoDurationMs: videoDurationMs,
        editingRegion: existingRegion,
        onRegionCreated: (blurRegion) {
          ref.read(demoDetailNotifierProvider.notifier).updateBlurRegion(blurRegion);
        },
      ),
    );
  }
}

/// Custom gesture recognizer that handles right-click events and prevents browser context menu
class _CustomRightClickRecognizer extends OneSequenceGestureRecognizer {
  void Function(TapUpDetails)? onRightClick;

  @override
  String get debugDescription => 'custom right click';

  @override
  void addAllowedPointer(PointerDownEvent event) {
    if (event.buttons == kSecondaryButton) {
      startTrackingPointer(event.pointer, event.transform);
      resolve(GestureDisposition.accepted);
    } else {
      resolve(GestureDisposition.rejected);
    }
  }

  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerUpEvent && event.buttons == 0) {
      // This was a right-click release
      final details = TapUpDetails(
        kind: event.kind,
        globalPosition: event.position,
        localPosition: event.localPosition,
      );

      // Invoke the callback
      onRightClick?.call(details);

      // Stop tracking
      stopTrackingPointer(event.pointer);
    }
  }

  @override
  void didStopTrackingLastPointer(int pointer) {
    // Clean up when done tracking
  }
}
