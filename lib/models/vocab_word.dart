import 'package:freezed_annotation/freezed_annotation.dart';

part 'vocab_word.freezed.dart';
part 'vocab_word.g.dart';

@freezed
sealed class VocabWord with _$VocabWord {
  const factory VocabWord({
    required String id,
    required String word,
    required String level,
    required String cefrLevel,
    required String partOfSpeech,
    required String definition,
    required String translation,
    required String example,
    required String category,
    @Default(<String>[]) List<String> tags,

    @Default(<String, String>{}) Map<String, String> tr,
  }) = _VocabWord;

  factory VocabWord.fromJson(Map<String, dynamic> json) => _$VocabWordFromJson(json);
}
