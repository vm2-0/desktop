import 'dart:async';
import 'dart:math';

import 'package:clones_desktop/application/factory.dart';
import 'package:clones_desktop/application/referral.dart';
import 'package:clones_desktop/application/session/state.dart';
import 'package:clones_desktop/domain/models/wallet/tier_info.dart';
import 'package:clones_desktop/domain/models/wallet/token_balance.dart';
import 'package:clones_desktop/infrastructure/wallet.repository.dart';
import 'package:clones_desktop/utils/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
class SessionNotifier extends _$SessionNotifier {
  SessionNotifier();

  Timer? _pollingTimer;
  Timer? _connectingTimer;

  @override
  Session build() {
    ref.onDispose(() {
      _pollingTimer?.cancel();
      _connectingTimer?.cancel();
    });

    return const Session();
  }

  Future<void> cancelConnection() async {
    state = state.copyWith(
      connectionToken: null,
      address: null,
      balances: null,
      tier: null,
    );
  }

  Future<void> startPolling() async {
    final token = state.connectionToken;
    if (token == null) {
      state = state.copyWith(
        address: null,
        balances: null,
      );
      return;
    }

    _pollingTimer?.cancel();

    ref.notifyListeners();

    _connectingTimer = Timer(const Duration(seconds: 5), () {
      ref.notifyListeners();
    });

    _pollingTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      try {
        final checkConnectionResult =
            await ref.read(checkWalletConnectionProvider(token).future);
        if (checkConnectionResult.connected) {
          _pollingTimer?.cancel();
          _pollingTimer = null;
          if (checkConnectionResult.address != null) {
            state = state.copyWith(
              address: checkConnectionResult.address,
              referralCode: checkConnectionResult.referralCode,
              referrerAddress: checkConnectionResult.referrerAddress,
              referrerCode: checkConnectionResult.referrerCode,
              tier: checkConnectionResult.tier,
            );
            await fetchBalances();
          }
        }
      } catch (e) {
        debugPrint('Failed to check connection: $e');
      }
    });
  }

  void addReferralCode(String referralCode) {
    state = state.copyWith(referralCode: referralCode.toUpperCase());
  }

  Future<void> addReferrerInfo() async {
    final referrerInfo =
        await ref.read(getReferrerInfoProvider(state.address!).future);
    if (referrerInfo.referrerAddress == null ||
        referrerInfo.referrerCode == null) {
      return;
    }

    state = state.copyWith(
      referrerAddress: referrerInfo.referrerAddress,
      referrerCode: referrerInfo.referrerCode,
    );
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _connectingTimer?.cancel();
    _connectingTimer = null;
  }

  Future<void> fetchBalances() async {
    if (state.address == null) {
      state = state.copyWith(balances: []);
      return;
    }
    final walletRepository = ref.read(walletRepositoryProvider);
    final supportedTokens = await ref.read(getSupportedTokensProvider.future);

    state = state.copyWith(
      balances: supportedTokens
          .map(
            (token) => TokenBalance(
              symbol: token.symbol,
              name: token.name,
              logoUrl: token.logoUrl,
              isLoading: true,
            ),
          )
          .toList(),
    );

    final updatedBalances = <TokenBalance>[];
    for (final tokenBalance in state.balances!) {
      try {
        final balance = await walletRepository.getBalance(
          address: state.address!,
          symbol: tokenBalance.symbol,
        );
        updatedBalances.add(
          tokenBalance.copyWith(balance: balance, isLoading: false),
        );
      } catch (e) {
        debugPrint('Failed to fetch balance for ${tokenBalance.symbol}: $e');
        updatedBalances.add(tokenBalance.copyWith(isLoading: false));
      }
    }
    state = state.copyWith(balances: updatedBalances);
  }

  Future<void> getConnectionUrl() async {
    String _generateToken() {
      final random = Random();
      final randomPart = random.nextDouble().toStringAsFixed(16).substring(2);
      final randomBase36 = BigInt.parse(randomPart).toRadixString(36);
      final timestampPart =
          DateTime.now().millisecondsSinceEpoch.toRadixString(36);
      return '$randomBase36$timestampPart';
    }

    final token = _generateToken();
    state = state.copyWith(connectionToken: token);
  }
}

@riverpod
Future<double> getTokenBalance(
  Ref ref,
  String address,
  String symbol,
) async {
  final walletRepository = ref.read(walletRepositoryProvider);
  return walletRepository.getBalance(address: address, symbol: symbol);
}

@riverpod
Future<
    ({
      bool connected,
      String? address,
      String? referralCode,
      String? referrerAddress,
      String? referrerCode,
      TierInfo tier,
    })> checkWalletConnection(
  Ref ref,
  String token,
) async {
  final walletRepository = ref.read(walletRepositoryProvider);
  return walletRepository.checkConnection(token);
}

@riverpod
WalletRepositoryImpl walletRepository(
  Ref ref,
) {
  final apiClient = ref.watch(apiClientProvider);
  return WalletRepositoryImpl(apiClient);
}
