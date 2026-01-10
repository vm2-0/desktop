import 'package:clones_desktop/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final forgeDetailTabProvider = StateProvider<String>((ref) => 'general');

class ForgeFactoryDetailSidebar extends ConsumerStatefulWidget {
  const ForgeFactoryDetailSidebar({
    super.key,
    required this.poolId,
  });

  final String poolId;

  @override
  ConsumerState<ForgeFactoryDetailSidebar> createState() =>
      _ForgeFactoryDetailSidebarState();
}

class _ForgeFactoryDetailSidebarState
    extends ConsumerState<ForgeFactoryDetailSidebar> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      ref.read(forgeDetailTabProvider.notifier).state = 'general';
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentTab = ref.watch(forgeDetailTabProvider);
    final buttons = [
      SidebarButtonData(
        path: '/forge/${widget.poolId}/general',
        imagePath: Assets.factoryGeneralIcon,
        label: 'General',
        key: 'general',
      ),
      SidebarButtonData(
        path: '/forge/${widget.poolId}/tasks',
        imagePath: Assets.factoryTasksIcon,
        label: 'Tasks',
        key: 'tasks',
      ),
      SidebarButtonData(
        path: '/forge/${widget.poolId}/demonstrations',
        imagePath: Assets.factoryDemosIcon,
        label: 'Demos',
        key: 'demos',
      ),
      SidebarButtonData(
        path: '/forge/${widget.poolId}/datasets',
        imagePath: Assets.factoryDatasetsIcon,
        label: 'Datasets',
        key: 'datasets',
      ),
    ];

    var activeIndex = buttons.indexWhere((b) => b.key == currentTab);
    if (activeIndex == -1) activeIndex = 0;

    return Container(
      width: 100,
      color: Colors.transparent,
      child: Column(
        children: [
          Expanded(
            child: AnimatedSidebarSection(
              buttons: buttons,
              activeIndex: activeIndex,
              onTap: (i) {
                ref.read(forgeDetailTabProvider.notifier).state =
                    buttons[i].key;
                context.go(buttons[i].path);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedSidebarSection extends StatelessWidget {
  const AnimatedSidebarSection({
    super.key,
    required this.buttons,
    required this.activeIndex,
    required this.onTap,
  });

  final List<SidebarButtonData> buttons;
  final int activeIndex;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    const double buttonHeight = 80;
    const double sidebarWidth = 100;
    const double highlightSize = 70;
    final totalHeight = buttons.length * buttonHeight;
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableHeight = constraints.maxHeight;
        final topOffset = (availableHeight - totalHeight) / 2;
        return Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
              top: topOffset +
                  activeIndex * buttonHeight +
                  (buttonHeight - highlightSize) / 2,
              left: (sidebarWidth - highlightSize) / 2,
              width: highlightSize,
              height: highlightSize,
              child: Opacity(
                opacity: 0.5,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: ClonesColors.secondary.withValues(alpha: 0.2),
                      width: 0.5,
                    ),
                    gradient: LinearGradient(
                      colors: [
                        ClonesColors.secondary.withValues(alpha: 0.2),
                        Colors.transparent,
                        Colors.transparent,
                        ClonesColors.secondary.withValues(alpha: 0.2),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: topOffset,
              left: 0,
              right: 0,
              child: Column(
                children: List.generate(buttons.length, (i) {
                  final button = buttons[i];
                  return SizedBox(
                    height: buttonHeight,
                    child: Center(
                      child: GestureDetector(
                        onTap: () => onTap(i),
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              colors: [
                                ClonesColors.primary.withValues(alpha: 0.5),
                                ClonesColors.secondary.withValues(alpha: 0.9),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ).createShader(bounds);
                          },
                          blendMode: BlendMode.dstIn,
                          child: activeIndex == i
                              ? ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return LinearGradient(
                                      colors: [
                                        ClonesColors.primary
                                            .withValues(alpha: 0.5),
                                        ClonesColors.secondary
                                            .withValues(alpha: 0.9),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ).createShader(bounds);
                                  },
                                  blendMode: BlendMode.dstIn,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Stack(
                                        children: [
                                          Image.asset(
                                            button.imagePath,
                                            width: 40,
                                            height: 40,
                                            color: ClonesColors.primary,
                                          ),
                                          Opacity(
                                            opacity: 0.7,
                                            child: Image.asset(
                                              button.imagePath,
                                              width: 40,
                                              height: 40,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        button.label,
                                        style:
                                            theme.textTheme.bodySmall?.copyWith(
                                          fontSize: 7,
                                          color: ClonesColors.primary
                                              .withValues(alpha: 1),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      button.imagePath,
                                      width: 40,
                                      height: 40,
                                    ),
                                    Text(
                                      button.label,
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        fontSize: 7,
                                        color: ClonesColors.primary
                                            .withValues(alpha: 1),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }
}

class SidebarButtonData {
  SidebarButtonData({
    required this.path,
    required this.imagePath,
    required this.label,
    required this.key,
  });
  final String path;
  final String imagePath;
  final String label;
  final String key;
}
