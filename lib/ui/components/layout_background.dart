import 'package:clones_desktop/application/route_provider.dart';
import 'package:clones_desktop/application/ui_state/provider.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/components/global_action_rail.dart';
import 'package:clones_desktop/ui/components/modals/modals_management.dart';
import 'package:clones_desktop/ui/components/sidebar.dart';
import 'package:clones_desktop/ui/views/factory/layouts/factory_view.dart';
import 'package:clones_desktop/ui/views/factory_history/layouts/factory_history_view.dart';
import 'package:clones_desktop/ui/views/forge/layouts/forge_view.dart';
import 'package:clones_desktop/ui/views/home/layouts/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LayoutBackground extends ConsumerWidget {
  const LayoutBackground({
    super.key,
    required this.child,
    this.actions,
  });
  final Widget child;

  final Widget? actions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenHeight = constraints.maxHeight;
        final screenWidth = constraints.maxWidth;
        final logoSize = screenWidth * 0.25;
        const minLogoSize = 120.0;
        const maxLogoSize = 400.0;
        logoSize.clamp(minLogoSize, maxLogoSize);
        final currentRoute = ref.watch(currentRouteProvider);
        final isVideoFullscreen = ref.watch(uiStateNotifierProvider.select((s) => s.isVideoFullscreen));

        return Stack(
          alignment: Alignment.center,
          children: [
            const SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Assets.background),
                    fit: BoxFit.cover,
                    alignment: Alignment.centerRight,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 30,
              child: Opacity(
                opacity: 0.05,
                child: Text(
                  currentRoute == HomeView.routeName
                      ? 'CLONES'
                      : currentRoute == ForgeView.routeName
                          ? 'FORGE'
                          : currentRoute == FactoryView.routeName
                              ? 'FORGE'
                              : currentRoute == FactoryHistoryView.routeName
                                  ? 'FORGE'
                                  : '',
                  style: const TextStyle(
                    fontSize: 200,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              top: -500,
              left: -1500,
              child: Opacity(
                opacity: 0.04,
                child: SvgPicture.asset(
                  Assets.logo,
                  width: 2000,
                  height: 2000,
                  colorFilter: const ColorFilter.mode(
                    ClonesColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -1000,
              right: -800,
              child: Opacity(
                opacity: 0.04,
                child: SvgPicture.asset(
                  Assets.logo,
                  width: 1500,
                  height: 1500,
                  colorFilter: const ColorFilter.mode(
                    ClonesColors.tertiary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Row(
                children: [
                  const SizedBox(
                    width: 100,
                    child: Sidebar(),
                  ),
                  Container(
                    width: 1,
                    height: screenHeight * 0.4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: 0.05),
                          Colors.white.withValues(alpha: 0.2),
                          Colors.white.withValues(alpha: 0.05),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ClipRect(
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Expanded(child: child),
                              if (actions != null)
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: actions,
                                ),
                            ],
                          ),
                          if (!isVideoFullscreen)
                            const Positioned(
                              bottom: 10,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: GlobalActionRail(),
                              ),
                            ),
                          const ModalsManagement(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
