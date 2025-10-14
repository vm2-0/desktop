// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'referral.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$referralRepositoryHash() =>
    r'27f8f29f6bfe8a3e5835ab232311c721ad29f4d1';

/// See also [referralRepository].
@ProviderFor(referralRepository)
final referralRepositoryProvider =
    AutoDisposeProvider<ReferralRepository>.internal(
  referralRepository,
  name: r'referralRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$referralRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReferralRepositoryRef = AutoDisposeProviderRef<ReferralRepository>;
String _$getReferralInfoHash() => r'40143f689b19395e6e4d20cd6cfbf21af6f00932';

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

/// See also [getReferralInfo].
@ProviderFor(getReferralInfo)
const getReferralInfoProvider = GetReferralInfoFamily();

/// See also [getReferralInfo].
class GetReferralInfoFamily extends Family<AsyncValue<ReferralInfo?>> {
  /// See also [getReferralInfo].
  const GetReferralInfoFamily();

  /// See also [getReferralInfo].
  GetReferralInfoProvider call(
    String walletAddress,
  ) {
    return GetReferralInfoProvider(
      walletAddress,
    );
  }

  @override
  GetReferralInfoProvider getProviderOverride(
    covariant GetReferralInfoProvider provider,
  ) {
    return call(
      provider.walletAddress,
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
  String? get name => r'getReferralInfoProvider';
}

/// See also [getReferralInfo].
class GetReferralInfoProvider extends AutoDisposeFutureProvider<ReferralInfo?> {
  /// See also [getReferralInfo].
  GetReferralInfoProvider(
    String walletAddress,
  ) : this._internal(
          (ref) => getReferralInfo(
            ref as GetReferralInfoRef,
            walletAddress,
          ),
          from: getReferralInfoProvider,
          name: r'getReferralInfoProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getReferralInfoHash,
          dependencies: GetReferralInfoFamily._dependencies,
          allTransitiveDependencies:
              GetReferralInfoFamily._allTransitiveDependencies,
          walletAddress: walletAddress,
        );

  GetReferralInfoProvider._internal(
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
    FutureOr<ReferralInfo?> Function(GetReferralInfoRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetReferralInfoProvider._internal(
        (ref) => create(ref as GetReferralInfoRef),
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
  AutoDisposeFutureProviderElement<ReferralInfo?> createElement() {
    return _GetReferralInfoProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetReferralInfoProvider &&
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
mixin GetReferralInfoRef on AutoDisposeFutureProviderRef<ReferralInfo?> {
  /// The parameter `walletAddress` of this provider.
  String get walletAddress;
}

class _GetReferralInfoProviderElement
    extends AutoDisposeFutureProviderElement<ReferralInfo?>
    with GetReferralInfoRef {
  _GetReferralInfoProviderElement(super.provider);

  @override
  String get walletAddress => (origin as GetReferralInfoProvider).walletAddress;
}

String _$getReferrerInfoHash() => r'30bc7cb6cc94b0d421bbf21982c4f232641c1837';

/// See also [getReferrerInfo].
@ProviderFor(getReferrerInfo)
const getReferrerInfoProvider = GetReferrerInfoFamily();

/// See also [getReferrerInfo].
class GetReferrerInfoFamily extends Family<
    AsyncValue<({String? referrerAddress, String? referrerCode})>> {
  /// See also [getReferrerInfo].
  const GetReferrerInfoFamily();

  /// See also [getReferrerInfo].
  GetReferrerInfoProvider call(
    String walletAddress,
  ) {
    return GetReferrerInfoProvider(
      walletAddress,
    );
  }

  @override
  GetReferrerInfoProvider getProviderOverride(
    covariant GetReferrerInfoProvider provider,
  ) {
    return call(
      provider.walletAddress,
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
  String? get name => r'getReferrerInfoProvider';
}

/// See also [getReferrerInfo].
class GetReferrerInfoProvider extends AutoDisposeFutureProvider<
    ({String? referrerAddress, String? referrerCode})> {
  /// See also [getReferrerInfo].
  GetReferrerInfoProvider(
    String walletAddress,
  ) : this._internal(
          (ref) => getReferrerInfo(
            ref as GetReferrerInfoRef,
            walletAddress,
          ),
          from: getReferrerInfoProvider,
          name: r'getReferrerInfoProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getReferrerInfoHash,
          dependencies: GetReferrerInfoFamily._dependencies,
          allTransitiveDependencies:
              GetReferrerInfoFamily._allTransitiveDependencies,
          walletAddress: walletAddress,
        );

  GetReferrerInfoProvider._internal(
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
    FutureOr<({String? referrerAddress, String? referrerCode})> Function(
            GetReferrerInfoRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetReferrerInfoProvider._internal(
        (ref) => create(ref as GetReferrerInfoRef),
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
  AutoDisposeFutureProviderElement<
      ({String? referrerAddress, String? referrerCode})> createElement() {
    return _GetReferrerInfoProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetReferrerInfoProvider &&
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
mixin GetReferrerInfoRef on AutoDisposeFutureProviderRef<
    ({String? referrerAddress, String? referrerCode})> {
  /// The parameter `walletAddress` of this provider.
  String get walletAddress;
}

class _GetReferrerInfoProviderElement extends AutoDisposeFutureProviderElement<
    ({String? referrerAddress, String? referrerCode})> with GetReferrerInfoRef {
  _GetReferrerInfoProviderElement(super.provider);

  @override
  String get walletAddress => (origin as GetReferrerInfoProvider).walletAddress;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
