// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recording.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$listRecordingsHash() => r'd148b94a250b6d6c7f36d2ec67a67e17cb495af6';

/// See also [listRecordings].
@ProviderFor(listRecordings)
final listRecordingsProvider =
    AutoDisposeFutureProvider<List<rec_meta.RecordingMeta>>.internal(
  listRecordings,
  name: r'listRecordingsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$listRecordingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ListRecordingsRef
    = AutoDisposeFutureProviderRef<List<rec_meta.RecordingMeta>>;
String _$writeRecordingFileHash() =>
    r'1b3d08229ab9afb894658f36cc0994515c4184e9';

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

/// See also [writeRecordingFile].
@ProviderFor(writeRecordingFile)
const writeRecordingFileProvider = WriteRecordingFileFamily();

/// See also [writeRecordingFile].
class WriteRecordingFileFamily extends Family<AsyncValue<void>> {
  /// See also [writeRecordingFile].
  const WriteRecordingFileFamily();

  /// See also [writeRecordingFile].
  WriteRecordingFileProvider call({
    required String recordingId,
    required String filename,
    required String content,
  }) {
    return WriteRecordingFileProvider(
      recordingId: recordingId,
      filename: filename,
      content: content,
    );
  }

  @override
  WriteRecordingFileProvider getProviderOverride(
    covariant WriteRecordingFileProvider provider,
  ) {
    return call(
      recordingId: provider.recordingId,
      filename: provider.filename,
      content: provider.content,
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
  String? get name => r'writeRecordingFileProvider';
}

/// See also [writeRecordingFile].
class WriteRecordingFileProvider extends AutoDisposeFutureProvider<void> {
  /// See also [writeRecordingFile].
  WriteRecordingFileProvider({
    required String recordingId,
    required String filename,
    required String content,
  }) : this._internal(
          (ref) => writeRecordingFile(
            ref as WriteRecordingFileRef,
            recordingId: recordingId,
            filename: filename,
            content: content,
          ),
          from: writeRecordingFileProvider,
          name: r'writeRecordingFileProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$writeRecordingFileHash,
          dependencies: WriteRecordingFileFamily._dependencies,
          allTransitiveDependencies:
              WriteRecordingFileFamily._allTransitiveDependencies,
          recordingId: recordingId,
          filename: filename,
          content: content,
        );

  WriteRecordingFileProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.recordingId,
    required this.filename,
    required this.content,
  }) : super.internal();

  final String recordingId;
  final String filename;
  final String content;

  @override
  Override overrideWith(
    FutureOr<void> Function(WriteRecordingFileRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WriteRecordingFileProvider._internal(
        (ref) => create(ref as WriteRecordingFileRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        recordingId: recordingId,
        filename: filename,
        content: content,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _WriteRecordingFileProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WriteRecordingFileProvider &&
        other.recordingId == recordingId &&
        other.filename == filename &&
        other.content == content;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, recordingId.hashCode);
    hash = _SystemHash.combine(hash, filename.hashCode);
    hash = _SystemHash.combine(hash, content.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WriteRecordingFileRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `recordingId` of this provider.
  String get recordingId;

  /// The parameter `filename` of this provider.
  String get filename;

  /// The parameter `content` of this provider.
  String get content;
}

class _WriteRecordingFileProviderElement
    extends AutoDisposeFutureProviderElement<void> with WriteRecordingFileRef {
  _WriteRecordingFileProviderElement(super.provider);

  @override
  String get recordingId => (origin as WriteRecordingFileProvider).recordingId;
  @override
  String get filename => (origin as WriteRecordingFileProvider).filename;
  @override
  String get content => (origin as WriteRecordingFileProvider).content;
}

String _$getRecordingFileHash() => r'8df5b233fa1f35a5c038c7ebc0553e06d399edae';

/// See also [getRecordingFile].
@ProviderFor(getRecordingFile)
const getRecordingFileProvider = GetRecordingFileFamily();

/// See also [getRecordingFile].
class GetRecordingFileFamily extends Family<AsyncValue<String>> {
  /// See also [getRecordingFile].
  const GetRecordingFileFamily();

  /// See also [getRecordingFile].
  GetRecordingFileProvider call({
    required String recordingId,
    required String filename,
  }) {
    return GetRecordingFileProvider(
      recordingId: recordingId,
      filename: filename,
    );
  }

  @override
  GetRecordingFileProvider getProviderOverride(
    covariant GetRecordingFileProvider provider,
  ) {
    return call(
      recordingId: provider.recordingId,
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
  String? get name => r'getRecordingFileProvider';
}

/// See also [getRecordingFile].
class GetRecordingFileProvider extends AutoDisposeFutureProvider<String> {
  /// See also [getRecordingFile].
  GetRecordingFileProvider({
    required String recordingId,
    required String filename,
  }) : this._internal(
          (ref) => getRecordingFile(
            ref as GetRecordingFileRef,
            recordingId: recordingId,
            filename: filename,
          ),
          from: getRecordingFileProvider,
          name: r'getRecordingFileProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getRecordingFileHash,
          dependencies: GetRecordingFileFamily._dependencies,
          allTransitiveDependencies:
              GetRecordingFileFamily._allTransitiveDependencies,
          recordingId: recordingId,
          filename: filename,
        );

  GetRecordingFileProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.recordingId,
    required this.filename,
  }) : super.internal();

  final String recordingId;
  final String filename;

  @override
  Override overrideWith(
    FutureOr<String> Function(GetRecordingFileRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetRecordingFileProvider._internal(
        (ref) => create(ref as GetRecordingFileRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        recordingId: recordingId,
        filename: filename,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String> createElement() {
    return _GetRecordingFileProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetRecordingFileProvider &&
        other.recordingId == recordingId &&
        other.filename == filename;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, recordingId.hashCode);
    hash = _SystemHash.combine(hash, filename.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetRecordingFileRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `recordingId` of this provider.
  String get recordingId;

  /// The parameter `filename` of this provider.
  String get filename;
}

class _GetRecordingFileProviderElement
    extends AutoDisposeFutureProviderElement<String> with GetRecordingFileRef {
  _GetRecordingFileProviderElement(super.provider);

  @override
  String get recordingId => (origin as GetRecordingFileProvider).recordingId;
  @override
  String get filename => (origin as GetRecordingFileProvider).filename;
}

String _$deleteRecordingHash() => r'64310bc42e73b45588b2683022f123e53dba5f03';

/// See also [deleteRecording].
@ProviderFor(deleteRecording)
const deleteRecordingProvider = DeleteRecordingFamily();

/// See also [deleteRecording].
class DeleteRecordingFamily extends Family<AsyncValue<void>> {
  /// See also [deleteRecording].
  const DeleteRecordingFamily();

  /// See also [deleteRecording].
  DeleteRecordingProvider call({
    required String recordingId,
  }) {
    return DeleteRecordingProvider(
      recordingId: recordingId,
    );
  }

  @override
  DeleteRecordingProvider getProviderOverride(
    covariant DeleteRecordingProvider provider,
  ) {
    return call(
      recordingId: provider.recordingId,
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
  String? get name => r'deleteRecordingProvider';
}

/// See also [deleteRecording].
class DeleteRecordingProvider extends AutoDisposeFutureProvider<void> {
  /// See also [deleteRecording].
  DeleteRecordingProvider({
    required String recordingId,
  }) : this._internal(
          (ref) => deleteRecording(
            ref as DeleteRecordingRef,
            recordingId: recordingId,
          ),
          from: deleteRecordingProvider,
          name: r'deleteRecordingProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$deleteRecordingHash,
          dependencies: DeleteRecordingFamily._dependencies,
          allTransitiveDependencies:
              DeleteRecordingFamily._allTransitiveDependencies,
          recordingId: recordingId,
        );

  DeleteRecordingProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.recordingId,
  }) : super.internal();

  final String recordingId;

  @override
  Override overrideWith(
    FutureOr<void> Function(DeleteRecordingRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DeleteRecordingProvider._internal(
        (ref) => create(ref as DeleteRecordingRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        recordingId: recordingId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _DeleteRecordingProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteRecordingProvider && other.recordingId == recordingId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, recordingId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DeleteRecordingRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `recordingId` of this provider.
  String get recordingId;
}

class _DeleteRecordingProviderElement
    extends AutoDisposeFutureProviderElement<void> with DeleteRecordingRef {
  _DeleteRecordingProviderElement(super.provider);

  @override
  String get recordingId => (origin as DeleteRecordingProvider).recordingId;
}

String _$mergedRecordingsHash() => r'1ce8067d701b1f0deff44c2a1f556ce33ab14f68';

/// See also [mergedRecordings].
@ProviderFor(mergedRecordings)
final mergedRecordingsProvider =
    AutoDisposeFutureProvider<List<ApiRecording>>.internal(
  mergedRecordings,
  name: r'mergedRecordingsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mergedRecordingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MergedRecordingsRef = AutoDisposeFutureProviderRef<List<ApiRecording>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
