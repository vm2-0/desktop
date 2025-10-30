// ignore_for_file: invalid_annotation_target

import 'package:clones_desktop/domain/models/factory/factory_app.dart';
import 'package:clones_desktop/domain/models/factory/factory_token.dart';
import 'package:clones_desktop/domain/models/factory/factory_upload_limit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'factory.freezed.dart';
part 'factory.g.dart';

/// Status of a Factory
enum FactoryStatus {
  @JsonValue('active')
  active,
  @JsonValue('paused')
  paused,
  @JsonValue('error')
  error,
  @JsonValue('no-funds')
  noFunds,
}

extension FactoryStatusExtension on FactoryStatus {
  String get jsonValue {
    switch (this) {
      case FactoryStatus.active:
        return 'active';
      case FactoryStatus.paused:
        return 'paused';
      case FactoryStatus.error:
        return 'error';
      case FactoryStatus.noFunds:
        return 'no-funds';
    }
  }

  String get displayName {
    switch (this) {
      case FactoryStatus.active:
        return 'Active';
      case FactoryStatus.paused:
        return 'Paused';
      case FactoryStatus.error:
        return 'Error';
      case FactoryStatus.noFunds:
        return 'No Funds';
    }
  }
}

/// Main Factory model - canonical structure aligned with backend
@freezed
class Factory with _$Factory {
  const factory Factory({
    // Core identity
    required String id,
    required String poolAddress,
    required String name,
    String? description,

    // Ownership
    required String ownerAddress,

    // Status & lifecycle
    required FactoryStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,

    // Skills & categorization
    @Default([]) List<String> skills,

    // Economic model
    required FactoryToken token,
    @Default(0.0) double balance,

    // Statistics
    @Default(0) int demonstrations,

    // Configuration
    FactoryUploadLimit? uploadLimit,

    // Apps & tasks (integrated)
    @Default([]) List<FactoryApp> apps,

    // Search optimization
    @Default('') String searchText,

    // UI state (not stored on backend)
    @Default(false) bool expanded,
    @Default(false) bool isLoading,
  }) = _Factory;

  factory Factory.fromJson(Map<String, dynamic> json) =>
      _$FactoryFromJson(json);
}
