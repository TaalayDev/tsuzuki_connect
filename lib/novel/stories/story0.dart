import '../dialogue_builder.dart';
import 'story_vocabulary.dart';

StoryData getStory0() => dialogue()
    .story(0, tr("s0.title"), tr("s0.subtitle"))
    .description(tr("s0.desc"))
    .estimatedTime("45-60 minutes")
    .jlptFocus("N5")
    .vocabularyList(story0Vocabulary)
    // ============================================
    // SCENE 1: Walking to School
    // ============================================
    .scene("scene1", "opening")
    .music("classroom")
    .street("morning")
    .n(tr("s0.s1.morning_air"))
    .n(tr("s0.s1.cherry_blossoms"))
    .effect("cherry-blossoms")
    .n(tr("s0.s1.first_day"))
    .n(tr("s0.s1.dream"))
    .n(tr("s0.s1.directions"))
    .n(tr("s0.s1.around_corner"))
    // Player thoughts
    .think(tr("s0.s1.think_early"), "thinking")
    .think(tr("s0.s1.think_others"), "neutral")
    .n(tr("s0.s1.building_view"))
    .n(tr("s0.s1.sign"))
    .vocab("日本語学校", "にほんごがっこう", "nihongo gakkou", "Japanese language school", {
      'category': "places",
    })
    .think(tr("s0.s1.think_no_back"), "happy")
    .jump("classroom_entrance")
    // ============================================
    // SCENE 2: Entering the Classroom
    // ============================================
    .scene("scene2", "classroom_entrance")
    .classroom("morning")
    .stopEffect()
    .n(tr("s0.s2.push_door"))
    .n(tr("s0.s2.sunlight"))
    .n(tr("s0.s2.chalkboard"))
    .n(tr("s0.s2.smell"))
    .n(tr("s0.s2.first_arrive"))
    // Ken enters
    .show("ken", "left", "happy")
    .n(tr("s0.s2.ken_desc"))
    .ken(tr("s0.s2.ken_greeting"), "happy")
    .menu()
    .choice(tr("s0.s2.choice.sure"), "ken_friendly")
    .choice(tr("s0.s2.choice.okay"), "ken_shy")
    .endMenu()
    // ============================================
    // SCENE 2A: Friendly response to Ken
    // ============================================
    .scene("scene2a", "ken_friendly")
    .show("player", "right", "happy")
    .player(tr("s0.s2a.player_reply"), "happy")
    .ken(tr("s0.s2a.ken_reply"), "happy")
    .n(tr("s0.s2a.seat"))
    .ken(tr("s0.s2a.ken_name"), "neutral")
    .vocab("初めまして", "はじめまして", "hajimemashite", "Nice to meet you", {
      'category': "greetings",
    })
    .ken(tr("s0.s2a.ken_hajimemashite"), "happy")
    .befriend("ken", "Friendly introduction")
    .jump("mei_entrance")
    // ============================================
    // SCENE 2B: Shy response to Ken
    // ============================================
    .scene("scene2b", "ken_shy")
    .show("player", "right", "embarrassed")
    .player(tr("s0.s2b.player_reply"), "embarrassed")
    .n(tr("s0.s2b.seat"))
    .ken(tr("s0.s2b.ken_reassurance"), "happy")
    .ken(tr("s0.s2b.ken_beginner"), "neutral")
    .vocab("大丈夫", "だいじょうぶ", "daijoubu", "It's okay / All right", {
      'category': "phrases",
    })
    .ken(tr("s0.s2b.ken_daijoubu"), "happy")
    .n(tr("s0.s2b.relax"))
    .jump("mei_entrance")
    // ============================================
    // SCENE 3: Mei's Entrance
    // ============================================
    .scene("scene3", "mei_entrance")
    .n(tr("s0.s3.mei_enter"))
    .show("mei", "center", "neutral")
    .n(tr("s0.s3.mei_desc"))
    .mei(tr("s0.s3.mei_silent"), "neutral")
    .n(tr("s0.s3.mei_nod"))
    .ken(tr("s0.s3.ken_intense"), "thinking")
    .ken(tr("s0.s3.ken_programmer"), "neutral")
    .express("mei", "thinking")
    .n(tr("s0.s3.mei_sensing"))
    .express("mei", "neutral")
    .n(tr("s0.s3.mei_smile"))
    .jump("yuki_entrance")
    // ============================================
    // SCENE 4: Yuki's Entrance
    // ============================================
    .scene("scene4", "yuki_entrance")
    .n(tr("s0.s4.trickle"))
    .n(tr("s0.s4.burst"))
    .show("yuki", "right", "happy")
    .yuki(tr("s0.s4.yuki_late"), "happy")
    .n(tr("s0.s4.yuki_desc"))
    .n(tr("s0.s4.yuki_bag"))
    .ken(tr("s0.s4.ken_nope"), "happy")
    .yuki(tr("s0.s4.yuki_relief"), "happy")
    .yuki(tr("s0.s4.yuki_anime"), "embarrassed")
    .noun("アニメ", null, "anime", "Anime / Animation", "daily-life")
    .yuki(tr("s0.s4.yuki_intro"), "happy")
    .n(tr("s0.s4.yuki_sit"))
    .yuki(tr("s0.s4.yuki_excited"), "happy")
    .ken(tr("s0.s4.ken_same"), "neutral")
    .yuki(tr("s0.s4.yuki_reason"), "happy")
    .yuki(tr("s0.s4.yuki_ask"), "neutral")
    .menu()
    .choice(tr("s0.s4.choice.media"), "reason_media")
    .choice(tr("s0.s4.choice.travel"), "reason_travel")
    .choice(tr("s0.s4.choice.career"), "reason_career")
    .endMenu()
    // ============================================
    // SCENE 4A: Media reason
    // ============================================
    .scene("scene4a", "reason_media")
    .player(tr("s0.s4a.player"), "happy")
    .yuki(tr("s0.s4a.yuki"), "happy")
    .befriend("yuki", "Shared interests")
    .ken(tr("s0.s4a.ken"), "happy")
    .jump("tanaka_entrance")
    // ============================================
    // SCENE 4B: Travel reason
    // ============================================
    .scene("scene4b", "reason_travel")
    .player(tr("s0.s4b.player"), "neutral")
    .ken(tr("s0.s4b.ken"), "happy")
    .yuki(tr("s0.s4b.yuki"), "happy")
    .jump("tanaka_entrance")
    // ============================================
    // SCENE 4C: Career reason
    // ============================================
    .scene("scene4c", "reason_career")
    .player(tr("s0.s4c.player"), "neutral")
    .show("mei", "center", "thinking")
    .n(tr("s0.s4c.notice_mei"))
    .ken(tr("s0.s4c.ken"), "neutral")
    .befriend("mei", "Pragmatic outlook")
    .jump("tanaka_entrance")
    // ============================================
    // SCENE 5: Tanaka-sensei's Entrance
    // ============================================
    .scene("scene5", "tanaka_entrance")
    .music("classroom", true)
    .n(tr("s0.s5.door_open"))
    .hideAll()
    .show("tanaka", "center", "happy")
    .n(tr("s0.s5.tanaka_enter"))
    .n(tr("s0.s5.tanaka_desc"))
    .n(tr("s0.s5.tanaka_vibe"))
    .tanaka(tr("s0.s5.tanaka_greeting_jp"), "happy")
    .greeting("おはようございます", null, "ohayou gozaimasu", "Good morning (polite)")
    .n(tr("s0.s5.quiet"))
    .tanaka(tr("s0.s5.tanaka_understand"), "happy")
    .tanaka(tr("s0.s5.tanaka_intro"), "neutral")
    .tanaka(tr("s0.s5.call_me_sensei"), "happy")
    .vocab("先生", "せんせい", "sensei", "Teacher", {'category': "classroom"})
    .tanaka(tr("s0.s5.welcome"), "happy")
    .tanaka(tr("s0.s5.journey"), "neutral")
    .tanaka(tr("s0.s5.promise"), "happy")
    .jump("introductions")
    // ============================================
    // SCENE 6: Introductions
    // ============================================
    .scene("scene6", "introductions")
    .tanaka(tr("s0.s6.start_intro"), "happy")
    .n(tr("s0.s6.murmur"))
    .tanaka(tr("s0.s6.dont_worry"), "happy")
    .tanaka(tr("s0.s6.teach_intro"), "neutral")
    .tanaka(tr("s0.s6.hajimemashite"), "neutral")
    .tanaka(tr("s0.s6.watashi"), "neutral")
    .vocab("私", "わたし", "watashi", "I / me", {'category': "daily-life"})
    .tanaka(tr("s0.s6.finish"), "neutral")
    .tanaka(tr("s0.s6.yoroshiku_phrase"), "neutral")
    .greeting(
      "よろしくお願いします",
      "よろしくおねがいします",
      "yoroshiku onegaishimasu",
      "Please be kind to me / Nice to meet you",
    )
    .say("tanaka", tr("s0.s6.culture"), "neutral")
    .tanaka(tr("s0.s6.demo"), "happy")
    .tanaka(tr("s0.s6.tanaka_demo"), "neutral")
    .n(tr("s0.s6.bow"))
    .tanaka(tr("s0.s6.who_next"), "happy")
    .n(tr("s0.s6.silence"))
    .ken(tr("s0.s6.ken_vol"), "happy")
    .show("ken", "left", "neutral")
    .ken(tr("s0.s6.ken_intro"), "happy")
    .tanaka(tr("s0.s6.subarashii"), "happy")
    .yuki(tr("s0.s6.yuki_vol"), "happy")
    .show("yuki", "right", "happy")
    .yuki(tr("s0.s6.yuki_intro"), "happy")
    .tanaka(tr("s0.s6.excellent"), "happy")
    .hide("tanaka")
    .show("mei", "center", "neutral")
    .mei(tr("s0.s6.mei_intro"), "neutral")
    .hide("mei")
    .show("tanaka", "center", "happy")
    .tanaka(tr("s0.s6.beautiful"), "happy")
    .hide("tanaka")
    .show("mei", "center", "neutral")
    .mei(tr("s0.s6.mei_reply"), "neutral")
    .hide("mei")
    .show("tanaka", "center", "happy")
    .tanaka(tr("s0.s6.how_about_you"), "happy")
    .n(tr("s0.s6.tanaka_encouraging"))
    .tanaka(tr("s0.s6.no_pressure"), "happy")
    .menu()
    .choice(tr("s0.s6.choice.confident"), "intro_confident")
    .choice(tr("s0.s6.choice.nervous"), "intro_nervous")
    .endMenu()
    // ============================================
    // SCENE 6A: Confident Introduction
    // ============================================
    .scene("scene6a", "intro_confident")
    .player(tr("s0.s6a.player"), "happy")
    .tanaka(tr("s0.s6a.tanaka"), "happy")
    .befriend("tanaka", "Confident first attempt")
    // .effect("sparkle")
    .jump("first_lesson")
    // ============================================
    // SCENE 6B: Nervous Introduction
    // ============================================
    .scene("scene6b", "intro_nervous")
    .player(tr("s0.s6b.player1"), "embarrassed")
    .player(tr("s0.s6b.player2"), "embarrassed")
    .tanaka(tr("s0.s6b.tanaka1"), "happy")
    .tanaka(tr("s0.s6b.tanaka2"), "happy")
    .befriend("tanaka", "Tanaka appreciates your effort")
    .jump("first_lesson")
    // ============================================
    // SCENE 7: First Lesson
    // ============================================
    .scene("scene7", "first_lesson")
    .n(tr("s0.s7.chalkboard"))
    .tanaka(tr("s0.s7.phrases"), "happy")
    .tanaka(tr("s0.s7.arigatou"), "neutral")
    .greeting("ありがとうございます", null, "arigatou gozaimasu", "Thank you (polite)")
    .tanaka(tr("s0.s7.usage"), "happy")
    .yuki(tr("s0.s7.yuki_try"), "happy")
    .tanaka(tr("s0.s7.correction"), "happy")
    .tanaka(tr("s0.s7.example"), "happy")
    .tanaka(tr("s0.s7.sumimasen"), "neutral")
    .greeting("すみません", null, "sumimasen", "Excuse me / I'm sorry")
    .tanaka(tr("s0.s7.versatile"), "neutral")
    .ken(tr("s0.s7.ken_ask"), "surprised")
    .tanaka(tr("s0.s7.explanation"), "happy")
    .mei(tr("s0.s7.mei_comment"), "thinking")
    .jump("class_practice")
    // ============================================
    // SCENE 8: Class Practice
    // ============================================
    .scene("scene8", "class_practice")
    .tanaka(tr("s0.s8.tanaka_start"), "happy")
    .tanaka(tr("s0.s8.tanaka_pair"), "neutral")
    .n(tr("s0.s8.ken_yuki_awkward"))
    .tanaka(tr("s0.s8.tanaka_instruct"), "happy")
    .ken(tr("s0.s8.ken_try"), "neutral")
    .yuki(tr("s0.s8.yuki_reply"), "happy")
    .tanaka(tr("s0.s8.tanaka_douzo"), "happy")
    .greeting("どうぞ", null, "douzo", "Please / Go ahead")
    .n(tr("s0.s8.practice_fade"))
    .n(tr("s0.s8.mei_relax"))
    .jump("class_end")
    // ============================================
    // SCENE 9: End of Class
    // ============================================
    .scene("scene9", "class_end")
    .n(tr("s0.s9.time_flies"))
    .tanaka(tr("s0.s9.tanaka_end"), "happy")
    .tanaka(tr("s0.s9.practice"), "happy")
    .tanaka(tr("s0.s9.one_more"), "neutral")
    .tanaka(tr("s0.s9.ganbatte_phrase"), "happy")
    .verb("頑張る", "がんばる", "ganbaru", "To do one's best")
    .tanaka(tr("s0.s9.special"), "happy")
    .tanaka(tr("s0.s9.short_story"), "neutral")
    .tanaka(tr("s0.s9.context"), "happy")
    .tanaka(tr("s0.s9.believe"), "happy")
    .n(tr("s0.s9.bow"))
    .jump("after_class")
    // ============================================
    // SCENE 10: After Class
    // ============================================
    .scene("scene10", "after_class")
    .n(tr("s0.s10.packing"))
    .ken(tr("s0.s10.ken_fun"), "happy")
    .yuki(tr("s0.s10.yuki_nice"), "happy")
    .ken(tr("s0.s10.ken_invite"), "neutral")
    .yuki(tr("s0.s10.yuki_study"), "happy")
    .hide("tanaka")
    .show("mei", "center", "neutral")
    .n(tr("s0.s10.mei_pause"))
    .ken(tr("s0.s10.ken_invite_mei"), "happy")
    .mei(tr("s0.s10.mei_work"), "neutral")
    .ken(tr("s0.s10.ken_bad"), "neutral")
    .mei(tr("s0.s10.mei_maybe"), "neutral")
    .n(tr("s0.s10.mei_smile"))
    .yuki(tr("s0.s10.yuki_ask"), "happy")
    .menu()
    .choice(tr("s0.s10.choice.go"), "cafe_yes")
    .choice(tr("s0.s10.choice.skip"), "cafe_no")
    .endMenu()
    // ============================================
    // SCENE 10A: Go to Cafe
    // ============================================
    .scene("scene10a", "cafe_yes")
    .hide("tanaka")
    .hide("mei")
    .player(tr("s0.s10a.player"), "happy")
    .ken(tr("s0.s10a.ken"), "happy")
    .yuki(tr("s0.s10a.yuki"), "happy")
    .befriend("ken", "Accepting social invitation")
    .befriend("yuki", "Accepting social invitation")
    .music("cafe", true)
    .cafe("afternoon")
    .n(tr("s0.s10a.walk"))
    .n(tr("s0.s10a.cafe_desc"))
    .vocab("カフェ", null, "kafe", "Cafe", {'category': "places"})
    .ken(tr("s0.s10a.ken_matcha"), "happy")
    .yuki(tr("s0.s10a.yuki_order"), "happy")
    .ken(tr("s0.s10a.ken_staff"), "happy")
    .yuki(tr("s0.s10a.yuki_details"), "happy")
    .n(tr("s0.s10a.chat"))
    .n(tr("s0.s10a.ken_talk"))
    .n(tr("s0.s10a.yuki_talk"))
    .n(tr("s0.s10a.friends"))
    .jump("ending")
    // ============================================
    // SCENE 10B: Go Home
    // ============================================
    .scene("scene10b", "cafe_no")
    .player(tr("s0.s10b.player"), "neutral")
    .ken(tr("s0.s10b.ken"), "happy")
    .yuki(tr("s0.s10b.yuki"), "happy")
    .player(tr("s0.s10b.player_promise"), "happy")
    .street("afternoon")
    .n(tr("s0.s10b.wave"))
    .n(tr("s0.s10b.practice_head"))
    .think(tr("s0.s10b.think_practice"))
    .n(tr("s0.s10b.feels_good"))
    .jump("ending")
    // ============================================
    // SCENE 11: Ending
    // ============================================
    .scene("scene11", "ending")
    .hideAll()
    .apartment("evening")
    .music("emotional", true)
    .n(tr("s0.s11.evening"))
    .n(tr("s0.s11.notebook"))
    .think(tr("s0.s11.think_good"), "happy")
    .think(tr("s0.s11.think_friends"), "happy")
    .think(tr("s0.s11.think_mei"), "thinking")
    .n(tr("s0.s11.practice_writing"))
    .vocab("勉強", "べんきょう", "benkyou", "Study", {'category': "classroom"})
    .think(tr("s0.s11.think_benkyou"), "happy")
    .think(tr("s0.s11.think_ganbarimasu"), "happy")
    .n(tr("s0.s11.stars"))
    .n(tr("s0.s11.beginning"))
    .n(tr("s0.s11.wonderful"))
    .n(tr("s0.s11.separator"))
    .n(tr("s0.s11.complete"))
    .n(tr("s0.s11.separator"))
    .hideAll()
    .end()
    .build();
