import 'package:clones_desktop/application/coin_price.dart';
import 'package:clones_desktop/utils/format_num.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UsdPrice extends ConsumerWidget {
  const UsdPrice({
    super.key,
    required this.amount,
    required this.symbol,
    this.style,
    this.withParentheses = true,
  });
  final Decimal amount;
  final String symbol;
  final TextStyle? style;
  final bool withParentheses;

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final priceUSD = ref.watch(coinPriceNotifierProvider(symbol));
    final price = amount * Decimal.parse(priceUSD.toString());
    final theme = Theme.of(context);
    return Text(
      withParentheses
          ? '(\$${price.toStringAsFixedLowValue(2, 5)})'
          : '\$${price.toStringAsFixedLowValue(2, 5)}',
      style: style ?? theme.textTheme.bodySmall,
    );
  }
}
