import 'package:clones_desktop/domain/models/referral/referral_info.dart';
import 'package:clones_desktop/infrastructure/referral.repository.dart';
import 'package:clones_desktop/utils/api_client.dart';
import 'package:clones_desktop/utils/env.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'referral.g.dart';

@riverpod
ReferralRepository referralRepository(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ReferralRepositoryImpl(apiClient);
}

@riverpod
Future<ReferralInfo?> getReferralInfo(Ref ref, String walletAddress) async {
  try {
    final repository = ref.watch(referralRepositoryProvider);
    final response = await repository.getReferralInfo(walletAddress);
    // Check if the referral code is empty
    if (response.referralCode.isEmpty) {
      return null;
    }

    final referralInfo = ReferralInfo(
      referralCode: response.referralCode,
      walletAddress: walletAddress,
      totalReferrals: response.totalReferrals,
      totalRewards: response.totalRewards,
      isActive: response.isActive,
      expiresAt: response.expiresAt,
      createdAt: response.createdAt,
      lastUpdated: response.lastUpdated,
    );

    return referralInfo;
  } catch (e) {
    rethrow;
  }
}

@riverpod
Future<({String? referrerAddress, String? referrerCode})> getReferrerInfo(
  Ref ref,
  String walletAddress,
) async {
  final repository = ref.watch(referralRepositoryProvider);
  return repository.getReferrerInfo(walletAddress);
}
