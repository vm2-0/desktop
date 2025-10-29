import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:clones_desktop/application/agent/agent_launcher.dart';
import 'package:clones_desktop/application/deeplink_provider.dart';
import 'package:clones_desktop/application/route_provider.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/infrastructure/sparkle_updater.dart';
import 'package:clones_desktop/ui/main_layout.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/demo_detail_view.dart';
import 'package:clones_desktop/ui/views/factory/layouts/factory_view.dart';
import 'package:clones_desktop/ui/views/factory_history/layouts/factory_history_view.dart';
import 'package:clones_desktop/ui/views/forge/layouts/forge_view.dart';
import 'package:clones_desktop/ui/views/forge_detail/layouts/forge_factory_demos_tab.dart';
import 'package:clones_desktop/ui/views/forge_detail/layouts/forge_factory_detail_shell.dart';
import 'package:clones_desktop/ui/views/forge_detail/layouts/forge_factory_general_tab.dart';
import 'package:clones_desktop/ui/views/forge_detail/layouts/forge_factory_tasks_tab.dart';
import 'package:clones_desktop/ui/views/home/layouts/home_view.dart';
import 'package:clones_desktop/ui/views/leaderboards/layouts/leaderboards_view.dart';
import 'package:clones_desktop/ui/views/record_overlay/layouts/record_overlay_view.dart';
import 'package:clones_desktop/ui/views/referral/layouts/referral_view.dart';
import 'package:clones_desktop/utils/env.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:media_kit/media_kit.dart';
import 'package:window_manager/window_manager.dart';

final _router = GoRouter(
  initialLocation: '/', // We'll handle initial routing in the app
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainLayout(
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: HomeView.routeName,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeView(),
          ),
        ),
        GoRoute(
          path: FactoryView.routeName,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: FactoryView(),
          ),
        ),
        GoRoute(
          path: FactoryHistoryView.routeName,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: FactoryHistoryView(),
          ),
        ),
        GoRoute(
          path: DemoDetailView.routeName,
          pageBuilder: (context, state) {
            final extra = state.extra;
            String? recordingId;
            Map<String, dynamic>? trainingParams;

            // Handle cases: String recordingId, Map with training params, or Map with factory submission
            if (extra is String) {
              recordingId = extra.isEmpty ? null : extra;
            } else if (extra is Map<String, dynamic>) {
              if (extra['isFactorySubmission'] == true) {
                // For factory submissions, pass the submission info through trainingParams
                recordingId = null;
                trainingParams = extra;
              } else {
                // For new demo recording, recordingId is null
                recordingId = null;
                trainingParams = extra;
              }
            }

            return NoTransitionPage(
              child: DemoDetailView(
                recordingId: recordingId,
                trainingParams: trainingParams,
              ),
            );
          },
        ),
        GoRoute(
          path: ForgeView.routeName,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ForgeView(),
          ),
        ),
        ShellRoute(
          pageBuilder: (context, state, child) {
            final factoryId = state.pathParameters['id']!;
            return NoTransitionPage(
              child: ForgeFactoryDetailShell(
                factoryId: factoryId,
                child: child,
              ),
            );
          },
          routes: [
            GoRoute(
              path: '/forge/:id/general',
              pageBuilder: (context, state) {
                return const NoTransitionPage(child: ForgeFactoryGeneralTab());
              },
            ),
            GoRoute(
              path: '/forge/:id/tasks',
              pageBuilder: (context, state) {
                return const NoTransitionPage(child: ForgeFactoryTasksTab());
              },
            ),
            GoRoute(
              path: '/forge/:id/demonstrations',
              pageBuilder: (context, state) {
                return const NoTransitionPage(
                  child: ForgeFactoryDemonstrationsTab(),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: LeaderboardsView.routeName,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: LeaderboardsView(),
          ),
        ),
        GoRoute(
          path: ReferralView.routeName,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ReferralView(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: RecordOverlayView.routeName,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: RecordOverlayView(),
      ),
    ),
  ],
);

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize media_kit for video playback (Windows and macOS)
  MediaKit.ensureInitialized();

  // Initialize window manager for desktop platforms
  if (!kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
    await windowManager.ensureInitialized();
    const windowOptions = WindowOptions(
      size: Size(1440, 900),
      center: true,
      backgroundColor: Colors.black,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  // Load environment-specific .env file
  await Env.loadEnvironmentFile();

  // Ensure the Rust agent is running before UI starts interacting with IPC.
  // Wait for agent startup to avoid race conditions with tool initialization.
  try {
    await AgentLauncher().ensureStarted();
  } catch (e) {
    developer.log('Failed to start agent: $e', name: 'AgentLauncher');
    // Continue anyway - failures will be handled by individual API calls
  }

  runApp(const ProviderScope(child: ClonesApp()));
}

class ClonesApp extends ConsumerStatefulWidget {
  const ClonesApp({super.key});

  @override
  ConsumerState<ClonesApp> createState() => _ClonesAppState();
}

class _ClonesAppState extends ConsumerState<ClonesApp> {
  @override
  void initState() {
    super.initState();
    _router.routeInformationProvider.addListener(_updateRoute);
    // Set initial route
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateRoute();
      _checkForUpdates();
    });
  }

  Future<void> _checkForUpdates() async {
    // Delay to ensure app is fully initialized
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      if (Platform.isMacOS) {
        // Use native Sparkle updater on macOS for better performance and UX
        await _initializeSparkleUpdater();
      } else {
        developer.log(
          'Native updaters for Windows/Linux not yet implemented',
          name: 'AppLifecycleManager',
        );
      }
    }
  }

  Future<void> _initializeSparkleUpdater() async {
    try {
      developer.log(
        '[Sparkle] Initializing Sparkle updater...',
        name: 'Sparkle',
      );
      final sparkle = SparkleUpdater();

      // Determine appcast URL based on environment
      String appcastUrl;
      const environment =
          String.fromEnvironment('ENVIRONMENT', defaultValue: 'dev');
      developer.log('[Sparkle] Environment: $environment', name: 'Sparkle');

      if (environment == 'prod') {
        appcastUrl = 'https://releases.clones-ai.com/latest/darwin/appcast.xml';
      } else {
        appcastUrl =
            'https://releases-test.clones-ai.com/latest/darwin/appcast.xml';
      }

      developer.log(
        '[Sparkle] Using appcast URL: $appcastUrl',
        name: 'Sparkle',
      );

      await sparkle.initialize(
        appcastUrl: appcastUrl,
      );

      developer.log(
        '[Sparkle] Sparkle initialized successfully',
        name: 'Sparkle',
      );

      // Check for updates in background
      developer.log(
        '[Sparkle] Checking for updates in background...',
        name: 'Sparkle',
      );
      await sparkle.checkForUpdatesInBackground();
      developer.log(
        '[Sparkle] Background update check completed',
        name: 'Sparkle',
      );
    } catch (e) {
      developer.log(
        '[Sparkle] Failed to initialize Sparkle updater: $e',
        name: 'Sparkle',
        level: 1000,
      );
    }
  }

  void _updateRoute() {
    if (!mounted) return;
    final location = _router.routeInformationProvider.value.uri.toString();
    // The router location can be empty at the very beginning.
    if (location.isEmpty) return;
    final current = ref.read(currentRouteProvider);
    if (current != location) {
      ref.read(currentRouteProvider.notifier).state = location;
    }
  }

  @override
  void dispose() {
    _router.routeInformationProvider.removeListener(_updateRoute);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen for deep link events and navigate accordingly.
    ref.listen(deepLinkProvider, (previous, next) {
      final url = next.value;
      if (url != null && url.isNotEmpty) {
        final uri = Uri.parse(url);

        // Handle `clones://open` by navigating to the main view.
        if (uri.host == 'open') {
          _router.go(FactoryView.routeName);
          return;
        }
        // Fallback or navigate to other routes based on the host
        _router.go('/${uri.host}');
      }
    });

    final textTheme = Theme.of(context).textTheme.copyWith(
          bodySmall: ClonesFonts.getPrimaryFont(
            fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
            fontWeight: Theme.of(context).textTheme.bodySmall?.fontWeight,
            fontStyle: Theme.of(context).textTheme.bodySmall?.fontStyle,
            color: ClonesColors.secondaryText,
          ),
          bodyMedium: ClonesFonts.getPrimaryFont(
            fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
            fontWeight: Theme.of(context).textTheme.bodyMedium?.fontWeight,
            fontStyle: Theme.of(context).textTheme.bodyMedium?.fontStyle,
            color: ClonesColors.secondaryText,
          ),
          bodyLarge: ClonesFonts.getPrimaryFont(
            fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
            fontWeight: Theme.of(context).textTheme.bodyLarge?.fontWeight,
            fontStyle: Theme.of(context).textTheme.bodyLarge?.fontStyle,
            color: ClonesColors.secondaryText,
          ),
          titleLarge: ClonesFonts.getPrimaryFont(
            fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
            fontWeight: Theme.of(context).textTheme.titleLarge?.fontWeight,
            fontStyle: Theme.of(context).textTheme.titleLarge?.fontStyle,
            color: ClonesColors.primaryText,
          ),
          titleMedium: ClonesFonts.getPrimaryFont(
            fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
            fontWeight: Theme.of(context).textTheme.titleMedium?.fontWeight,
            fontStyle: Theme.of(context).textTheme.titleMedium?.fontStyle,
            color: ClonesColors.primaryText,
          ),
          titleSmall: ClonesFonts.getPrimaryFont(
            fontSize: Theme.of(context).textTheme.titleSmall?.fontSize,
            fontWeight: Theme.of(context).textTheme.titleSmall?.fontWeight,
            fontStyle: Theme.of(context).textTheme.titleSmall?.fontStyle,
            color: ClonesColors.primaryText,
          ),
          labelSmall: ClonesFonts.getMonoFont(
            fontSize: Theme.of(context).textTheme.labelSmall?.fontSize,
            fontWeight: Theme.of(context).textTheme.labelSmall?.fontWeight,
            color: ClonesColors.primaryText,
          ),
        );

    final mediaQuery = MediaQuery.of(context);

    return MaterialApp.router(
      title: 'Clones Desktop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFbb4eff),
        ),
        textTheme: textTheme,
        snackBarTheme: SnackBarThemeData(
          width: mediaQuery.size.width * 0.5,
          backgroundColor: ClonesColors.tertiary.withValues(alpha: 0.7),
          elevation: 2,
          contentTextStyle: textTheme.bodyMedium,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
              color: ClonesColors.tertiary,
            ),
          ),
          closeIconColor: ClonesColors.primaryText,
        ),
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
