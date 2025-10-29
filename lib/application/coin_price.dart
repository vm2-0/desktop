import 'dart:async';

import 'package:clones_desktop/application/token_price_provider.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coin_price.g.dart';

/// A notifier responsible for managing and updating cryptocurrency prices.
///
/// This notifier fetches cryptocurrency prices from the repository at
/// regular intervals (1 minute) and updates the state with the latest prices for a symbol.
@riverpod
class CoinPriceNotifier extends _$CoinPriceNotifier {
  static final _logger = Logger('CoinPriceNotifier');

  /// A timer to periodically fetch prices.
  Timer? _timer;

  /// Builds the initial state and starts the periodic price update timer.
  @override
  double build(String symbol) {
    ref.onDispose(stopTimer);
    startTimer(symbol);
    return 0;
  }

  /// Starts the periodic price fetch timer.
  ///
  /// The prices are updated every minute using the repository.
  Future<void> startTimer(String symbol) async {
    if (_timer != null) return;

    _logger.info('Start timer for symbol: $symbol');
    try {
      state = await ref.read(getTokenPriceProvider(symbol).future);
      _timer = Timer.periodic(const Duration(minutes: 1), (_) async {
        try {
          state = await ref.read(getTokenPriceProvider(symbol).future);
        } catch (e) {
          _logger.warning('Failed to fetch price for $symbol: $e');
        }
      });
    } catch (e) {
      _logger.severe('Failed to start timer for $symbol: $e');
    }
  }

  /// Stops the periodic price fetch timer.
  Future<void> stopTimer() async {
    _logger.info('Stop timer');
    if (_timer == null) return;
    _timer?.cancel();
    _timer = null;
  }
}
