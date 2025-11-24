// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tasksRepositoryHash() => r'70733151ce44023c41ce7f639ced118959f3d8df';

/// See also [tasksRepository].
@ProviderFor(tasksRepository)
final tasksRepositoryProvider =
    AutoDisposeProvider<TasksRepositoryImpl>.internal(
  tasksRepository,
  name: r'tasksRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tasksRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TasksRepositoryRef = AutoDisposeProviderRef<TasksRepositoryImpl>;
String _$getTasksForFactoryHash() =>
    r'878899ab643ed3b5713d886fa46253d4f9621f4e';

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

/// See also [getTasksForFactory].
@ProviderFor(getTasksForFactory)
const getTasksForFactoryProvider = GetTasksForFactoryFamily();

/// See also [getTasksForFactory].
class GetTasksForFactoryFamily extends Family<AsyncValue<List<WorkflowTask>>> {
  /// See also [getTasksForFactory].
  const GetTasksForFactoryFamily();

  /// See also [getTasksForFactory].
  GetTasksForFactoryProvider call({
    Map<String, dynamic>? filter,
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
    Map<String, dynamic>? filter,
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

  final Map<String, dynamic>? filter;

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
  Map<String, dynamic>? get filter;
}

class _GetTasksForFactoryProviderElement
    extends AutoDisposeFutureProviderElement<List<WorkflowTask>>
    with GetTasksForFactoryRef {
  _GetTasksForFactoryProviderElement(super.provider);

  @override
  Map<String, dynamic>? get filter =>
      (origin as GetTasksForFactoryProvider).filter;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
