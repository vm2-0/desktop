import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/components/video_player/timeline/timeline_blur_regions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Editor for creating and modifying blur regions over video content
class BlurRegionEditor extends StatefulWidget {
  const BlurRegionEditor({
    required this.videoWidth,
    required this.videoHeight,
    required this.videoDurationMs,
    required this.currentTimeMs,
    required this.onRegionCreated,
    required this.onRegionUpdated,
    required this.onCancel,
    this.editingRegion,
    super.key,
  });

  final double videoWidth;
  final double videoHeight;
  final double videoDurationMs;
  final double currentTimeMs;
  final void Function(BlurRegion) onRegionCreated;
  final void Function(BlurRegion) onRegionUpdated;
  final VoidCallback onCancel;
  final BlurRegion? editingRegion;

  @override
  State<BlurRegionEditor> createState() => _BlurRegionEditorState();
}

class _BlurRegionEditorState extends State<BlurRegionEditor> {
  late Rect _selectedRegion;
  late double _startTimeMs;
  late double _endTimeMs;
  late int _intensity;
  late String _blurType;

  bool _isDragging = false;
  bool _isResizing = false;
  int _resizeHandle = -1; // 0=TL, 1=TR, 2=BL, 3=BR, -1=none
  Offset? _dragStart;
  Rect? _initialRegion;

  @override
  void initState() {
    super.initState();

    if (widget.editingRegion != null) {
      // Editing existing region
      final region = widget.editingRegion!;
      _selectedRegion = Rect.fromLTWH(
        region.x * widget.videoWidth,
        region.y * widget.videoHeight,
        region.width * widget.videoWidth,
        region.height * widget.videoHeight,
      );
      _startTimeMs = region.startTimeMs;
      _endTimeMs = region.endTimeMs;
      _intensity = region.intensity;
      _blurType = region.blurType;
    } else {
      // Creating new region - start with a default size at the center
      const defaultSize = 100.0;
      _selectedRegion = Rect.fromCenter(
        center: Offset(widget.videoWidth / 2, widget.videoHeight / 2),
        width: defaultSize,
        height: defaultSize,
      );
      _startTimeMs = widget.currentTimeMs;
      _endTimeMs = widget.currentTimeMs + 5000; // Default 5 seconds
      _intensity = 5; // Medium blur
      _blurType = 'gaussian';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.8),
      body: Column(
        children: [
          _buildToolbar(context),
          Expanded(
            child: Stack(
              children: [
                // Video preview area
                Center(
                  child: Container(
                    width: widget.videoWidth,
                    height: widget.videoHeight,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Stack(
                      children: [
                        // Placeholder for video frame (in real implementation, show actual video)
                        Container(
                          width: widget.videoWidth,
                          height: widget.videoHeight,
                          color: Colors.grey.shade800,
                          child: const Center(
                            child: Icon(
                              Icons.play_circle_outline,
                              size: 64,
                              color: Colors.white38,
                            ),
                          ),
                        ),
                        // Blur region overlay
                        _buildBlurRegionOverlay(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildControlPanel(context),
        ],
      ),
    );
  }

  Widget _buildToolbar(BuildContext context) {
    return Container(
      height: 56,
      color: Colors.black.withValues(alpha: 0.9),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            widget.editingRegion != null
                ? 'Edit Blur Region'
                : 'Create Blur Region',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const Spacer(),
          TextButton(
            onPressed: widget.onCancel,
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: _saveBlurRegion,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
            ),
            child: Text(widget.editingRegion != null ? 'Update' : 'Create'),
          ),
        ],
      ),
    );
  }

  Widget _buildBlurRegionOverlay() {
    return Positioned(
      left: _selectedRegion.left,
      top: _selectedRegion.top,
      child: GestureDetector(
        onPanStart: (details) {
          _dragStart = details.localPosition;
          _initialRegion = _selectedRegion;

          // Check if we're hitting a resize handle
          final handles = _getResizeHandles();
          for (int i = 0; i < handles.length; i++) {
            if ((handles[i] - details.localPosition).distance < 20) {
              _isResizing = true;
              _resizeHandle = i;
              return;
            }
          }

          // Otherwise, we're dragging the whole region
          _isDragging = true;
        },
        onPanUpdate: (details) {
          setState(() {
            if (_isResizing && _dragStart != null && _initialRegion != null) {
              _handleResize(details.localPosition);
            } else if (_isDragging &&
                _dragStart != null &&
                _initialRegion != null) {
              _handleDrag(details.localPosition);
            }
          });
        },
        onPanEnd: (details) {
          _isDragging = false;
          _isResizing = false;
          _resizeHandle = -1;
          _dragStart = null;
          _initialRegion = null;
        },
        child: Container(
          width: _selectedRegion.width,
          height: _selectedRegion.height,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue.shade400, width: 2),
            color: Colors.blue.withValues(alpha: 0.2),
          ),
          child: Stack(
            children: [
              // Blur preview effect (simulated)
              Container(
                width: _selectedRegion.width,
                height: _selectedRegion.height,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  backgroundBlendMode: BlendMode.overlay,
                ),
                child: const Center(
                  child: Icon(
                    Icons.blur_on,
                    color: Colors.white54,
                    size: 32,
                  ),
                ),
              ),
              // Resize handles
              ..._buildResizeHandles(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildResizeHandles() {
    const handleSize = 12.0;
    const handleColor = Colors.blue;

    return [
      // Top-left
      Positioned(
        left: -handleSize / 2,
        top: -handleSize / 2,
        child: _buildHandle(handleColor, handleSize),
      ),
      // Top-right
      Positioned(
        right: -handleSize / 2,
        top: -handleSize / 2,
        child: _buildHandle(handleColor, handleSize),
      ),
      // Bottom-left
      Positioned(
        left: -handleSize / 2,
        bottom: -handleSize / 2,
        child: _buildHandle(handleColor, handleSize),
      ),
      // Bottom-right
      Positioned(
        right: -handleSize / 2,
        bottom: -handleSize / 2,
        child: _buildHandle(handleColor, handleSize),
      ),
    ];
  }

  Widget _buildHandle(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.white, width: 1),
        shape: BoxShape.circle,
      ),
    );
  }

  List<Offset> _getResizeHandles() {
    return [
      _selectedRegion.topLeft, // 0: Top-left
      _selectedRegion.topRight, // 1: Top-right
      _selectedRegion.bottomLeft, // 2: Bottom-left
      _selectedRegion.bottomRight, // 3: Bottom-right
    ];
  }

  void _handleDrag(Offset currentPosition) {
    if (_dragStart == null || _initialRegion == null) return;

    final delta = currentPosition - _dragStart!;
    final newLeft = (_initialRegion!.left + delta.dx)
        .clamp(0.0, widget.videoWidth - _selectedRegion.width);
    final newTop = (_initialRegion!.top + delta.dy)
        .clamp(0.0, widget.videoHeight - _selectedRegion.height);

    _selectedRegion = Rect.fromLTWH(
      newLeft,
      newTop,
      _selectedRegion.width,
      _selectedRegion.height,
    );
  }

  void _handleResize(Offset currentPosition) {
    if (_dragStart == null || _initialRegion == null) return;

    final delta = currentPosition - _dragStart!;
    double newLeft = _initialRegion!.left;
    double newTop = _initialRegion!.top;
    double newWidth = _initialRegion!.width;
    double newHeight = _initialRegion!.height;

    switch (_resizeHandle) {
      case 0: // Top-left
        newLeft = (_initialRegion!.left + delta.dx)
            .clamp(0.0, _initialRegion!.right - 20);
        newTop = (_initialRegion!.top + delta.dy)
            .clamp(0.0, _initialRegion!.bottom - 20);
        newWidth = _initialRegion!.right - newLeft;
        newHeight = _initialRegion!.bottom - newTop;
        break;
      case 1: // Top-right
        newTop = (_initialRegion!.top + delta.dy)
            .clamp(0.0, _initialRegion!.bottom - 20);
        newWidth = (_initialRegion!.width + delta.dx)
            .clamp(20.0, widget.videoWidth - _initialRegion!.left);
        newHeight = _initialRegion!.bottom - newTop;
        break;
      case 2: // Bottom-left
        newLeft = (_initialRegion!.left + delta.dx)
            .clamp(0.0, _initialRegion!.right - 20);
        newWidth = _initialRegion!.right - newLeft;
        newHeight = (_initialRegion!.height + delta.dy)
            .clamp(20.0, widget.videoHeight - _initialRegion!.top);
        break;
      case 3: // Bottom-right
        newWidth = (_initialRegion!.width + delta.dx)
            .clamp(20.0, widget.videoWidth - _initialRegion!.left);
        newHeight = (_initialRegion!.height + delta.dy)
            .clamp(20.0, widget.videoHeight - _initialRegion!.top);
        break;
    }

    _selectedRegion = Rect.fromLTWH(newLeft, newTop, newWidth, newHeight);
  }

  Widget _buildControlPanel(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.95),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Timeline controls
          Row(
            children: [
              const Icon(Icons.schedule, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(
                'Duration: ${((_endTimeMs - _startTimeMs) / 1000).toStringAsFixed(1)}s',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              const Spacer(),
              Text(
                'Start: ${(_startTimeMs / 1000).toStringAsFixed(1)}s',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(width: 16),
              Text(
                'End: ${(_endTimeMs / 1000).toStringAsFixed(1)}s',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Start time slider
          Row(
            children: [
              const Text('Start',
                  style: TextStyle(color: Colors.white70, fontSize: 12)),
              Expanded(
                child: Slider(
                  value: _startTimeMs.clamp(0.0, widget.videoDurationMs),
                  min: 0,
                  max: widget.videoDurationMs,
                  onChanged: (value) {
                    setState(() {
                      _startTimeMs = value;
                      if (_startTimeMs >= _endTimeMs) {
                        _endTimeMs = (_startTimeMs + 1000)
                            .clamp(0.0, widget.videoDurationMs);
                      }
                    });
                  },
                ),
              ),
            ],
          ),
          // End time slider
          Row(
            children: [
              const Text('End',
                  style: TextStyle(color: Colors.white70, fontSize: 12)),
              Expanded(
                child: Slider(
                  value: _endTimeMs.clamp(0.0, widget.videoDurationMs),
                  min: 0,
                  max: widget.videoDurationMs,
                  onChanged: (value) {
                    setState(() {
                      _endTimeMs = value;
                      if (_endTimeMs <= _startTimeMs) {
                        _startTimeMs = (_endTimeMs - 1000)
                            .clamp(0.0, widget.videoDurationMs);
                      }
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Blur controls
          Row(
            children: [
              // Intensity
              const Text('Intensity:',
                  style: TextStyle(color: Colors.white, fontSize: 14)),
              const SizedBox(width: 8),
              SizedBox(
                width: 120,
                child: Slider(
                  value: _intensity.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  label: _intensity.toString(),
                  onChanged: (value) {
                    setState(() {
                      _intensity = value.round();
                    });
                  },
                ),
              ),
              const Spacer(),
              // Blur type
              const Text('Type:',
                  style: TextStyle(color: Colors.white, fontSize: 14)),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: _blurType,
                dropdownColor: Colors.grey.shade800,
                style: const TextStyle(color: Colors.white),
                items: const [
                  DropdownMenuItem(value: 'gaussian', child: Text('Gaussian')),
                  DropdownMenuItem(value: 'box', child: Text('Box')),
                  DropdownMenuItem(value: 'smart', child: Text('Smart')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _blurType = value;
                    });
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _saveBlurRegion() {
    // Convert absolute pixels back to relative coordinates
    final relativeRegion = BlurRegion(
      id: widget.editingRegion?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      x: _selectedRegion.left / widget.videoWidth,
      y: _selectedRegion.top / widget.videoHeight,
      width: _selectedRegion.width / widget.videoWidth,
      height: _selectedRegion.height / widget.videoHeight,
      startTimeMs: _startTimeMs,
      endTimeMs: _endTimeMs,
      intensity: _intensity,
      blurType: _blurType,
    );

    if (widget.editingRegion != null) {
      widget.onRegionUpdated(relativeRegion);
    } else {
      widget.onRegionCreated(relativeRegion);
    }
  }
}

/// Simple modal overlay for quick blur region creation
class QuickBlurRegionModal extends StatefulWidget {
  const QuickBlurRegionModal({
    required this.currentTimeMs,
    required this.videoDurationMs,
    required this.onRegionCreated,
    this.editingRegion,
    super.key,
  });

  final double currentTimeMs;
  final double videoDurationMs;
  final BlurRegion? editingRegion;
  final void Function(BlurRegion) onRegionCreated;

  @override
  State<QuickBlurRegionModal> createState() => _QuickBlurRegionModalState();
}

class _QuickBlurRegionModalState extends State<QuickBlurRegionModal> {
  late double _duration;
  late int _intensity;
  late String _blurType;

  @override
  void initState() {
    super.initState();

    if (widget.editingRegion != null) {
      // Editing existing region
      final region = widget.editingRegion!;
      _duration = (region.endTimeMs - region.startTimeMs) / 1000.0;
      _intensity = region.intensity;
      _blurType = region.blurType;
    } else {
      // Creating new region
      _duration = 5.0; // Default 5 seconds
      _intensity = 5;
      _blurType = 'gaussian';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 2),
      child: Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 400,
            maxHeight: 400,
          ),
          child: Stack(
            children: [
              Positioned(
                child: CardWidget(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          widget.editingRegion != null
                              ? 'Edit Blur Region'
                              : 'Quick Blur Region',
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Duration: ${_duration.toStringAsFixed(1)}s',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Slider(
                          value: _duration,
                          min: 0.5,
                          max: 30,
                          divisions: 59,
                          onChanged: (value) =>
                              setState(() => _duration = value),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              'Intensity:',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Slider(
                                value: _intensity.toDouble(),
                                min: 1,
                                max: 10,
                                divisions: 9,
                                label: _intensity.toString(),
                                onChanged: (value) =>
                                    setState(() => _intensity = value.round()),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              'Type:',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(width: 16),
                            DropdownButton<String>(
                              value: _blurType,
                              dropdownColor: Colors.grey.shade800,
                              style: Theme.of(context).textTheme.bodySmall,
                              items: const [
                                DropdownMenuItem(
                                    value: 'gaussian', child: Text('Gaussian')),
                                DropdownMenuItem(
                                    value: 'box', child: Text('Box')),
                                DropdownMenuItem(
                                    value: 'smart', child: Text('Smart')),
                              ],
                              onChanged: (value) {
                                if (value != null)
                                  setState(() => _blurType = value);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            BtnPrimary(
                              buttonText: 'Cancel',
                              onTap: () => Navigator.of(context).pop(),
                              btnPrimaryType: BtnPrimaryType.outlinePrimary,
                            ),
                            BtnPrimary(
                              buttonText: widget.editingRegion != null
                                  ? 'Update'
                                  : 'Create',
                              onTap: _createQuickRegion,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createQuickRegion() {
    final region = BlurRegion(
      id: widget.editingRegion?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      // Keep existing position if editing, otherwise create centered region
      x: widget.editingRegion?.x ?? 0.35, // Centered horizontally
      y: widget.editingRegion?.y ?? 0.35, // Centered vertically
      width: widget.editingRegion?.width ?? 0.3, // 30% of video width
      height: widget.editingRegion?.height ?? 0.3, // 30% of video height
      startTimeMs: widget.editingRegion?.startTimeMs ?? widget.currentTimeMs,
      endTimeMs: (widget.editingRegion?.startTimeMs ?? widget.currentTimeMs) +
          (_duration * 1000),
      intensity: _intensity,
      blurType: _blurType,
    );

    widget.onRegionCreated(region);
    Navigator.of(context).pop();
  }
}
