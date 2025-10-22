import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:clones_desktop/application/agent/agent_launcher.dart';
import 'package:clones_desktop/application/agent/heartbeat_monitor.dart';
import 'package:clones_desktop/application/deeplink_provider.dart';
import 'package:clones_desktop/application/route_provider.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/infrastructure/flutter_window_manager.dart';
import 'package:clones_desktop/infrastructure/sparkle_updater.dart';
import 'package:clones_desktop/ui/main_layout.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/demo_detail_view.dart';
import 'package:clones_desktop/ui/views/factory/layouts/factory_view.dart';
import 'package:clones_desktop/ui/views/factory_history/layouts/factory_history_view.dart';
import 'package:clones_desktop/ui/views/forge/layouts/forge_view.dart';
import 'package:clones_desktop/ui/views/forge_detail/layouts/forge_factory_detail_shell.dart';
import 'package:clones_desktop/ui/views/forge_detail/layouts/forge_factory_general_tab.dart';
import 'package:clones_desktop/ui/views/forge_detail/layouts/forge_factory_tasks_tab.dart';
import 'package:clones_desktop/ui/views/forge_detail/layouts/forge_factory_uploads_tab.dart';
import 'package:clones_desktop/ui/views/home/layouts/home_view.dart';
import 'package:clones_desktop/ui/views/leaderboards/layouts/leaderboards_view.dart';
import 'package:clones_desktop/ui/views/record_overlay/layouts/record_overlay_view.dart';
import 'package:clones_desktop/ui/views/referral/layouts/referral_view.dart';
import 'package:clones_desktop/utils/env.dart';
import 'package:clones_desktop/utils/window_alignment.dart';
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

            // Handle both cases: String recordingId or Map with training params
            if (extra is String) {
              recordingId = extra.isEmpty ? null : extra;
            } else if (extra is Map<String, dynamic>) {
              // For new demo recording, recordingId is null
              recordingId = null;
              trainingParams = extra;
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
              path: '/forge/:id/uploads',
              pageBuilder: (context, state) {
                return const NoTransitionPage(child: ForgeFactoryUploadsTab());
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
    await windowManager.setPreventClose(true);
    windowManager.addListener(CloseListener());
    const windowOptions = WindowOptions(
      size: Size(1200, 800),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
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
    debugPrint('Failed to start agent: $e');
    // Continue anyway - failures will be handled by individual API calls
  }

  // Register shutdown handlers to clean up the agent
  if (!kIsWeb) {
    ProcessSignal.sigint.watch().listen((_) => _shutdown());
    ProcessSignal.sigterm.watch().listen((_) => _shutdown());
  }

  // Initialize app lifecycle management for cleanup
  AppLifecycleManager.initialize();
  
  runApp(const ProviderScope(child: ClonesApp()));
}

/// Graceful shutdown handler
Future<void> _shutdown() async {
  debugPrint('Shutting down application...');
  try {
    // Stop agent and cleanup heartbeat
    await AgentLauncher().stop();
    debugPrint('Agent shutdown completed');
  } catch (e) {
    debugPrint('Error during agent shutdown: $e');
  }
  
  // Force cleanup if not already done
  AppLifecycleManager._forceCleanup();
  
  exit(0);
}

class ClonesApp extends ConsumerStatefulWidget {
  const ClonesApp({super.key});

  @override
  ConsumerState<ClonesApp> createState() => _ClonesAppState();
}

class _ClonesAppState extends ConsumerState<ClonesApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _router.routeInformationProvider.addListener(_updateRoute);
    // Set initial route
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (kIsWeb) {
        _initializeWindow();
      }
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
        debugPrint('Native updaters for Windows/Linux not yet implemented');
      }
    }
  }

  Future<void> _initializeSparkleUpdater() async {
    try {
      developer.log('[Sparkle] Initializing Sparkle updater...', name: 'Sparkle');
      final sparkle = SparkleUpdater();

      // Determine appcast URL based on environment
      String appcastUrl;
      const environment = String.fromEnvironment('ENVIRONMENT', defaultValue: 'dev');
      developer.log('[Sparkle] Environment: $environment', name: 'Sparkle');
      
      if (environment == 'prod') {
        appcastUrl = 'https://releases.clones-ai.com/latest/darwin/appcast.xml';
      } else {
        appcastUrl = 'https://releases-test.clones-ai.com/latest/darwin/appcast.xml';
      }
      
      developer.log('[Sparkle] Using appcast URL: $appcastUrl', name: 'Sparkle');

      await sparkle.initialize(
        appcastUrl: appcastUrl,
        automaticallyChecksForUpdates: true,
        automaticallyDownloadsUpdates: false,
      );
      
      developer.log('[Sparkle] Sparkle initialized successfully', name: 'Sparkle');

      // Check for updates in background
      developer.log('[Sparkle] Checking for updates in background...', name: 'Sparkle');
      await sparkle.checkForUpdatesInBackground();
      developer.log('[Sparkle] Background update check completed', name: 'Sparkle');

    } catch (e) {
      developer.log('[Sparkle] Failed to initialize Sparkle updater: $e', name: 'Sparkle', level: 1000);
    }
  }

  Future<void> _initializeWindow() async {
    final displays = await FlutterWindowManager.getDisplaysSize();
    final smallestDisplay = displays.reduce((a, b) {
      final areaA = a.width * a.height;
      final areaB = b.width * b.height;
      return areaA < areaB ? a : b;
    });
    await FlutterWindowManager.resizeWindow(
      smallestDisplay.width,
      smallestDisplay.height,
    );

    await FlutterWindowManager.setWindowPosition(
      WindowAlignment.topCenter,
    );

    await FlutterWindowManager.setWindowResizable(true);
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
    WidgetsBinding.instance.removeObserver(this);
    _router.routeInformationProvider.removeListener(_updateRoute);
    // Stop the agent when the app is disposed
    AgentLauncher().stop();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.detached) {
      // App is being terminated - kill the agent
      debugPrint('App lifecycle: detached - stopping agent');
      AgentLauncher().stop();
    }
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
            color: ClonesColors.secondaryText,
          ),
          bodyMedium: ClonesFonts.getPrimaryFont(
            fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
            fontWeight: Theme.of(context).textTheme.bodyMedium?.fontWeight,
            color: ClonesColors.secondaryText,
          ),
          bodyLarge: ClonesFonts.getPrimaryFont(
            fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
            fontWeight: Theme.of(context).textTheme.bodyLarge?.fontWeight,
            color: ClonesColors.secondaryText,
          ),
          titleLarge: ClonesFonts.getPrimaryFont(
            fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
            fontWeight: Theme.of(context).textTheme.titleLarge?.fontWeight,
            color: ClonesColors.primaryText,
          ),
          titleMedium: ClonesFonts.getPrimaryFont(
            fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
            fontWeight: Theme.of(context).textTheme.titleMedium?.fontWeight,
            color: ClonesColors.primaryText,
          ),
          titleSmall: ClonesFonts.getPrimaryFont(
            fontSize: Theme.of(context).textTheme.titleSmall?.fontSize,
            fontWeight: Theme.of(context).textTheme.titleSmall?.fontWeight,
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

class CloseListener with WindowListener {
  @override
  Future<void> onWindowClose() async {
    debugPrint('Window close requested - starting cleanup');
    if (await windowManager.isPreventClose()) {
      await _shutdown();
    }
  }
}

/// Lifecycle listener for additional cleanup scenarios
class AppLifecycleManager with WidgetsBindingObserver {
  static bool _cleanupCalled = false;

  static void initialize() {
    WidgetsBinding.instance.addObserver(AppLifecycleManager());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('App lifecycle state changed: $state');
    // IMPORTANT: On Windows desktop, AppLifecycleState.detached is unreliable
    // and can be triggered even when the app is still running normally.
    // Only cleanup on detached for mobile platforms where it's more reliable.
    // On desktop, rely on the window close handler instead.
    if (state == AppLifecycleState.detached &&
        !_cleanupCalled &&
        !kIsWeb &&
        (Platform.isIOS || Platform.isAndroid)) {
      debugPrint('App detached - forcing cleanup');
      _forceCleanup();
    }
  }

  static void _forceCleanup() {
    if (_cleanupCalled) return;
    _cleanupCalled = true;
    
    debugPrint('Force cleanup: stopping heartbeat');
    
    // Force cleanup heartbeat synchronously
    try {
      HeartbeatMonitor().stopFlutterHeartbeat();
    } catch (e) {
      debugPrint('Error during force cleanup: $e');
    }
  }
}
