import 'package:clones_desktop/domain/models/api/request_options.dart';
import 'package:clones_desktop/domain/models/factory/factory_token.dart';
import 'package:clones_desktop/domain/models/leaderboard/forge_leader_board.dart';
import 'package:clones_desktop/domain/models/leaderboard/stats_leader_board.dart';
import 'package:clones_desktop/domain/models/leaderboard/worker_leader_board.dart';
import 'package:clones_desktop/utils/api_client.dart';
import 'package:clones_desktop/utils/decimal_json.dart';

class LeaderboardRepositoryImpl {
  LeaderboardRepositoryImpl(this._client);
  final ApiClient _client;

  double _toDouble(dynamic value) {
    // Try DecimalJson first to support MongoDB Decimal128 extended JSON
    final dec = DecimalJson.fromJson(value);
    if (dec != null) {
      final s = dec.toString();
      final d = double.tryParse(s);
      if (d != null) return d;
    }
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    if (value is Map) {
      final number = value[r'$numberDecimal'] ??
          value[r'$numberDouble'] ??
          value[r'$numberInt'] ??
          value[r'$numberLong'];
      if (number is String) return double.tryParse(number) ?? 0.0;
    }
    return 0;
  }

  Future<Map<String, dynamic>> getLeaderboardData() async {
    try {
      final data = await _client.get<Map<String, dynamic>>(
        '/demonstration/leaderboards',
        options: const RequestOptions(requiresAuth: true),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return {
        'workersLeaderboard': (data['workersLeaderboard'] as List)
            .map(
              (worker) => WorkerLeaderboard(
                rank: worker['rank'],
                address: worker['address'],
                tasks: worker['tasks'],
                rewards: DecimalJson.fromJson(worker['rewards']),
                avgScore: _toDouble(worker['avgScore']),
                tokens: (worker['tokens'] as List<dynamic>? ?? [])
                    .map(
                      (tokenData) => WorkerTokenReward(
                        token: FactoryToken.fromJson(tokenData),
                        totalReward: _toDouble(tokenData['totalReward'] ?? 0),
                      ),
                    )
                    .toList(),
                totalUSD: _toDouble(worker['totalUSD'] ?? 0),
              ),
            )
            .toList(),
        'forgeLeaderboard': (data['forgeLeaderboard'] as List)
            .map(
              (forge) => ForgeLeaderboard(
                rank: forge['rank'],
                name: forge['name'],
                tasks: forge['tasks'],
                payout: _toDouble(forge['payout']),
                token: forge['token'] != null
                    ? FactoryToken.fromJson(forge['token'])
                    : null,
                payoutUSD: _toDouble(forge['payoutUSD'] ?? 0),
              ),
            )
            .toList(),
        'stats': LeaderboardStats(
          totalWorkers: data['stats']['totalWorkers'],
          tasksCompleted: data['stats']['tasksCompleted'],
          totalRewards: _toDouble(data['stats']['totalRewards']),
          activeForges: data['stats']['activeForges'],
          totalUSDPayout: _toDouble(data['stats']['totalUSDPayout'] ?? 0),
        ),
      };
    } catch (e) {
      throw Exception('Failed to load leaderboard data: $e');
    }
  }
}
