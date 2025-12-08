import 'package:clones_desktop/domain/models/api/request_options.dart';
import 'package:clones_desktop/domain/models/factory/factory.dart';
import 'package:clones_desktop/domain/models/factory/factory_grading_result.dart';
import 'package:clones_desktop/domain/models/factory/factory_search_criteria.dart';
import 'package:clones_desktop/domain/models/factory/factory_search_result.dart';
import 'package:clones_desktop/domain/models/factory/workflow_task.dart';
import 'package:clones_desktop/domain/models/supported_token.dart';
import 'package:clones_desktop/domain/models/withdrawal/withdrawal_validation.dart';
import 'package:clones_desktop/utils/api_client.dart';

abstract class FactoriesRepository {
  Future<FactorySearchResult> searchFactories(FactorySearchCriteria criteria);
  Future<FactorySearchResult> getUserFactories({
    required String walletAddress,
    int limit = 20,
    int offset = 0,
    FactoryStatus? status,
  });
  Future<Factory> updateFactoryTasks({
    required String factoryId,
    required List<WorkflowTask> tasks,
    required String walletAddress,
  });
}

/// Repository for Factory operations - integrated with new Factory API
class FactoriesRepositoryImpl implements FactoriesRepository {
  const FactoriesRepositoryImpl(this._apiClient);

  final ApiClient _apiClient;

  /// Search factories with advanced filtering
  @override
  Future<FactorySearchResult> searchFactories(
    FactorySearchCriteria criteria,
  ) async {
    try {
      final responseData = await _apiClient.post<Map<String, dynamic>>(
        '/forge/factories/search',
        data: criteria.toJson(),
        options: const RequestOptions(requiresAuth: true),
      );

      return FactorySearchResult.fromJson(responseData);
    } catch (_) {
      return FactorySearchResult(
        limit: criteria.limit,
        offset: criteria.offset,
      );
    }
  }

  /// Get factories for authenticated user
  @override
  Future<FactorySearchResult> getUserFactories({
    required String walletAddress,
    int limit = 20,
    int offset = 0,
    FactoryStatus? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'limit': limit.toString(),
        'offset': offset.toString(),
      };

      if (status != null) {
        queryParams['status'] = status.jsonValue;
      }

      final responseData = await _apiClient.get<Map<String, dynamic>>(
        '/forge/factories',
        params: queryParams,
        options: const RequestOptions(requiresAuth: true),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return FactorySearchResult.fromJson(responseData);
    } catch (e) {
      throw Exception('Failed to get user factories: $e');
    }
  }

  /// Get factory by ID
  Future<Factory> getFactory(String factoryId) async {
    try {
      final responseData = await _apiClient.get<Map<String, dynamic>>(
        '/forge/factories/$factoryId',
        options: const RequestOptions(requiresAuth: true),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      final factory = Factory.fromJson(responseData);
      return factory.copyWith(
        balance: (responseData['balance'] as num?)?.toDouble() ?? 0.0,
      );
    } catch (e) {
      throw Exception('Failed to get factory: $e');
    }
  }

  /// Get grading results for a factory
  Future<List<FactoryGradingResult>> getFactoryGradingResults(
    String factoryId,
  ) async {
    try {
      final responseData = await _apiClient.get<List<dynamic>>(
        '/forge/factories/$factoryId/grading-results',
        options: const RequestOptions(requiresAuth: true),
        fromJson: (json) => json as List<dynamic>,
      );

      return responseData
          .map(
            (json) =>
                FactoryGradingResult.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get factory grading results: $e');
    }
  }

  /// Update factory
  Future<Factory> updateFactory({
    required String factoryId,
    required String walletAddress,
    String? name,
    String? description,
    List<String>? skills,
    FactoryStatus? status,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (name != null) updateData['name'] = name;
      if (description != null) updateData['description'] = description;
      if (skills != null) updateData['skills'] = skills;
      if (status != null) updateData['status'] = status.jsonValue;

      final responseData = await _apiClient.put<Map<String, dynamic>>(
        '/forge/factories/$factoryId',
        data: updateData,
        options: const RequestOptions(
          requiresAuth: true,
        ),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return Factory.fromJson(responseData);
    } catch (e) {
      throw Exception('Failed to update factory: $e');
    }
  }

  /// Get factories by creator address (for public viewing)
  Future<FactorySearchResult> getFactoriesByCreator({
    required String creatorAddress,
    int limit = 20,
    int offset = 0,
  }) async {
    // Use search endpoint with creator filter
    final criteria = FactorySearchCriteria(
      creator: creatorAddress,
      limit: limit,
      offset: offset,
    );

    return searchFactories(criteria);
  }

  /// Search factories by skills
  Future<FactorySearchResult> searchFactoriesBySkills({
    required List<String> skills,
    int limit = 20,
    int offset = 0,
  }) async {
    final criteria = FactorySearchCriteria(
      skills: skills,
      limit: limit,
      offset: offset,
      sortBy: 'balance',
    );

    return searchFactories(criteria);
  }

  /// Search factories by token
  Future<FactorySearchResult> searchFactoriesByToken({
    required String tokenSymbol,
    int limit = 20,
    int offset = 0,
  }) async {
    final criteria = FactorySearchCriteria(
      token: tokenSymbol,
      limit: limit,
      offset: offset,
      sortBy: 'balance',
    );

    return searchFactories(criteria);
  }

  /// Create a new pool (blockchain operation)
  Future<Map<String, dynamic>> createPool({
    required String token,
    required String creator,
  }) async {
    try {
      return await _apiClient.post<Map<String, dynamic>>(
        '/forge/pools/create',
        data: {
          'token': token,
          'creator': creator,
        },
        options: const RequestOptions(requiresAuth: true),
        fromJson: (json) => json as Map<String, dynamic>,
      );
    } catch (e) {
      throw Exception('Failed to create pool: $e');
    }
  }

  /// Predict pool address before creation
  Future<Map<String, dynamic>> predictPoolAddress({
    required String creator,
    required String token,
  }) async {
    try {
      return await _apiClient.post<Map<String, dynamic>>(
        '/forge/factories/pools/predict-address',
        data: {
          'creator': creator,
          'token': token,
        },
        options: const RequestOptions(requiresAuth: true),
        fromJson: (json) => json as Map<String, dynamic>,
      );
    } catch (e) {
      throw Exception('Failed to predict pool address: $e');
    }
  }

  /// Estimate gas for factory operations
  Future<Map<String, dynamic>> estimateGas({
    required String type,
    String? token,
    String? amount,
    String? creator,
    String? poolAddress,
  }) async {
    try {
      final body = <String, dynamic>{'type': type};
      if (token != null) body['token'] = token;
      if (amount != null) body['amount'] = amount;
      if (creator != null) body['creator'] = creator;
      if (poolAddress != null) body['poolAddress'] = poolAddress;

      final response = await _apiClient.post<Map<String, dynamic>>(
        '/transaction/estimate-gas',
        data: body,
        options: const RequestOptions(requiresAuth: true),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return response;
    } catch (e) {
      throw Exception('Failed to estimate gas: $e');
    }
  }

  /// Get pool information including balance
  Future<Map<String, dynamic>> getPoolInfo({
    required String poolAddress,
    String? account,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (account != null) queryParams['account'] = account;

      final responseData = await _apiClient.get<Map<String, dynamic>>(
        '/forge/factories/pools/$poolAddress',
        params: queryParams.isEmpty ? null : queryParams,
        options: const RequestOptions(requiresAuth: true),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      return responseData;
    } catch (e) {
      throw Exception('Failed to get pool info: $e');
    }
  }

  /// Get pool balance only (lightweight endpoint)
  Future<Map<String, dynamic>> getPoolBalance({
    required String poolAddress,
  }) async {
    try {
      final responseData = await _apiClient.get<Map<String, dynamic>>(
        '/forge/factories/pools/$poolAddress/balance',
        options: const RequestOptions(requiresAuth: true),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      return responseData;
    } catch (e) {
      throw Exception('Failed to get pool balance: $e');
    }
  }

  /// Fund a pool with tokens
  Future<Map<String, dynamic>> fundPool({
    required String poolAddress,
    required double amount,
  }) async {
    try {
      return await _apiClient.post<Map<String, dynamic>>(
        '/forge/factories/pools/fund',
        data: {
          'poolAddress': poolAddress,
          'amount': amount,
        },
        options: const RequestOptions(requiresAuth: true),
        fromJson: (json) => json as Map<String, dynamic>,
      );
    } catch (e) {
      throw Exception('Failed to fund pool: $e');
    }
  }

  /// Generate claim signature for rewards
  Future<Map<String, dynamic>> generateClaimSignature({
    required String vaultAddress,
    required String account,
    required double cumulativeAmount,
    int? deadline,
  }) async {
    try {
      final body = <String, dynamic>{
        'vaultAddress': vaultAddress,
        'account': account,
        'cumulativeAmount': cumulativeAmount,
      };
      if (deadline != null) body['deadline'] = deadline;

      return await _apiClient.post<Map<String, dynamic>>(
        '/forge/claims/signature',
        data: body,
        options: const RequestOptions(requiresAuth: true),
        fromJson: (json) => json as Map<String, dynamic>,
      );
    } catch (e) {
      throw Exception('Failed to generate claim signature: $e');
    }
  }

  /// Generate batch claim data for multiple claims
  Future<Map<String, dynamic>> generateBatchClaimData({
    required List<Map<String, dynamic>> claims,
  }) async {
    try {
      return await _apiClient.post<Map<String, dynamic>>(
        '/forge/claims/batch',
        data: {'claims': claims},
        options: const RequestOptions(requiresAuth: true),
        fromJson: (json) => json as Map<String, dynamic>,
      );
    } catch (e) {
      throw Exception('Failed to generate batch claim data: $e');
    }
  }

  /// Get publisher information
  Future<Map<String, dynamic>> getPublisherInfo() async {
    try {
      return await _apiClient.get<Map<String, dynamic>>(
        '/forge/publisher',
        options: const RequestOptions(requiresAuth: true),
        fromJson: (json) => json as Map<String, dynamic>,
      );
    } catch (e) {
      throw Exception('Failed to get publisher info: $e');
    }
  }

  /// Get supported tokens list
  Future<List<SupportedToken>> getSupportedTokens() async {
    try {
      final tokensJson = await _apiClient.get<List<dynamic>>(
        '/forge/factories/supported-tokens',
        options: const RequestOptions(requiresAuth: true),
        fromJson: (json) => json as List<dynamic>,
      );

      return tokensJson
          .map((json) => SupportedToken.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get supported tokens: $e');
    }
  }

  /// Withdraw funds from a pool
  Future<Map<String, dynamic>> withdrawPool({
    required String poolAddress,
    required double amount,
  }) async {
    try {
      return await _apiClient.post<Map<String, dynamic>>(
        '/forge/factories/pools/withdraw',
        data: {
          'poolAddress': poolAddress,
          'amount': amount,
        },
        options: const RequestOptions(requiresAuth: true),
        fromJson: (json) => json as Map<String, dynamic>,
      );
    } catch (e) {
      throw Exception('Failed to withdraw from pool: $e');
    }
  }

  /// Update factory tasks - new tasks-first endpoint
  @override
  Future<Factory> updateFactoryTasks({
    required String factoryId,
    required List<WorkflowTask> tasks,
    required String walletAddress,
  }) async {
    try {
      final cleanTasks = tasks.map((task) {
        final cleanTask = <String, dynamic>{
          'prompt': task.prompt,
          'categories': task.categories,
          'task_name': task.taskName,
          'apps_used': task.appsUsed
              .map(
                (app) => {
                  'name': app.name,
                  'domain': app.domain,
                  'description': app.description,
                },
              )
              .toList(),
        };

        if (task.id != null && task.id!.isNotEmpty) {
          cleanTask['id'] = task.id;
        }

        if (task.uploadLimit != null && task.uploadLimit! >= 1) {
          cleanTask['uploadLimit'] = task.uploadLimit;
        }

        if (task.rewardLimit != null && task.rewardLimit!.toDouble() > 0) {
          cleanTask['rewardLimit'] = task.rewardLimit!.toDouble();
        }

        return cleanTask;
      }).toList();

      final responseData = await _apiClient.put<Map<String, dynamic>>(
        '/forge/factories/apps/$factoryId/workflows',
        data: {'tasks': cleanTasks},
        options: const RequestOptions(requiresAuth: true),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return Factory.fromJson(responseData);
    } catch (e) {
      throw Exception('Failed to update factory tasks: $e');
    }
  }

  /// Validate a withdrawal before execution
  /// Checks if the withdrawal would leave sufficient funds for pending claims
  Future<WithdrawalValidation> validateWithdrawal({
    required String poolAddress,
    required String amount,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/withdrawal/validate',
        data: {
          'poolAddress': poolAddress,
          'amount': amount,
        },
        options: const RequestOptions(requiresAuth: true),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return WithdrawalValidation.fromJson(response);
    } catch (e) {
      throw Exception('Failed to validate withdrawal: $e');
    }
  }

  /// Get pool health status and metrics
  Future<PoolHealth> getPoolHealth({
    required String poolAddress,
  }) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/withdrawal/pools/$poolAddress/health',
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return PoolHealth.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get pool health: $e');
    }
  }

  /// Get maximum safe withdrawal amount for a pool
  Future<MaxWithdrawal> getMaxWithdrawal({
    required String poolAddress,
  }) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/withdrawal/pools/$poolAddress/max-withdrawal',
        options: const RequestOptions(requiresAuth: true),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return MaxWithdrawal.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get max withdrawal: $e');
    }
  }
}
