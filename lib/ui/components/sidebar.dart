import 'package:clones_desktop/application/environment_provider.dart';
import 'package:clones_desktop/application/route_provider.dart';
import 'package:clones_desktop/application/upload_modal_provider.dart';
import 'package:clones_desktop/application/version_provider.dart';
import 'package:clones_desktop/application/wallet_modal_provider.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/demo_detail_view.dart';
import 'package:clones_desktop/ui/views/factory/layouts/factory_view.dart';
import 'package:clones_desktop/ui/views/factory_history/layouts/factory_history_view.dart';
import 'package:clones_desktop/ui/views/forge/layouts/forge_view.dart';
import 'package:clones_desktop/ui/views/home/layouts/home_view.dart';
import 'package:clones_desktop/ui/views/leaderboards/layouts/leaderboards_view.dart';
import 'package:clones_desktop/ui/views/record_overlay/layouts/record_overlay_view.dart';
import 'package:clones_desktop/ui/views/referral/layouts/referral_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Sidebar extends ConsumerWidget {
  const Sidebar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRoute = ref.watch(currentRouteProvider);
    final appVersion = ref.watch(appVersionProvider);
    final environment = ref.watch(environmentProvider);
    final buttons = [
      SidebarButtonData(
        path: HomeView.routeName,
        imagePath: Assets.homeIcon,
        label: 'Home',
      ),
      SidebarButtonData(
        path: ForgeView.routeName,
        imagePath: Assets.forgeIcon,
        label: 'Forge',
      ),
      SidebarButtonData(
        path: FactoryView.routeName,
        imagePath: Assets.farmerIcon,
        label: 'Factory',
      ),
      SidebarButtonData(
        path: FactoryHistoryView.routeName,
        imagePath: Assets.farmerHistoryIcon,
        label: 'Factory History',
      ),
      SidebarButtonData(
        path: LeaderboardsView.routeName,
        imagePath: Assets.statsIcon,
        label: 'Leaderboards',
      ),
      SidebarButtonData(
        path: ReferralView.routeName,
        imagePath: Assets.referralIcon,
        label: 'Referral',
      ),
    ];

    var activeIndex = 0;
    if (currentRoute.startsWith(DemoDetailView.routeName) ||
        currentRoute.startsWith(RecordOverlayView.routeName)) {
      activeIndex = 2;
    } else {
      activeIndex = buttons.indexWhere(
        (b) => currentRoute == b.path || currentRoute.startsWith('${b.path}/'),
      );
      if (activeIndex == -1) activeIndex = 0;
    }
    final theme = Theme.of(context);
    return Container(
      width: 64,
      color: Colors.transparent,
      child: Column(
        children: [
          Expanded(
            child: AnimatedSidebarSection(
              buttons: buttons,
              activeIndex: activeIndex,
              onTap: (i) {
                ref.read(uploadModalProvider.notifier).hide();
                ref.read(walletModalProvider.notifier).hide();
                context.go(buttons[i].path);
              },
            ),
          ),
          appVersion.when(
            data: (version) => Padding(
              padding: const EdgeInsets.only(bottom: 16, top: 8),
              child: Column(
                children: [
                  Text(
                    version,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                  if (environment.shouldShowEnvironmentBadge)
                    Text(
                      environment.displayName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: ClonesColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
            loading: () => const SizedBox(),
            error: (err, stack) => const SizedBox(),
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
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
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
                                ? Stack(
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
                                  )
                                : Image.asset(
                                    button.imagePath,
                                    width: 40,
                                    height: 40,
                                  ),
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
  });
  final String path;
  final String imagePath;
  final String label;
}
