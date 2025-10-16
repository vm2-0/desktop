import 'package:clones_desktop/domain/models/api/request_options.dart';
import 'package:clones_desktop/domain/models/wallet/tier_info.dart';
import 'package:clones_desktop/utils/api_client.dart';

class WalletRepositoryImpl {
  WalletRepositoryImpl(this._client);
  final ApiClient _client;

  Future<double> getBalance({
    required String address,
    required String symbol,
  }) async {
    try {
      final data = await _client.get<Map<String, dynamic>>(
        '/wallet/balance/$address',
        params: {'symbol': symbol},
        options: const RequestOptions(requiresAuth: true),
      );
      return data['balance']?.toDouble() ?? 0;
    } catch (e) {
      throw Exception('Failed to get balance: $e');
    }
  }

  Future<
      ({
        bool connected,
        String? address,
        String? referralCode,
        String? referrerAddress,
        String? referrerCode,
        TierInfo? tier,
      })> checkConnection(
    String token,
  ) async {
    try {
      final data = await _client.get<Map<String, dynamic>>(
        '/wallet/connection',
        params: {'token': token},
      );

      final tier = data['tier'] != null && data['tier'] is Map<String, dynamic>
          ? TierInfo.fromJson(data['tier'] as Map<String, dynamic>)
          : null;

      return (
        connected: data['connected'] as bool,
        address: data['address'] as String?,
        referralCode: data['referralCode'] as String?,
        referrerAddress: data['referrer']?['walletAddress'] as String?,
        referrerCode: data['referrer']?['referralCode'] as String?,
        tier: tier,
      );
    } catch (e) {
      throw Exception('Failed to check connection: $e');
    }
  }

  Future<double> getTokenPriceUSD({
    required String symbol,
  }) async {
    try {
      final data = await _client.get<Map<String, dynamic>>(
        '/wallet/price',
        params: {'symbol': symbol},
      );
      return data['priceUSD']?.toDouble() ?? 0;
    } catch (e) {
      throw Exception('Failed to get token price: $e');
    }
  }
}
