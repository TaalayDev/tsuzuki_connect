/// Ren'Py-style fluent builder used by the Dart story sources.
///
/// The produced maps intentionally keep the same schema as the original
/// JavaScript `DialogueBuilder`, so they can be serialized to the existing
/// story JSON format without an adapter.
typedef StoryData = Map<String, dynamic>;
typedef StoryWord = Map<String, dynamic>;

/// Marks a story translation key without resolving it prematurely.
///
/// The UI resolves this key separately as Japanese, romaji, and the selected
/// translation language. Keeping the key here also makes story construction
/// independent of whichever UI language happens to be active.
String tr(String key) => key;

DialogueBuilder dialogue() => DialogueBuilder();

StoryWord word(
  String japanese,
  String? reading,
  String romaji,
  String english, [
  Map<String, dynamic> options = const {},
]) => <String, dynamic>{
  'japanese': japanese,
  'reading': reading,
  'romaji': romaji,
  'english': english,
  'category': options['category'] ?? 'general',
  'jlptLevel': options['jlpt'] ?? 'N5',
  ...options,
};

List<Map<String, dynamic>> mergeScenes(Iterable<dynamic> builders) {
  return <Map<String, dynamic>>[
    for (final value in builders)
      ...(((value is DialogueBuilder ? value.build() : value)
                  as StoryData)['scenes']
              as List<dynamic>)
          .cast<Map<String, dynamic>>(),
  ];
}

class DialogueBuilder {
  final List<Map<String, dynamic>> _scenes = [];
  Map<String, dynamic>? _currentScene;
  List<Map<String, dynamic>>? _pendingChoices;
  final StoryData _storyMeta = <String, dynamic>{
    'id': 0,
    'title': '',
    'titleJp': '',
    'description': '',
    'estimatedTime': '',
    'jlptFocus': 'N5',
    'vocabulary': <StoryWord>[],
  };

  DialogueBuilder story(int id, String title, String titleJp) {
    _storyMeta
      ..['id'] = id
      ..['title'] = title
      ..['titleJp'] = titleJp;
    return this;
  }

  DialogueBuilder description(String text) {
    _storyMeta['description'] = text;
    return this;
  }

  DialogueBuilder estimatedTime(String time) {
    _storyMeta['estimatedTime'] = time;
    return this;
  }

  DialogueBuilder jlptFocus(String level) {
    _storyMeta['jlptFocus'] = level;
    return this;
  }

  DialogueBuilder vocabularyList(List<StoryWord> vocabulary) {
    _storyMeta['vocabulary'] = vocabulary;
    return this;
  }

  DialogueBuilder scene(String id, [String? label]) {
    _flushPending();
    _currentScene = <String, dynamic>{
      'id': id,
      'label': label ?? id,
      'lines': <Map<String, dynamic>>[],
    };
    _scenes.add(_currentScene!);
    return this;
  }

  DialogueBuilder label(String labelName) {
    _currentScene?['label'] = labelName;
    return this;
  }

  DialogueBuilder jump(String targetLabel) =>
      _addLine(<String, dynamic>{'type': 'jump', 'target': targetLabel});
  DialogueBuilder end() => _addLine(<String, dynamic>{'type': 'end'});

  DialogueBuilder bg(
    String background, [
    String time = 'afternoon',
    String transition = 'fade',
  ]) => _addLine(<String, dynamic>{
    'type': 'background',
    'bg': background,
    'time': time,
    'transition': transition,
  });

  DialogueBuilder classroom([String time = 'morning']) => bg('classroom', time);
  DialogueBuilder street([String time = 'afternoon']) => bg('street', time);
  DialogueBuilder cafe([String time = 'afternoon']) => bg('cafe', time);
  DialogueBuilder apartment([String time = 'evening']) => bg('apartment', time);
  DialogueBuilder station([String time = 'afternoon']) => bg('station', time);
  DialogueBuilder park([String time = 'afternoon']) => bg('park', time);
  DialogueBuilder train([String time = 'afternoon']) => bg('train', time);
  DialogueBuilder izakaya([String time = 'evening']) => bg('izakaya', time);
  DialogueBuilder hallway([String time = 'morning']) => bg('hallway', time);

  DialogueBuilder show(
    String name, [
    String position = 'center',
    String expression = 'neutral',
  ]) => _addLine(<String, dynamic>{
    'type': 'character',
    'name': name,
    'position': position,
    'expression': expression,
  });

  DialogueBuilder hide(String name) =>
      _addLine(<String, dynamic>{'type': 'character-hide', 'name': name});
  DialogueBuilder hideAll() =>
      _addLine(<String, dynamic>{'type': 'character-hide-all'});
  DialogueBuilder move(String name, String position) =>
      _addLine(<String, dynamic>{
        'type': 'character-move',
        'name': name,
        'position': position,
      });
  DialogueBuilder express(String name, String expression) =>
      _addLine(<String, dynamic>{
        'type': 'character-express',
        'name': name,
        'expression': expression,
      });

  DialogueBuilder n(String text) =>
      _addLine(<String, dynamic>{'type': 'narration', 'text': text});

  DialogueBuilder say(String speaker, String text, [String? expression]) {
    return _addLine(<String, dynamic>{
      'type': 'dialogue',
      'speaker': speaker,
      'text': text,
      'expression': ?expression,
    });
  }

  DialogueBuilder player(String text, [String expression = 'neutral']) =>
      say('player', text, expression);

  DialogueBuilder think(String text, [String expression = 'thinking']) =>
      say('player', '($text)', expression);

  DialogueBuilder ken(String text, [String expression = 'neutral']) =>
      say('ken', text, expression);
  DialogueBuilder mei(String text, [String expression = 'neutral']) =>
      say('mei', text, expression);
  DialogueBuilder yuki(String text, [String expression = 'neutral']) =>
      say('yuki', text, expression);
  DialogueBuilder tanaka(String text, [String expression = 'neutral']) =>
      say('tanaka', text, expression);
  DialogueBuilder sora(String text, [String expression = 'neutral']) =>
      say('sora', text, expression);
  DialogueBuilder server(String text, [String expression = 'neutral']) =>
      say('server', text, expression);

  DialogueBuilder pause([String? speaker]) =>
      speaker == null ? n('...') : say(speaker, '...', 'neutral');

  DialogueBuilder vocab(
    String japanese,
    String? reading,
    String romaji,
    String english, [
    Map<String, dynamic> options = const {},
  ]) {
    return _addLine(<String, dynamic>{
      'type': 'vocab',
      'word': <String, dynamic>{
        'japanese': japanese,
        'reading': reading,
        'romaji': romaji,
        'english': english,
        'category': options['category'] ?? 'general',
        'jlptLevel': options['jlpt'] ?? 'N5',
        'storyId': _storyMeta['id'],
        ...options,
      },
    });
  }

  DialogueBuilder greeting(
    String japanese,
    String? reading,
    String romaji,
    String english,
  ) => vocab(japanese, reading, romaji, english, const <String, dynamic>{
    'category': 'greetings',
  });
  DialogueBuilder phrase(
    String japanese,
    String? reading,
    String romaji,
    String english,
  ) => vocab(japanese, reading, romaji, english, const <String, dynamic>{
    'category': 'phrases',
  });
  DialogueBuilder noun(
    String japanese,
    String? reading,
    String romaji,
    String english, [
    String category = 'nouns',
  ]) => vocab(japanese, reading, romaji, english, <String, dynamic>{
    'category': category,
  });
  DialogueBuilder verb(
    String japanese,
    String? reading,
    String romaji,
    String english,
  ) => vocab(japanese, reading, romaji, english, const <String, dynamic>{
    'category': 'verbs',
  });
  DialogueBuilder adjective(
    String japanese,
    String? reading,
    String romaji,
    String english,
  ) => vocab(japanese, reading, romaji, english, const <String, dynamic>{
    'category': 'adjectives',
  });

  DialogueBuilder menu() {
    _pendingChoices = <Map<String, dynamic>>[];
    return this;
  }

  DialogueBuilder choice(
    String text,
    String next, [
    Map<String, dynamic> options = const {},
  ]) {
    final choices = _pendingChoices;
    if (choices == null) {
      throw StateError('choice() must be called after menu()');
    }
    choices.add(<String, dynamic>{
      'text': text,
      'next': next,
      'hint': options['hint'],
      'relationship': options['relationship'],
      ...options,
    });
    return this;
  }

  DialogueBuilder endMenu() {
    final choices = _pendingChoices;
    if (choices != null && choices.isNotEmpty) {
      _addLine(<String, dynamic>{'type': 'choice', 'choices': choices});
    }
    _pendingChoices = null;
    return this;
  }

  DialogueBuilder relationship(
    String character,
    int change, [
    String reason = '',
  ]) => _addLine(<String, dynamic>{
    'type': 'relationship',
    'character': character,
    'change': change,
    'reason': reason,
  });
  DialogueBuilder befriend(String character, [String reason = '']) =>
      relationship(character, 1, reason);
  DialogueBuilder bond(String character, [String reason = '']) =>
      relationship(character, 2, reason);
  DialogueBuilder upset(String character, [String reason = '']) =>
      relationship(character, -1, reason);

  DialogueBuilder effect(String effectName, [int? duration]) =>
      _addLine(<String, dynamic>{
        'type': 'effect',
        'effect': effectName,
        'duration': duration,
      });
  DialogueBuilder stopEffect() => effect('stop');
  DialogueBuilder cherryBlossoms() => effect('cherry-blossoms');
  DialogueBuilder rain() => effect('rain');
  DialogueBuilder snow() => effect('snow');
  DialogueBuilder sparkle() => effect('sparkle');
  DialogueBuilder shake() => effect('shake');
  DialogueBuilder fadeIn() => effect('fade-in');
  DialogueBuilder fadeOut() => effect('fade-out');

  DialogueBuilder music(String track, [bool fadeIn = false]) => _addLine(
    <String, dynamic>{'type': 'music', 'track': track, 'fadeIn': fadeIn},
  );
  DialogueBuilder stopMusic() => music('stop');
  DialogueBuilder sfx(String sound) =>
      _addLine(<String, dynamic>{'type': 'sfx', 'sound': sound});

  DialogueBuilder setFlag(String flag, [dynamic value = true]) =>
      _addLine(<String, dynamic>{'type': 'flag', 'flag': flag, 'value': value});
  DialogueBuilder checkFlag(String flag, String ifTrue, [String? ifFalse]) =>
      _addLine(<String, dynamic>{
        'type': 'condition',
        'flag': flag,
        'ifTrue': ifTrue,
        'ifFalse': ifFalse,
      });

  DialogueBuilder lesson(Map<String, dynamic> lessonData) =>
      _addLine(<String, dynamic>{'type': 'lesson', ...lessonData});
  DialogueBuilder quiz(
    String question, [
    Map<String, dynamic> options = const {},
  ]) => _addLine(<String, dynamic>{
    'type': 'quiz',
    'question': question,
    ...options,
  });

  DialogueBuilder wait([int milliseconds = 1000]) =>
      _addLine(<String, dynamic>{'type': 'wait', 'duration': milliseconds});
  DialogueBuilder titleCard(
    String title, [
    String subtitle = '',
    int duration = 4000,
  ]) => _addLine(<String, dynamic>{
    'type': 'title-card',
    'title': title,
    'subtitle': subtitle,
    'duration': duration,
  });
  DialogueBuilder comment(String text) =>
      _addLine(<String, dynamic>{'type': '_comment', 'text': text});

  DialogueBuilder _addLine(Map<String, dynamic> line) {
    final scene = _currentScene;
    if (scene == null) {
      throw StateError('Must call scene() before adding content');
    }
    (scene['lines'] as List<Map<String, dynamic>>).add(line);
    return this;
  }

  void _flushPending() {
    if (_pendingChoices?.isNotEmpty ?? false) endMenu();
  }

  StoryData build() {
    _flushPending();
    return <String, dynamic>{
      ..._storyMeta,
      'vocabulary': List<StoryWord>.of(
        (_storyMeta['vocabulary'] as List).cast<StoryWord>(),
      ),
      'scenes': <Map<String, dynamic>>[
        for (final scene in _scenes)
          <String, dynamic>{
            ...scene,
            'lines': (scene['lines'] as List<Map<String, dynamic>>)
                .where((line) => line['type'] != '_comment')
                .toList(growable: false),
          },
      ],
    };
  }
}
