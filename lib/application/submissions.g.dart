// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submissions.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$submissionsRepositoryHash() =>
    r'63e139706c455b9e25126b5f0547025cb549e4c6';

/// See also [submissionsRepository].
@ProviderFor(submissionsRepository)
final submissionsRepositoryProvider =
    AutoDisposeProvider<SubmissionsRepositoryImpl>.internal(
  submissionsRepository,
  name: r'submissionsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$submissionsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SubmissionsRepositoryRef
    = AutoDisposeProviderRef<SubmissionsRepositoryImpl>;
String _$getSubmissionStatusHash() =>
    r'0705c8519154d78e062b33f9ad404cc98368410e';

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

/// See also [getSubmissionStatus].
@ProviderFor(getSubmissionStatus)
const getSubmissionStatusProvider = GetSubmissionStatusFamily();

/// See also [getSubmissionStatus].
class GetSubmissionStatusFamily extends Family<AsyncValue<SubmissionStatus>> {
  /// See also [getSubmissionStatus].
  const GetSubmissionStatusFamily();

  /// See also [getSubmissionStatus].
  GetSubmissionStatusProvider call({
    required String submissionId,
  }) {
    return GetSubmissionStatusProvider(
      submissionId: submissionId,
    );
  }

  @override
  GetSubmissionStatusProvider getProviderOverride(
    covariant GetSubmissionStatusProvider provider,
  ) {
    return call(
      submissionId: provider.submissionId,
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
  String? get name => r'getSubmissionStatusProvider';
}

/// See also [getSubmissionStatus].
class GetSubmissionStatusProvider
    extends AutoDisposeFutureProvider<SubmissionStatus> {
  /// See also [getSubmissionStatus].
  GetSubmissionStatusProvider({
    required String submissionId,
  }) : this._internal(
          (ref) => getSubmissionStatus(
            ref as GetSubmissionStatusRef,
            submissionId: submissionId,
          ),
          from: getSubmissionStatusProvider,
          name: r'getSubmissionStatusProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getSubmissionStatusHash,
          dependencies: GetSubmissionStatusFamily._dependencies,
          allTransitiveDependencies:
              GetSubmissionStatusFamily._allTransitiveDependencies,
          submissionId: submissionId,
        );

  GetSubmissionStatusProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.submissionId,
  }) : super.internal();

  final String submissionId;

  @override
  Override overrideWith(
    FutureOr<SubmissionStatus> Function(GetSubmissionStatusRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetSubmissionStatusProvider._internal(
        (ref) => create(ref as GetSubmissionStatusRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        submissionId: submissionId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<SubmissionStatus> createElement() {
    return _GetSubmissionStatusProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetSubmissionStatusProvider &&
        other.submissionId == submissionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, submissionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetSubmissionStatusRef on AutoDisposeFutureProviderRef<SubmissionStatus> {
  /// The parameter `submissionId` of this provider.
  String get submissionId;
}

class _GetSubmissionStatusProviderElement
    extends AutoDisposeFutureProviderElement<SubmissionStatus>
    with GetSubmissionStatusRef {
  _GetSubmissionStatusProviderElement(super.provider);

  @override
  String get submissionId =>
      (origin as GetSubmissionStatusProvider).submissionId;
}

String _$listSubmissionsHash() => r'd884130a18e30dc678dad3739d1f35e571e32ba6';

/// See also [listSubmissions].
@ProviderFor(listSubmissions)
final listSubmissionsProvider =
    AutoDisposeFutureProvider<List<SubmissionStatus>>.internal(
  listSubmissions,
  name: r'listSubmissionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$listSubmissionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ListSubmissionsRef
    = AutoDisposeFutureProviderRef<List<SubmissionStatus>>;
String _$getFactorySubmissionsHash() =>
    r'4954c1585987a41d363565f29e53d94d62ed06ec';

/// See also [getFactorySubmissions].
@ProviderFor(getFactorySubmissions)
const getFactorySubmissionsProvider = GetFactorySubmissionsFamily();

/// See also [getFactorySubmissions].
class GetFactorySubmissionsFamily
    extends Family<AsyncValue<List<PoolSubmission>>> {
  /// See also [getFactorySubmissions].
  const GetFactorySubmissionsFamily();

  /// See also [getFactorySubmissions].
  GetFactorySubmissionsProvider call(
    String factoryAddress,
  ) {
    return GetFactorySubmissionsProvider(
      factoryAddress,
    );
  }

  @override
  GetFactorySubmissionsProvider getProviderOverride(
    covariant GetFactorySubmissionsProvider provider,
  ) {
    return call(
      provider.factoryAddress,
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
  String? get name => r'getFactorySubmissionsProvider';
}

/// See also [getFactorySubmissions].
class GetFactorySubmissionsProvider
    extends AutoDisposeFutureProvider<List<PoolSubmission>> {
  /// See also [getFactorySubmissions].
  GetFactorySubmissionsProvider(
    String factoryAddress,
  ) : this._internal(
          (ref) => getFactorySubmissions(
            ref as GetFactorySubmissionsRef,
            factoryAddress,
          ),
          from: getFactorySubmissionsProvider,
          name: r'getFactorySubmissionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getFactorySubmissionsHash,
          dependencies: GetFactorySubmissionsFamily._dependencies,
          allTransitiveDependencies:
              GetFactorySubmissionsFamily._allTransitiveDependencies,
          factoryAddress: factoryAddress,
        );

  GetFactorySubmissionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.factoryAddress,
  }) : super.internal();

  final String factoryAddress;

  @override
  Override overrideWith(
    FutureOr<List<PoolSubmission>> Function(GetFactorySubmissionsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetFactorySubmissionsProvider._internal(
        (ref) => create(ref as GetFactorySubmissionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        factoryAddress: factoryAddress,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<PoolSubmission>> createElement() {
    return _GetFactorySubmissionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetFactorySubmissionsProvider &&
        other.factoryAddress == factoryAddress;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, factoryAddress.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetFactorySubmissionsRef
    on AutoDisposeFutureProviderRef<List<PoolSubmission>> {
  /// The parameter `factoryAddress` of this provider.
  String get factoryAddress;
}

class _GetFactorySubmissionsProviderElement
    extends AutoDisposeFutureProviderElement<List<PoolSubmission>>
    with GetFactorySubmissionsRef {
  _GetFactorySubmissionsProviderElement(super.provider);

  @override
  String get factoryAddress =>
      (origin as GetFactorySubmissionsProvider).factoryAddress;
}

String _$getDemoFileHash() => r'0cd04f8b3ad0788bc5a55eb9a91f8a6dc99a4fe1';

/// See also [getDemoFile].
@ProviderFor(getDemoFile)
const getDemoFileProvider = GetDemoFileFamily();

/// See also [getDemoFile].
class GetDemoFileFamily extends Family<AsyncValue<String>> {
  /// See also [getDemoFile].
  const GetDemoFileFamily();

  /// See also [getDemoFile].
  GetDemoFileProvider call({
    required String submissionId,
    required String filename,
  }) {
    return GetDemoFileProvider(
      submissionId: submissionId,
      filename: filename,
    );
  }

  @override
  GetDemoFileProvider getProviderOverride(
    covariant GetDemoFileProvider provider,
  ) {
    return call(
      submissionId: provider.submissionId,
      filename: provider.filename,
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
  String? get name => r'getDemoFileProvider';
}

/// See also [getDemoFile].
class GetDemoFileProvider extends AutoDisposeFutureProvider<String> {
  /// See also [getDemoFile].
  GetDemoFileProvider({
    required String submissionId,
    required String filename,
  }) : this._internal(
          (ref) => getDemoFile(
            ref as GetDemoFileRef,
            submissionId: submissionId,
            filename: filename,
          ),
          from: getDemoFileProvider,
          name: r'getDemoFileProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getDemoFileHash,
          dependencies: GetDemoFileFamily._dependencies,
          allTransitiveDependencies:
              GetDemoFileFamily._allTransitiveDependencies,
          submissionId: submissionId,
          filename: filename,
        );

  GetDemoFileProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.submissionId,
    required this.filename,
  }) : super.internal();

  final String submissionId;
  final String filename;

  @override
  Override overrideWith(
    FutureOr<String> Function(GetDemoFileRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetDemoFileProvider._internal(
        (ref) => create(ref as GetDemoFileRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        submissionId: submissionId,
        filename: filename,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String> createElement() {
    return _GetDemoFileProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetDemoFileProvider &&
        other.submissionId == submissionId &&
        other.filename == filename;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, submissionId.hashCode);
    hash = _SystemHash.combine(hash, filename.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetDemoFileRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `submissionId` of this provider.
  String get submissionId;

  /// The parameter `filename` of this provider.
  String get filename;
}

class _GetDemoFileProviderElement
    extends AutoDisposeFutureProviderElement<String> with GetDemoFileRef {
  _GetDemoFileProviderElement(super.provider);

  @override
  String get submissionId => (origin as GetDemoFileProvider).submissionId;
  @override
  String get filename => (origin as GetDemoFileProvider).filename;
}

String _$getDemoFileAsBase64Hash() =>
    r'0ff3ab11f4e6e315d5058b1d33ad1976dcf6fb76';

/// See also [getDemoFileAsBase64].
@ProviderFor(getDemoFileAsBase64)
const getDemoFileAsBase64Provider = GetDemoFileAsBase64Family();

/// See also [getDemoFileAsBase64].
class GetDemoFileAsBase64Family extends Family<AsyncValue<String>> {
  /// See also [getDemoFileAsBase64].
  const GetDemoFileAsBase64Family();

  /// See also [getDemoFileAsBase64].
  GetDemoFileAsBase64Provider call({
    required String submissionId,
    required String filename,
  }) {
    return GetDemoFileAsBase64Provider(
      submissionId: submissionId,
      filename: filename,
    );
  }

  @override
  GetDemoFileAsBase64Provider getProviderOverride(
    covariant GetDemoFileAsBase64Provider provider,
  ) {
    return call(
      submissionId: provider.submissionId,
      filename: provider.filename,
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
  String? get name => r'getDemoFileAsBase64Provider';
}

/// See also [getDemoFileAsBase64].
class GetDemoFileAsBase64Provider extends AutoDisposeFutureProvider<String> {
  /// See also [getDemoFileAsBase64].
  GetDemoFileAsBase64Provider({
    required String submissionId,
    required String filename,
  }) : this._internal(
          (ref) => getDemoFileAsBase64(
            ref as GetDemoFileAsBase64Ref,
            submissionId: submissionId,
            filename: filename,
          ),
          from: getDemoFileAsBase64Provider,
          name: r'getDemoFileAsBase64Provider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getDemoFileAsBase64Hash,
          dependencies: GetDemoFileAsBase64Family._dependencies,
          allTransitiveDependencies:
              GetDemoFileAsBase64Family._allTransitiveDependencies,
          submissionId: submissionId,
          filename: filename,
        );

  GetDemoFileAsBase64Provider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.submissionId,
    required this.filename,
  }) : super.internal();

  final String submissionId;
  final String filename;

  @override
  Override overrideWith(
    FutureOr<String> Function(GetDemoFileAsBase64Ref provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetDemoFileAsBase64Provider._internal(
        (ref) => create(ref as GetDemoFileAsBase64Ref),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        submissionId: submissionId,
        filename: filename,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String> createElement() {
    return _GetDemoFileAsBase64ProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetDemoFileAsBase64Provider &&
        other.submissionId == submissionId &&
        other.filename == filename;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, submissionId.hashCode);
    hash = _SystemHash.combine(hash, filename.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetDemoFileAsBase64Ref on AutoDisposeFutureProviderRef<String> {
  /// The parameter `submissionId` of this provider.
  String get submissionId;

  /// The parameter `filename` of this provider.
  String get filename;
}

class _GetDemoFileAsBase64ProviderElement
    extends AutoDisposeFutureProviderElement<String>
    with GetDemoFileAsBase64Ref {
  _GetDemoFileAsBase64ProviderElement(super.provider);

  @override
  String get submissionId =>
      (origin as GetDemoFileAsBase64Provider).submissionId;
  @override
  String get filename => (origin as GetDemoFileAsBase64Provider).filename;
}

String _$paginatedSubmissionsNotifierHash() =>
    r'529e54a8931d06e20f397293fa74437d03c7f15a';

/// See also [PaginatedSubmissionsNotifier].
@ProviderFor(PaginatedSubmissionsNotifier)
final paginatedSubmissionsNotifierProvider = AutoDisposeAsyncNotifierProvider<
    PaginatedSubmissionsNotifier, List<SubmissionStatus>>.internal(
  PaginatedSubmissionsNotifier.new,
  name: r'paginatedSubmissionsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$paginatedSubmissionsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PaginatedSubmissionsNotifier
    = AutoDisposeAsyncNotifier<List<SubmissionStatus>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
