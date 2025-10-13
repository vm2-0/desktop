import 'package:clones_desktop/application/tauri_api.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/components/design_widget/dialog/popup_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReferralRequiredDialog {
  static Future<void> show(BuildContext context, WidgetRef ref) async {
    final tauriApi = ref.read(tauriApiClientProvider);

    await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => PopupTemplate(
        popupTitle: 'Referrer Code Required',
        popupContent: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'You need a referrer code to start training sessions and earn rewards.',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            const Text(
              'To get a referrer code, please join our Telegram community:',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.telegram,
                    color: Color(0xFF8B5CF6),
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Join our Telegram to get referrer codes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () async {
                const telegramUrl = 'https://t.me/clonesonbase';
                try {
                  await tauriApi.openExternalUrl(telegramUrl);
                } catch (e) {
                  debugPrint('Failed to open Telegram URL: $e');
                }
              },
              icon: const Icon(
                Icons.open_in_new,
                color: Color(0xFF8B5CF6),
                size: 16,
              ),
              label: const Text(
                'Open Telegram',
                style: TextStyle(color: Color(0xFF8B5CF6)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BtnPrimary(
                  onTap: () => Navigator.of(context).pop(),
                  buttonText: 'Close',
                  btnPrimaryType: BtnPrimaryType.outlinePrimary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
