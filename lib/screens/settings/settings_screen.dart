import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/device_language.dart';
import '../../services/i18n_service.dart';
import '../../services/tts_service.dart';
import '../../state/i18n_provider.dart';
import '../../state/settings_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/adaptive_modal.dart';
import '../../widgets/glass_panel.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const _languageOptions = DeviceLanguage.selectableLanguages;
  static const _fontSizeOptions = ['small', 'medium', 'large'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final i18n = ref.watch(i18nProvider);
    final ttsService = ref.read(ttsServiceProvider);

    return ModalScaffold(
      title: i18n.t('settings.title'),
      child: ListView(
        shrinkWrap: true,
        primary: false,
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: i18n.t('settings.language.section'),
            children: [
              _LabeledRow(
                label: i18n.t('settings.language.ui_language'),
                child: DropdownButton<String>(
                  value: settings.language,
                  items: [
                    for (final code in _languageOptions)
                      DropdownMenuItem(
                        value: code,
                        child: Text(i18n.t('settings.language.$code')),
                      ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      notifier.update((s) => s.copyWith(language: value));
                    }
                  },
                ),
              ),
            ],
          ),
          _Section(
            title: i18n.t('settings.display.section'),
            children: [
              _LabeledRow(
                label: i18n.t('settings.display.font_size'),
                child: DropdownButton<String>(
                  value: settings.fontSize,
                  items: [
                    for (final size in _fontSizeOptions)
                      DropdownMenuItem(
                        value: size,
                        child: Text(i18n.t('settings.display.font.$size')),
                      ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      notifier.update((s) => s.copyWith(fontSize: value));
                    }
                  },
                ),
              ),
            ],
          ),
          _Section(
            title: i18n.t('settings.support.section'),
            children: [
              _SwitchRow(
                label: i18n.t('settings.support.subtitles'),
                value: settings.showSubtitles,
                onChanged: (v) =>
                    notifier.update((s) => s.copyWith(showSubtitles: v)),
              ),
              _SwitchRow(
                label: i18n.t('settings.support.reading'),
                value: settings.showTranscription,
                onChanged: (v) =>
                    notifier.update((s) => s.copyWith(showTranscription: v)),
              ),
              _SwitchRow(
                label: i18n.t('settings.support.choice_translation'),
                value: settings.showChoiceTranslation,
                onChanged: (v) => notifier.update(
                  (s) => s.copyWith(showChoiceTranslation: v),
                ),
              ),
            ],
          ),
          _Section(
            title: i18n.t('settings.tts.section'),
            children: [
              _VoicePicker(
                ttsService: ttsService,
                i18n: i18n,
                value: settings.ttsVoice,
                onChanged: (v) =>
                    notifier.update((s) => s.copyWith(ttsVoice: v)),
              ),
              _SliderRow(
                label: i18n.t('settings.tts.rate'),
                value: settings.ttsRate,
                min: 0.5,
                max: 1.5,
                onChanged: (v) =>
                    notifier.update((s) => s.copyWith(ttsRate: v)),
                onChangeEnd: (_) => ttsService.speak('This is how I sound.'),
              ),
              _SliderRow(
                label: i18n.t('settings.tts.pitch'),
                value: settings.ttsPitch,
                min: 0.5,
                max: 1.5,
                onChanged: (v) =>
                    notifier.update((s) => s.copyWith(ttsPitch: v)),
                onChangeEnd: (_) => ttsService.speak('This is how I sound.'),
              ),
            ],
          ),
          _Section(
            title: i18n.t('settings.audio.section'),
            children: [
              _SliderRow(
                label: i18n.t('settings.audio.master'),
                value: settings.masterVolume,
                min: 0,
                max: 1,
                onChanged: (v) =>
                    notifier.update((s) => s.copyWith(masterVolume: v)),
              ),
              _SliderRow(
                label: i18n.t('settings.audio.music'),
                value: settings.musicVolume,
                min: 0,
                max: 1,
                onChanged: (v) =>
                    notifier.update((s) => s.copyWith(musicVolume: v)),
              ),
              _SliderRow(
                label: i18n.t('settings.audio.sfx'),
                value: settings.sfxVolume,
                min: 0,
                max: 1,
                onChanged: (v) =>
                    notifier.update((s) => s.copyWith(sfxVolume: v)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.purple,
            ),
          ),
          const SizedBox(height: 8),
          GlassPanel(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

class _LabeledRow extends StatelessWidget {
  const _LabeledRow({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label)),
          child,
        ],
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return _LabeledRow(
      label: label,
      child: Switch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: AppColors.orange,
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  const _SliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.onChangeEnd,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final ValueChanged<double>? onChangeEnd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            activeColor: AppColors.orange,
            onChanged: onChanged,
            onChangeEnd: onChangeEnd,
          ),
        ],
      ),
    );
  }
}

class _VoicePicker extends StatefulWidget {
  const _VoicePicker({
    required this.ttsService,
    required this.i18n,
    required this.value,
    required this.onChanged,
  });

  final TtsService ttsService;
  final I18nService i18n;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  State<_VoicePicker> createState() => _VoicePickerState();
}

class _VoicePickerState extends State<_VoicePicker> {
  late Future<List<Map<String, String>>> _voicesFuture;

  @override
  void initState() {
    super.initState();
    _voicesFuture = widget.ttsService.getEnglishVoices();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, String>>>(
      future: _voicesFuture,
      builder: (context, snapshot) {
        final voices = snapshot.data ?? const [];
        final currentValue = voices.any((v) => v['name'] == widget.value)
            ? widget.value
            : '';

        return _LabeledRow(
          label: widget.i18n.t('settings.tts.voice'),
          child: DropdownButton<String>(
            value: currentValue,
            items: [
              DropdownMenuItem(
                value: '',
                child: Text(widget.i18n.t('settings.tts.voice_default')),
              ),
              for (final voice in voices)
                DropdownMenuItem(
                  value: voice['name'],
                  child: Text(voice['name'] ?? ''),
                ),
            ],
            onChanged: (value) {
              if (value != null) {
                widget.onChanged(value);
                widget.ttsService.setPreferredVoice(
                  value.isEmpty ? null : value,
                );
                widget.ttsService.speak('This is how I sound.');
              }
            },
          ),
        );
      },
    );
  }
}
