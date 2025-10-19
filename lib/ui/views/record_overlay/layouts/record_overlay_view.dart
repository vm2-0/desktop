import 'package:clones_desktop/ui/views/record_overlay/bloc/provider.dart';
import 'package:clones_desktop/ui/views/record_overlay/layouts/components/record_overlay_header.dart';
import 'package:clones_desktop/ui/views/record_overlay/layouts/components/record_overlay_objectives.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecordOverlayView extends ConsumerStatefulWidget {
  const RecordOverlayView({super.key});

  static const routeName = '/record-overlay';

  @override
  ConsumerState<RecordOverlayView> createState() => _RecordOverlayViewState();
}

class _RecordOverlayViewState extends ConsumerState<RecordOverlayView> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    
    // Listen to close state changes and schedule navigation for after build
    ref.listen(recordOverlayNotifierProvider, (previous, next) {
      if (next.close && (previous?.close != true)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Navigator.of(context).pop();
          }
        });
      }
    });

    return Container(
      width: mediaQuery.size.width,
      height: mediaQuery.size.height,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [RecordOverlayHeader(), RecordOverlayObjectives()],
      ),
    );
  }
}
