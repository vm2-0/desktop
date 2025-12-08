// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apps.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appsRepositoryHash() => r'00f96fe79c6deb88024ad39b8ea601003dcb8951';

/// See also [appsRepository].
@ProviderFor(appsRepository)
final appsRepositoryProvider = AutoDisposeProvider<AppsRepositoryImpl>.internal(
  appsRepository,
  name: r'appsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppsRepositoryRef = AutoDisposeProviderRef<AppsRepositoryImpl>;
String _$generateWorkflowsHash() => r'8cef92bf3d0fb60c3d90153990148d1b609d7e16';

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

/// See also [generateWorkflows].
@ProviderFor(generateWorkflows)
const generateWorkflowsProvider = GenerateWorkflowsFamily();

/// See also [generateWorkflows].
class GenerateWorkflowsFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [generateWorkflows].
  const GenerateWorkflowsFamily();

  /// See also [generateWorkflows].
  GenerateWorkflowsProvider call({
    required String prompt,
  }) {
    return GenerateWorkflowsProvider(
      prompt: prompt,
    );
  }

  @override
  GenerateWorkflowsProvider getProviderOverride(
    covariant GenerateWorkflowsProvider provider,
  ) {
    return call(
      prompt: provider.prompt,
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
  String? get name => r'generateWorkflowsProvider';
}

/// See also [generateWorkflows].
class GenerateWorkflowsProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// See also [generateWorkflows].
  GenerateWorkflowsProvider({
    required String prompt,
  }) : this._internal(
          (ref) => generateWorkflows(
            ref as GenerateWorkflowsRef,
            prompt: prompt,
          ),
          from: generateWorkflowsProvider,
          name: r'generateWorkflowsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$generateWorkflowsHash,
          dependencies: GenerateWorkflowsFamily._dependencies,
          allTransitiveDependencies:
              GenerateWorkflowsFamily._allTransitiveDependencies,
          prompt: prompt,
        );

  GenerateWorkflowsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.prompt,
  }) : super.internal();

  final String prompt;

  @override
  Override overrideWith(
    FutureOr<Map<String, dynamic>> Function(GenerateWorkflowsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GenerateWorkflowsProvider._internal(
        (ref) => create(ref as GenerateWorkflowsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        prompt: prompt,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _GenerateWorkflowsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GenerateWorkflowsProvider && other.prompt == prompt;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, prompt.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GenerateWorkflowsRef
    on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `prompt` of this provider.
  String get prompt;
}

class _GenerateWorkflowsProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with GenerateWorkflowsRef {
  _GenerateWorkflowsProviderElement(super.provider);

  @override
  String get prompt => (origin as GenerateWorkflowsProvider).prompt;
}

String _$getTasksForFactoryHash() =>
    r'3b62e59712ddbbbfa95b4bb5df3c7c2bbfcf2182';

/// See also [getTasksForFactory].
@ProviderFor(getTasksForFactory)
const getTasksForFactoryProvider = GetTasksForFactoryFamily();

/// See also [getTasksForFactory].
class GetTasksForFactoryFamily extends Family<AsyncValue<List<WorkflowTask>>> {
  /// See also [getTasksForFactory].
  const GetTasksForFactoryFamily();

  /// See also [getTasksForFactory].
  GetTasksForFactoryProvider call({
    required FactoryFilter filter,
  }) {
    return GetTasksForFactoryProvider(
      filter: filter,
    );
  }

  @override
  GetTasksForFactoryProvider getProviderOverride(
    covariant GetTasksForFactoryProvider provider,
  ) {
    return call(
      filter: provider.filter,
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
  String? get name => r'getTasksForFactoryProvider';
}

/// See also [getTasksForFactory].
class GetTasksForFactoryProvider
    extends AutoDisposeFutureProvider<List<WorkflowTask>> {
  /// See also [getTasksForFactory].
  GetTasksForFactoryProvider({
    required FactoryFilter filter,
  }) : this._internal(
          (ref) => getTasksForFactory(
            ref as GetTasksForFactoryRef,
            filter: filter,
          ),
          from: getTasksForFactoryProvider,
          name: r'getTasksForFactoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getTasksForFactoryHash,
          dependencies: GetTasksForFactoryFamily._dependencies,
          allTransitiveDependencies:
              GetTasksForFactoryFamily._allTransitiveDependencies,
          filter: filter,
        );

  GetTasksForFactoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.filter,
  }) : super.internal();

  final FactoryFilter filter;

  @override
  Override overrideWith(
    FutureOr<List<WorkflowTask>> Function(GetTasksForFactoryRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetTasksForFactoryProvider._internal(
        (ref) => create(ref as GetTasksForFactoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        filter: filter,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<WorkflowTask>> createElement() {
    return _GetTasksForFactoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetTasksForFactoryProvider && other.filter == filter;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, filter.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetTasksForFactoryRef
    on AutoDisposeFutureProviderRef<List<WorkflowTask>> {
  /// The parameter `filter` of this provider.
  FactoryFilter get filter;
}

class _GetTasksForFactoryProviderElement
    extends AutoDisposeFutureProviderElement<List<WorkflowTask>>
    with GetTasksForFactoryRef {
  _GetTasksForFactoryProviderElement(super.provider);

  @override
  FactoryFilter get filter => (origin as GetTasksForFactoryProvider).filter;
}

String _$getFactoryCategoriesHash() =>
    r'db400870d957e66004e026b8b66c2ed573bf2382';

/// See also [getFactoryCategories].
@ProviderFor(getFactoryCategories)
final getFactoryCategoriesProvider =
    AutoDisposeFutureProvider<List<String>>.internal(
  getFactoryCategories,
  name: r'getFactoryCategoriesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getFactoryCategoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetFactoryCategoriesRef = AutoDisposeFutureProviderRef<List<String>>;
String _$getAppAlternativesHash() =>
    r'6a11e8438fca40e9de089b423ef1a1f25fb8f85c';

/// See also [getAppAlternatives].
@ProviderFor(getAppAlternatives)
const getAppAlternativesProvider = GetAppAlternativesFamily();

/// See also [getAppAlternatives].
class GetAppAlternativesFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// See also [getAppAlternatives].
  const GetAppAlternativesFamily();

  /// See also [getAppAlternatives].
  GetAppAlternativesProvider call({
    required String identifier,
    List<String>? categories,
  }) {
    return GetAppAlternativesProvider(
      identifier: identifier,
      categories: categories,
    );
  }

  @override
  GetAppAlternativesProvider getProviderOverride(
    covariant GetAppAlternativesProvider provider,
  ) {
    return call(
      identifier: provider.identifier,
      categories: provider.categories,
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
  String? get name => r'getAppAlternativesProvider';
}

/// See also [getAppAlternatives].
class GetAppAlternativesProvider
    extends AutoDisposeFutureProvider<List<Map<String, dynamic>>> {
  /// See also [getAppAlternatives].
  GetAppAlternativesProvider({
    required String identifier,
    List<String>? categories,
  }) : this._internal(
          (ref) => getAppAlternatives(
            ref as GetAppAlternativesRef,
            identifier: identifier,
            categories: categories,
          ),
          from: getAppAlternativesProvider,
          name: r'getAppAlternativesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getAppAlternativesHash,
          dependencies: GetAppAlternativesFamily._dependencies,
          allTransitiveDependencies:
              GetAppAlternativesFamily._allTransitiveDependencies,
          identifier: identifier,
          categories: categories,
        );

  GetAppAlternativesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.identifier,
    required this.categories,
  }) : super.internal();

  final String identifier;
  final List<String>? categories;

  @override
  Override overrideWith(
    FutureOr<List<Map<String, dynamic>>> Function(
            GetAppAlternativesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetAppAlternativesProvider._internal(
        (ref) => create(ref as GetAppAlternativesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        identifier: identifier,
        categories: categories,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Map<String, dynamic>>> createElement() {
    return _GetAppAlternativesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetAppAlternativesProvider &&
        other.identifier == identifier &&
        other.categories == categories;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, identifier.hashCode);
    hash = _SystemHash.combine(hash, categories.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetAppAlternativesRef
    on AutoDisposeFutureProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `identifier` of this provider.
  String get identifier;

  /// The parameter `categories` of this provider.
  List<String>? get categories;
}

class _GetAppAlternativesProviderElement
    extends AutoDisposeFutureProviderElement<List<Map<String, dynamic>>>
    with GetAppAlternativesRef {
  _GetAppAlternativesProviderElement(super.provider);

  @override
  String get identifier => (origin as GetAppAlternativesProvider).identifier;
  @override
  List<String>? get categories =>
      (origin as GetAppAlternativesProvider).categories;
}

String _$incrementAppUsageHash() => r'aa9c82eea27e564af163c2e0a7f5eaa6fad167e2';

/// See also [incrementAppUsage].
@ProviderFor(incrementAppUsage)
const incrementAppUsageProvider = IncrementAppUsageFamily();

/// See also [incrementAppUsage].
class IncrementAppUsageFamily extends Family<AsyncValue<void>> {
  /// See also [incrementAppUsage].
  const IncrementAppUsageFamily();

  /// See also [incrementAppUsage].
  IncrementAppUsageProvider call({
    required String identifier,
  }) {
    return IncrementAppUsageProvider(
      identifier: identifier,
    );
  }

  @override
  IncrementAppUsageProvider getProviderOverride(
    covariant IncrementAppUsageProvider provider,
  ) {
    return call(
      identifier: provider.identifier,
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
  String? get name => r'incrementAppUsageProvider';
}

/// See also [incrementAppUsage].
class IncrementAppUsageProvider extends AutoDisposeFutureProvider<void> {
  /// See also [incrementAppUsage].
  IncrementAppUsageProvider({
    required String identifier,
  }) : this._internal(
          (ref) => incrementAppUsage(
            ref as IncrementAppUsageRef,
            identifier: identifier,
          ),
          from: incrementAppUsageProvider,
          name: r'incrementAppUsageProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$incrementAppUsageHash,
          dependencies: IncrementAppUsageFamily._dependencies,
          allTransitiveDependencies:
              IncrementAppUsageFamily._allTransitiveDependencies,
          identifier: identifier,
        );

  IncrementAppUsageProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.identifier,
  }) : super.internal();

  final String identifier;

  @override
  Override overrideWith(
    FutureOr<void> Function(IncrementAppUsageRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IncrementAppUsageProvider._internal(
        (ref) => create(ref as IncrementAppUsageRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        identifier: identifier,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _IncrementAppUsageProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IncrementAppUsageProvider && other.identifier == identifier;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, identifier.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin IncrementAppUsageRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `identifier` of this provider.
  String get identifier;
}

class _IncrementAppUsageProviderElement
    extends AutoDisposeFutureProviderElement<void> with IncrementAppUsageRef {
  _IncrementAppUsageProviderElement(super.provider);

  @override
  String get identifier => (origin as IncrementAppUsageProvider).identifier;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
