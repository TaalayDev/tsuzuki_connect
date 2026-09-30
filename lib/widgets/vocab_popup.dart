import 'package:flutter/material.dart';

import '../models/vocab_word.dart';
import '../services/i18n_service.dart';
import '../services/tts_service.dart';
import '../theme/app_theme.dart';
import 'glass_panel.dart';

Future<void> showVocabPopup(
  BuildContext context, {
  required Offset anchor,
  required VocabWord word,
  required I18nService i18n,
  required TtsService ttsService,
  required String uiLanguage,
}) {
  final translation = word.tr[uiLanguage] ?? word.translation;
  final meta = [word.cefrLevel, word.partOfSpeech, word.category].where((s) => s.isNotEmpty).join(' · ');

  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'vocab-popup',
    barrierColor: Colors.black.withValues(alpha: 0.15),
    transitionDuration: const Duration(milliseconds: 150),
    pageBuilder: (context, animation, secondaryAnimation) {
      final size = MediaQuery.sizeOf(context);
      const cardWidth = 300.0;
      final left = (anchor.dx - cardWidth / 2).clamp(10.0, size.width - cardWidth - 10);

      final showBelow = anchor.dy < 160;
      final top = showBelow ? anchor.dy + 24 : null;
      final bottom = showBelow ? null : size.height - anchor.dy + 24;

      return Stack(
        children: [
          Positioned(
            left: left,
            top: top,
            bottom: bottom,
            width: cardWidth,
            child: FadeTransition(
              opacity: animation,
              child: GlassPanel(
                borderRadius: 20,
                padding: const EdgeInsets.all(20),
                shadows: const [BoxShadow(color: Color(0x40906FD1), blurRadius: 40, offset: Offset(0, 16))],
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              word.word,
                              style: AppTheme.japaneseFont(fontSize: 28, color: AppColors.brownDark),
                            ),
                          ),
                          Material(
                            color: const Color(0x1F6F52B5), // rgba(111,82,181,0.12)
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () => ttsService.speak(word.word),
                              child: const Padding(
                                padding: EdgeInsets.all(6),
                                child: Icon(Icons.volume_up, color: AppColors.purpleDark, size: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (translation.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4, bottom: 8),
                          child: Text(translation, style: AppTheme.japaneseFont(fontSize: 16, color: AppColors.purple)),
                        ),
                      Text(
                        word.definition,
                        style: const TextStyle(fontSize: 15, color: AppColors.brownDark, height: 1.5),
                      ),
                      if (meta.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            meta.toUpperCase(),
                            style: const TextStyle(fontSize: 12, color: AppColors.orange, letterSpacing: 0.4),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) => child,
  );
}
