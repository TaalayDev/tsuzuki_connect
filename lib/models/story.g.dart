// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DialogueSceneImpl _$$DialogueSceneImplFromJson(Map<String, dynamic> json) =>
    _$DialogueSceneImpl(
      id: json['id'] as String,
      label: json['label'] as String,
      lines: (json['lines'] as List<dynamic>)
          .map((e) => DialogueLine.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$DialogueSceneImplToJson(_$DialogueSceneImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'lines': instance.lines,
    };

_$StoryImpl _$$StoryImplFromJson(Map<String, dynamic> json) => _$StoryImpl(
  id: _idFromJson(json['id']),
  title: json['title'] as String,
  subtitle: json['subtitle'] as String,
  description: json['description'] as String? ?? '',
  estimatedTime: json['estimatedTime'] as String? ?? '',
  cefrFocus: json['cefrFocus'] as String? ?? 'A1',
  scenes: (json['scenes'] as List<dynamic>)
      .map((e) => DialogueScene.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$StoryImplToJson(_$StoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'description': instance.description,
      'estimatedTime': instance.estimatedTime,
      'cefrFocus': instance.cefrFocus,
      'scenes': instance.scenes,
    };
