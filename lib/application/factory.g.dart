// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'factory.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$factoryRepositoryHash() => r'13491e1a4765442985aad0ad0d603c8da5eab1eb';

/// See also [factoryRepository].
@ProviderFor(factoryRepository)
final factoryRepositoryProvider =
    AutoDisposeProvider<FactoriesRepositoryImpl>.internal(
  factoryRepository,
  name: r'factoryRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$factoryRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FactoryRepositoryRef = AutoDisposeProviderRef<FactoriesRepositoryImpl>;
String _$createPoolHash() => r'5b0415c967f44678717d78662e8b093ca8a2b386';

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

/// See also [createPool].
@ProviderFor(createPool)
const createPoolProvider = CreatePoolFamily();

/// See also [createPool].
class CreatePoolFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [createPool].
  const CreatePoolFamily();

  /// See also [createPool].
  CreatePoolProvider call({
    required String token,
    required String creator,
  }) {
    return CreatePoolProvider(
      token: token,
      creator: creator,
    );
  }

  @override
  CreatePoolProvider getProviderOverride(
    covariant CreatePoolProvider provider,
  ) {
    return call(
      token: provider.token,
      creator: provider.creator,
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
  String? get name => r'createPoolProvider';
}

/// See also [createPool].
class CreatePoolProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// See also [createPool].
  CreatePoolProvider({
    required String token,
    required String creator,
  }) : this._internal(
          (ref) => createPool(
            ref as CreatePoolRef,
            token: token,
            creator: creator,
          ),
          from: createPoolProvider,
          name: r'createPoolProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$createPoolHash,
          dependencies: CreatePoolFamily._dependencies,
          allTransitiveDependencies:
              CreatePoolFamily._allTransitiveDependencies,
          token: token,
          creator: creator,
        );

  CreatePoolProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.token,
    required this.creator,
  }) : super.internal();

  final String token;
  final String creator;

  @override
  Override overrideWith(
    FutureOr<Map<String, dynamic>> Function(CreatePoolRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CreatePoolProvider._internal(
        (ref) => create(ref as CreatePoolRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        token: token,
        creator: creator,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _CreatePoolProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CreatePoolProvider &&
        other.token == token &&
        other.creator == creator;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, token.hashCode);
    hash = _SystemHash.combine(hash, creator.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CreatePoolRef on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `token` of this provider.
  String get token;

  /// The parameter `creator` of this provider.
  String get creator;
}

class _CreatePoolProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with CreatePoolRef {
  _CreatePoolProviderElement(super.provider);

  @override
  String get token => (origin as CreatePoolProvider).token;
  @override
  String get creator => (origin as CreatePoolProvider).creator;
}

String _$predictPoolAddressHash() =>
    r'9616919c0f4bf7442c03bb813c18e28a6fec9225';

/// See also [predictPoolAddress].
@ProviderFor(predictPoolAddress)
const predictPoolAddressProvider = PredictPoolAddressFamily();

/// See also [predictPoolAddress].
class PredictPoolAddressFamily
    extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [predictPoolAddress].
  const PredictPoolAddressFamily();

  /// See also [predictPoolAddress].
  PredictPoolAddressProvider call({
    required String creator,
    required String token,
  }) {
    return PredictPoolAddressProvider(
      creator: creator,
      token: token,
    );
  }

  @override
  PredictPoolAddressProvider getProviderOverride(
    covariant PredictPoolAddressProvider provider,
  ) {
    return call(
      creator: provider.creator,
      token: provider.token,
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
  String? get name => r'predictPoolAddressProvider';
}

/// See also [predictPoolAddress].
class PredictPoolAddressProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// See also [predictPoolAddress].
  PredictPoolAddressProvider({
    required String creator,
    required String token,
  }) : this._internal(
          (ref) => predictPoolAddress(
            ref as PredictPoolAddressRef,
            creator: creator,
            token: token,
          ),
          from: predictPoolAddressProvider,
          name: r'predictPoolAddressProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$predictPoolAddressHash,
          dependencies: PredictPoolAddressFamily._dependencies,
          allTransitiveDependencies:
              PredictPoolAddressFamily._allTransitiveDependencies,
          creator: creator,
          token: token,
        );

  PredictPoolAddressProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.creator,
    required this.token,
  }) : super.internal();

  final String creator;
  final String token;

  @override
  Override overrideWith(
    FutureOr<Map<String, dynamic>> Function(PredictPoolAddressRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PredictPoolAddressProvider._internal(
        (ref) => create(ref as PredictPoolAddressRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        creator: creator,
        token: token,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _PredictPoolAddressProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PredictPoolAddressProvider &&
        other.creator == creator &&
        other.token == token;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, creator.hashCode);
    hash = _SystemHash.combine(hash, token.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PredictPoolAddressRef
    on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `creator` of this provider.
  String get creator;

  /// The parameter `token` of this provider.
  String get token;
}

class _PredictPoolAddressProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with PredictPoolAddressRef {
  _PredictPoolAddressProviderElement(super.provider);

  @override
  String get creator => (origin as PredictPoolAddressProvider).creator;
  @override
  String get token => (origin as PredictPoolAddressProvider).token;
}

String _$estimateFactoryGasHash() =>
    r'6725b188ead9dff574e4c7b0b645e2e1c9c18b14';

/// See also [estimateFactoryGas].
@ProviderFor(estimateFactoryGas)
const estimateFactoryGasProvider = EstimateFactoryGasFamily();

/// See also [estimateFactoryGas].
class EstimateFactoryGasFamily
    extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [estimateFactoryGas].
  const EstimateFactoryGasFamily();

  /// See also [estimateFactoryGas].
  EstimateFactoryGasProvider call({
    required String type,
    String? token,
    String? amount,
    String? creator,
    String? poolAddress,
  }) {
    return EstimateFactoryGasProvider(
      type: type,
      token: token,
      amount: amount,
      creator: creator,
      poolAddress: poolAddress,
    );
  }

  @override
  EstimateFactoryGasProvider getProviderOverride(
    covariant EstimateFactoryGasProvider provider,
  ) {
    return call(
      type: provider.type,
      token: provider.token,
      amount: provider.amount,
      creator: provider.creator,
      poolAddress: provider.poolAddress,
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
  String? get name => r'estimateFactoryGasProvider';
}

/// See also [estimateFactoryGas].
class EstimateFactoryGasProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// See also [estimateFactoryGas].
  EstimateFactoryGasProvider({
    required String type,
    String? token,
    String? amount,
    String? creator,
    String? poolAddress,
  }) : this._internal(
          (ref) => estimateFactoryGas(
            ref as EstimateFactoryGasRef,
            type: type,
            token: token,
            amount: amount,
            creator: creator,
            poolAddress: poolAddress,
          ),
          from: estimateFactoryGasProvider,
          name: r'estimateFactoryGasProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$estimateFactoryGasHash,
          dependencies: EstimateFactoryGasFamily._dependencies,
          allTransitiveDependencies:
              EstimateFactoryGasFamily._allTransitiveDependencies,
          type: type,
          token: token,
          amount: amount,
          creator: creator,
          poolAddress: poolAddress,
        );

  EstimateFactoryGasProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
    required this.token,
    required this.amount,
    required this.creator,
    required this.poolAddress,
  }) : super.internal();

  final String type;
  final String? token;
  final String? amount;
  final String? creator;
  final String? poolAddress;

  @override
  Override overrideWith(
    FutureOr<Map<String, dynamic>> Function(EstimateFactoryGasRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EstimateFactoryGasProvider._internal(
        (ref) => create(ref as EstimateFactoryGasRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
        token: token,
        amount: amount,
        creator: creator,
        poolAddress: poolAddress,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _EstimateFactoryGasProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EstimateFactoryGasProvider &&
        other.type == type &&
        other.token == token &&
        other.amount == amount &&
        other.creator == creator &&
        other.poolAddress == poolAddress;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);
    hash = _SystemHash.combine(hash, token.hashCode);
    hash = _SystemHash.combine(hash, amount.hashCode);
    hash = _SystemHash.combine(hash, creator.hashCode);
    hash = _SystemHash.combine(hash, poolAddress.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin EstimateFactoryGasRef
    on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `type` of this provider.
  String get type;

  /// The parameter `token` of this provider.
  String? get token;

  /// The parameter `amount` of this provider.
  String? get amount;

  /// The parameter `creator` of this provider.
  String? get creator;

  /// The parameter `poolAddress` of this provider.
  String? get poolAddress;
}

class _EstimateFactoryGasProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with EstimateFactoryGasRef {
  _EstimateFactoryGasProviderElement(super.provider);

  @override
  String get type => (origin as EstimateFactoryGasProvider).type;
  @override
  String? get token => (origin as EstimateFactoryGasProvider).token;
  @override
  String? get amount => (origin as EstimateFactoryGasProvider).amount;
  @override
  String? get creator => (origin as EstimateFactoryGasProvider).creator;
  @override
  String? get poolAddress => (origin as EstimateFactoryGasProvider).poolAddress;
}

String _$getPoolInfoHash() => r'40fad27594d7f89d2b8b57df20c3a29f4918a596';

/// See also [getPoolInfo].
@ProviderFor(getPoolInfo)
const getPoolInfoProvider = GetPoolInfoFamily();

/// See also [getPoolInfo].
class GetPoolInfoFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [getPoolInfo].
  const GetPoolInfoFamily();

  /// See also [getPoolInfo].
  GetPoolInfoProvider call({
    required String poolAddress,
    String? account,
  }) {
    return GetPoolInfoProvider(
      poolAddress: poolAddress,
      account: account,
    );
  }

  @override
  GetPoolInfoProvider getProviderOverride(
    covariant GetPoolInfoProvider provider,
  ) {
    return call(
      poolAddress: provider.poolAddress,
      account: provider.account,
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
  String? get name => r'getPoolInfoProvider';
}

/// See also [getPoolInfo].
class GetPoolInfoProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// See also [getPoolInfo].
  GetPoolInfoProvider({
    required String poolAddress,
    String? account,
  }) : this._internal(
          (ref) => getPoolInfo(
            ref as GetPoolInfoRef,
            poolAddress: poolAddress,
            account: account,
          ),
          from: getPoolInfoProvider,
          name: r'getPoolInfoProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getPoolInfoHash,
          dependencies: GetPoolInfoFamily._dependencies,
          allTransitiveDependencies:
              GetPoolInfoFamily._allTransitiveDependencies,
          poolAddress: poolAddress,
          account: account,
        );

  GetPoolInfoProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.poolAddress,
    required this.account,
  }) : super.internal();

  final String poolAddress;
  final String? account;

  @override
  Override overrideWith(
    FutureOr<Map<String, dynamic>> Function(GetPoolInfoRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetPoolInfoProvider._internal(
        (ref) => create(ref as GetPoolInfoRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        poolAddress: poolAddress,
        account: account,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _GetPoolInfoProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetPoolInfoProvider &&
        other.poolAddress == poolAddress &&
        other.account == account;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, poolAddress.hashCode);
    hash = _SystemHash.combine(hash, account.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetPoolInfoRef on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `poolAddress` of this provider.
  String get poolAddress;

  /// The parameter `account` of this provider.
  String? get account;
}

class _GetPoolInfoProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with GetPoolInfoRef {
  _GetPoolInfoProviderElement(super.provider);

  @override
  String get poolAddress => (origin as GetPoolInfoProvider).poolAddress;
  @override
  String? get account => (origin as GetPoolInfoProvider).account;
}

String _$fundPoolHash() => r'622fe786cf84b714f8de992a625d063a672d7da0';

/// See also [fundPool].
@ProviderFor(fundPool)
const fundPoolProvider = FundPoolFamily();

/// See also [fundPool].
class FundPoolFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [fundPool].
  const FundPoolFamily();

  /// See also [fundPool].
  FundPoolProvider call({
    required String poolAddress,
    required double amount,
  }) {
    return FundPoolProvider(
      poolAddress: poolAddress,
      amount: amount,
    );
  }

  @override
  FundPoolProvider getProviderOverride(
    covariant FundPoolProvider provider,
  ) {
    return call(
      poolAddress: provider.poolAddress,
      amount: provider.amount,
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
  String? get name => r'fundPoolProvider';
}

/// See also [fundPool].
class FundPoolProvider extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// See also [fundPool].
  FundPoolProvider({
    required String poolAddress,
    required double amount,
  }) : this._internal(
          (ref) => fundPool(
            ref as FundPoolRef,
            poolAddress: poolAddress,
            amount: amount,
          ),
          from: fundPoolProvider,
          name: r'fundPoolProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fundPoolHash,
          dependencies: FundPoolFamily._dependencies,
          allTransitiveDependencies: FundPoolFamily._allTransitiveDependencies,
          poolAddress: poolAddress,
          amount: amount,
        );

  FundPoolProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.poolAddress,
    required this.amount,
  }) : super.internal();

  final String poolAddress;
  final double amount;

  @override
  Override overrideWith(
    FutureOr<Map<String, dynamic>> Function(FundPoolRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FundPoolProvider._internal(
        (ref) => create(ref as FundPoolRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        poolAddress: poolAddress,
        amount: amount,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _FundPoolProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FundPoolProvider &&
        other.poolAddress == poolAddress &&
        other.amount == amount;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, poolAddress.hashCode);
    hash = _SystemHash.combine(hash, amount.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FundPoolRef on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `poolAddress` of this provider.
  String get poolAddress;

  /// The parameter `amount` of this provider.
  double get amount;
}

class _FundPoolProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with FundPoolRef {
  _FundPoolProviderElement(super.provider);

  @override
  String get poolAddress => (origin as FundPoolProvider).poolAddress;
  @override
  double get amount => (origin as FundPoolProvider).amount;
}

String _$withdrawPoolHash() => r'59f8b1bd9d479836daff0dd978687b1ebd5c68b5';

/// See also [withdrawPool].
@ProviderFor(withdrawPool)
const withdrawPoolProvider = WithdrawPoolFamily();

/// See also [withdrawPool].
class WithdrawPoolFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [withdrawPool].
  const WithdrawPoolFamily();

  /// See also [withdrawPool].
  WithdrawPoolProvider call({
    required String poolAddress,
    required double amount,
  }) {
    return WithdrawPoolProvider(
      poolAddress: poolAddress,
      amount: amount,
    );
  }

  @override
  WithdrawPoolProvider getProviderOverride(
    covariant WithdrawPoolProvider provider,
  ) {
    return call(
      poolAddress: provider.poolAddress,
      amount: provider.amount,
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
  String? get name => r'withdrawPoolProvider';
}

/// See also [withdrawPool].
class WithdrawPoolProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// See also [withdrawPool].
  WithdrawPoolProvider({
    required String poolAddress,
    required double amount,
  }) : this._internal(
          (ref) => withdrawPool(
            ref as WithdrawPoolRef,
            poolAddress: poolAddress,
            amount: amount,
          ),
          from: withdrawPoolProvider,
          name: r'withdrawPoolProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$withdrawPoolHash,
          dependencies: WithdrawPoolFamily._dependencies,
          allTransitiveDependencies:
              WithdrawPoolFamily._allTransitiveDependencies,
          poolAddress: poolAddress,
          amount: amount,
        );

  WithdrawPoolProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.poolAddress,
    required this.amount,
  }) : super.internal();

  final String poolAddress;
  final double amount;

  @override
  Override overrideWith(
    FutureOr<Map<String, dynamic>> Function(WithdrawPoolRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WithdrawPoolProvider._internal(
        (ref) => create(ref as WithdrawPoolRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        poolAddress: poolAddress,
        amount: amount,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _WithdrawPoolProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WithdrawPoolProvider &&
        other.poolAddress == poolAddress &&
        other.amount == amount;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, poolAddress.hashCode);
    hash = _SystemHash.combine(hash, amount.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WithdrawPoolRef on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `poolAddress` of this provider.
  String get poolAddress;

  /// The parameter `amount` of this provider.
  double get amount;
}

class _WithdrawPoolProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with WithdrawPoolRef {
  _WithdrawPoolProviderElement(super.provider);

  @override
  String get poolAddress => (origin as WithdrawPoolProvider).poolAddress;
  @override
  double get amount => (origin as WithdrawPoolProvider).amount;
}

String _$generateClaimSignatureHash() =>
    r'e3ea6f19d75375411bce6cf131be532960fc2def';

/// See also [generateClaimSignature].
@ProviderFor(generateClaimSignature)
const generateClaimSignatureProvider = GenerateClaimSignatureFamily();

/// See also [generateClaimSignature].
class GenerateClaimSignatureFamily
    extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [generateClaimSignature].
  const GenerateClaimSignatureFamily();

  /// See also [generateClaimSignature].
  GenerateClaimSignatureProvider call({
    required String vaultAddress,
    required String account,
    required double cumulativeAmount,
    int? deadline,
  }) {
    return GenerateClaimSignatureProvider(
      vaultAddress: vaultAddress,
      account: account,
      cumulativeAmount: cumulativeAmount,
      deadline: deadline,
    );
  }

  @override
  GenerateClaimSignatureProvider getProviderOverride(
    covariant GenerateClaimSignatureProvider provider,
  ) {
    return call(
      vaultAddress: provider.vaultAddress,
      account: provider.account,
      cumulativeAmount: provider.cumulativeAmount,
      deadline: provider.deadline,
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
  String? get name => r'generateClaimSignatureProvider';
}

/// See also [generateClaimSignature].
class GenerateClaimSignatureProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// See also [generateClaimSignature].
  GenerateClaimSignatureProvider({
    required String vaultAddress,
    required String account,
    required double cumulativeAmount,
    int? deadline,
  }) : this._internal(
          (ref) => generateClaimSignature(
            ref as GenerateClaimSignatureRef,
            vaultAddress: vaultAddress,
            account: account,
            cumulativeAmount: cumulativeAmount,
            deadline: deadline,
          ),
          from: generateClaimSignatureProvider,
          name: r'generateClaimSignatureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$generateClaimSignatureHash,
          dependencies: GenerateClaimSignatureFamily._dependencies,
          allTransitiveDependencies:
              GenerateClaimSignatureFamily._allTransitiveDependencies,
          vaultAddress: vaultAddress,
          account: account,
          cumulativeAmount: cumulativeAmount,
          deadline: deadline,
        );

  GenerateClaimSignatureProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.vaultAddress,
    required this.account,
    required this.cumulativeAmount,
    required this.deadline,
  }) : super.internal();

  final String vaultAddress;
  final String account;
  final double cumulativeAmount;
  final int? deadline;

  @override
  Override overrideWith(
    FutureOr<Map<String, dynamic>> Function(GenerateClaimSignatureRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GenerateClaimSignatureProvider._internal(
        (ref) => create(ref as GenerateClaimSignatureRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        vaultAddress: vaultAddress,
        account: account,
        cumulativeAmount: cumulativeAmount,
        deadline: deadline,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _GenerateClaimSignatureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GenerateClaimSignatureProvider &&
        other.vaultAddress == vaultAddress &&
        other.account == account &&
        other.cumulativeAmount == cumulativeAmount &&
        other.deadline == deadline;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, vaultAddress.hashCode);
    hash = _SystemHash.combine(hash, account.hashCode);
    hash = _SystemHash.combine(hash, cumulativeAmount.hashCode);
    hash = _SystemHash.combine(hash, deadline.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GenerateClaimSignatureRef
    on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `vaultAddress` of this provider.
  String get vaultAddress;

  /// The parameter `account` of this provider.
  String get account;

  /// The parameter `cumulativeAmount` of this provider.
  double get cumulativeAmount;

  /// The parameter `deadline` of this provider.
  int? get deadline;
}

class _GenerateClaimSignatureProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with GenerateClaimSignatureRef {
  _GenerateClaimSignatureProviderElement(super.provider);

  @override
  String get vaultAddress =>
      (origin as GenerateClaimSignatureProvider).vaultAddress;
  @override
  String get account => (origin as GenerateClaimSignatureProvider).account;
  @override
  double get cumulativeAmount =>
      (origin as GenerateClaimSignatureProvider).cumulativeAmount;
  @override
  int? get deadline => (origin as GenerateClaimSignatureProvider).deadline;
}

String _$generateBatchClaimDataHash() =>
    r'210b33a862572c166bf59ee89adec304fb418ec6';

/// See also [generateBatchClaimData].
@ProviderFor(generateBatchClaimData)
const generateBatchClaimDataProvider = GenerateBatchClaimDataFamily();

/// See also [generateBatchClaimData].
class GenerateBatchClaimDataFamily
    extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [generateBatchClaimData].
  const GenerateBatchClaimDataFamily();

  /// See also [generateBatchClaimData].
  GenerateBatchClaimDataProvider call({
    required List<Map<String, dynamic>> claims,
  }) {
    return GenerateBatchClaimDataProvider(
      claims: claims,
    );
  }

  @override
  GenerateBatchClaimDataProvider getProviderOverride(
    covariant GenerateBatchClaimDataProvider provider,
  ) {
    return call(
      claims: provider.claims,
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
  String? get name => r'generateBatchClaimDataProvider';
}

/// See also [generateBatchClaimData].
class GenerateBatchClaimDataProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// See also [generateBatchClaimData].
  GenerateBatchClaimDataProvider({
    required List<Map<String, dynamic>> claims,
  }) : this._internal(
          (ref) => generateBatchClaimData(
            ref as GenerateBatchClaimDataRef,
            claims: claims,
          ),
          from: generateBatchClaimDataProvider,
          name: r'generateBatchClaimDataProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$generateBatchClaimDataHash,
          dependencies: GenerateBatchClaimDataFamily._dependencies,
          allTransitiveDependencies:
              GenerateBatchClaimDataFamily._allTransitiveDependencies,
          claims: claims,
        );

  GenerateBatchClaimDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.claims,
  }) : super.internal();

  final List<Map<String, dynamic>> claims;

  @override
  Override overrideWith(
    FutureOr<Map<String, dynamic>> Function(GenerateBatchClaimDataRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GenerateBatchClaimDataProvider._internal(
        (ref) => create(ref as GenerateBatchClaimDataRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        claims: claims,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _GenerateBatchClaimDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GenerateBatchClaimDataProvider && other.claims == claims;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, claims.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GenerateBatchClaimDataRef
    on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `claims` of this provider.
  List<Map<String, dynamic>> get claims;
}

class _GenerateBatchClaimDataProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with GenerateBatchClaimDataRef {
  _GenerateBatchClaimDataProviderElement(super.provider);

  @override
  List<Map<String, dynamic>> get claims =>
      (origin as GenerateBatchClaimDataProvider).claims;
}

String _$getPublisherInfoHash() => r'471e217c8a5753fd0b6ad89f0fc50d3a22c0f059';

/// See also [getPublisherInfo].
@ProviderFor(getPublisherInfo)
final getPublisherInfoProvider =
    AutoDisposeFutureProvider<Map<String, dynamic>>.internal(
  getPublisherInfo,
  name: r'getPublisherInfoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getPublisherInfoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetPublisherInfoRef
    = AutoDisposeFutureProviderRef<Map<String, dynamic>>;
String _$getSupportedTokensHash() =>
    r'd65a8234695f3e1309bb41c04c87015af22dde96';

/// See also [getSupportedTokens].
@ProviderFor(getSupportedTokens)
final getSupportedTokensProvider =
    AutoDisposeFutureProvider<List<SupportedToken>>.internal(
  getSupportedTokens,
  name: r'getSupportedTokensProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getSupportedTokensHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetSupportedTokensRef
    = AutoDisposeFutureProviderRef<List<SupportedToken>>;
String _$searchFactoriesHash() => r'b64e749543831512a74cc02c2f1d2cb3b54c0c80';

/// See also [searchFactories].
@ProviderFor(searchFactories)
const searchFactoriesProvider = SearchFactoriesFamily();

/// See also [searchFactories].
class SearchFactoriesFamily extends Family<AsyncValue<FactorySearchResult>> {
  /// See also [searchFactories].
  const SearchFactoriesFamily();

  /// See also [searchFactories].
  SearchFactoriesProvider call({
    required FactorySearchCriteria criteria,
  }) {
    return SearchFactoriesProvider(
      criteria: criteria,
    );
  }

  @override
  SearchFactoriesProvider getProviderOverride(
    covariant SearchFactoriesProvider provider,
  ) {
    return call(
      criteria: provider.criteria,
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
  String? get name => r'searchFactoriesProvider';
}

/// See also [searchFactories].
class SearchFactoriesProvider
    extends AutoDisposeFutureProvider<FactorySearchResult> {
  /// See also [searchFactories].
  SearchFactoriesProvider({
    required FactorySearchCriteria criteria,
  }) : this._internal(
          (ref) => searchFactories(
            ref as SearchFactoriesRef,
            criteria: criteria,
          ),
          from: searchFactoriesProvider,
          name: r'searchFactoriesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchFactoriesHash,
          dependencies: SearchFactoriesFamily._dependencies,
          allTransitiveDependencies:
              SearchFactoriesFamily._allTransitiveDependencies,
          criteria: criteria,
        );

  SearchFactoriesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.criteria,
  }) : super.internal();

  final FactorySearchCriteria criteria;

  @override
  Override overrideWith(
    FutureOr<FactorySearchResult> Function(SearchFactoriesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchFactoriesProvider._internal(
        (ref) => create(ref as SearchFactoriesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        criteria: criteria,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<FactorySearchResult> createElement() {
    return _SearchFactoriesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchFactoriesProvider && other.criteria == criteria;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, criteria.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchFactoriesRef on AutoDisposeFutureProviderRef<FactorySearchResult> {
  /// The parameter `criteria` of this provider.
  FactorySearchCriteria get criteria;
}

class _SearchFactoriesProviderElement
    extends AutoDisposeFutureProviderElement<FactorySearchResult>
    with SearchFactoriesRef {
  _SearchFactoriesProviderElement(super.provider);

  @override
  FactorySearchCriteria get criteria =>
      (origin as SearchFactoriesProvider).criteria;
}

String _$getUserFactoriesHash() => r'8286474ea96087467c26182e63a4e95630cfaa75';

/// See also [getUserFactories].
@ProviderFor(getUserFactories)
const getUserFactoriesProvider = GetUserFactoriesFamily();

/// See also [getUserFactories].
class GetUserFactoriesFamily extends Family<AsyncValue<FactorySearchResult>> {
  /// See also [getUserFactories].
  const GetUserFactoriesFamily();

  /// See also [getUserFactories].
  GetUserFactoriesProvider call({
    required String walletAddress,
  }) {
    return GetUserFactoriesProvider(
      walletAddress: walletAddress,
    );
  }

  @override
  GetUserFactoriesProvider getProviderOverride(
    covariant GetUserFactoriesProvider provider,
  ) {
    return call(
      walletAddress: provider.walletAddress,
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
  String? get name => r'getUserFactoriesProvider';
}

/// See also [getUserFactories].
class GetUserFactoriesProvider
    extends AutoDisposeFutureProvider<FactorySearchResult> {
  /// See also [getUserFactories].
  GetUserFactoriesProvider({
    required String walletAddress,
  }) : this._internal(
          (ref) => getUserFactories(
            ref as GetUserFactoriesRef,
            walletAddress: walletAddress,
          ),
          from: getUserFactoriesProvider,
          name: r'getUserFactoriesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getUserFactoriesHash,
          dependencies: GetUserFactoriesFamily._dependencies,
          allTransitiveDependencies:
              GetUserFactoriesFamily._allTransitiveDependencies,
          walletAddress: walletAddress,
        );

  GetUserFactoriesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.walletAddress,
  }) : super.internal();

  final String walletAddress;

  @override
  Override overrideWith(
    FutureOr<FactorySearchResult> Function(GetUserFactoriesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetUserFactoriesProvider._internal(
        (ref) => create(ref as GetUserFactoriesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        walletAddress: walletAddress,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<FactorySearchResult> createElement() {
    return _GetUserFactoriesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetUserFactoriesProvider &&
        other.walletAddress == walletAddress;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, walletAddress.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetUserFactoriesRef on AutoDisposeFutureProviderRef<FactorySearchResult> {
  /// The parameter `walletAddress` of this provider.
  String get walletAddress;
}

class _GetUserFactoriesProviderElement
    extends AutoDisposeFutureProviderElement<FactorySearchResult>
    with GetUserFactoriesRef {
  _GetUserFactoriesProviderElement(super.provider);

  @override
  String get walletAddress =>
      (origin as GetUserFactoriesProvider).walletAddress;
}

String _$getFactoryHash() => r'd5ac92fba25293e034ba15db5bd17474130ae269';

/// See also [getFactory].
@ProviderFor(getFactory)
const getFactoryProvider = GetFactoryFamily();

/// See also [getFactory].
class GetFactoryFamily extends Family<AsyncValue<Factory>> {
  /// See also [getFactory].
  const GetFactoryFamily();

  /// See also [getFactory].
  GetFactoryProvider call({
    required String factoryId,
  }) {
    return GetFactoryProvider(
      factoryId: factoryId,
    );
  }

  @override
  GetFactoryProvider getProviderOverride(
    covariant GetFactoryProvider provider,
  ) {
    return call(
      factoryId: provider.factoryId,
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
  String? get name => r'getFactoryProvider';
}

/// See also [getFactory].
class GetFactoryProvider extends AutoDisposeFutureProvider<Factory> {
  /// See also [getFactory].
  GetFactoryProvider({
    required String factoryId,
  }) : this._internal(
          (ref) => getFactory(
            ref as GetFactoryRef,
            factoryId: factoryId,
          ),
          from: getFactoryProvider,
          name: r'getFactoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getFactoryHash,
          dependencies: GetFactoryFamily._dependencies,
          allTransitiveDependencies:
              GetFactoryFamily._allTransitiveDependencies,
          factoryId: factoryId,
        );

  GetFactoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.factoryId,
  }) : super.internal();

  final String factoryId;

  @override
  Override overrideWith(
    FutureOr<Factory> Function(GetFactoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetFactoryProvider._internal(
        (ref) => create(ref as GetFactoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        factoryId: factoryId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Factory> createElement() {
    return _GetFactoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetFactoryProvider && other.factoryId == factoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, factoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetFactoryRef on AutoDisposeFutureProviderRef<Factory> {
  /// The parameter `factoryId` of this provider.
  String get factoryId;
}

class _GetFactoryProviderElement
    extends AutoDisposeFutureProviderElement<Factory> with GetFactoryRef {
  _GetFactoryProviderElement(super.provider);

  @override
  String get factoryId => (origin as GetFactoryProvider).factoryId;
}

String _$updateFactoryHash() => r'068d9b83e5920981713210160bbda2f4d90e69b4';

/// See also [updateFactory].
@ProviderFor(updateFactory)
const updateFactoryProvider = UpdateFactoryFamily();

/// See also [updateFactory].
class UpdateFactoryFamily extends Family<AsyncValue<Factory>> {
  /// See also [updateFactory].
  const UpdateFactoryFamily();

  /// See also [updateFactory].
  UpdateFactoryProvider call({
    required String factoryId,
    required String walletAddress,
    String? factoryName,
    String? description,
    List<String>? skills,
    FactoryStatus? status,
  }) {
    return UpdateFactoryProvider(
      factoryId: factoryId,
      walletAddress: walletAddress,
      factoryName: factoryName,
      description: description,
      skills: skills,
      status: status,
    );
  }

  @override
  UpdateFactoryProvider getProviderOverride(
    covariant UpdateFactoryProvider provider,
  ) {
    return call(
      factoryId: provider.factoryId,
      walletAddress: provider.walletAddress,
      factoryName: provider.factoryName,
      description: provider.description,
      skills: provider.skills,
      status: provider.status,
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
  String? get name => r'updateFactoryProvider';
}

/// See also [updateFactory].
class UpdateFactoryProvider extends AutoDisposeFutureProvider<Factory> {
  /// See also [updateFactory].
  UpdateFactoryProvider({
    required String factoryId,
    required String walletAddress,
    String? factoryName,
    String? description,
    List<String>? skills,
    FactoryStatus? status,
  }) : this._internal(
          (ref) => updateFactory(
            ref as UpdateFactoryRef,
            factoryId: factoryId,
            walletAddress: walletAddress,
            factoryName: factoryName,
            description: description,
            skills: skills,
            status: status,
          ),
          from: updateFactoryProvider,
          name: r'updateFactoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$updateFactoryHash,
          dependencies: UpdateFactoryFamily._dependencies,
          allTransitiveDependencies:
              UpdateFactoryFamily._allTransitiveDependencies,
          factoryId: factoryId,
          walletAddress: walletAddress,
          factoryName: factoryName,
          description: description,
          skills: skills,
          status: status,
        );

  UpdateFactoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.factoryId,
    required this.walletAddress,
    required this.factoryName,
    required this.description,
    required this.skills,
    required this.status,
  }) : super.internal();

  final String factoryId;
  final String walletAddress;
  final String? factoryName;
  final String? description;
  final List<String>? skills;
  final FactoryStatus? status;

  @override
  Override overrideWith(
    FutureOr<Factory> Function(UpdateFactoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdateFactoryProvider._internal(
        (ref) => create(ref as UpdateFactoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        factoryId: factoryId,
        walletAddress: walletAddress,
        factoryName: factoryName,
        description: description,
        skills: skills,
        status: status,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Factory> createElement() {
    return _UpdateFactoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateFactoryProvider &&
        other.factoryId == factoryId &&
        other.walletAddress == walletAddress &&
        other.factoryName == factoryName &&
        other.description == description &&
        other.skills == skills &&
        other.status == status;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, factoryId.hashCode);
    hash = _SystemHash.combine(hash, walletAddress.hashCode);
    hash = _SystemHash.combine(hash, factoryName.hashCode);
    hash = _SystemHash.combine(hash, description.hashCode);
    hash = _SystemHash.combine(hash, skills.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UpdateFactoryRef on AutoDisposeFutureProviderRef<Factory> {
  /// The parameter `factoryId` of this provider.
  String get factoryId;

  /// The parameter `walletAddress` of this provider.
  String get walletAddress;

  /// The parameter `factoryName` of this provider.
  String? get factoryName;

  /// The parameter `description` of this provider.
  String? get description;

  /// The parameter `skills` of this provider.
  List<String>? get skills;

  /// The parameter `status` of this provider.
  FactoryStatus? get status;
}

class _UpdateFactoryProviderElement
    extends AutoDisposeFutureProviderElement<Factory> with UpdateFactoryRef {
  _UpdateFactoryProviderElement(super.provider);

  @override
  String get factoryId => (origin as UpdateFactoryProvider).factoryId;
  @override
  String get walletAddress => (origin as UpdateFactoryProvider).walletAddress;
  @override
  String? get factoryName => (origin as UpdateFactoryProvider).factoryName;
  @override
  String? get description => (origin as UpdateFactoryProvider).description;
  @override
  List<String>? get skills => (origin as UpdateFactoryProvider).skills;
  @override
  FactoryStatus? get status => (origin as UpdateFactoryProvider).status;
}

String _$getFactoriesByCreatorHash() =>
    r'117ad722587ca413040749b80f31ab55310364eb';

/// See also [getFactoriesByCreator].
@ProviderFor(getFactoriesByCreator)
const getFactoriesByCreatorProvider = GetFactoriesByCreatorFamily();

/// See also [getFactoriesByCreator].
class GetFactoriesByCreatorFamily
    extends Family<AsyncValue<FactorySearchResult>> {
  /// See also [getFactoriesByCreator].
  const GetFactoriesByCreatorFamily();

  /// See also [getFactoriesByCreator].
  GetFactoriesByCreatorProvider call({
    required String creatorAddress,
  }) {
    return GetFactoriesByCreatorProvider(
      creatorAddress: creatorAddress,
    );
  }

  @override
  GetFactoriesByCreatorProvider getProviderOverride(
    covariant GetFactoriesByCreatorProvider provider,
  ) {
    return call(
      creatorAddress: provider.creatorAddress,
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
  String? get name => r'getFactoriesByCreatorProvider';
}

/// See also [getFactoriesByCreator].
class GetFactoriesByCreatorProvider
    extends AutoDisposeFutureProvider<FactorySearchResult> {
  /// See also [getFactoriesByCreator].
  GetFactoriesByCreatorProvider({
    required String creatorAddress,
  }) : this._internal(
          (ref) => getFactoriesByCreator(
            ref as GetFactoriesByCreatorRef,
            creatorAddress: creatorAddress,
          ),
          from: getFactoriesByCreatorProvider,
          name: r'getFactoriesByCreatorProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getFactoriesByCreatorHash,
          dependencies: GetFactoriesByCreatorFamily._dependencies,
          allTransitiveDependencies:
              GetFactoriesByCreatorFamily._allTransitiveDependencies,
          creatorAddress: creatorAddress,
        );

  GetFactoriesByCreatorProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.creatorAddress,
  }) : super.internal();

  final String creatorAddress;

  @override
  Override overrideWith(
    FutureOr<FactorySearchResult> Function(GetFactoriesByCreatorRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetFactoriesByCreatorProvider._internal(
        (ref) => create(ref as GetFactoriesByCreatorRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        creatorAddress: creatorAddress,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<FactorySearchResult> createElement() {
    return _GetFactoriesByCreatorProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetFactoriesByCreatorProvider &&
        other.creatorAddress == creatorAddress;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, creatorAddress.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetFactoriesByCreatorRef
    on AutoDisposeFutureProviderRef<FactorySearchResult> {
  /// The parameter `creatorAddress` of this provider.
  String get creatorAddress;
}

class _GetFactoriesByCreatorProviderElement
    extends AutoDisposeFutureProviderElement<FactorySearchResult>
    with GetFactoriesByCreatorRef {
  _GetFactoriesByCreatorProviderElement(super.provider);

  @override
  String get creatorAddress =>
      (origin as GetFactoriesByCreatorProvider).creatorAddress;
}

String _$searchFactoriesBySkillsHash() =>
    r'2bf7a39cde3b7d61f973666869c2efce7598f7f7';

/// See also [searchFactoriesBySkills].
@ProviderFor(searchFactoriesBySkills)
const searchFactoriesBySkillsProvider = SearchFactoriesBySkillsFamily();

/// See also [searchFactoriesBySkills].
class SearchFactoriesBySkillsFamily
    extends Family<AsyncValue<FactorySearchResult>> {
  /// See also [searchFactoriesBySkills].
  const SearchFactoriesBySkillsFamily();

  /// See also [searchFactoriesBySkills].
  SearchFactoriesBySkillsProvider call({
    required List<String> skills,
  }) {
    return SearchFactoriesBySkillsProvider(
      skills: skills,
    );
  }

  @override
  SearchFactoriesBySkillsProvider getProviderOverride(
    covariant SearchFactoriesBySkillsProvider provider,
  ) {
    return call(
      skills: provider.skills,
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
  String? get name => r'searchFactoriesBySkillsProvider';
}

/// See also [searchFactoriesBySkills].
class SearchFactoriesBySkillsProvider
    extends AutoDisposeFutureProvider<FactorySearchResult> {
  /// See also [searchFactoriesBySkills].
  SearchFactoriesBySkillsProvider({
    required List<String> skills,
  }) : this._internal(
          (ref) => searchFactoriesBySkills(
            ref as SearchFactoriesBySkillsRef,
            skills: skills,
          ),
          from: searchFactoriesBySkillsProvider,
          name: r'searchFactoriesBySkillsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchFactoriesBySkillsHash,
          dependencies: SearchFactoriesBySkillsFamily._dependencies,
          allTransitiveDependencies:
              SearchFactoriesBySkillsFamily._allTransitiveDependencies,
          skills: skills,
        );

  SearchFactoriesBySkillsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.skills,
  }) : super.internal();

  final List<String> skills;

  @override
  Override overrideWith(
    FutureOr<FactorySearchResult> Function(SearchFactoriesBySkillsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchFactoriesBySkillsProvider._internal(
        (ref) => create(ref as SearchFactoriesBySkillsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        skills: skills,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<FactorySearchResult> createElement() {
    return _SearchFactoriesBySkillsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchFactoriesBySkillsProvider && other.skills == skills;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, skills.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchFactoriesBySkillsRef
    on AutoDisposeFutureProviderRef<FactorySearchResult> {
  /// The parameter `skills` of this provider.
  List<String> get skills;
}

class _SearchFactoriesBySkillsProviderElement
    extends AutoDisposeFutureProviderElement<FactorySearchResult>
    with SearchFactoriesBySkillsRef {
  _SearchFactoriesBySkillsProviderElement(super.provider);

  @override
  List<String> get skills => (origin as SearchFactoriesBySkillsProvider).skills;
}

String _$searchFactoriesByTokenHash() =>
    r'bfaeac276a8c720cf003d058172d5abe74cddd4f';

/// See also [searchFactoriesByToken].
@ProviderFor(searchFactoriesByToken)
const searchFactoriesByTokenProvider = SearchFactoriesByTokenFamily();

/// See also [searchFactoriesByToken].
class SearchFactoriesByTokenFamily
    extends Family<AsyncValue<FactorySearchResult>> {
  /// See also [searchFactoriesByToken].
  const SearchFactoriesByTokenFamily();

  /// See also [searchFactoriesByToken].
  SearchFactoriesByTokenProvider call({
    required String tokenSymbol,
  }) {
    return SearchFactoriesByTokenProvider(
      tokenSymbol: tokenSymbol,
    );
  }

  @override
  SearchFactoriesByTokenProvider getProviderOverride(
    covariant SearchFactoriesByTokenProvider provider,
  ) {
    return call(
      tokenSymbol: provider.tokenSymbol,
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
  String? get name => r'searchFactoriesByTokenProvider';
}

/// See also [searchFactoriesByToken].
class SearchFactoriesByTokenProvider
    extends AutoDisposeFutureProvider<FactorySearchResult> {
  /// See also [searchFactoriesByToken].
  SearchFactoriesByTokenProvider({
    required String tokenSymbol,
  }) : this._internal(
          (ref) => searchFactoriesByToken(
            ref as SearchFactoriesByTokenRef,
            tokenSymbol: tokenSymbol,
          ),
          from: searchFactoriesByTokenProvider,
          name: r'searchFactoriesByTokenProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchFactoriesByTokenHash,
          dependencies: SearchFactoriesByTokenFamily._dependencies,
          allTransitiveDependencies:
              SearchFactoriesByTokenFamily._allTransitiveDependencies,
          tokenSymbol: tokenSymbol,
        );

  SearchFactoriesByTokenProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.tokenSymbol,
  }) : super.internal();

  final String tokenSymbol;

  @override
  Override overrideWith(
    FutureOr<FactorySearchResult> Function(SearchFactoriesByTokenRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchFactoriesByTokenProvider._internal(
        (ref) => create(ref as SearchFactoriesByTokenRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        tokenSymbol: tokenSymbol,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<FactorySearchResult> createElement() {
    return _SearchFactoriesByTokenProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchFactoriesByTokenProvider &&
        other.tokenSymbol == tokenSymbol;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, tokenSymbol.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchFactoriesByTokenRef
    on AutoDisposeFutureProviderRef<FactorySearchResult> {
  /// The parameter `tokenSymbol` of this provider.
  String get tokenSymbol;
}

class _SearchFactoriesByTokenProviderElement
    extends AutoDisposeFutureProviderElement<FactorySearchResult>
    with SearchFactoriesByTokenRef {
  _SearchFactoriesByTokenProviderElement(super.provider);

  @override
  String get tokenSymbol =>
      (origin as SearchFactoriesByTokenProvider).tokenSymbol;
}

String _$updateFactoryAppsHash() => r'829be3690c1a4df17079fd95b0d1660ab5315502';

/// See also [updateFactoryApps].
@ProviderFor(updateFactoryApps)
const updateFactoryAppsProvider = UpdateFactoryAppsFamily();

/// See also [updateFactoryApps].
class UpdateFactoryAppsFamily extends Family<AsyncValue<Factory>> {
  /// See also [updateFactoryApps].
  const UpdateFactoryAppsFamily();

  /// See also [updateFactoryApps].
  UpdateFactoryAppsProvider call({
    required String factoryId,
    required List<FactoryApp> apps,
    required String walletAddress,
  }) {
    return UpdateFactoryAppsProvider(
      factoryId: factoryId,
      apps: apps,
      walletAddress: walletAddress,
    );
  }

  @override
  UpdateFactoryAppsProvider getProviderOverride(
    covariant UpdateFactoryAppsProvider provider,
  ) {
    return call(
      factoryId: provider.factoryId,
      apps: provider.apps,
      walletAddress: provider.walletAddress,
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
  String? get name => r'updateFactoryAppsProvider';
}

/// See also [updateFactoryApps].
class UpdateFactoryAppsProvider extends AutoDisposeFutureProvider<Factory> {
  /// See also [updateFactoryApps].
  UpdateFactoryAppsProvider({
    required String factoryId,
    required List<FactoryApp> apps,
    required String walletAddress,
  }) : this._internal(
          (ref) => updateFactoryApps(
            ref as UpdateFactoryAppsRef,
            factoryId: factoryId,
            apps: apps,
            walletAddress: walletAddress,
          ),
          from: updateFactoryAppsProvider,
          name: r'updateFactoryAppsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$updateFactoryAppsHash,
          dependencies: UpdateFactoryAppsFamily._dependencies,
          allTransitiveDependencies:
              UpdateFactoryAppsFamily._allTransitiveDependencies,
          factoryId: factoryId,
          apps: apps,
          walletAddress: walletAddress,
        );

  UpdateFactoryAppsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.factoryId,
    required this.apps,
    required this.walletAddress,
  }) : super.internal();

  final String factoryId;
  final List<FactoryApp> apps;
  final String walletAddress;

  @override
  Override overrideWith(
    FutureOr<Factory> Function(UpdateFactoryAppsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdateFactoryAppsProvider._internal(
        (ref) => create(ref as UpdateFactoryAppsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        factoryId: factoryId,
        apps: apps,
        walletAddress: walletAddress,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Factory> createElement() {
    return _UpdateFactoryAppsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateFactoryAppsProvider &&
        other.factoryId == factoryId &&
        other.apps == apps &&
        other.walletAddress == walletAddress;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, factoryId.hashCode);
    hash = _SystemHash.combine(hash, apps.hashCode);
    hash = _SystemHash.combine(hash, walletAddress.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UpdateFactoryAppsRef on AutoDisposeFutureProviderRef<Factory> {
  /// The parameter `factoryId` of this provider.
  String get factoryId;

  /// The parameter `apps` of this provider.
  List<FactoryApp> get apps;

  /// The parameter `walletAddress` of this provider.
  String get walletAddress;
}

class _UpdateFactoryAppsProviderElement
    extends AutoDisposeFutureProviderElement<Factory>
    with UpdateFactoryAppsRef {
  _UpdateFactoryAppsProviderElement(super.provider);

  @override
  String get factoryId => (origin as UpdateFactoryAppsProvider).factoryId;
  @override
  List<FactoryApp> get apps => (origin as UpdateFactoryAppsProvider).apps;
  @override
  String get walletAddress =>
      (origin as UpdateFactoryAppsProvider).walletAddress;
}

String _$getFactoryBalanceHash() => r'74caa983518a37bf79c620f85ccc8fddbfc6197e';

/// See also [getFactoryBalance].
@ProviderFor(getFactoryBalance)
const getFactoryBalanceProvider = GetFactoryBalanceFamily();

/// See also [getFactoryBalance].
class GetFactoryBalanceFamily extends Family<AsyncValue<double>> {
  /// See also [getFactoryBalance].
  const GetFactoryBalanceFamily();

  /// See also [getFactoryBalance].
  GetFactoryBalanceProvider call({
    required String poolAddress,
  }) {
    return GetFactoryBalanceProvider(
      poolAddress: poolAddress,
    );
  }

  @override
  GetFactoryBalanceProvider getProviderOverride(
    covariant GetFactoryBalanceProvider provider,
  ) {
    return call(
      poolAddress: provider.poolAddress,
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
  String? get name => r'getFactoryBalanceProvider';
}

/// See also [getFactoryBalance].
class GetFactoryBalanceProvider extends AutoDisposeFutureProvider<double> {
  /// See also [getFactoryBalance].
  GetFactoryBalanceProvider({
    required String poolAddress,
  }) : this._internal(
          (ref) => getFactoryBalance(
            ref as GetFactoryBalanceRef,
            poolAddress: poolAddress,
          ),
          from: getFactoryBalanceProvider,
          name: r'getFactoryBalanceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getFactoryBalanceHash,
          dependencies: GetFactoryBalanceFamily._dependencies,
          allTransitiveDependencies:
              GetFactoryBalanceFamily._allTransitiveDependencies,
          poolAddress: poolAddress,
        );

  GetFactoryBalanceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.poolAddress,
  }) : super.internal();

  final String poolAddress;

  @override
  Override overrideWith(
    FutureOr<double> Function(GetFactoryBalanceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetFactoryBalanceProvider._internal(
        (ref) => create(ref as GetFactoryBalanceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        poolAddress: poolAddress,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<double> createElement() {
    return _GetFactoryBalanceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetFactoryBalanceProvider &&
        other.poolAddress == poolAddress;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, poolAddress.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetFactoryBalanceRef on AutoDisposeFutureProviderRef<double> {
  /// The parameter `poolAddress` of this provider.
  String get poolAddress;
}

class _GetFactoryBalanceProviderElement
    extends AutoDisposeFutureProviderElement<double> with GetFactoryBalanceRef {
  _GetFactoryBalanceProviderElement(super.provider);

  @override
  String get poolAddress => (origin as GetFactoryBalanceProvider).poolAddress;
}

String _$validateWithdrawalHash() =>
    r'3a4e4b75145bfc54b4a620d71f37265017602934';

/// See also [validateWithdrawal].
@ProviderFor(validateWithdrawal)
const validateWithdrawalProvider = ValidateWithdrawalFamily();

/// See also [validateWithdrawal].
class ValidateWithdrawalFamily
    extends Family<AsyncValue<WithdrawalValidation>> {
  /// See also [validateWithdrawal].
  const ValidateWithdrawalFamily();

  /// See also [validateWithdrawal].
  ValidateWithdrawalProvider call({
    required String poolAddress,
    required String amount,
  }) {
    return ValidateWithdrawalProvider(
      poolAddress: poolAddress,
      amount: amount,
    );
  }

  @override
  ValidateWithdrawalProvider getProviderOverride(
    covariant ValidateWithdrawalProvider provider,
  ) {
    return call(
      poolAddress: provider.poolAddress,
      amount: provider.amount,
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
  String? get name => r'validateWithdrawalProvider';
}

/// See also [validateWithdrawal].
class ValidateWithdrawalProvider
    extends AutoDisposeFutureProvider<WithdrawalValidation> {
  /// See also [validateWithdrawal].
  ValidateWithdrawalProvider({
    required String poolAddress,
    required String amount,
  }) : this._internal(
          (ref) => validateWithdrawal(
            ref as ValidateWithdrawalRef,
            poolAddress: poolAddress,
            amount: amount,
          ),
          from: validateWithdrawalProvider,
          name: r'validateWithdrawalProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$validateWithdrawalHash,
          dependencies: ValidateWithdrawalFamily._dependencies,
          allTransitiveDependencies:
              ValidateWithdrawalFamily._allTransitiveDependencies,
          poolAddress: poolAddress,
          amount: amount,
        );

  ValidateWithdrawalProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.poolAddress,
    required this.amount,
  }) : super.internal();

  final String poolAddress;
  final String amount;

  @override
  Override overrideWith(
    FutureOr<WithdrawalValidation> Function(ValidateWithdrawalRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ValidateWithdrawalProvider._internal(
        (ref) => create(ref as ValidateWithdrawalRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        poolAddress: poolAddress,
        amount: amount,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<WithdrawalValidation> createElement() {
    return _ValidateWithdrawalProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ValidateWithdrawalProvider &&
        other.poolAddress == poolAddress &&
        other.amount == amount;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, poolAddress.hashCode);
    hash = _SystemHash.combine(hash, amount.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ValidateWithdrawalRef
    on AutoDisposeFutureProviderRef<WithdrawalValidation> {
  /// The parameter `poolAddress` of this provider.
  String get poolAddress;

  /// The parameter `amount` of this provider.
  String get amount;
}

class _ValidateWithdrawalProviderElement
    extends AutoDisposeFutureProviderElement<WithdrawalValidation>
    with ValidateWithdrawalRef {
  _ValidateWithdrawalProviderElement(super.provider);

  @override
  String get poolAddress => (origin as ValidateWithdrawalProvider).poolAddress;
  @override
  String get amount => (origin as ValidateWithdrawalProvider).amount;
}

String _$getPoolHealthHash() => r'044dc39e950e015cc0796bff43fee6ffaa7543d3';

/// See also [getPoolHealth].
@ProviderFor(getPoolHealth)
const getPoolHealthProvider = GetPoolHealthFamily();

/// See also [getPoolHealth].
class GetPoolHealthFamily extends Family<AsyncValue<PoolHealth>> {
  /// See also [getPoolHealth].
  const GetPoolHealthFamily();

  /// See also [getPoolHealth].
  GetPoolHealthProvider call({
    required String poolAddress,
  }) {
    return GetPoolHealthProvider(
      poolAddress: poolAddress,
    );
  }

  @override
  GetPoolHealthProvider getProviderOverride(
    covariant GetPoolHealthProvider provider,
  ) {
    return call(
      poolAddress: provider.poolAddress,
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
  String? get name => r'getPoolHealthProvider';
}

/// See also [getPoolHealth].
class GetPoolHealthProvider extends AutoDisposeFutureProvider<PoolHealth> {
  /// See also [getPoolHealth].
  GetPoolHealthProvider({
    required String poolAddress,
  }) : this._internal(
          (ref) => getPoolHealth(
            ref as GetPoolHealthRef,
            poolAddress: poolAddress,
          ),
          from: getPoolHealthProvider,
          name: r'getPoolHealthProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getPoolHealthHash,
          dependencies: GetPoolHealthFamily._dependencies,
          allTransitiveDependencies:
              GetPoolHealthFamily._allTransitiveDependencies,
          poolAddress: poolAddress,
        );

  GetPoolHealthProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.poolAddress,
  }) : super.internal();

  final String poolAddress;

  @override
  Override overrideWith(
    FutureOr<PoolHealth> Function(GetPoolHealthRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetPoolHealthProvider._internal(
        (ref) => create(ref as GetPoolHealthRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        poolAddress: poolAddress,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<PoolHealth> createElement() {
    return _GetPoolHealthProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetPoolHealthProvider && other.poolAddress == poolAddress;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, poolAddress.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetPoolHealthRef on AutoDisposeFutureProviderRef<PoolHealth> {
  /// The parameter `poolAddress` of this provider.
  String get poolAddress;
}

class _GetPoolHealthProviderElement
    extends AutoDisposeFutureProviderElement<PoolHealth> with GetPoolHealthRef {
  _GetPoolHealthProviderElement(super.provider);

  @override
  String get poolAddress => (origin as GetPoolHealthProvider).poolAddress;
}

String _$getMaxWithdrawalHash() => r'f0910ca9edc47a2834cbb184f8d6a0064156aa5c';

/// See also [getMaxWithdrawal].
@ProviderFor(getMaxWithdrawal)
const getMaxWithdrawalProvider = GetMaxWithdrawalFamily();

/// See also [getMaxWithdrawal].
class GetMaxWithdrawalFamily extends Family<AsyncValue<MaxWithdrawal>> {
  /// See also [getMaxWithdrawal].
  const GetMaxWithdrawalFamily();

  /// See also [getMaxWithdrawal].
  GetMaxWithdrawalProvider call({
    required String poolAddress,
  }) {
    return GetMaxWithdrawalProvider(
      poolAddress: poolAddress,
    );
  }

  @override
  GetMaxWithdrawalProvider getProviderOverride(
    covariant GetMaxWithdrawalProvider provider,
  ) {
    return call(
      poolAddress: provider.poolAddress,
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
  String? get name => r'getMaxWithdrawalProvider';
}

/// See also [getMaxWithdrawal].
class GetMaxWithdrawalProvider
    extends AutoDisposeFutureProvider<MaxWithdrawal> {
  /// See also [getMaxWithdrawal].
  GetMaxWithdrawalProvider({
    required String poolAddress,
  }) : this._internal(
          (ref) => getMaxWithdrawal(
            ref as GetMaxWithdrawalRef,
            poolAddress: poolAddress,
          ),
          from: getMaxWithdrawalProvider,
          name: r'getMaxWithdrawalProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getMaxWithdrawalHash,
          dependencies: GetMaxWithdrawalFamily._dependencies,
          allTransitiveDependencies:
              GetMaxWithdrawalFamily._allTransitiveDependencies,
          poolAddress: poolAddress,
        );

  GetMaxWithdrawalProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.poolAddress,
  }) : super.internal();

  final String poolAddress;

  @override
  Override overrideWith(
    FutureOr<MaxWithdrawal> Function(GetMaxWithdrawalRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetMaxWithdrawalProvider._internal(
        (ref) => create(ref as GetMaxWithdrawalRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        poolAddress: poolAddress,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<MaxWithdrawal> createElement() {
    return _GetMaxWithdrawalProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetMaxWithdrawalProvider &&
        other.poolAddress == poolAddress;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, poolAddress.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetMaxWithdrawalRef on AutoDisposeFutureProviderRef<MaxWithdrawal> {
  /// The parameter `poolAddress` of this provider.
  String get poolAddress;
}

class _GetMaxWithdrawalProviderElement
    extends AutoDisposeFutureProviderElement<MaxWithdrawal>
    with GetMaxWithdrawalRef {
  _GetMaxWithdrawalProviderElement(super.provider);

  @override
  String get poolAddress => (origin as GetMaxWithdrawalProvider).poolAddress;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
