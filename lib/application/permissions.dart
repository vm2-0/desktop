import 'package:clones_desktop/application/tauri_api.dart';
import 'package:clones_desktop/domain/models/permissions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'permissions.g.dart';

@riverpod
class PermissionsNotifier extends _$PermissionsNotifier {
  @override
  PermissionsData build() {
    return const PermissionsData();
  }

  Future<void> checkPermissions() async {
    state = state.copyWith(isLoading: true);

    try {
      final tauriClient = ref.read(tauriApiClientProvider);
      final axPerms = await tauriClient.hasAxPerms();
      final recordPerms = await tauriClient.hasRecordPerms();

      state = state.copyWith(
        accessibilityStatus:
            axPerms ? PermissionStatus.granted : PermissionStatus.denied,
        screenRecordingStatus:
            recordPerms ? PermissionStatus.granted : PermissionStatus.denied,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> requestAccessibilityPermission() async {
    // Set to pending while requesting
    state = state.copyWith(accessibilityStatus: PermissionStatus.pending);

    try {
      final tauriClient = ref.read(tauriApiClientProvider);
      final granted = await tauriClient.requestAxPerms();
      
      state = state.copyWith(
        accessibilityStatus: granted
            ? PermissionStatus.granted
            : PermissionStatus.denied,
      );
    } catch (e) {
      state = state.copyWith(accessibilityStatus: PermissionStatus.denied);
    }
  }

  Future<void> requestScreenRecordingPermission() async {
    // Set to pending while requesting
    state = state.copyWith(screenRecordingStatus: PermissionStatus.pending);

    try {
      final tauriClient = ref.read(tauriApiClientProvider);
      final granted = await tauriClient.requestRecordPerms();
      
      state = state.copyWith(
        screenRecordingStatus: granted
            ? PermissionStatus.granted
            : PermissionStatus.denied,
      );
    } catch (e) {
      state = state.copyWith(screenRecordingStatus: PermissionStatus.denied);
    }
  }
}
