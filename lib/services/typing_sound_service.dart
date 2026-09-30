// import 'dart:async';

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:synthkit/synthkit.dart';

// import '../state/settings_provider.dart';

// /// Short synthesized dialogue ticks with a stable timbre for each speaker.
// class TypingSoundService {
//   TypingSoundService({SynthKitEngine? engine}) : _engine = engine ?? SynthKitEngine();

//   final SynthKitEngine _engine;
//   final Map<String, SynthKitSynth> _synths = {};
//   final Map<String, Future<SynthKitSynth?>> _pendingSynths = {};
//   Future<void>? _initializing;
//   double _volume = 0.35;
//   DateTime _lastTick = DateTime.fromMillisecondsSinceEpoch(0);
//   bool _disposed = false;

//   void setVolume(double volume) {
//     _volume = volume.clamp(0.0, 1.0);
//     final initializing = _initializing;
//     if (initializing != null) {
//       unawaited(
//         initializing.then((_) {
//           if (!_disposed) return _engine.setMasterVolume(_volume);
//         }),
//       );
//     }
//   }

//   void playTick({String? speaker, required String character}) {
//     if (_disposed || _volume <= 0 || character.trim().isEmpty) return;
//     if (!RegExp(r"[A-Za-z0-9']").hasMatch(character)) return;

//     final now = DateTime.now();
//     if (now.difference(_lastTick) < const Duration(milliseconds: 42)) return;
//     _lastTick = now;
//     unawaited(_play(speaker?.toLowerCase().trim() ?? 'narrator', character));
//   }

//   Future<void> _play(String speaker, String character) async {
//     try {
//       await _ensureInitialized();
//       if (_disposed) return;
//       final synth = await _synthFor(speaker);
//       if (synth == null || _disposed) return;
//       final voice = _voiceFor(speaker);
//       final variation = character.codeUnitAt(0) % 3 - 1;
//       await synth.triggerAttackRelease(
//         SynthKitNote.midi((voice.midi + variation).clamp(36, 96)),
//         const Duration(milliseconds: 46),
//         velocity: 0.72,
//       );
//     } catch (_) {
//       // Typing audio is decorative and must never interrupt dialogue.
//     }
//   }

//   Future<void> _ensureInitialized() {
//     if (_disposed) return Future.value();
//     return _initializing ??= _engine.initialize(masterVolume: _volume);
//   }

//   Future<SynthKitSynth?> _synthFor(String speaker) {
//     final existing = _synths[speaker];
//     if (existing != null) return Future.value(existing);
//     return _pendingSynths.putIfAbsent(speaker, () async {
//       if (_disposed) return null;
//       final voice = _voiceFor(speaker);
//       final synth = await _engine.createSynth(
//         SynthKitSynthOptions(
//           waveform: voice.waveform,
//           envelope: const SynthKitEnvelope(
//             attack: Duration(milliseconds: 2),
//             decay: Duration(milliseconds: 28),
//             sustain: 0.16,
//             release: Duration(milliseconds: 24),
//           ),
//           filter: SynthKitFilter.lowPass(cutoffHz: voice.cutoffHz),
//           volume: 0.26,
//         ),
//       );
//       if (_disposed) {
//         await synth.dispose();
//         return null;
//       }
//       _synths[speaker] = synth;
//       _pendingSynths.remove(speaker);
//       return synth;
//     });
//   }

//   _TypingVoice _voiceFor(String speaker) {
//     const named = <String, _TypingVoice>{
//       'alex': _TypingVoice(SynthKitWaveform.triangle, 67, 2100),
//       'ken': _TypingVoice(SynthKitWaveform.square, 55, 1250),
//       'mei': _TypingVoice(SynthKitWaveform.sine, 72, 2600),
//       'yuki': _TypingVoice(SynthKitWaveform.sawtooth, 62, 1550),
//       'player': _TypingVoice(SynthKitWaveform.triangle, 64, 1850),
//       'narrator': _TypingVoice(SynthKitWaveform.sine, 52, 1050),
//     };
//     final known = named[speaker];
//     if (known != null) return known;

//     // Every additional authored speaker receives a deterministic voice, so
//     // it remains recognizable across sessions without maintaining a long
//     // hard-coded roster.
//     final hash = speaker.codeUnits.fold<int>(17, (value, unit) {
//       return ((value * 37) + unit) & 0x7fffffff;
//     });
//     final waveforms = SynthKitWaveform.values;
//     return _TypingVoice(waveforms[hash % waveforms.length], 48 + (hash % 29), 1050 + (hash % 18) * 110.0);
//   }

//   Future<void> dispose() async {
//     if (_disposed) return;
//     _disposed = true;
//     await _engine.dispose();
//     _synths.clear();
//     _pendingSynths.clear();
//   }
// }

// class _TypingVoice {
//   const _TypingVoice(this.waveform, this.midi, this.cutoffHz);

//   final SynthKitWaveform waveform;
//   final int midi;
//   final double cutoffHz;
// }

// final typingSoundServiceProvider = Provider<TypingSoundService>((ref) {
//   final service = TypingSoundService();
//   final initial = ref.read(settingsProvider);
//   service.setVolume(initial.masterVolume * initial.sfxVolume);
//   ref.listen(settingsProvider, (_, next) {
//     service.setVolume(next.masterVolume * next.sfxVolume);
//   });
//   ref.onDispose(() => unawaited(service.dispose()));
//   return service;
// });
