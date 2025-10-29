// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin_price.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$coinPriceNotifierHash() => r'79598fe0847bd7074a2323ce71cc0fb5971b0a07';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$CoinPriceNotifier
    extends BuildlessAutoDisposeNotifier<double> {
  late final String symbol;

  double build(
    String symbol,
  );
}

/// A notifier responsible for managing and updating cryptocurrency prices.
///
/// This notifier fetches cryptocurrency prices from the repository at
/// regular intervals (1 minute) and updates the state with the latest prices for a symbol.
///
/// Copied from [CoinPriceNotifier].
@ProviderFor(CoinPriceNotifier)
const coinPriceNotifierProvider = CoinPriceNotifierFamily();

/// A notifier responsible for managing and updating cryptocurrency prices.
///
/// This notifier fetches cryptocurrency prices from the repository at
/// regular intervals (1 minute) and updates the state with the latest prices for a symbol.
///
/// Copied from [CoinPriceNotifier].
class CoinPriceNotifierFamily extends Family<double> {
  /// A notifier responsible for managing and updating cryptocurrency prices.
  ///
  /// This notifier fetches cryptocurrency prices from the repository at
  /// regular intervals (1 minute) and updates the state with the latest prices for a symbol.
  ///
  /// Copied from [CoinPriceNotifier].
  const CoinPriceNotifierFamily();

  /// A notifier responsible for managing and updating cryptocurrency prices.
  ///
  /// This notifier fetches cryptocurrency prices from the repository at
  /// regular intervals (1 minute) and updates the state with the latest prices for a symbol.
  ///
  /// Copied from [CoinPriceNotifier].
  CoinPriceNotifierProvider call(
    String symbol,
  ) {
    return CoinPriceNotifierProvider(
      symbol,
    );
  }

  @override
  CoinPriceNotifierProvider getProviderOverride(
    covariant CoinPriceNotifierProvider provider,
  ) {
    return call(
      provider.symbol,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'coinPriceNotifierProvider';
}

/// A notifier responsible for managing and updating cryptocurrency prices.
///
/// This notifier fetches cryptocurrency prices from the repository at
/// regular intervals (1 minute) and updates the state with the latest prices for a symbol.
///
/// Copied from [CoinPriceNotifier].
class CoinPriceNotifierProvider
    extends AutoDisposeNotifierProviderImpl<CoinPriceNotifier, double> {
  /// A notifier responsible for managing and updating cryptocurrency prices.
  ///
  /// This notifier fetches cryptocurrency prices from the repository at
  /// regular intervals (1 minute) and updates the state with the latest prices for a symbol.
  ///
  /// Copied from [CoinPriceNotifier].
  CoinPriceNotifierProvider(
    String symbol,
  ) : this._internal(
          () => CoinPriceNotifier()..symbol = symbol,
          from: coinPriceNotifierProvider,
          name: r'coinPriceNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$coinPriceNotifierHash,
          dependencies: CoinPriceNotifierFamily._dependencies,
          allTransitiveDependencies:
              CoinPriceNotifierFamily._allTransitiveDependencies,
          symbol: symbol,
        );

  CoinPriceNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.symbol,
  }) : super.internal();

  final String symbol;

  @override
  double runNotifierBuild(
    covariant CoinPriceNotifier notifier,
  ) {
    return notifier.build(
      symbol,
    );
  }

  @override
  Override overrideWith(CoinPriceNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: CoinPriceNotifierProvider._internal(
        () => create()..symbol = symbol,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        symbol: symbol,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<CoinPriceNotifier, double>
      createElement() {
    return _CoinPriceNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CoinPriceNotifierProvider && other.symbol == symbol;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, symbol.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CoinPriceNotifierRef on AutoDisposeNotifierProviderRef<double> {
  /// The parameter `symbol` of this provider.
  String get symbol;
}

class _CoinPriceNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<CoinPriceNotifier, double>
    with CoinPriceNotifierRef {
  _CoinPriceNotifierProviderElement(super.provider);

  @override
  String get symbol => (origin as CoinPriceNotifierProvider).symbol;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
