/**
 * TSUZUKI CONNECT - I18n System
 * Lightweight DOM-based translations for static UI strings.
 */

import { STORY_TRANSLATIONS } from './StoryTranslations.js';

export const UI_TRANSLATIONS = {
    en: {
        'page.title': 'Tsuzuki Connect - A Place Connected by Words',
        'menu.new_game': 'NEW GAME',
        'menu.continue': 'CONTINUE',
        'menu.chapter_select': 'CHAPTER SELECT',
        'menu.kotoba_log': 'KOTOBA LOG',
        'menu.settings': 'SETTINGS',
        'menu.credits': 'CREDITS',
        'menu.unlock_title': 'Unlock All Stories',
        'menu.unlock_sub': 'One-time · All 8 chapters',
        'menu.subtitle': '言葉でつながる場所',
        'credits.title': 'Credits',
        'credits.music': 'BG music',
        'credits.backgrounds': 'BG images',
        'credits.characters': 'Characters',

        'cc.title': 'Create Your Character',
        'cc.name': 'Name',
        'cc.name_placeholder': 'Enter your name...',
        'cc.why': 'Why are you learning Japanese?',
        'cc.reason.culture': 'Fascinated by Japanese culture',
        'cc.reason.work': 'Career opportunities',
        'cc.reason.love': 'Following my heart',
        'cc.reason.adventure': 'Seeking adventure',
        'cc.level': 'Japanese Level',
        'cc.levels.beginner': 'Complete Beginner (N5)',
        'cc.levels.some': 'Some Knowledge (N4)',
        'cc.levels.intermediate': 'Intermediate (N3)',
        'cc.begin': 'Begin Your Journey',

        'game.menu': 'Menu',
        'game.auto': 'Auto',
        'game.skip': 'Skip',
        'game.log': 'Log',

        'settings.title': 'Settings',
        'settings.profile.section': 'Profile',
        'settings.profile.player_name': 'Player Name',
        'settings.language.section': 'Language',
        'settings.language.ui_language': 'UI Language',
        'settings.language.en': 'English',
        'settings.language.ru': 'Русский',
        'settings.language.zh': '中文',
        'settings.language.ko': '한국어',

        'settings.display.section': 'Display',
        'settings.display.text_speed': 'Text Speed',
        'settings.display.speed.slow': 'Slow',
        'settings.display.speed.medium': 'Medium',
        'settings.display.speed.fast': 'Fast',
        'settings.display.font_size': 'Font Size',
        'settings.display.font.small': 'Small',
        'settings.display.font.medium': 'Medium',
        'settings.display.font.large': 'Large',

        'settings.support.section': 'Language Support',
        'settings.support.subtitles': 'Show English Subtitles',
        'settings.support.furigana': 'Show Furigana',
        'settings.support.furigana_options.all': 'All Kanji',
        'settings.support.furigana_options.uncommon': 'Uncommon Only',
        'settings.support.furigana_options.off': 'Off',

        'settings.audio.section': 'Audio',
        'settings.audio.master': 'Master Volume',
        'settings.audio.music': 'Music Volume',
        'settings.audio.sfx': 'SFX Volume',

        'common.close': 'Close',

        'quick_menu.title': 'Menu',
        'quick_menu.save': 'Save',
        'quick_menu.load': 'Load',
        'quick_menu.text_log': 'Text Log',
        'quick_menu.kotoba_log': 'Kotoba Log',
        'quick_menu.settings': 'Settings',
        'quick_menu.main_menu': 'Main Menu',
        'quick_menu.return': 'Return',

        'text_log.title': 'Text Log',

        'kotoba.title': 'Kotoba Log 言葉ログ',
        'kotoba.tabs.story': 'By Story',
        'kotoba.tabs.category': 'By Category',
        'kotoba.tabs.level': 'By Level',

        'lesson.title': "Tanaka-sensei's Classroom",
        'lesson.skip': 'Skip Lesson',
        'lesson.continue': 'Continue',

        // Runtime UI strings
        'runtime.name_required': 'Please enter your name',
        'runtime.confirm.return_to_title': 'Return to title? Unsaved progress will be lost.',
        'runtime.chapter_select_soon': 'Chapter select coming soon!',
        'runtime.chapter_select.title': 'Chapter Select',
        'runtime.chapter_select.note': 'Select a chapter to start from the beginning.',
        'runtime.chapter_select.chapter': 'Chapter',
        'runtime.chapter_select.start': 'Start',
        'runtime.chapter_select.locked': 'Locked',
        'runtime.chapter_select.time': 'Time',
        'runtime.chapter_select.jlpt': 'JLPT',
        'runtime.chapter_select.invalid': 'Selected chapter is unavailable.',
        'runtime.chapter_select.story_limit': 'Only Story {n} is currently available.',
        'runtime.saved': 'Game saved!',
        'runtime.confirm.delete_save': 'Delete this save?',
        'runtime.kotoba.none': 'No words learned yet!',
        'runtime.scene': 'Scene',
        'runtime.save.title.save': 'Save Game',
        'runtime.save.title.load': 'Load Game',
        'runtime.save.label.auto': 'Auto-Save',
        'runtime.save.label.slot': 'Slot {n}',
        'runtime.save.empty': 'Empty Slot',
        'runtime.save.action.save': 'Save',
        'runtime.save.action.load': 'Load',
        'runtime.save.action.delete': 'Delete',
        'runtime.vocab.new_word': 'New word: {jp} - {en}',
        'runtime.story_complete.title': 'Story Complete!',
        'runtime.story_complete.time_played': 'Time Played: {time}',
        'runtime.story_complete.words_learned': 'New Words Learned: {count}',
        'runtime.story_complete.praise': 'Great progress!',
        'runtime.story_complete.continue': 'Continue',
        'runtime.story_complete.main_menu': 'Main Menu',
        'runtime.story_complete.next_story': 'Next Story',
        'runtime.story_complete.more_coming': 'Next stories will be continued.',
        'runtime.story_complete.demo_mode': 'Demo mode: only stories up to Story 3 are available.'
    },
    ru: {
        'page.title': 'Tsuzuki Connect — место, где соединяют слова',
        'menu.new_game': 'НОВАЯ ИГРА',
        'menu.continue': 'ПРОДОЛЖИТЬ',
        'menu.chapter_select': 'ВЫБОР ГЛАВЫ',
        'menu.kotoba_log': 'ЖУРНАЛ KOTOBA',
        'menu.settings': 'НАСТРОЙКИ',
        'menu.credits': 'БЛАГОДАРНОСТИ',
        'menu.unlock_title': 'Открыть все истории',
        'menu.unlock_sub': 'Одноразовая покупка · Все 8 глав',
        'menu.subtitle': '言葉でつながる場所',
        'credits.title': 'Благодарности',
        'credits.music': 'Фоновая музыка',
        'credits.backgrounds': 'Фоновые изображения',
        'credits.characters': 'Персонажи',

        'cc.title': 'Создайте персонажа',
        'cc.name': 'Имя',
        'cc.name_placeholder': 'Введите имя...',
        'cc.why': 'Почему вы учите японский?',
        'cc.reason.culture': 'Интерес к японской культуре',
        'cc.reason.work': 'Карьерные возможности',
        'cc.reason.love': 'По зову сердца',
        'cc.reason.adventure': 'Жажда приключений',
        'cc.level': 'Уровень японского',
        'cc.levels.beginner': 'Полный новичок (N5)',
        'cc.levels.some': 'Есть базовые знания (N4)',
        'cc.levels.intermediate': 'Средний уровень (N3)',
        'cc.begin': 'Начать путешествие',

        'game.menu': 'Меню',
        'game.auto': 'Авто',
        'game.skip': 'Пропуск',
        'game.log': 'Журнал',

        'settings.title': 'Настройки',
        'settings.profile.section': 'Профиль',
        'settings.profile.player_name': 'Имя игрока',
        'settings.language.section': 'Язык',
        'settings.language.ui_language': 'Язык интерфейса',
        'settings.language.en': 'English',
        'settings.language.ru': 'Русский',
        'settings.language.zh': '中文',
        'settings.language.ko': '한국어',

        'settings.display.section': 'Экран',
        'settings.display.text_speed': 'Скорость текста',
        'settings.display.speed.slow': 'Медленно',
        'settings.display.speed.medium': 'Средне',
        'settings.display.speed.fast': 'Быстро',
        'settings.display.font_size': 'Размер шрифта',
        'settings.display.font.small': 'Маленький',
        'settings.display.font.medium': 'Средний',
        'settings.display.font.large': 'Большой',

        'settings.support.section': 'Языковая поддержка',
        'settings.support.subtitles': 'Показывать английские субтитры',
        'settings.support.furigana': 'Показывать фуригану',
        'settings.support.furigana_options.all': 'Для всех кандзи',
        'settings.support.furigana_options.uncommon': 'Только для редких',
        'settings.support.furigana_options.off': 'Выключено',

        'settings.audio.section': 'Звук',
        'settings.audio.master': 'Общая громкость',
        'settings.audio.music': 'Громкость музыки',
        'settings.audio.sfx': 'Громкость эффектов',

        'common.close': 'Закрыть',

        'quick_menu.title': 'Меню',
        'quick_menu.save': 'Сохранить',
        'quick_menu.load': 'Загрузить',
        'quick_menu.text_log': 'Журнал текста',
        'quick_menu.kotoba_log': 'Журнал kotoba',
        'quick_menu.settings': 'Настройки',
        'quick_menu.main_menu': 'Главное меню',
        'quick_menu.return': 'Назад',

        'text_log.title': 'Журнал текста',

        'kotoba.title': 'Журнал kotoba 言葉ログ',
        'kotoba.tabs.story': 'По сюжету',
        'kotoba.tabs.category': 'По категориям',
        'kotoba.tabs.level': 'По уровню',

        'lesson.title': 'Класс Танака-сэнсэя',
        'lesson.skip': 'Пропустить урок',
        'lesson.continue': 'Продолжить',

        'runtime.name_required': 'Введите имя',
        'runtime.confirm.return_to_title': 'Вернуться в главное меню? Несохранённый прогресс будет потерян.',
        'runtime.chapter_select_soon': 'Выбор главы скоро появится!',
        'runtime.chapter_select.title': 'Выбор главы',
        'runtime.chapter_select.note': 'Выберите главу, чтобы начать с самого начала.',
        'runtime.chapter_select.chapter': 'Глава',
        'runtime.chapter_select.start': 'Начать',
        'runtime.chapter_select.locked': 'Закрыто',
        'runtime.chapter_select.time': 'Время',
        'runtime.chapter_select.jlpt': 'JLPT',
        'runtime.chapter_select.invalid': 'Выбранная глава недоступна.',
        'runtime.chapter_select.story_limit': 'Сейчас доступна только история до главы {n}.',
        'runtime.saved': 'Игра сохранена!',
        'runtime.confirm.delete_save': 'Удалить это сохранение?',
        'runtime.kotoba.none': 'Пока нет выученных слов!',
        'runtime.scene': 'Сцена',
        'runtime.save.title.save': 'Сохранить игру',
        'runtime.save.title.load': 'Загрузить игру',
        'runtime.save.label.auto': 'Автосохранение',
        'runtime.save.label.slot': 'Слот {n}',
        'runtime.save.empty': 'Пустой слот',
        'runtime.save.action.save': 'Сохранить',
        'runtime.save.action.load': 'Загрузить',
        'runtime.save.action.delete': 'Удалить',
        'runtime.vocab.new_word': 'Новое слово: {jp} — {en}',
        'runtime.story_complete.title': 'История завершена!',
        'runtime.story_complete.time_played': 'Время в игре: {time}',
        'runtime.story_complete.words_learned': 'Новых слов: {count}',
        'runtime.story_complete.praise': 'Отличный прогресс!',
        'runtime.story_complete.continue': 'Продолжить',
        'runtime.story_complete.main_menu': 'Главное меню',
        'runtime.story_complete.next_story': 'Следующая история',
        'runtime.story_complete.more_coming': 'Следующие истории будут продолжены.',
        'runtime.story_complete.demo_mode': 'Демо-режим: доступны только истории до главы 3.'
    },
    zh: {
        'page.title': 'Tsuzuki Connect — 用语言连接的地方',
        'menu.new_game': '新游戏',
        'menu.continue': '继续',
        'menu.chapter_select': '章节选择',
        'menu.kotoba_log': '词汇日志',
        'menu.settings': '设置',
        'menu.credits': '鸣谢',
        'menu.unlock_title': '解锁全部故事',
        'menu.unlock_sub': '一次性购买 · 全部 8 章',
        'menu.subtitle': '言葉でつながる場所',
        'credits.title': '鸣谢',
        'credits.music': '背景音乐',
        'credits.backgrounds': '背景图片',
        'credits.characters': '角色素材',

        'cc.title': '创建角色',
        'cc.name': '姓名',
        'cc.name_placeholder': '输入你的名字…',
        'cc.why': '你为什么学习日语？',
        'cc.reason.culture': '喜欢日本文化',
        'cc.reason.work': '职业机会',
        'cc.reason.love': '跟随内心',
        'cc.reason.adventure': '追寻冒险',
        'cc.level': '日语水平',
        'cc.levels.beginner': '完全初学者 (N5)',
        'cc.levels.some': '有一定基础 (N4)',
        'cc.levels.intermediate': '中级 (N3)',
        'cc.begin': '开始旅程',

        'game.menu': '菜单',
        'game.auto': '自动',
        'game.skip': '跳过',
        'game.log': '日志',

        'settings.title': '设置',
        'settings.profile.section': '个人资料',
        'settings.profile.player_name': '玩家名称',
        'settings.language.section': '语言',
        'settings.language.ui_language': '界面语言',
        'settings.language.en': 'English',
        'settings.language.ru': 'Русский',
        'settings.language.zh': '中文',
        'settings.language.ko': '한국어',

        'settings.display.section': '显示',
        'settings.display.text_speed': '文字速度',
        'settings.display.speed.slow': '慢',
        'settings.display.speed.medium': '中',
        'settings.display.speed.fast': '快',
        'settings.display.font_size': '字体大小',
        'settings.display.font.small': '小',
        'settings.display.font.medium': '中',
        'settings.display.font.large': '大',

        'settings.support.section': '语言辅助',
        'settings.support.subtitles': '显示英文字幕',
        'settings.support.furigana': '显示注音（Furigana）',
        'settings.support.furigana_options.all': '全部汉字',
        'settings.support.furigana_options.uncommon': '仅生僻汉字',
        'settings.support.furigana_options.off': '关闭',

        'settings.audio.section': '音频',
        'settings.audio.master': '主音量',
        'settings.audio.music': '音乐音量',
        'settings.audio.sfx': '音效音量',

        'common.close': '关闭',

        'quick_menu.title': '菜单',
        'quick_menu.save': '保存',
        'quick_menu.load': '读取',
        'quick_menu.text_log': '文本记录',
        'quick_menu.kotoba_log': '词汇日志',
        'quick_menu.settings': '设置',
        'quick_menu.main_menu': '主菜单',
        'quick_menu.return': '返回',

        'text_log.title': '文本记录',

        'kotoba.title': '词汇日志 言葉ログ',
        'kotoba.tabs.story': '按剧情',
        'kotoba.tabs.category': '按类别',
        'kotoba.tabs.level': '按等级',

        'lesson.title': '田中老师的课堂',
        'lesson.skip': '跳过课程',
        'lesson.continue': '继续',

        'runtime.name_required': '请先输入你的名字',
        'runtime.confirm.return_to_title': '返回标题画面？未保存的进度将丢失。',
        'runtime.chapter_select_soon': '章节选择即将推出！',
        'runtime.chapter_select.title': '章节选择',
        'runtime.chapter_select.note': '选择一个章节并从开头开始。',
        'runtime.chapter_select.chapter': '章节',
        'runtime.chapter_select.start': '开始',
        'runtime.chapter_select.locked': '未解锁',
        'runtime.chapter_select.time': '时长',
        'runtime.chapter_select.jlpt': 'JLPT',
        'runtime.chapter_select.invalid': '所选章节不可用。',
        'runtime.chapter_select.story_limit': '当前仅开放到故事 {n}。',
        'runtime.saved': '已保存！',
        'runtime.confirm.delete_save': '删除这个存档？',
        'runtime.kotoba.none': '还没有学到任何词汇！',
        'runtime.scene': '场景',
        'runtime.save.title.save': '保存游戏',
        'runtime.save.title.load': '读取游戏',
        'runtime.save.label.auto': '自动存档',
        'runtime.save.label.slot': '存档位 {n}',
        'runtime.save.empty': '空存档位',
        'runtime.save.action.save': '保存',
        'runtime.save.action.load': '读取',
        'runtime.save.action.delete': '删除',
        'runtime.vocab.new_word': '新词：{jp} - {en}',
        'runtime.story_complete.title': '故事完成！',
        'runtime.story_complete.time_played': '游玩时间：{time}',
        'runtime.story_complete.words_learned': '新学词汇：{count}',
        'runtime.story_complete.praise': '进步很棒！',
        'runtime.story_complete.continue': '继续',
        'runtime.story_complete.main_menu': '主菜单',
        'runtime.story_complete.next_story': '下一章故事',
        'runtime.story_complete.more_coming': '后续故事将继续更新。',
        'runtime.story_complete.demo_mode': '演示模式：目前仅开放到故事 3。'
    },
    ko: {
        'page.title': 'Tsuzuki Connect — 말로 이어지는 곳',
        'menu.new_game': '새 게임',
        'menu.continue': '이어하기',
        'menu.chapter_select': '챕터 선택',
        'menu.kotoba_log': '코토바 로그',
        'menu.settings': '설정',
        'menu.credits': '크레딧',
        'menu.unlock_title': '모든 스토리 해제',
        'menu.unlock_sub': '일회 구매 · 전 8 챕터',
        'menu.subtitle': '言葉でつながる場所',
        'credits.title': '크레딧',
        'credits.music': '배경 음악',
        'credits.backgrounds': '배경 이미지',
        'credits.characters': '캐릭터',

        'cc.title': '캐릭터 만들기',
        'cc.name': '이름',
        'cc.name_placeholder': '이름을 입력하세요...',
        'cc.why': '왜 일본어를 배우고 있나요?',
        'cc.reason.culture': '일본 문화에 관심이 있어요',
        'cc.reason.work': '커리어 기회',
        'cc.reason.love': '마음이 이끄는 대로',
        'cc.reason.adventure': '모험을 찾아서',
        'cc.level': '일본어 수준',
        'cc.levels.beginner': '완전 초보자 (N5)',
        'cc.levels.some': '기초 지식 있음 (N4)',
        'cc.levels.intermediate': '중급 (N3)',
        'cc.begin': '여정 시작',

        'game.menu': '메뉴',
        'game.auto': '자동',
        'game.skip': '넘기기',
        'game.log': '로그',

        'settings.title': '설정',
        'settings.profile.section': '프로필',
        'settings.profile.player_name': '플레이어 이름',
        'settings.language.section': '언어',
        'settings.language.ui_language': 'UI 언어',
        'settings.language.en': 'English',
        'settings.language.ru': 'Русский',
        'settings.language.zh': '中文',
        'settings.language.ko': '한국어',

        'settings.display.section': '화면',
        'settings.display.text_speed': '텍스트 속도',
        'settings.display.speed.slow': '느림',
        'settings.display.speed.medium': '보통',
        'settings.display.speed.fast': '빠름',
        'settings.display.font_size': '글꼴 크기',
        'settings.display.font.small': '작게',
        'settings.display.font.medium': '보통',
        'settings.display.font.large': '크게',

        'settings.support.section': '언어 지원',
        'settings.support.subtitles': '영어 자막 표시',
        'settings.support.furigana': '후리가나 표시',
        'settings.support.furigana_options.all': '모든 한자',
        'settings.support.furigana_options.uncommon': '어려운 한자만',
        'settings.support.furigana_options.off': '끔',

        'settings.audio.section': '오디오',
        'settings.audio.master': '전체 볼륨',
        'settings.audio.music': '음악 볼륨',
        'settings.audio.sfx': '효과음 볼륨',

        'common.close': '닫기',

        'quick_menu.title': '메뉴',
        'quick_menu.save': '저장',
        'quick_menu.load': '불러오기',
        'quick_menu.text_log': '텍스트 로그',
        'quick_menu.kotoba_log': '코토바 로그',
        'quick_menu.settings': '설정',
        'quick_menu.main_menu': '메인 메뉴',
        'quick_menu.return': '돌아가기',

        'text_log.title': '텍스트 로그',

        'kotoba.title': '코토바 로그 言葉ログ',
        'kotoba.tabs.story': '스토리별',
        'kotoba.tabs.category': '카테고리별',
        'kotoba.tabs.level': '레벨별',

        'lesson.title': '다나카 선생님의 교실',
        'lesson.skip': '수업 건너뛰기',
        'lesson.continue': '계속',

        'runtime.name_required': '이름을 입력해 주세요',
        'runtime.confirm.return_to_title': '타이틀로 돌아갈까요? 저장하지 않은 진행 상황은 사라집니다.',
        'runtime.chapter_select_soon': '챕터 선택은 곧 추가됩니다!',
        'runtime.chapter_select.title': '챕터 선택',
        'runtime.chapter_select.note': '챕터를 선택해 처음부터 시작하세요.',
        'runtime.chapter_select.chapter': '챕터',
        'runtime.chapter_select.start': '시작',
        'runtime.chapter_select.locked': '잠김',
        'runtime.chapter_select.time': '플레이 시간',
        'runtime.chapter_select.jlpt': 'JLPT',
        'runtime.chapter_select.invalid': '선택한 챕터를 열 수 없습니다.',
        'runtime.chapter_select.story_limit': '현재는 스토리 {n}까지만 이용할 수 있습니다.',
        'runtime.saved': '저장했어요!',
        'runtime.confirm.delete_save': '이 저장 데이터를 삭제할까요?',
        'runtime.kotoba.none': '아직 배운 단어가 없어요!',
        'runtime.scene': '장면',
        'runtime.save.title.save': '게임 저장',
        'runtime.save.title.load': '게임 불러오기',
        'runtime.save.label.auto': '자동 저장',
        'runtime.save.label.slot': '{n}번 슬롯',
        'runtime.save.empty': '빈 슬롯',
        'runtime.save.action.save': '저장',
        'runtime.save.action.load': '불러오기',
        'runtime.save.action.delete': '삭제',
        'runtime.vocab.new_word': '새 단어: {jp} - {en}',
        'runtime.story_complete.title': '스토리 완료!',
        'runtime.story_complete.time_played': '플레이 시간: {time}',
        'runtime.story_complete.words_learned': '새로 배운 단어: {count}',
        'runtime.story_complete.praise': '정말 잘하고 있어요!',
        'runtime.story_complete.continue': '계속',
        'runtime.story_complete.main_menu': '메인 메뉴',
        'runtime.story_complete.next_story': '다음 스토리',
        'runtime.story_complete.more_coming': '다음 스토리는 계속됩니다.',
        'runtime.story_complete.demo_mode': '데모 모드: 현재는 스토리 3까지만 이용할 수 있습니다.'
    }
};

export class I18n {
    constructor({ translations = UI_TRANSLATIONS, defaultLanguage = 'en' } = {}) {
        this.translations = {};
        this.mergeTranslations(translations);

        // Handle categorized story translations
        if (STORY_TRANSLATIONS) {
            Object.values(STORY_TRANSLATIONS).forEach(group => {
                this.mergePivotedTranslations(group);
            });
        }

        this.defaultLanguage = defaultLanguage;
        this.language = defaultLanguage;
    }

    mergeTranslations(other) {
        if (!other) return;
        for (const [lang, keys] of Object.entries(other)) {
            if (!this.translations[lang]) {
                this.translations[lang] = {};
            }
            Object.assign(this.translations[lang], keys);
        }
    }

    mergePivotedTranslations(pivoted) {
        if (!pivoted) return;
        for (const [key, langs] of Object.entries(pivoted)) {
            for (const [lang, text] of Object.entries(langs)) {
                if (!this.translations[lang]) {
                    this.translations[lang] = {};
                }
                this.translations[lang][key] = text;
            }
        }
    }

    setLanguage(language) {
        if (!language) return;
        if (this.translations[language]) {
            this.language = language;
        } else {
            this.language = this.defaultLanguage;
        }
    }

    getLanguage() {
        return this.language;
    }

    t(key, vars = null) {
        const langTable = this.translations[this.language] || {};
        const fallbackTable = this.translations[this.defaultLanguage] || {};

        let value = langTable[key] ?? fallbackTable[key] ?? key;
        if (vars && typeof value === 'string') {
            for (const [varName, varValue] of Object.entries(vars)) {
                value = value.replaceAll(`{${varName}}`, String(varValue));
            }
        }
        return value;
    }

    tForLanguage(language, key, vars = null) {
        if (!language || !key) return key;
        const table = this.translations[language] || {};
        let value = table[key];
        if (value === undefined || value === null) return key;
        if (vars && typeof value === 'string') {
            for (const [varName, varValue] of Object.entries(vars)) {
                value = value.replaceAll(`{${varName}}`, String(varValue));
            }
        }
        return value;
    }

    hasTranslation(language, key) {
        return Boolean(language && key && this.translations[language] && this.translations[language][key] !== undefined);
    }

    findKeyByLocalizedText(text) {
        if (!text || typeof text !== 'string') return null;
        const langTable = this.translations[this.language] || {};
        for (const [key, value] of Object.entries(langTable)) {
            if (value === text) return key;
        }
        const fallbackTable = this.translations[this.defaultLanguage] || {};
        for (const [key, value] of Object.entries(fallbackTable)) {
            if (value === text) return key;
        }
        return null;
    }

    applyToDom(root = document) {
        root.querySelectorAll('[data-i18n]').forEach(el => {
            const key = el.getAttribute('data-i18n');
            if (key) el.textContent = this.t(key);
        });

        root.querySelectorAll('[data-i18n-placeholder]').forEach(el => {
            const key = el.getAttribute('data-i18n-placeholder');
            if (key) el.setAttribute('placeholder', this.t(key));
        });

        root.querySelectorAll('[data-i18n-title]').forEach(el => {
            const key = el.getAttribute('data-i18n-title');
            if (key) el.setAttribute('title', this.t(key));
        });

        root.querySelectorAll('[data-i18n-aria-label]').forEach(el => {
            const key = el.getAttribute('data-i18n-aria-label');
            if (key) el.setAttribute('aria-label', this.t(key));
        });

        document.documentElement.lang = this.getHtmlLang();
        document.title = this.t('page.title');
    }

    getHtmlLang() {
        switch (this.language) {
            case 'ru':
                return 'ru';
            case 'zh':
                return 'zh-Hans';
            case 'ko':
                return 'ko';
            case 'en':
            default:
                return 'en';
        }
    }
}

/**
 * Lightweight translation helper for story modules.
 * Uses the global i18n instance initialized in main.js when available.
 */
export function tr(key, vars = null) {
    if (!key) return '';
    const i18n = (typeof window !== 'undefined' && window.i18n) ? window.i18n : null;
    if (i18n && typeof i18n.t === 'function') {
        return i18n.t(key, vars);
    }
    return key;
}
