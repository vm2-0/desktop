// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getTokenBalanceHash() => r'4cb07e604fe52d9dc953807ba587401053563c67';

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

/// See also [getTokenBalance].
@ProviderFor(getTokenBalance)
const getTokenBalanceProvider = GetTokenBalanceFamily();

/// See also [getTokenBalance].
class GetTokenBalanceFamily extends Family<AsyncValue<double>> {
  /// See also [getTokenBalance].
  const GetTokenBalanceFamily();

  /// See also [getTokenBalance].
  GetTokenBalanceProvider call(
    String address,
    String symbol,
  ) {
    return GetTokenBalanceProvider(
      address,
      symbol,
    );
  }

  @override
  GetTokenBalanceProvider getProviderOverride(
    covariant GetTokenBalanceProvider provider,
  ) {
    return call(
      provider.address,
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
  String? get name => r'getTokenBalanceProvider';
}

/// See also [getTokenBalance].
class GetTokenBalanceProvider extends AutoDisposeFutureProvider<double> {
  /// See also [getTokenBalance].
  GetTokenBalanceProvider(
    String address,
    String symbol,
  ) : this._internal(
          (ref) => getTokenBalance(
            ref as GetTokenBalanceRef,
            address,
            symbol,
          ),
          from: getTokenBalanceProvider,
          name: r'getTokenBalanceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getTokenBalanceHash,
          dependencies: GetTokenBalanceFamily._dependencies,
          allTransitiveDependencies:
              GetTokenBalanceFamily._allTransitiveDependencies,
          address: address,
          symbol: symbol,
        );

  GetTokenBalanceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.address,
    required this.symbol,
  }) : super.internal();

  final String address;
  final String symbol;

  @override
  Override overrideWith(
    FutureOr<double> Function(GetTokenBalanceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetTokenBalanceProvider._internal(
        (ref) => create(ref as GetTokenBalanceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        address: address,
        symbol: symbol,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<double> createElement() {
    return _GetTokenBalanceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetTokenBalanceProvider &&
        other.address == address &&
        other.symbol == symbol;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, address.hashCode);
    hash = _SystemHash.combine(hash, symbol.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetTokenBalanceRef on AutoDisposeFutureProviderRef<double> {
  /// The parameter `address` of this provider.
  String get address;

  /// The parameter `symbol` of this provider.
  String get symbol;
}

class _GetTokenBalanceProviderElement
    extends AutoDisposeFutureProviderElement<double> with GetTokenBalanceRef {
  _GetTokenBalanceProviderElement(super.provider);

  @override
  String get address => (origin as GetTokenBalanceProvider).address;
  @override
  String get symbol => (origin as GetTokenBalanceProvider).symbol;
}

String _$checkWalletConnectionHash() =>
    r'fa7a3e0986a575e4562aeaacf3a3eec07107d1ef';

/// See also [checkWalletConnection].
@ProviderFor(checkWalletConnection)
const checkWalletConnectionProvider = CheckWalletConnectionFamily();

/// See also [checkWalletConnection].
class CheckWalletConnectionFamily extends Family<
    AsyncValue<
        ({
          bool connected,
          String? address,
          String? referralCode,
          String? referrerAddress,
          String? referrerCode,
          TierInfo? tier
        })>> {
  /// See also [checkWalletConnection].
  const CheckWalletConnectionFamily();

  /// See also [checkWalletConnection].
  CheckWalletConnectionProvider call(
    String token,
  ) {
    return CheckWalletConnectionProvider(
      token,
    );
  }

  @override
  CheckWalletConnectionProvider getProviderOverride(
    covariant CheckWalletConnectionProvider provider,
  ) {
    return call(
      provider.token,
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
  String? get name => r'checkWalletConnectionProvider';
}

/// See also [checkWalletConnection].
class CheckWalletConnectionProvider extends AutoDisposeFutureProvider<
    ({
      bool connected,
      String? address,
      String? referralCode,
      String? referrerAddress,
      String? referrerCode,
      TierInfo? tier
    })> {
  /// See also [checkWalletConnection].
  CheckWalletConnectionProvider(
    String token,
  ) : this._internal(
          (ref) => checkWalletConnection(
            ref as CheckWalletConnectionRef,
            token,
          ),
          from: checkWalletConnectionProvider,
          name: r'checkWalletConnectionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$checkWalletConnectionHash,
          dependencies: CheckWalletConnectionFamily._dependencies,
          allTransitiveDependencies:
              CheckWalletConnectionFamily._allTransitiveDependencies,
          token: token,
        );

  CheckWalletConnectionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.token,
  }) : super.internal();

  final String token;

  @override
  Override overrideWith(
    FutureOr<
                ({
                  bool connected,
                  String? address,
                  String? referralCode,
                  String? referrerAddress,
                  String? referrerCode,
                  TierInfo? tier
                })>
            Function(CheckWalletConnectionRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CheckWalletConnectionProvider._internal(
        (ref) => create(ref as CheckWalletConnectionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        token: token,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<
      ({
        bool connected,
        String? address,
        String? referralCode,
        String? referrerAddress,
        String? referrerCode,
        TierInfo? tier
      })> createElement() {
    return _CheckWalletConnectionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CheckWalletConnectionProvider && other.token == token;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, token.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CheckWalletConnectionRef on AutoDisposeFutureProviderRef<
    ({
      bool connected,
      String? address,
      String? referralCode,
      String? referrerAddress,
      String? referrerCode,
      TierInfo? tier
    })> {
  /// The parameter `token` of this provider.
  String get token;
}

class _CheckWalletConnectionProviderElement
    extends AutoDisposeFutureProviderElement<
        ({
          bool connected,
          String? address,
          String? referralCode,
          String? referrerAddress,
          String? referrerCode,
          TierInfo? tier
        })> with CheckWalletConnectionRef {
  _CheckWalletConnectionProviderElement(super.provider);

  @override
  String get token => (origin as CheckWalletConnectionProvider).token;
}

String _$walletRepositoryHash() => r'1a8ff16f4150be00fefd59b17e15e38ec937b09b';

/// See also [walletRepository].
@ProviderFor(walletRepository)
final walletRepositoryProvider =
    AutoDisposeProvider<WalletRepositoryImpl>.internal(
  walletRepository,
  name: r'walletRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$walletRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WalletRepositoryRef = AutoDisposeProviderRef<WalletRepositoryImpl>;
String _$sessionNotifierHash() => r'54b041ca287af2df5711e0e1a71ff19e9aef16d2';

/// See also [SessionNotifier].
@ProviderFor(SessionNotifier)
final sessionNotifierProvider =
    AutoDisposeNotifierProvider<SessionNotifier, Session>.internal(
  SessionNotifier.new,
  name: r'sessionNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sessionNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SessionNotifier = AutoDisposeNotifier<Session>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
