import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../state/i18n_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/adaptive_modal.dart';

/// Port of `#credits-modal` in `index.html` — attribution for third-party
/// assets, content copied verbatim (these are the actual license/credit
/// links, not placeholders).
class CreditsScreen extends ConsumerWidget {
  const CreditsScreen({super.key});

  static const _entries = [
    (labelKey: 'credits.music', name: 'kummel', url: 'https://www.gamedevmarket.net/asset/lofi-world-volume-1-7-free-lofi-tracks'),
    (labelKey: 'credits.backgrounds', name: 'vecteezy.com', url: 'https://www.vecteezy.com/'),
    (labelKey: 'credits.backgrounds', name: 'pexels.com', url: 'https://www.pexels.com/'),
    (labelKey: 'credits.characters', name: 'wataokiba.net', url: 'https://wataokiba.net/%e7%b4%a0%e6%9d%90%e4%b8%80%e8%a6%a7/'),
    (labelKey: 'credits.characters', name: 'vecteezy.com', url: 'https://www.vecteezy.com/'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final i18n = ref.watch(i18nProvider);

    return ModalScaffold(
      title: i18n.t('credits.title'),
      child: ListView(
        shrinkWrap: true,
        primary: false,
        padding: const EdgeInsets.all(20),
        children: [
          for (final entry in _entries)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(color: AppColors.brownDark, fontSize: 15),
                  children: [
                    TextSpan(text: '${i18n.t(entry.labelKey)}: '),
                    TextSpan(
                      text: entry.name,
                      style: const TextStyle(
                        color: AppColors.purple,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => launchUrl(Uri.parse(entry.url), mode: LaunchMode.externalApplication),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
