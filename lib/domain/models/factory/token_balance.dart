// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_balance.freezed.dart';
part 'token_balance.g.dart';

// TODO(reddwarf03): Doublon with wallet/token_balance.dart ?
@freezed
class TokenBalance with _$TokenBalance {
  const factory TokenBalance({
    required String token,
    required double balance,
  }) = _TokenBalance;

  factory TokenBalance.fromJson(Map<String, dynamic> json) =>
      _$TokenBalanceFromJson(json);
}
