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
mixin _$DemoDetailState {
  bool get isLoading => throw _privateConstructorUsedError;
  ApiRecording? get recording => throw _privateConstructorUsedError;
  List<RecordingEvent> get events => throw _privateConstructorUsedError;
  List<SftMessage> get sftMessages => throw _privateConstructorUsedError;
  Set<String> get eventTypes => throw _privateConstructorUsedError;
  Set<String> get enabledEventTypes => throw _privateConstructorUsedError;
  int get startTime => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  VideoSource? get videoSource => throw _privateConstructorUsedError;
  String? get currentVideoId => throw _privateConstructorUsedError;
  bool get showTrainingSessionModal =>
      throw _privateConstructorUsedError; // Video editing
  List<VideoClip> get clips => throw _privateConstructorUsedError;
  Set<String> get selectedClipIds => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  VideoClip? get clipboardClip =>
      throw _privateConstructorUsedError; // Each deletion operation is stored as a separate list of clips
  List<List<VideoClip>> get deletedClipsHistory =>
      throw _privateConstructorUsedError; // Legacy support for RangeValues (deprecated)
  List<RangeValues> get clipSegments => throw _privateConstructorUsedError;
  Set<int> get selectedClipIndexes =>
      throw _privateConstructorUsedError; // New states for button handling
  bool get isProcessing => throw _privateConstructorUsedError;
  bool get isExporting => throw _privateConstructorUsedError;
  bool get isUploading => throw _privateConstructorUsedError;
  bool get showUploadConfirmModal => throw _privateConstructorUsedError;
  String? get exportPath => throw _privateConstructorUsedError;
  String? get exportError => throw _privateConstructorUsedError;
  String? get uploadError =>
      throw _privateConstructorUsedError; // AxTree overlay state
  bool get showAxTreeOverlay => throw _privateConstructorUsedError;
  RecordingEvent? get currentAxTreeEvent =>
      throw _privateConstructorUsedError; // Pre-upload messages animation state
  String get firstMessage => throw _privateConstructorUsedError;
  String get secondMessage => throw _privateConstructorUsedError;
  String get thirdMessage => throw _privateConstructorUsedError;
  bool get showFirstMessage => throw _privateConstructorUsedError;
  bool get showSecondMessage => throw _privateConstructorUsedError;
  bool get showThirdMessage => throw _privateConstructorUsedError;
  int get currentTypingIndex => throw _privateConstructorUsedError;
  int get currentMessageIndex => throw _privateConstructorUsedError;

  /// Create a copy of DemoDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DemoDetailStateCopyWith<DemoDetailState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DemoDetailStateCopyWith<$Res> {
  factory $DemoDetailStateCopyWith(
          DemoDetailState value, $Res Function(DemoDetailState) then) =
      _$DemoDetailStateCopyWithImpl<$Res, DemoDetailState>;
  @useResult
  $Res call(
      {bool isLoading,
      ApiRecording? recording,
      List<RecordingEvent> events,
      List<SftMessage> sftMessages,
      Set<String> eventTypes,
      Set<String> enabledEventTypes,
      int startTime,
      @JsonKey(includeIfNull: false) VideoSource? videoSource,
      String? currentVideoId,
      bool showTrainingSessionModal,
      List<VideoClip> clips,
      Set<String> selectedClipIds,
      @JsonKey(includeIfNull: false) VideoClip? clipboardClip,
      List<List<VideoClip>> deletedClipsHistory,
      List<RangeValues> clipSegments,
      Set<int> selectedClipIndexes,
      bool isProcessing,
      bool isExporting,
      bool isUploading,
      bool showUploadConfirmModal,
      String? exportPath,
      String? exportError,
      String? uploadError,
      bool showAxTreeOverlay,
      RecordingEvent? currentAxTreeEvent,
      String firstMessage,
      String secondMessage,
      String thirdMessage,
      bool showFirstMessage,
      bool showSecondMessage,
      bool showThirdMessage,
      int currentTypingIndex,
      int currentMessageIndex});

  $ApiRecordingCopyWith<$Res>? get recording;
  $VideoClipCopyWith<$Res>? get clipboardClip;
  $RecordingEventCopyWith<$Res>? get currentAxTreeEvent;
}

/// @nodoc
class _$DemoDetailStateCopyWithImpl<$Res, $Val extends DemoDetailState>
    implements $DemoDetailStateCopyWith<$Res> {
  _$DemoDetailStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DemoDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? recording = freezed,
    Object? events = null,
    Object? sftMessages = null,
    Object? eventTypes = null,
    Object? enabledEventTypes = null,
    Object? startTime = null,
    Object? videoSource = freezed,
    Object? currentVideoId = freezed,
    Object? showTrainingSessionModal = null,
    Object? clips = null,
    Object? selectedClipIds = null,
    Object? clipboardClip = freezed,
    Object? deletedClipsHistory = null,
    Object? clipSegments = null,
    Object? selectedClipIndexes = null,
    Object? isProcessing = null,
    Object? isExporting = null,
    Object? isUploading = null,
    Object? showUploadConfirmModal = null,
    Object? exportPath = freezed,
    Object? exportError = freezed,
    Object? uploadError = freezed,
    Object? showAxTreeOverlay = null,
    Object? currentAxTreeEvent = freezed,
    Object? firstMessage = null,
    Object? secondMessage = null,
    Object? thirdMessage = null,
    Object? showFirstMessage = null,
    Object? showSecondMessage = null,
    Object? showThirdMessage = null,
    Object? currentTypingIndex = null,
    Object? currentMessageIndex = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      recording: freezed == recording
          ? _value.recording
          : recording // ignore: cast_nullable_to_non_nullable
              as ApiRecording?,
      events: null == events
          ? _value.events
          : events // ignore: cast_nullable_to_non_nullable
              as List<RecordingEvent>,
      sftMessages: null == sftMessages
          ? _value.sftMessages
          : sftMessages // ignore: cast_nullable_to_non_nullable
              as List<SftMessage>,
      eventTypes: null == eventTypes
          ? _value.eventTypes
          : eventTypes // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      enabledEventTypes: null == enabledEventTypes
          ? _value.enabledEventTypes
          : enabledEventTypes // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as int,
      videoSource: freezed == videoSource
          ? _value.videoSource
          : videoSource // ignore: cast_nullable_to_non_nullable
              as VideoSource?,
      currentVideoId: freezed == currentVideoId
          ? _value.currentVideoId
          : currentVideoId // ignore: cast_nullable_to_non_nullable
              as String?,
      showTrainingSessionModal: null == showTrainingSessionModal
          ? _value.showTrainingSessionModal
          : showTrainingSessionModal // ignore: cast_nullable_to_non_nullable
              as bool,
      clips: null == clips
          ? _value.clips
          : clips // ignore: cast_nullable_to_non_nullable
              as List<VideoClip>,
      selectedClipIds: null == selectedClipIds
          ? _value.selectedClipIds
          : selectedClipIds // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      clipboardClip: freezed == clipboardClip
          ? _value.clipboardClip
          : clipboardClip // ignore: cast_nullable_to_non_nullable
              as VideoClip?,
      deletedClipsHistory: null == deletedClipsHistory
          ? _value.deletedClipsHistory
          : deletedClipsHistory // ignore: cast_nullable_to_non_nullable
              as List<List<VideoClip>>,
      clipSegments: null == clipSegments
          ? _value.clipSegments
          : clipSegments // ignore: cast_nullable_to_non_nullable
              as List<RangeValues>,
      selectedClipIndexes: null == selectedClipIndexes
          ? _value.selectedClipIndexes
          : selectedClipIndexes // ignore: cast_nullable_to_non_nullable
              as Set<int>,
      isProcessing: null == isProcessing
          ? _value.isProcessing
          : isProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
      isExporting: null == isExporting
          ? _value.isExporting
          : isExporting // ignore: cast_nullable_to_non_nullable
              as bool,
      isUploading: null == isUploading
          ? _value.isUploading
          : isUploading // ignore: cast_nullable_to_non_nullable
              as bool,
      showUploadConfirmModal: null == showUploadConfirmModal
          ? _value.showUploadConfirmModal
          : showUploadConfirmModal // ignore: cast_nullable_to_non_nullable
              as bool,
      exportPath: freezed == exportPath
          ? _value.exportPath
          : exportPath // ignore: cast_nullable_to_non_nullable
              as String?,
      exportError: freezed == exportError
          ? _value.exportError
          : exportError // ignore: cast_nullable_to_non_nullable
              as String?,
      uploadError: freezed == uploadError
          ? _value.uploadError
          : uploadError // ignore: cast_nullable_to_non_nullable
              as String?,
      showAxTreeOverlay: null == showAxTreeOverlay
          ? _value.showAxTreeOverlay
          : showAxTreeOverlay // ignore: cast_nullable_to_non_nullable
              as bool,
      currentAxTreeEvent: freezed == currentAxTreeEvent
          ? _value.currentAxTreeEvent
          : currentAxTreeEvent // ignore: cast_nullable_to_non_nullable
              as RecordingEvent?,
      firstMessage: null == firstMessage
          ? _value.firstMessage
          : firstMessage // ignore: cast_nullable_to_non_nullable
              as String,
      secondMessage: null == secondMessage
          ? _value.secondMessage
          : secondMessage // ignore: cast_nullable_to_non_nullable
              as String,
      thirdMessage: null == thirdMessage
          ? _value.thirdMessage
          : thirdMessage // ignore: cast_nullable_to_non_nullable
              as String,
      showFirstMessage: null == showFirstMessage
          ? _value.showFirstMessage
          : showFirstMessage // ignore: cast_nullable_to_non_nullable
              as bool,
      showSecondMessage: null == showSecondMessage
          ? _value.showSecondMessage
          : showSecondMessage // ignore: cast_nullable_to_non_nullable
              as bool,
      showThirdMessage: null == showThirdMessage
          ? _value.showThirdMessage
          : showThirdMessage // ignore: cast_nullable_to_non_nullable
              as bool,
      currentTypingIndex: null == currentTypingIndex
          ? _value.currentTypingIndex
          : currentTypingIndex // ignore: cast_nullable_to_non_nullable
              as int,
      currentMessageIndex: null == currentMessageIndex
          ? _value.currentMessageIndex
          : currentMessageIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  /// Create a copy of DemoDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ApiRecordingCopyWith<$Res>? get recording {
    if (_value.recording == null) {
      return null;
    }

    return $ApiRecordingCopyWith<$Res>(_value.recording!, (value) {
      return _then(_value.copyWith(recording: value) as $Val);
    });
  }

  /// Create a copy of DemoDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VideoClipCopyWith<$Res>? get clipboardClip {
    if (_value.clipboardClip == null) {
      return null;
    }

    return $VideoClipCopyWith<$Res>(_value.clipboardClip!, (value) {
      return _then(_value.copyWith(clipboardClip: value) as $Val);
    });
  }

  /// Create a copy of DemoDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RecordingEventCopyWith<$Res>? get currentAxTreeEvent {
    if (_value.currentAxTreeEvent == null) {
      return null;
    }

    return $RecordingEventCopyWith<$Res>(_value.currentAxTreeEvent!, (value) {
      return _then(_value.copyWith(currentAxTreeEvent: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DemoDetailStateImplCopyWith<$Res>
    implements $DemoDetailStateCopyWith<$Res> {
  factory _$$DemoDetailStateImplCopyWith(_$DemoDetailStateImpl value,
          $Res Function(_$DemoDetailStateImpl) then) =
      __$$DemoDetailStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      ApiRecording? recording,
      List<RecordingEvent> events,
      List<SftMessage> sftMessages,
      Set<String> eventTypes,
      Set<String> enabledEventTypes,
      int startTime,
      @JsonKey(includeIfNull: false) VideoSource? videoSource,
      String? currentVideoId,
      bool showTrainingSessionModal,
      List<VideoClip> clips,
      Set<String> selectedClipIds,
      @JsonKey(includeIfNull: false) VideoClip? clipboardClip,
      List<List<VideoClip>> deletedClipsHistory,
      List<RangeValues> clipSegments,
      Set<int> selectedClipIndexes,
      bool isProcessing,
      bool isExporting,
      bool isUploading,
      bool showUploadConfirmModal,
      String? exportPath,
      String? exportError,
      String? uploadError,
      bool showAxTreeOverlay,
      RecordingEvent? currentAxTreeEvent,
      String firstMessage,
      String secondMessage,
      String thirdMessage,
      bool showFirstMessage,
      bool showSecondMessage,
      bool showThirdMessage,
      int currentTypingIndex,
      int currentMessageIndex});

  @override
  $ApiRecordingCopyWith<$Res>? get recording;
  @override
  $VideoClipCopyWith<$Res>? get clipboardClip;
  @override
  $RecordingEventCopyWith<$Res>? get currentAxTreeEvent;
}

/// @nodoc
class __$$DemoDetailStateImplCopyWithImpl<$Res>
    extends _$DemoDetailStateCopyWithImpl<$Res, _$DemoDetailStateImpl>
    implements _$$DemoDetailStateImplCopyWith<$Res> {
  __$$DemoDetailStateImplCopyWithImpl(
      _$DemoDetailStateImpl _value, $Res Function(_$DemoDetailStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of DemoDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? recording = freezed,
    Object? events = null,
    Object? sftMessages = null,
    Object? eventTypes = null,
    Object? enabledEventTypes = null,
    Object? startTime = null,
    Object? videoSource = freezed,
    Object? currentVideoId = freezed,
    Object? showTrainingSessionModal = null,
    Object? clips = null,
    Object? selectedClipIds = null,
    Object? clipboardClip = freezed,
    Object? deletedClipsHistory = null,
    Object? clipSegments = null,
    Object? selectedClipIndexes = null,
    Object? isProcessing = null,
    Object? isExporting = null,
    Object? isUploading = null,
    Object? showUploadConfirmModal = null,
    Object? exportPath = freezed,
    Object? exportError = freezed,
    Object? uploadError = freezed,
    Object? showAxTreeOverlay = null,
    Object? currentAxTreeEvent = freezed,
    Object? firstMessage = null,
    Object? secondMessage = null,
    Object? thirdMessage = null,
    Object? showFirstMessage = null,
    Object? showSecondMessage = null,
    Object? showThirdMessage = null,
    Object? currentTypingIndex = null,
    Object? currentMessageIndex = null,
  }) {
    return _then(_$DemoDetailStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      recording: freezed == recording
          ? _value.recording
          : recording // ignore: cast_nullable_to_non_nullable
              as ApiRecording?,
      events: null == events
          ? _value._events
          : events // ignore: cast_nullable_to_non_nullable
              as List<RecordingEvent>,
      sftMessages: null == sftMessages
          ? _value._sftMessages
          : sftMessages // ignore: cast_nullable_to_non_nullable
              as List<SftMessage>,
      eventTypes: null == eventTypes
          ? _value._eventTypes
          : eventTypes // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      enabledEventTypes: null == enabledEventTypes
          ? _value._enabledEventTypes
          : enabledEventTypes // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as int,
      videoSource: freezed == videoSource
          ? _value.videoSource
          : videoSource // ignore: cast_nullable_to_non_nullable
              as VideoSource?,
      currentVideoId: freezed == currentVideoId
          ? _value.currentVideoId
          : currentVideoId // ignore: cast_nullable_to_non_nullable
              as String?,
      showTrainingSessionModal: null == showTrainingSessionModal
          ? _value.showTrainingSessionModal
          : showTrainingSessionModal // ignore: cast_nullable_to_non_nullable
              as bool,
      clips: null == clips
          ? _value._clips
          : clips // ignore: cast_nullable_to_non_nullable
              as List<VideoClip>,
      selectedClipIds: null == selectedClipIds
          ? _value._selectedClipIds
          : selectedClipIds // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      clipboardClip: freezed == clipboardClip
          ? _value.clipboardClip
          : clipboardClip // ignore: cast_nullable_to_non_nullable
              as VideoClip?,
      deletedClipsHistory: null == deletedClipsHistory
          ? _value._deletedClipsHistory
          : deletedClipsHistory // ignore: cast_nullable_to_non_nullable
              as List<List<VideoClip>>,
      clipSegments: null == clipSegments
          ? _value._clipSegments
          : clipSegments // ignore: cast_nullable_to_non_nullable
              as List<RangeValues>,
      selectedClipIndexes: null == selectedClipIndexes
          ? _value._selectedClipIndexes
          : selectedClipIndexes // ignore: cast_nullable_to_non_nullable
              as Set<int>,
      isProcessing: null == isProcessing
          ? _value.isProcessing
          : isProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
      isExporting: null == isExporting
          ? _value.isExporting
          : isExporting // ignore: cast_nullable_to_non_nullable
              as bool,
      isUploading: null == isUploading
          ? _value.isUploading
          : isUploading // ignore: cast_nullable_to_non_nullable
              as bool,
      showUploadConfirmModal: null == showUploadConfirmModal
          ? _value.showUploadConfirmModal
          : showUploadConfirmModal // ignore: cast_nullable_to_non_nullable
              as bool,
      exportPath: freezed == exportPath
          ? _value.exportPath
          : exportPath // ignore: cast_nullable_to_non_nullable
              as String?,
      exportError: freezed == exportError
          ? _value.exportError
          : exportError // ignore: cast_nullable_to_non_nullable
              as String?,
      uploadError: freezed == uploadError
          ? _value.uploadError
          : uploadError // ignore: cast_nullable_to_non_nullable
              as String?,
      showAxTreeOverlay: null == showAxTreeOverlay
          ? _value.showAxTreeOverlay
          : showAxTreeOverlay // ignore: cast_nullable_to_non_nullable
              as bool,
      currentAxTreeEvent: freezed == currentAxTreeEvent
          ? _value.currentAxTreeEvent
          : currentAxTreeEvent // ignore: cast_nullable_to_non_nullable
              as RecordingEvent?,
      firstMessage: null == firstMessage
          ? _value.firstMessage
          : firstMessage // ignore: cast_nullable_to_non_nullable
              as String,
      secondMessage: null == secondMessage
          ? _value.secondMessage
          : secondMessage // ignore: cast_nullable_to_non_nullable
              as String,
      thirdMessage: null == thirdMessage
          ? _value.thirdMessage
          : thirdMessage // ignore: cast_nullable_to_non_nullable
              as String,
      showFirstMessage: null == showFirstMessage
          ? _value.showFirstMessage
          : showFirstMessage // ignore: cast_nullable_to_non_nullable
              as bool,
      showSecondMessage: null == showSecondMessage
          ? _value.showSecondMessage
          : showSecondMessage // ignore: cast_nullable_to_non_nullable
              as bool,
      showThirdMessage: null == showThirdMessage
          ? _value.showThirdMessage
          : showThirdMessage // ignore: cast_nullable_to_non_nullable
              as bool,
      currentTypingIndex: null == currentTypingIndex
          ? _value.currentTypingIndex
          : currentTypingIndex // ignore: cast_nullable_to_non_nullable
              as int,
      currentMessageIndex: null == currentMessageIndex
          ? _value.currentMessageIndex
          : currentMessageIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$DemoDetailStateImpl extends _DemoDetailState {
  const _$DemoDetailStateImpl(
      {this.isLoading = false,
      this.recording,
      final List<RecordingEvent> events = const [],
      final List<SftMessage> sftMessages = const [],
      final Set<String> eventTypes = const {},
      final Set<String> enabledEventTypes = const {},
      this.startTime = 0,
      @JsonKey(includeIfNull: false) this.videoSource,
      this.currentVideoId,
      this.showTrainingSessionModal = false,
      final List<VideoClip> clips = const [],
      final Set<String> selectedClipIds = const {},
      @JsonKey(includeIfNull: false) this.clipboardClip,
      final List<List<VideoClip>> deletedClipsHistory = const [],
      final List<RangeValues> clipSegments = const [],
      final Set<int> selectedClipIndexes = const {},
      this.isProcessing = false,
      this.isExporting = false,
      this.isUploading = false,
      this.showUploadConfirmModal = false,
      this.exportPath,
      this.exportError,
      this.uploadError,
      this.showAxTreeOverlay = false,
      this.currentAxTreeEvent,
      this.firstMessage = '',
      this.secondMessage = '',
      this.thirdMessage = '',
      this.showFirstMessage = false,
      this.showSecondMessage = false,
      this.showThirdMessage = false,
      this.currentTypingIndex = 0,
      this.currentMessageIndex = 0})
      : _events = events,
        _sftMessages = sftMessages,
        _eventTypes = eventTypes,
        _enabledEventTypes = enabledEventTypes,
        _clips = clips,
        _selectedClipIds = selectedClipIds,
        _deletedClipsHistory = deletedClipsHistory,
        _clipSegments = clipSegments,
        _selectedClipIndexes = selectedClipIndexes,
        super._();

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final ApiRecording? recording;
  final List<RecordingEvent> _events;
  @override
  @JsonKey()
  List<RecordingEvent> get events {
    if (_events is EqualUnmodifiableListView) return _events;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_events);
  }

  final List<SftMessage> _sftMessages;
  @override
  @JsonKey()
  List<SftMessage> get sftMessages {
    if (_sftMessages is EqualUnmodifiableListView) return _sftMessages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sftMessages);
  }

  final Set<String> _eventTypes;
  @override
  @JsonKey()
  Set<String> get eventTypes {
    if (_eventTypes is EqualUnmodifiableSetView) return _eventTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_eventTypes);
  }

  final Set<String> _enabledEventTypes;
  @override
  @JsonKey()
  Set<String> get enabledEventTypes {
    if (_enabledEventTypes is EqualUnmodifiableSetView)
      return _enabledEventTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_enabledEventTypes);
  }

  @override
  @JsonKey()
  final int startTime;
  @override
  @JsonKey(includeIfNull: false)
  final VideoSource? videoSource;
  @override
  final String? currentVideoId;
  @override
  @JsonKey()
  final bool showTrainingSessionModal;
// Video editing
  final List<VideoClip> _clips;
// Video editing
  @override
  @JsonKey()
  List<VideoClip> get clips {
    if (_clips is EqualUnmodifiableListView) return _clips;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_clips);
  }

  final Set<String> _selectedClipIds;
  @override
  @JsonKey()
  Set<String> get selectedClipIds {
    if (_selectedClipIds is EqualUnmodifiableSetView) return _selectedClipIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_selectedClipIds);
  }

  @override
  @JsonKey(includeIfNull: false)
  final VideoClip? clipboardClip;
// Each deletion operation is stored as a separate list of clips
  final List<List<VideoClip>> _deletedClipsHistory;
// Each deletion operation is stored as a separate list of clips
  @override
  @JsonKey()
  List<List<VideoClip>> get deletedClipsHistory {
    if (_deletedClipsHistory is EqualUnmodifiableListView)
      return _deletedClipsHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_deletedClipsHistory);
  }

// Legacy support for RangeValues (deprecated)
  final List<RangeValues> _clipSegments;
// Legacy support for RangeValues (deprecated)
  @override
  @JsonKey()
  List<RangeValues> get clipSegments {
    if (_clipSegments is EqualUnmodifiableListView) return _clipSegments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_clipSegments);
  }

  final Set<int> _selectedClipIndexes;
  @override
  @JsonKey()
  Set<int> get selectedClipIndexes {
    if (_selectedClipIndexes is EqualUnmodifiableSetView)
      return _selectedClipIndexes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_selectedClipIndexes);
  }

// New states for button handling
  @override
  @JsonKey()
  final bool isProcessing;
  @override
  @JsonKey()
  final bool isExporting;
  @override
  @JsonKey()
  final bool isUploading;
  @override
  @JsonKey()
  final bool showUploadConfirmModal;
  @override
  final String? exportPath;
  @override
  final String? exportError;
  @override
  final String? uploadError;
// AxTree overlay state
  @override
  @JsonKey()
  final bool showAxTreeOverlay;
  @override
  final RecordingEvent? currentAxTreeEvent;
// Pre-upload messages animation state
  @override
  @JsonKey()
  final String firstMessage;
  @override
  @JsonKey()
  final String secondMessage;
  @override
  @JsonKey()
  final String thirdMessage;
  @override
  @JsonKey()
  final bool showFirstMessage;
  @override
  @JsonKey()
  final bool showSecondMessage;
  @override
  @JsonKey()
  final bool showThirdMessage;
  @override
  @JsonKey()
  final int currentTypingIndex;
  @override
  @JsonKey()
  final int currentMessageIndex;

  @override
  String toString() {
    return 'DemoDetailState(isLoading: $isLoading, recording: $recording, events: $events, sftMessages: $sftMessages, eventTypes: $eventTypes, enabledEventTypes: $enabledEventTypes, startTime: $startTime, videoSource: $videoSource, currentVideoId: $currentVideoId, showTrainingSessionModal: $showTrainingSessionModal, clips: $clips, selectedClipIds: $selectedClipIds, clipboardClip: $clipboardClip, deletedClipsHistory: $deletedClipsHistory, clipSegments: $clipSegments, selectedClipIndexes: $selectedClipIndexes, isProcessing: $isProcessing, isExporting: $isExporting, isUploading: $isUploading, showUploadConfirmModal: $showUploadConfirmModal, exportPath: $exportPath, exportError: $exportError, uploadError: $uploadError, showAxTreeOverlay: $showAxTreeOverlay, currentAxTreeEvent: $currentAxTreeEvent, firstMessage: $firstMessage, secondMessage: $secondMessage, thirdMessage: $thirdMessage, showFirstMessage: $showFirstMessage, showSecondMessage: $showSecondMessage, showThirdMessage: $showThirdMessage, currentTypingIndex: $currentTypingIndex, currentMessageIndex: $currentMessageIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DemoDetailStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.recording, recording) ||
                other.recording == recording) &&
            const DeepCollectionEquality().equals(other._events, _events) &&
            const DeepCollectionEquality()
                .equals(other._sftMessages, _sftMessages) &&
            const DeepCollectionEquality()
                .equals(other._eventTypes, _eventTypes) &&
            const DeepCollectionEquality()
                .equals(other._enabledEventTypes, _enabledEventTypes) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.videoSource, videoSource) ||
                other.videoSource == videoSource) &&
            (identical(other.currentVideoId, currentVideoId) ||
                other.currentVideoId == currentVideoId) &&
            (identical(
                    other.showTrainingSessionModal, showTrainingSessionModal) ||
                other.showTrainingSessionModal == showTrainingSessionModal) &&
            const DeepCollectionEquality().equals(other._clips, _clips) &&
            const DeepCollectionEquality()
                .equals(other._selectedClipIds, _selectedClipIds) &&
            (identical(other.clipboardClip, clipboardClip) ||
                other.clipboardClip == clipboardClip) &&
            const DeepCollectionEquality()
                .equals(other._deletedClipsHistory, _deletedClipsHistory) &&
            const DeepCollectionEquality()
                .equals(other._clipSegments, _clipSegments) &&
            const DeepCollectionEquality()
                .equals(other._selectedClipIndexes, _selectedClipIndexes) &&
            (identical(other.isProcessing, isProcessing) ||
                other.isProcessing == isProcessing) &&
            (identical(other.isExporting, isExporting) ||
                other.isExporting == isExporting) &&
            (identical(other.isUploading, isUploading) ||
                other.isUploading == isUploading) &&
            (identical(other.showUploadConfirmModal, showUploadConfirmModal) ||
                other.showUploadConfirmModal == showUploadConfirmModal) &&
            (identical(other.exportPath, exportPath) ||
                other.exportPath == exportPath) &&
            (identical(other.exportError, exportError) ||
                other.exportError == exportError) &&
            (identical(other.uploadError, uploadError) ||
                other.uploadError == uploadError) &&
            (identical(other.showAxTreeOverlay, showAxTreeOverlay) ||
                other.showAxTreeOverlay == showAxTreeOverlay) &&
            (identical(other.currentAxTreeEvent, currentAxTreeEvent) ||
                other.currentAxTreeEvent == currentAxTreeEvent) &&
            (identical(other.firstMessage, firstMessage) ||
                other.firstMessage == firstMessage) &&
            (identical(other.secondMessage, secondMessage) ||
                other.secondMessage == secondMessage) &&
            (identical(other.thirdMessage, thirdMessage) ||
                other.thirdMessage == thirdMessage) &&
            (identical(other.showFirstMessage, showFirstMessage) ||
                other.showFirstMessage == showFirstMessage) &&
            (identical(other.showSecondMessage, showSecondMessage) ||
                other.showSecondMessage == showSecondMessage) &&
            (identical(other.showThirdMessage, showThirdMessage) ||
                other.showThirdMessage == showThirdMessage) &&
            (identical(other.currentTypingIndex, currentTypingIndex) ||
                other.currentTypingIndex == currentTypingIndex) &&
            (identical(other.currentMessageIndex, currentMessageIndex) ||
                other.currentMessageIndex == currentMessageIndex));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        isLoading,
        recording,
        const DeepCollectionEquality().hash(_events),
        const DeepCollectionEquality().hash(_sftMessages),
        const DeepCollectionEquality().hash(_eventTypes),
        const DeepCollectionEquality().hash(_enabledEventTypes),
        startTime,
        videoSource,
        currentVideoId,
        showTrainingSessionModal,
        const DeepCollectionEquality().hash(_clips),
        const DeepCollectionEquality().hash(_selectedClipIds),
        clipboardClip,
        const DeepCollectionEquality().hash(_deletedClipsHistory),
        const DeepCollectionEquality().hash(_clipSegments),
        const DeepCollectionEquality().hash(_selectedClipIndexes),
        isProcessing,
        isExporting,
        isUploading,
        showUploadConfirmModal,
        exportPath,
        exportError,
        uploadError,
        showAxTreeOverlay,
        currentAxTreeEvent,
        firstMessage,
        secondMessage,
        thirdMessage,
        showFirstMessage,
        showSecondMessage,
        showThirdMessage,
        currentTypingIndex,
        currentMessageIndex
      ]);

  /// Create a copy of DemoDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DemoDetailStateImplCopyWith<_$DemoDetailStateImpl> get copyWith =>
      __$$DemoDetailStateImplCopyWithImpl<_$DemoDetailStateImpl>(
          this, _$identity);
}

abstract class _DemoDetailState extends DemoDetailState {
  const factory _DemoDetailState(
      {final bool isLoading,
      final ApiRecording? recording,
      final List<RecordingEvent> events,
      final List<SftMessage> sftMessages,
      final Set<String> eventTypes,
      final Set<String> enabledEventTypes,
      final int startTime,
      @JsonKey(includeIfNull: false) final VideoSource? videoSource,
      final String? currentVideoId,
      final bool showTrainingSessionModal,
      final List<VideoClip> clips,
      final Set<String> selectedClipIds,
      @JsonKey(includeIfNull: false) final VideoClip? clipboardClip,
      final List<List<VideoClip>> deletedClipsHistory,
      final List<RangeValues> clipSegments,
      final Set<int> selectedClipIndexes,
      final bool isProcessing,
      final bool isExporting,
      final bool isUploading,
      final bool showUploadConfirmModal,
      final String? exportPath,
      final String? exportError,
      final String? uploadError,
      final bool showAxTreeOverlay,
      final RecordingEvent? currentAxTreeEvent,
      final String firstMessage,
      final String secondMessage,
      final String thirdMessage,
      final bool showFirstMessage,
      final bool showSecondMessage,
      final bool showThirdMessage,
      final int currentTypingIndex,
      final int currentMessageIndex}) = _$DemoDetailStateImpl;
  const _DemoDetailState._() : super._();

  @override
  bool get isLoading;
  @override
  ApiRecording? get recording;
  @override
  List<RecordingEvent> get events;
  @override
  List<SftMessage> get sftMessages;
  @override
  Set<String> get eventTypes;
  @override
  Set<String> get enabledEventTypes;
  @override
  int get startTime;
  @override
  @JsonKey(includeIfNull: false)
  VideoSource? get videoSource;
  @override
  String? get currentVideoId;
  @override
  bool get showTrainingSessionModal; // Video editing
  @override
  List<VideoClip> get clips;
  @override
  Set<String> get selectedClipIds;
  @override
  @JsonKey(includeIfNull: false)
  VideoClip?
      get clipboardClip; // Each deletion operation is stored as a separate list of clips
  @override
  List<List<VideoClip>>
      get deletedClipsHistory; // Legacy support for RangeValues (deprecated)
  @override
  List<RangeValues> get clipSegments;
  @override
  Set<int> get selectedClipIndexes; // New states for button handling
  @override
  bool get isProcessing;
  @override
  bool get isExporting;
  @override
  bool get isUploading;
  @override
  bool get showUploadConfirmModal;
  @override
  String? get exportPath;
  @override
  String? get exportError;
  @override
  String? get uploadError; // AxTree overlay state
  @override
  bool get showAxTreeOverlay;
  @override
  RecordingEvent? get currentAxTreeEvent; // Pre-upload messages animation state
  @override
  String get firstMessage;
  @override
  String get secondMessage;
  @override
  String get thirdMessage;
  @override
  bool get showFirstMessage;
  @override
  bool get showSecondMessage;
  @override
  bool get showThirdMessage;
  @override
  int get currentTypingIndex;
  @override
  int get currentMessageIndex;

  /// Create a copy of DemoDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DemoDetailStateImplCopyWith<_$DemoDetailStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
