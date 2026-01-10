// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datasets.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$datasetRepositoryHash() => r'701ce9e54aca472550ce39cf7e82bf59cc83a098';

/// Provider for dataset repository instance
///
/// Copied from [datasetRepository].
@ProviderFor(datasetRepository)
final datasetRepositoryProvider =
    AutoDisposeProvider<DatasetRepository>.internal(
  datasetRepository,
  name: r'datasetRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$datasetRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DatasetRepositoryRef = AutoDisposeProviderRef<DatasetRepository>;
String _$getFactoryDatasetsHash() =>
    r'dbb78bf138c7705406df2e072fea00453116b8ae';

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

/// Provider to fetch datasets for a specific factory
///
/// Copied from [getFactoryDatasets].
@ProviderFor(getFactoryDatasets)
const getFactoryDatasetsProvider = GetFactoryDatasetsFamily();

/// Provider to fetch datasets for a specific factory
///
/// Copied from [getFactoryDatasets].
class GetFactoryDatasetsFamily extends Family<AsyncValue<List<Dataset>>> {
  /// Provider to fetch datasets for a specific factory
  ///
  /// Copied from [getFactoryDatasets].
  const GetFactoryDatasetsFamily();

  /// Provider to fetch datasets for a specific factory
  ///
  /// Copied from [getFactoryDatasets].
  GetFactoryDatasetsProvider call(
    String factoryId,
  ) {
    return GetFactoryDatasetsProvider(
      factoryId,
    );
  }

  @override
  GetFactoryDatasetsProvider getProviderOverride(
    covariant GetFactoryDatasetsProvider provider,
  ) {
    return call(
      provider.factoryId,
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
  String? get name => r'getFactoryDatasetsProvider';
}

/// Provider to fetch datasets for a specific factory
///
/// Copied from [getFactoryDatasets].
class GetFactoryDatasetsProvider
    extends AutoDisposeFutureProvider<List<Dataset>> {
  /// Provider to fetch datasets for a specific factory
  ///
  /// Copied from [getFactoryDatasets].
  GetFactoryDatasetsProvider(
    String factoryId,
  ) : this._internal(
          (ref) => getFactoryDatasets(
            ref as GetFactoryDatasetsRef,
            factoryId,
          ),
          from: getFactoryDatasetsProvider,
          name: r'getFactoryDatasetsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getFactoryDatasetsHash,
          dependencies: GetFactoryDatasetsFamily._dependencies,
          allTransitiveDependencies:
              GetFactoryDatasetsFamily._allTransitiveDependencies,
          factoryId: factoryId,
        );

  GetFactoryDatasetsProvider._internal(
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
    FutureOr<List<Dataset>> Function(GetFactoryDatasetsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetFactoryDatasetsProvider._internal(
        (ref) => create(ref as GetFactoryDatasetsRef),
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
  AutoDisposeFutureProviderElement<List<Dataset>> createElement() {
    return _GetFactoryDatasetsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetFactoryDatasetsProvider && other.factoryId == factoryId;
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
mixin GetFactoryDatasetsRef on AutoDisposeFutureProviderRef<List<Dataset>> {
  /// The parameter `factoryId` of this provider.
  String get factoryId;
}

class _GetFactoryDatasetsProviderElement
    extends AutoDisposeFutureProviderElement<List<Dataset>>
    with GetFactoryDatasetsRef {
  _GetFactoryDatasetsProviderElement(super.provider);

  @override
  String get factoryId => (origin as GetFactoryDatasetsProvider).factoryId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
