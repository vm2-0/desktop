import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppEnvironment {
  dev,
  test,
  prod,
}

class EnvironmentNotifier extends StateNotifier<AppEnvironment> {
  EnvironmentNotifier() : super(AppEnvironment.dev) {
    _detectEnvironment();
  }

  void _detectEnvironment() {
    // Get environment from .env file
    final env = dotenv.env['ENV'] ?? 'dev';
    
    switch (env.toLowerCase()) {
      case 'production':
      case 'prod':
        state = AppEnvironment.prod;
        break;
      case 'test':
      case 'testing':
      case 'staging':
        state = AppEnvironment.test;
        break;
      default:
        state = AppEnvironment.dev;
        break;
    }
  }
}

final environmentProvider = StateNotifierProvider<EnvironmentNotifier, AppEnvironment>(
  (ref) => EnvironmentNotifier(),
);

extension AppEnvironmentExtension on AppEnvironment {
  String get displayName {
    switch (this) {
      case AppEnvironment.dev:
        return 'DEVNET\nBase sepolia';
      case AppEnvironment.test:
        return 'TESTNET\nBase sepolia';
      case AppEnvironment.prod:
        return '';
    }
  }
  
  bool get shouldShowEnvironmentBadge {
    return this != AppEnvironment.prod;
  }
}