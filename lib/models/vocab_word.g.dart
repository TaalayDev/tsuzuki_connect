// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vocab_word.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VocabWordImpl _$$VocabWordImplFromJson(Map<String, dynamic> json) =>
    _$VocabWordImpl(
      id: json['id'] as String,
      word: json['word'] as String,
      level: json['level'] as String,
      cefrLevel: json['cefrLevel'] as String,
      partOfSpeech: json['partOfSpeech'] as String,
      definition: json['definition'] as String,
      translation: json['translation'] as String,
      example: json['example'] as String,
      category: json['category'] as String,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const <String>[],
      tr:
          (json['tr'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
    );

Map<String, dynamic> _$$VocabWordImplToJson(_$VocabWordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'word': instance.word,
      'level': instance.level,
      'cefrLevel': instance.cefrLevel,
      'partOfSpeech': instance.partOfSpeech,
      'definition': instance.definition,
      'translation': instance.translation,
      'example': instance.example,
      'category': instance.category,
      'tags': instance.tags,
      'tr': instance.tr,
    };
