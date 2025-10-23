// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TrainingSessionState {
  String? get prompt => throw _privateConstructorUsedError;
  Factory? get factory => throw _privateConstructorUsedError;
  FactoryTask? get factoryTask => throw _privateConstructorUsedError;
  Demonstration? get recordedDemonstration =>
      throw _privateConstructorUsedError;
  Demonstration? get recordingDemonstration =>
      throw _privateConstructorUsedError;
  bool get recordingProcessing => throw _privateConstructorUsedError;
  bool get showUploadConfirmModal => throw _privateConstructorUsedError;
  String? get currentRecordingId => throw _privateConstructorUsedError;
  bool get isUploading => throw _privateConstructorUsedError;
  Size? get originalWindowSize => throw _privateConstructorUsedError;
  RecordingState get recordingState => throw _privateConstructorUsedError;
  List<Message> get chatMessages => throw _privateConstructorUsedError;
  TypingMessage? get typingMessage => throw _privateConstructorUsedError;
  bool get isWaitingForResponse => throw _privateConstructorUsedError;
  AppInfo? get app => throw _privateConstructorUsedError;
  int get scrollToBottomNonce => throw _privateConstructorUsedError;
  bool get hasGivenUp => throw _privateConstructorUsedError;

  /// Create a copy of TrainingSessionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrainingSessionStateCopyWith<TrainingSessionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrainingSessionStateCopyWith<$Res> {
  factory $TrainingSessionStateCopyWith(TrainingSessionState value,
          $Res Function(TrainingSessionState) then) =
      _$TrainingSessionStateCopyWithImpl<$Res, TrainingSessionState>;
  @useResult
  $Res call(
      {String? prompt,
      Factory? factory,
      FactoryTask? factoryTask,
      Demonstration? recordedDemonstration,
      Demonstration? recordingDemonstration,
      bool recordingProcessing,
      bool showUploadConfirmModal,
      String? currentRecordingId,
      bool isUploading,
      Size? originalWindowSize,
      RecordingState recordingState,
      List<Message> chatMessages,
      TypingMessage? typingMessage,
      bool isWaitingForResponse,
      AppInfo? app,
      int scrollToBottomNonce,
      bool hasGivenUp});

  $FactoryCopyWith<$Res>? get factory;
  $FactoryTaskCopyWith<$Res>? get factoryTask;
  $DemonstrationCopyWith<$Res>? get recordedDemonstration;
  $DemonstrationCopyWith<$Res>? get recordingDemonstration;
  $TypingMessageCopyWith<$Res>? get typingMessage;
  $AppInfoCopyWith<$Res>? get app;
}

/// @nodoc
class _$TrainingSessionStateCopyWithImpl<$Res,
        $Val extends TrainingSessionState>
    implements $TrainingSessionStateCopyWith<$Res> {
  _$TrainingSessionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrainingSessionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? prompt = freezed,
    Object? factory = freezed,
    Object? factoryTask = freezed,
    Object? recordedDemonstration = freezed,
    Object? recordingDemonstration = freezed,
    Object? recordingProcessing = null,
    Object? showUploadConfirmModal = null,
    Object? currentRecordingId = freezed,
    Object? isUploading = null,
    Object? originalWindowSize = freezed,
    Object? recordingState = null,
    Object? chatMessages = null,
    Object? typingMessage = freezed,
    Object? isWaitingForResponse = null,
    Object? app = freezed,
    Object? scrollToBottomNonce = null,
    Object? hasGivenUp = null,
  }) {
    return _then(_value.copyWith(
      prompt: freezed == prompt
          ? _value.prompt
          : prompt // ignore: cast_nullable_to_non_nullable
              as String?,
      factory: freezed == factory
          ? _value.factory
          : factory // ignore: cast_nullable_to_non_nullable
              as Factory?,
      factoryTask: freezed == factoryTask
          ? _value.factoryTask
          : factoryTask // ignore: cast_nullable_to_non_nullable
              as FactoryTask?,
      recordedDemonstration: freezed == recordedDemonstration
          ? _value.recordedDemonstration
          : recordedDemonstration // ignore: cast_nullable_to_non_nullable
              as Demonstration?,
      recordingDemonstration: freezed == recordingDemonstration
          ? _value.recordingDemonstration
          : recordingDemonstration // ignore: cast_nullable_to_non_nullable
              as Demonstration?,
      recordingProcessing: null == recordingProcessing
          ? _value.recordingProcessing
          : recordingProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
      showUploadConfirmModal: null == showUploadConfirmModal
          ? _value.showUploadConfirmModal
          : showUploadConfirmModal // ignore: cast_nullable_to_non_nullable
              as bool,
      currentRecordingId: freezed == currentRecordingId
          ? _value.currentRecordingId
          : currentRecordingId // ignore: cast_nullable_to_non_nullable
              as String?,
      isUploading: null == isUploading
          ? _value.isUploading
          : isUploading // ignore: cast_nullable_to_non_nullable
              as bool,
      originalWindowSize: freezed == originalWindowSize
          ? _value.originalWindowSize
          : originalWindowSize // ignore: cast_nullable_to_non_nullable
              as Size?,
      recordingState: null == recordingState
          ? _value.recordingState
          : recordingState // ignore: cast_nullable_to_non_nullable
              as RecordingState,
      chatMessages: null == chatMessages
          ? _value.chatMessages
          : chatMessages // ignore: cast_nullable_to_non_nullable
              as List<Message>,
      typingMessage: freezed == typingMessage
          ? _value.typingMessage
          : typingMessage // ignore: cast_nullable_to_non_nullable
              as TypingMessage?,
      isWaitingForResponse: null == isWaitingForResponse
          ? _value.isWaitingForResponse
          : isWaitingForResponse // ignore: cast_nullable_to_non_nullable
              as bool,
      app: freezed == app
          ? _value.app
          : app // ignore: cast_nullable_to_non_nullable
              as AppInfo?,
      scrollToBottomNonce: null == scrollToBottomNonce
          ? _value.scrollToBottomNonce
          : scrollToBottomNonce // ignore: cast_nullable_to_non_nullable
              as int,
      hasGivenUp: null == hasGivenUp
          ? _value.hasGivenUp
          : hasGivenUp // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of TrainingSessionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FactoryCopyWith<$Res>? get factory {
    if (_value.factory == null) {
      return null;
    }

    return $FactoryCopyWith<$Res>(_value.factory!, (value) {
      return _then(_value.copyWith(factory: value) as $Val);
    });
  }

  /// Create a copy of TrainingSessionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FactoryTaskCopyWith<$Res>? get factoryTask {
    if (_value.factoryTask == null) {
      return null;
    }

    return $FactoryTaskCopyWith<$Res>(_value.factoryTask!, (value) {
      return _then(_value.copyWith(factoryTask: value) as $Val);
    });
  }

  /// Create a copy of TrainingSessionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DemonstrationCopyWith<$Res>? get recordedDemonstration {
    if (_value.recordedDemonstration == null) {
      return null;
    }

    return $DemonstrationCopyWith<$Res>(_value.recordedDemonstration!, (value) {
      return _then(_value.copyWith(recordedDemonstration: value) as $Val);
    });
  }

  /// Create a copy of TrainingSessionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DemonstrationCopyWith<$Res>? get recordingDemonstration {
    if (_value.recordingDemonstration == null) {
      return null;
    }

    return $DemonstrationCopyWith<$Res>(_value.recordingDemonstration!,
        (value) {
      return _then(_value.copyWith(recordingDemonstration: value) as $Val);
    });
  }

  /// Create a copy of TrainingSessionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TypingMessageCopyWith<$Res>? get typingMessage {
    if (_value.typingMessage == null) {
      return null;
    }

    return $TypingMessageCopyWith<$Res>(_value.typingMessage!, (value) {
      return _then(_value.copyWith(typingMessage: value) as $Val);
    });
  }

  /// Create a copy of TrainingSessionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AppInfoCopyWith<$Res>? get app {
    if (_value.app == null) {
      return null;
    }

    return $AppInfoCopyWith<$Res>(_value.app!, (value) {
      return _then(_value.copyWith(app: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TrainingSessionStateImplCopyWith<$Res>
    implements $TrainingSessionStateCopyWith<$Res> {
  factory _$$TrainingSessionStateImplCopyWith(_$TrainingSessionStateImpl value,
          $Res Function(_$TrainingSessionStateImpl) then) =
      __$$TrainingSessionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? prompt,
      Factory? factory,
      FactoryTask? factoryTask,
      Demonstration? recordedDemonstration,
      Demonstration? recordingDemonstration,
      bool recordingProcessing,
      bool showUploadConfirmModal,
      String? currentRecordingId,
      bool isUploading,
      Size? originalWindowSize,
      RecordingState recordingState,
      List<Message> chatMessages,
      TypingMessage? typingMessage,
      bool isWaitingForResponse,
      AppInfo? app,
      int scrollToBottomNonce,
      bool hasGivenUp});

  @override
  $FactoryCopyWith<$Res>? get factory;
  @override
  $FactoryTaskCopyWith<$Res>? get factoryTask;
  @override
  $DemonstrationCopyWith<$Res>? get recordedDemonstration;
  @override
  $DemonstrationCopyWith<$Res>? get recordingDemonstration;
  @override
  $TypingMessageCopyWith<$Res>? get typingMessage;
  @override
  $AppInfoCopyWith<$Res>? get app;
}

/// @nodoc
class __$$TrainingSessionStateImplCopyWithImpl<$Res>
    extends _$TrainingSessionStateCopyWithImpl<$Res, _$TrainingSessionStateImpl>
    implements _$$TrainingSessionStateImplCopyWith<$Res> {
  __$$TrainingSessionStateImplCopyWithImpl(_$TrainingSessionStateImpl _value,
      $Res Function(_$TrainingSessionStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of TrainingSessionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? prompt = freezed,
    Object? factory = freezed,
    Object? factoryTask = freezed,
    Object? recordedDemonstration = freezed,
    Object? recordingDemonstration = freezed,
    Object? recordingProcessing = null,
    Object? showUploadConfirmModal = null,
    Object? currentRecordingId = freezed,
    Object? isUploading = null,
    Object? originalWindowSize = freezed,
    Object? recordingState = null,
    Object? chatMessages = null,
    Object? typingMessage = freezed,
    Object? isWaitingForResponse = null,
    Object? app = freezed,
    Object? scrollToBottomNonce = null,
    Object? hasGivenUp = null,
  }) {
    return _then(_$TrainingSessionStateImpl(
      prompt: freezed == prompt
          ? _value.prompt
          : prompt // ignore: cast_nullable_to_non_nullable
              as String?,
      factory: freezed == factory
          ? _value.factory
          : factory // ignore: cast_nullable_to_non_nullable
              as Factory?,
      factoryTask: freezed == factoryTask
          ? _value.factoryTask
          : factoryTask // ignore: cast_nullable_to_non_nullable
              as FactoryTask?,
      recordedDemonstration: freezed == recordedDemonstration
          ? _value.recordedDemonstration
          : recordedDemonstration // ignore: cast_nullable_to_non_nullable
              as Demonstration?,
      recordingDemonstration: freezed == recordingDemonstration
          ? _value.recordingDemonstration
          : recordingDemonstration // ignore: cast_nullable_to_non_nullable
              as Demonstration?,
      recordingProcessing: null == recordingProcessing
          ? _value.recordingProcessing
          : recordingProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
      showUploadConfirmModal: null == showUploadConfirmModal
          ? _value.showUploadConfirmModal
          : showUploadConfirmModal // ignore: cast_nullable_to_non_nullable
              as bool,
      currentRecordingId: freezed == currentRecordingId
          ? _value.currentRecordingId
          : currentRecordingId // ignore: cast_nullable_to_non_nullable
              as String?,
      isUploading: null == isUploading
          ? _value.isUploading
          : isUploading // ignore: cast_nullable_to_non_nullable
              as bool,
      originalWindowSize: freezed == originalWindowSize
          ? _value.originalWindowSize
          : originalWindowSize // ignore: cast_nullable_to_non_nullable
              as Size?,
      recordingState: null == recordingState
          ? _value.recordingState
          : recordingState // ignore: cast_nullable_to_non_nullable
              as RecordingState,
      chatMessages: null == chatMessages
          ? _value._chatMessages
          : chatMessages // ignore: cast_nullable_to_non_nullable
              as List<Message>,
      typingMessage: freezed == typingMessage
          ? _value.typingMessage
          : typingMessage // ignore: cast_nullable_to_non_nullable
              as TypingMessage?,
      isWaitingForResponse: null == isWaitingForResponse
          ? _value.isWaitingForResponse
          : isWaitingForResponse // ignore: cast_nullable_to_non_nullable
              as bool,
      app: freezed == app
          ? _value.app
          : app // ignore: cast_nullable_to_non_nullable
              as AppInfo?,
      scrollToBottomNonce: null == scrollToBottomNonce
          ? _value.scrollToBottomNonce
          : scrollToBottomNonce // ignore: cast_nullable_to_non_nullable
              as int,
      hasGivenUp: null == hasGivenUp
          ? _value.hasGivenUp
          : hasGivenUp // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$TrainingSessionStateImpl extends _TrainingSessionState {
  const _$TrainingSessionStateImpl(
      {this.prompt,
      this.factory,
      this.factoryTask,
      this.recordedDemonstration,
      this.recordingDemonstration,
      this.recordingProcessing = false,
      this.showUploadConfirmModal = false,
      this.currentRecordingId,
      this.isUploading = false,
      this.originalWindowSize,
      this.recordingState = RecordingState.off,
      final List<Message> chatMessages = const [],
      this.typingMessage = null,
      this.isWaitingForResponse = false,
      this.app,
      this.scrollToBottomNonce = 0,
      this.hasGivenUp = false})
      : _chatMessages = chatMessages,
        super._();

  @override
  final String? prompt;
  @override
  final Factory? factory;
  @override
  final FactoryTask? factoryTask;
  @override
  final Demonstration? recordedDemonstration;
  @override
  final Demonstration? recordingDemonstration;
  @override
  @JsonKey()
  final bool recordingProcessing;
  @override
  @JsonKey()
  final bool showUploadConfirmModal;
  @override
  final String? currentRecordingId;
  @override
  @JsonKey()
  final bool isUploading;
  @override
  final Size? originalWindowSize;
  @override
  @JsonKey()
  final RecordingState recordingState;
  final List<Message> _chatMessages;
  @override
  @JsonKey()
  List<Message> get chatMessages {
    if (_chatMessages is EqualUnmodifiableListView) return _chatMessages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_chatMessages);
  }

  @override
  @JsonKey()
  final TypingMessage? typingMessage;
  @override
  @JsonKey()
  final bool isWaitingForResponse;
  @override
  final AppInfo? app;
  @override
  @JsonKey()
  final int scrollToBottomNonce;
  @override
  @JsonKey()
  final bool hasGivenUp;

  @override
  String toString() {
    return 'TrainingSessionState(prompt: $prompt, factory: $factory, factoryTask: $factoryTask, recordedDemonstration: $recordedDemonstration, recordingDemonstration: $recordingDemonstration, recordingProcessing: $recordingProcessing, showUploadConfirmModal: $showUploadConfirmModal, currentRecordingId: $currentRecordingId, isUploading: $isUploading, originalWindowSize: $originalWindowSize, recordingState: $recordingState, chatMessages: $chatMessages, typingMessage: $typingMessage, isWaitingForResponse: $isWaitingForResponse, app: $app, scrollToBottomNonce: $scrollToBottomNonce, hasGivenUp: $hasGivenUp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrainingSessionStateImpl &&
            (identical(other.prompt, prompt) || other.prompt == prompt) &&
            (identical(other.factory, factory) || other.factory == factory) &&
            (identical(other.factoryTask, factoryTask) ||
                other.factoryTask == factoryTask) &&
            (identical(other.recordedDemonstration, recordedDemonstration) ||
                other.recordedDemonstration == recordedDemonstration) &&
            (identical(other.recordingDemonstration, recordingDemonstration) ||
                other.recordingDemonstration == recordingDemonstration) &&
            (identical(other.recordingProcessing, recordingProcessing) ||
                other.recordingProcessing == recordingProcessing) &&
            (identical(other.showUploadConfirmModal, showUploadConfirmModal) ||
                other.showUploadConfirmModal == showUploadConfirmModal) &&
            (identical(other.currentRecordingId, currentRecordingId) ||
                other.currentRecordingId == currentRecordingId) &&
            (identical(other.isUploading, isUploading) ||
                other.isUploading == isUploading) &&
            (identical(other.originalWindowSize, originalWindowSize) ||
                other.originalWindowSize == originalWindowSize) &&
            (identical(other.recordingState, recordingState) ||
                other.recordingState == recordingState) &&
            const DeepCollectionEquality()
                .equals(other._chatMessages, _chatMessages) &&
            (identical(other.typingMessage, typingMessage) ||
                other.typingMessage == typingMessage) &&
            (identical(other.isWaitingForResponse, isWaitingForResponse) ||
                other.isWaitingForResponse == isWaitingForResponse) &&
            (identical(other.app, app) || other.app == app) &&
            (identical(other.scrollToBottomNonce, scrollToBottomNonce) ||
                other.scrollToBottomNonce == scrollToBottomNonce) &&
            (identical(other.hasGivenUp, hasGivenUp) ||
                other.hasGivenUp == hasGivenUp));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      prompt,
      factory,
      factoryTask,
      recordedDemonstration,
      recordingDemonstration,
      recordingProcessing,
      showUploadConfirmModal,
      currentRecordingId,
      isUploading,
      originalWindowSize,
      recordingState,
      const DeepCollectionEquality().hash(_chatMessages),
      typingMessage,
      isWaitingForResponse,
      app,
      scrollToBottomNonce,
      hasGivenUp);

  /// Create a copy of TrainingSessionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrainingSessionStateImplCopyWith<_$TrainingSessionStateImpl>
      get copyWith =>
          __$$TrainingSessionStateImplCopyWithImpl<_$TrainingSessionStateImpl>(
              this, _$identity);
}

abstract class _TrainingSessionState extends TrainingSessionState {
  const factory _TrainingSessionState(
      {final String? prompt,
      final Factory? factory,
      final FactoryTask? factoryTask,
      final Demonstration? recordedDemonstration,
      final Demonstration? recordingDemonstration,
      final bool recordingProcessing,
      final bool showUploadConfirmModal,
      final String? currentRecordingId,
      final bool isUploading,
      final Size? originalWindowSize,
      final RecordingState recordingState,
      final List<Message> chatMessages,
      final TypingMessage? typingMessage,
      final bool isWaitingForResponse,
      final AppInfo? app,
      final int scrollToBottomNonce,
      final bool hasGivenUp}) = _$TrainingSessionStateImpl;
  const _TrainingSessionState._() : super._();

  @override
  String? get prompt;
  @override
  Factory? get factory;
  @override
  FactoryTask? get factoryTask;
  @override
  Demonstration? get recordedDemonstration;
  @override
  Demonstration? get recordingDemonstration;
  @override
  bool get recordingProcessing;
  @override
  bool get showUploadConfirmModal;
  @override
  String? get currentRecordingId;
  @override
  bool get isUploading;
  @override
  Size? get originalWindowSize;
  @override
  RecordingState get recordingState;
  @override
  List<Message> get chatMessages;
  @override
  TypingMessage? get typingMessage;
  @override
  bool get isWaitingForResponse;
  @override
  AppInfo? get app;
  @override
  int get scrollToBottomNonce;
  @override
  bool get hasGivenUp;

  /// Create a copy of TrainingSessionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrainingSessionStateImplCopyWith<_$TrainingSessionStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ReplayGroupItem {
  List<SingleMessageItem> get messages => throw _privateConstructorUsedError;

  /// Create a copy of ReplayGroupItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReplayGroupItemCopyWith<ReplayGroupItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReplayGroupItemCopyWith<$Res> {
  factory $ReplayGroupItemCopyWith(
          ReplayGroupItem value, $Res Function(ReplayGroupItem) then) =
      _$ReplayGroupItemCopyWithImpl<$Res, ReplayGroupItem>;
  @useResult
  $Res call({List<SingleMessageItem> messages});
}

/// @nodoc
class _$ReplayGroupItemCopyWithImpl<$Res, $Val extends ReplayGroupItem>
    implements $ReplayGroupItemCopyWith<$Res> {
  _$ReplayGroupItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReplayGroupItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messages = null,
  }) {
    return _then(_value.copyWith(
      messages: null == messages
          ? _value.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<SingleMessageItem>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReplayGroupItemImplCopyWith<$Res>
    implements $ReplayGroupItemCopyWith<$Res> {
  factory _$$ReplayGroupItemImplCopyWith(_$ReplayGroupItemImpl value,
          $Res Function(_$ReplayGroupItemImpl) then) =
      __$$ReplayGroupItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<SingleMessageItem> messages});
}

/// @nodoc
class __$$ReplayGroupItemImplCopyWithImpl<$Res>
    extends _$ReplayGroupItemCopyWithImpl<$Res, _$ReplayGroupItemImpl>
    implements _$$ReplayGroupItemImplCopyWith<$Res> {
  __$$ReplayGroupItemImplCopyWithImpl(
      _$ReplayGroupItemImpl _value, $Res Function(_$ReplayGroupItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReplayGroupItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messages = null,
  }) {
    return _then(_$ReplayGroupItemImpl(
      messages: null == messages
          ? _value._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<SingleMessageItem>,
    ));
  }
}

/// @nodoc

class _$ReplayGroupItemImpl implements _ReplayGroupItem {
  const _$ReplayGroupItemImpl({required final List<SingleMessageItem> messages})
      : _messages = messages;

  final List<SingleMessageItem> _messages;
  @override
  List<SingleMessageItem> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  @override
  String toString() {
    return 'ReplayGroupItem(messages: $messages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReplayGroupItemImpl &&
            const DeepCollectionEquality().equals(other._messages, _messages));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_messages));

  /// Create a copy of ReplayGroupItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReplayGroupItemImplCopyWith<_$ReplayGroupItemImpl> get copyWith =>
      __$$ReplayGroupItemImplCopyWithImpl<_$ReplayGroupItemImpl>(
          this, _$identity);
}

abstract class _ReplayGroupItem implements ReplayGroupItem {
  const factory _ReplayGroupItem(
          {required final List<SingleMessageItem> messages}) =
      _$ReplayGroupItemImpl;

  @override
  List<SingleMessageItem> get messages;

  /// Create a copy of ReplayGroupItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReplayGroupItemImplCopyWith<_$ReplayGroupItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SingleMessageItem {
  Message get message => throw _privateConstructorUsedError;
  int get index => throw _privateConstructorUsedError;

  /// Create a copy of SingleMessageItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SingleMessageItemCopyWith<SingleMessageItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SingleMessageItemCopyWith<$Res> {
  factory $SingleMessageItemCopyWith(
          SingleMessageItem value, $Res Function(SingleMessageItem) then) =
      _$SingleMessageItemCopyWithImpl<$Res, SingleMessageItem>;
  @useResult
  $Res call({Message message, int index});

  $MessageCopyWith<$Res> get message;
}

/// @nodoc
class _$SingleMessageItemCopyWithImpl<$Res, $Val extends SingleMessageItem>
    implements $SingleMessageItemCopyWith<$Res> {
  _$SingleMessageItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SingleMessageItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? index = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as Message,
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  /// Create a copy of SingleMessageItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MessageCopyWith<$Res> get message {
    return $MessageCopyWith<$Res>(_value.message, (value) {
      return _then(_value.copyWith(message: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SingleMessageItemImplCopyWith<$Res>
    implements $SingleMessageItemCopyWith<$Res> {
  factory _$$SingleMessageItemImplCopyWith(_$SingleMessageItemImpl value,
          $Res Function(_$SingleMessageItemImpl) then) =
      __$$SingleMessageItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Message message, int index});

  @override
  $MessageCopyWith<$Res> get message;
}

/// @nodoc
class __$$SingleMessageItemImplCopyWithImpl<$Res>
    extends _$SingleMessageItemCopyWithImpl<$Res, _$SingleMessageItemImpl>
    implements _$$SingleMessageItemImplCopyWith<$Res> {
  __$$SingleMessageItemImplCopyWithImpl(_$SingleMessageItemImpl _value,
      $Res Function(_$SingleMessageItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of SingleMessageItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? index = null,
  }) {
    return _then(_$SingleMessageItemImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as Message,
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$SingleMessageItemImpl implements _SingleMessageItem {
  const _$SingleMessageItemImpl({required this.message, required this.index});

  @override
  final Message message;
  @override
  final int index;

  @override
  String toString() {
    return 'SingleMessageItem(message: $message, index: $index)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SingleMessageItemImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.index, index) || other.index == index));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, index);

  /// Create a copy of SingleMessageItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SingleMessageItemImplCopyWith<_$SingleMessageItemImpl> get copyWith =>
      __$$SingleMessageItemImplCopyWithImpl<_$SingleMessageItemImpl>(
          this, _$identity);
}

abstract class _SingleMessageItem implements SingleMessageItem {
  const factory _SingleMessageItem(
      {required final Message message,
      required final int index}) = _$SingleMessageItemImpl;

  @override
  Message get message;
  @override
  int get index;

  /// Create a copy of SingleMessageItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SingleMessageItemImplCopyWith<_$SingleMessageItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
