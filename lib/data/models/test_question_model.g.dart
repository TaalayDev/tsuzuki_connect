// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_question_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TestQuestion _$TestQuestionFromJson(Map<String, dynamic> json) =>
    _TestQuestion(
      id: (json['id'] as num).toInt(),
      questionJp: json['questionJp'] as String,
      questionEn: json['questionEn'] as String,
      type: $enumDecode(_$TestQuestionTypeEnumMap, json['type']),
      answers: (json['answers'] as List<dynamic>)
          .map((e) => TestAnswer.fromJson(e as Map<String, dynamic>))
          .toList(),
      correctAnswerIndex: (json['correctAnswerIndex'] as num).toInt(),
      jlptLevel: (json['jlptLevel'] as num).toInt(),
      category: json['category'] as String,
      hint: json['hint'] as String?,
      explanation: json['explanation'] as String?,
    );

Map<String, dynamic> _$TestQuestionToJson(_TestQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'questionJp': instance.questionJp,
      'questionEn': instance.questionEn,
      'type': _$TestQuestionTypeEnumMap[instance.type]!,
      'answers': instance.answers,
      'correctAnswerIndex': instance.correctAnswerIndex,
      'jlptLevel': instance.jlptLevel,
      'category': instance.category,
      'hint': instance.hint,
      'explanation': instance.explanation,
    };

const _$TestQuestionTypeEnumMap = {
  TestQuestionType.multipleChoice: 'multipleChoice',
  TestQuestionType.fillInBlank: 'fillInBlank',
  TestQuestionType.readingComprehension: 'readingComprehension',
};

_TestAnswer _$TestAnswerFromJson(Map<String, dynamic> json) => _TestAnswer(
      textJp: json['textJp'] as String,
      textEn: json['textEn'] as String,
      furigana: json['furigana'] as String?,
    );

Map<String, dynamic> _$TestAnswerToJson(_TestAnswer instance) =>
    <String, dynamic>{
      'textJp': instance.textJp,
      'textEn': instance.textEn,
      'furigana': instance.furigana,
    };
