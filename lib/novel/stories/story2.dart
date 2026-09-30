import '../dialogue_builder.dart';

// Vocabulary list for Story 2
final story2Vocabulary = <StoryWord>[
  // NOTE: Keep schema aligned with KotobaLog entries (japanese/reading/romaji/english/category)
  word("祖母", "そぼ", "sobo", "Grandmother (formal)", {'category': "family"}),
  word("祖父", "そふ", "sofu", "Grandfather (formal)", {'category': "family"}),
  word("おばあちゃん", null, "obaachan", "Grandma (casual)", {'category': "family"}),
  word("おじいちゃん", null, "ojiichan", "Grandpa (casual)", {'category': "family"}),
  word("庭", "にわ", "niwa", "Garden", {'category': "places"}),
  word("種", "たね", "tane", "Seed(s)", {'category': "garden"}),
  word("土", "つち", "tsuchi", "Soil/Earth", {'category': "garden"}),
  word("水", "みず", "mizu", "Water", {'category': "basic"}),
  word("花", "はな", "hana", "Flower", {'category': "garden"}),
  word("野菜", "やさい", "yasai", "Vegetables", {'category': "food"}),
  word("暑い", "あつい", "atsui", "Hot (weather)", {'category': "weather"}),
  word("疲れる", "つかれる", "tsukareru", "To be tired", {'category': "state"}),
  word("大丈夫", "だいじょうぶ", "daijoubu", "It's okay/alright", {
    'category': "phrases",
  }),
  word("心", "こころ", "kokoro", "Heart/Spirit", {'category': "emotions"}),
  word("届く", "とどく", "todoku", "To reach/arrive", {'category': "verbs"}),
];

StoryData getStory2() => dialogue()
    .story(2, tr("s2.title"), tr("s2.subtitle"))
    .description(tr("s2.desc"))
    .estimatedTime("60-75 minutes")
    .jlptFocus("N5-N4")
    .vocabularyList(story2Vocabulary)
    // ============================================
    // PROLOGUE: On the Plane
    // ============================================
    .scene("prologue", "on_plane")
    .titleCard(tr("s2.card_title"), tr("s2.card_subtitle"))
    .music("sad")
    .bg("train", "afternoon") // Using train as plane substitute
    .n(tr("s2.s0.turbulence"))
    .n(tr("s2.s0.announcer"))
    .think(tr("s2.s0.think_not_ready"), "worried")
    .n(tr("s2.s0.phone_screen"))
    .n(tr("s2.s0.mom_msg1"))
    .n(tr("s2.s0.mom_msg2"))
    .think(tr("s2.s0.think_should_have"), "sad")
    .n(tr("s2.s0.think_last_time"))
    .think(tr("s2.s0.think_smiled"), "embarrassed")
    .n(tr("s2.s0.app_practice"))
    .think(tr("s2.s0.think_too_late"), "sad")
    .jump("rural_station")
    // ============================================
    // SCENE 1: Arrival at Rural Station
    // ============================================
    .scene("scene1", "rural_station")
    .bg("station", "afternoon")
    .n(tr("s2.s1.rural_station"))
    .n(tr("s2.s1.rural_station_quiet"))
    .vocab("駅", "えき", "eki", "Station", {'category': "places"})
    .n(tr("s2.s1.cicadas"))
    .n(tr("s2.s1.grandfather_appearance"))
    .show("grandfather", "center", "silhouette")
    .n(tr("s2.s1.wave_suitcase"))
    .n(tr("s2.s1.grandfather_nods"))
    .n(tr("s2.s1.greeting_recall"))
    .vocab("こんにちは", null, "konnichiwa", "Hello/Good afternoon", {
      'category': "greetings",
    })
    .vocab("おじいちゃん", null, "ojiichan", "Grandpa (casual)", {
      'category': "family",
    })
    .player(tr("s2.s1.player_greeting"), "nervous")
    .say("grandfather", tr("s2.s1.grandfather_un"), "neutral") // Grandfather
    .n(tr("s2.s1.grandfather_takes_suitcase"))
    .think(tr("s2.s1.think_great_start"), "embarrassed")
    .hide("grandfather")
    .jump("truck_ride")
    // ============================================
    // SCENE 2: Drive to the House
    // ============================================
    .scene("scene2", "truck_ride")
    .bg("street", "afternoon")
    .n(tr("s2.s2.truck_ancient"))
    .n(tr("s2.s2.rice_fields"))
    .n(tr("s2.s2.silence"))
    .n(tr("s2.s2.try_conversation"))
    .vocab("暑い", "あつい", "atsui", "Hot (weather)", {'category': "weather"})
    .player(tr("s2.s2.player_hot"), "nervous")
    .say("grandfather", tr("s2.s2.grandfather_response"), "neutral")
    .n(tr("s2.s2.more_silence"))
    .vocab("おばあちゃん", null, "obaachan", "Grandma (casual)", {
      'category': "family",
    })
    .player(tr("s2.s2.player_ask_obaachan"), "worried")
    .n(tr("s2.s2.grandfather_tense"))
    .vocab("疲れている", "つかれている", "tsukareteiru", "Tired/exhausted", {
      'category': "state",
    })
    .say("grandfather", tr("s2.s2.grandfather_tired"), "neutral")
    .think(tr("s2.s2.think_fails"), "sad")
    .jump("traditional_house")
    // ============================================
    // SCENE 3: Grandmother's Room
    // ============================================
    .scene("scene3", "traditional_house")
    .bg("sitting_room", "afternoon")
    .n(tr("s2.s3.house_traditional"))
    .n(tr("s2.s3.voices_inside"))
    .n(tr("s2.s3.remove_shoes"))
    .show("mom", "center", "concerned") // Using Mei's silhouette for mom
    .n(tr("s2.s3.mom_appears"))
    .say("mom", tr("s2.s3.mom_glad"), "gentle")
    .say("mom", tr("s2.s3.mom_resting"), "serious")
    .player(tr("s2.s3.player_when"), "worried")
    .say("mom", tr("s2.s3.mom_soon"), "gentle")
    .n(tr("s2.s3.guilt_wash"))
    .say("mom", tr("s2.s3.mom_happy"), "happy")
    .hide("mom")
    .jump("first_meeting")
    // ============================================
    // SCENE 4: First Meeting with Grandmother
    // ============================================
    .scene("scene4", "first_meeting")
    .bg("futon_room", "afternoon")
    .n(tr("s2.s4.shoji_open"))
    .n(tr("s2.s4.grandmother_frail"))
    .show(
      "grandmother",
      "center",
      "silhouette",
    ) // Using Tanaka silhouette for grandmother
    .n(tr("s2.s4.eyes_open"))
    .vocab("花", "はな", "hana", "Flower (also a name)", {'category': "nature"})
    .say("grandmother", tr("s2.s4.grandmother_call"), "gentle")
    .n(tr("s2.s4.heart_clench"))
    .n(tr("s2.s4.kneel_beside"))
    .vocab("来る", "くる", "kuru", "To come", {'category': "verbs"})
    .player(tr("s2.s4.player_came"), "sad")
    .n(tr("s2.s4.dialect_thick"))
    .vocab("庭", "にわ", "niwa", "Garden", {'category': "places"})
    .vocab("大切", "たいせつ", "taisetsu", "Important/precious", {
      'category': "adjectives",
    })
    .say("grandmother", tr("s2.s4.grandmother_niwa"), "weak")
    .vocab("ごめんなさい", null, "gomennasai", "I'm sorry", {'category': "phrases"})
    .player(tr("s2.s4.player_sorry"), "sad")
    .n(tr("s2.s4.squeeze_hand"))
    .think(tr("s2.s4.think_failed"), "sad")
    .hide("grandmother")
    .jump("garden_discovery")
    // ============================================
    // SCENE 5: The Garden Discovery
    // ============================================
    .scene("scene5", "garden_discovery")
    .bg("sitting_room", "evening")
    .show("mom", "center", "serious")
    .n(tr("s2.s5.explains"))
    .say("mom", tr("s2.s5.mom_pride"), "sad")
    .say("mom", tr("s2.s5.mom_neglected"), "concerned")
    .say("mom", tr("s2.s5.mom_happy_garden"), "hopeful")
    .player(tr("s2.s5.player_sure"), "neutral")
    .hide("mom")
    .bg("park", "morning") // Next morning, using park as garden
    .n(tr("s2.s5.walk_outside"))
    .n(tr("s2.s5.garden_overgrown"))
    .n(tr("s2.s5.garden_beautiful"))
    .show("grandfather", "center", "neutral") // Grandfather appears
    .n(tr("s2.s5.grandfather_gloves"))
    .n(tr("s2.s5.hands_pair"))
    .n(tr("s2.s5.look_at_him"))
    .menu()
    .choice(tr("s2.s5.choice_accept"), "accept_gloves")
    .choice(tr("s2.s5.choice_hesitate"), "hesitate_gloves")
    .endMenu()
    // ============================================
    // SCENE 6A: Accept the Gloves
    // ============================================
    .scene("scene6a", "accept_gloves")
    .n(tr("s2.s6a.put_on_gloves"))
    .n(tr("s2.s6a.grandfather_nod"))
    .n(tr("s2.s6a.follow_him"))
    .jump("working_together")
    // ============================================
    // SCENE 6B: Hesitate
    // ============================================
    .scene("scene6b", "hesitate_gloves")
    .player(tr("s2.s6b.player_hesitate"), "worried")
    .n(tr("s2.s6b.grandfather_shrugs"))
    .vocab("やってみる", null, "yattemiru", "Try it/give it a try", {
      'category': "phrases",
    })
    .say("grandfather", tr("s2.s6b.grandfather_try"), "neutral")
    .n(tr("s2.s6b.grandfather_walks"))
    .jump("working_together")
    // ============================================
    // SCENE 7: Working Together
    // ============================================
    .scene("scene7", "working_together")
    .bg("park", "morning")
    .show("grandfather", "center", "neutral")
    .n(tr("s2.s7.grandfather_points"))
    .vocab("取る", "とる", "toru", "To take/remove", {'category': "verbs"})
    .say("grandfather", tr("s2.s7.grandfather_totte"), "neutral")
    .n(tr("s2.s7.player_pulls"))
    .n(tr("s2.s7.meditative"))
    .n(tr("s2.s7.grandfather_works"))
    .n(tr("s2.s7.grandfather_points_word"))
    .vocab("種", "たね", "tane", "Seed(s)", {'category': "garden"})
    .say("grandfather", tr("s2.s7.grandfather_tane"), "neutral")
    .vocab("土", "つち", "tsuchi", "Soil/earth", {'category': "garden"})
    .say("grandfather", tr("s2.s7.grandfather_tsuchi"), "neutral")
    .vocab("水", "みず", "mizu", "Water", {'category': "basic"})
    .say("grandfather", tr("s2.s7.grandfather_mizu"), "neutral")
    .n(tr("s2.s7.simple_words"))
    .n(tr("s2.s7.player_repeats"))
    .think(tr("s2.s7.think_teaching"), "neutral")
    .jump("finding_journal")
    // ============================================
    // SCENE 8: Finding the Journal
    // ============================================
    .scene("scene8", "finding_journal")
    .n(tr("s2.s8.hour_later"))
    .n(tr("s2.s8.follow_shed"))
    .bg("laundromat", "afternoon") // Using as shed interior
    .n(tr("s2.s8.inside_shed"))
    .n(tr("s2.s8.hands_notebook"))
    .vocab("読む", "よむ", "yomu", "To read", {'category': "verbs"})
    .say("grandfather", tr("s2.s8.grandfather_yonde"), "neutral")
    .n(tr("s2.s8.open_carefully"))
    .n(tr("s2.s8.garden_journal_desc"))
    .n(tr("s2.s8.first_entry_1975"))
    .vocab("植える", "うえる", "ueru", "To plant", {'category': "verbs"})
    .vocab("咲く", "さく", "saku", "To bloom/blossom", {'category': "verbs"})
    .n(tr("s2.s8.journal_entry"))
    .n(tr("s2.s8.journal_entry_translation"))
    .n(tr("s2.s8.hana_name"))
    .think(tr("s2.s8.think_named_after"), "shocked")
    .hide("grandfather")
    .jump("reading_to_grandmother")
    // ============================================
    // SCENE 9: Reading to Grandmother
    // ============================================
    .scene("scene9", "reading_to_grandmother")
    .bg("futon_room", "evening")
    .show("grandmother", "center", "silhouette")
    .n(tr("s2.s9.evening_bedside"))
    .n(tr("s2.s9.weak_eyes"))
    .player(tr("s2.s9.player_brought"), "gentle")
    .n(tr("s2.s9.open_random"))
    .player(tr("s2.s9.player_reading"), "nervous")
    .n(tr("s2.s9.japanese_terrible"))
    .n(tr("s2.s9.mispronounce"))
    .n(tr("s2.s9.eyes_open"))
    .n(tr("s2.s9.keep_reading"))
    .vocab("一緒に", "いっしょに", "isshoni", "Together", {'category': "phrases"})
    .player(tr("s2.s9.player_reading_more"), "emotional")
    .n(tr("s2.s9.reaches_out"))
    .vocab("ありがとう", null, "arigatou", "Thank you", {'category': "phrases"})
    .say("grandmother", tr("s2.s9.grandmother_arigatou"), "gentle")
    .n(tr("s2.s9.grandmother_smiles"))
    .n(tr("s2.s9.you_cry"))
    .player(tr("s2.s9.player_sorry_bad"), "crying")
    .n(tr("s2.s9.squeezes_hand"))
    .vocab("大丈夫", "だいじょうぶ", "daijoubu", "It's okay/alright", {
      'category': "phrases",
    })
    .vocab("心", "こころ", "kokoro", "Heart/spirit", {'category': "emotions"})
    .vocab("届く", "とどく", "todoku", "To reach/arrive", {'category': "verbs"})
    .say("grandmother", tr("s2.s9.grandmother_heart"), "warm")
    .hide("grandmother")
    .jump("following_days")
    // ============================================
    // SCENE 10: The Following Days
    // ============================================
    .scene("scene10", "following_days")
    .bg("park", "morning")
    .n(tr("s2.s10.days_pass"))
    .n(tr("s2.s10.working_together"))
    .n(tr("s2.s10.grandfather_teaches"))
    .n(tr("s2.s10.few_words"))
    .bg("futon_room", "evening")
    .n(tr("s2.s10.reading_every_evening"))
    .n(tr("s2.s10.japanese_improves"))
    .n(tr("s2.s10.start_understand"))
    .n(tr("s2.s10.tangible_love"))
    .jump("one_week_later")
    // ============================================
    // SCENE 11: One Week Later
    // ============================================
    .scene("scene11", "one_week_later")
    .bg("park", "morning")
    .show("grandmother", "center", "gentle")
    .show("grandfather", "right", "neutral")
    .n(tr("s2.s11.window_wheelchair"))
    .n(tr("s2.s11.garden_transformed"))
    .n(tr("s2.s11.grandmother_sees"))
    .vocab("きれい", null, "kirei", "Beautiful/pretty", {'category': "adjectives"})
    .say("grandmother", tr("s2.s11.grandmother_kirei"), "happy")
    .n(tr("s2.s11.grandfather_hand"))
    .player(tr("s2.s11.player_together"), "happy") // Together
    .n(tr("s2.s11.grandfather_rare_smile"))
    .say("grandmother", tr("s2.s11.grandmother_arigatou"), "crying")
    .n(tr("s2.s11.tears_in_eyes"))
    .hide("grandfather")
    .hide("grandmother")
    .jump("the_passing")
    // ============================================
    // SCENE 12: The Passing
    // ============================================
    .scene("scene12", "the_passing")
    .bg("futon_room", "evening")
    .music("emotional")
    .n(tr("s2.s12.passes_away"))
    .n(tr("s2.s12.holding_hand"))
    .n(tr("s2.s12.last_words"))
    .say("grandmother", tr("s2.s12.grandmother_final"), "peaceful")
    .think(tr("s2.s12.think_meant_everything"), "crying")
    .jump("epilogue")
    // ============================================
    // EPILOGUE: One Year Later
    // ============================================
    .scene("epilogue", "one_year_later")
    .bg("park_summer", "morning")
    .music("hopeful")
    .n(tr("s2.s13.one_year_later"))
    .n(tr("s2.s13.spring_festival"))
    .n(tr("s2.s13.you_returned"))
    .n(tr("s2.s13.garden_flourishing"))
    .n(tr("s2.s13.neighborhood_kids"))
    .vocab("まず", null, "mazu", "First", {'category': "sequence"})
    .vocab("穴", "あな", "ana", "Hole", {'category': "nouns"})
    .vocab("開ける", "あける", "akeru", "To open/make", {'category': "verbs"})
    .player(
      tr("s2.s13.player_teach"),
      "happy",
    ) // First, make a hole in the soil...
    .n(tr("s2.s13.your_japanese_better"))
    .show("grandfather", "right", "happy")
    .n(tr("s2.s13.grandfather_watches"))
    .n(tr("s2.s13.he_still_quiet"))
    .n(tr("s2.s13.but_understand"))
    .n(tr("s2.s13.kid_question"))
    .vocab("ちょっと待って", null, "chotto matte", "Wait a moment", {
      'category': "phrases",
    })
    .player(tr("s2.s13.player_wait"), "thinking") // Wait a moment...
    .n(tr("s2.s13.you_figure_out"))
    .think(tr("s2.s13.think_language"), "peaceful")
    .think(tr("s2.s13.think_hands"), "peaceful")
    .think(tr("s2.s13.think_grandmother"), "peaceful")
    .n(tr("s2.s13.final"))
    .hide("grandfather")
    .fadeOut()
    .wait(1000)
    .jump("debrief1")
    // ============================================
    // DEBRIEF 1: Initial Reactions
    // ============================================
    .scene("debrief1", "classroom_return")
    .bg("classroom", "afternoon")
    .effect("fade-in")
    .music("calm")
    .n(tr("s2.debrief1.back"))
    .show("tanaka", "center", "gentle")
    .say("tanaka", tr("s2.debrief1.tanaka_ask"), "concerned")
    .show("yuki", "left", "crying")
    .say("yuki", tr("s2.debrief1.yuki_crying"), "sad")
    .show("mei", "right", "concerned")
    .n(tr("s2.debrief1.mei_tissues"))
    .hide("mei")
    .hide("yuki")
    .show("ken", "left", "serious")
    .say("ken", tr("s2.debrief1.ken_heavy"), "thoughtful")
    .say("tanaka", tr("s2.debrief1.tanaka_powerful"), "warm")
    .show("mei", "right", "sad")
    .say("mei", tr("s2.debrief1.mei_relate"), "vulnerable")
    .say("tanaka", tr("s2.debrief1.tanaka_common"), "supportive")
    .jump("debrief2")
    // ============================================
    // DEBRIEF 2: Language Learning
    // ============================================
    .scene("debrief2", "language_discussion")
    .say("tanaka", tr("s2.debrief2.tanaka_language"), "teaching")
    .say("tanaka", tr("s2.debrief2.tanaka_garden"), "curious")
    .say("ken", tr("s2.debrief2.ken_simple"), "neutral")
    .say("tanaka", tr("s2.debrief2.tanaka_exactly"), "happy")
    .show("yuki", "left", "gentle")
    .hide("ken")
    .say("yuki", tr("s2.debrief2.yuki_hana"), "curious")
    .say("tanaka", tr("s2.debrief2.tanaka_beautiful"), "pleased")
    .say("tanaka", tr("s2.debrief2.tanaka_family"), "teaching")
    .jump("debrief3")
    // ============================================
    // DEBRIEF 3: Cultural Context
    // ============================================
    .scene("debrief3", "cultural_discussion")
    .say("tanaka", tr("s2.debrief3.tanaka_culture"), "serious")
    .say("tanaka", tr("s2.debrief3.tanaka_heart"), "warm")
    .say("tanaka", tr("s2.debrief3.tanaka_effort"), "teaching")
    .say("mei", tr("s2.debrief3.mei_relief"), "relieved")
    .show("ken", "right", "worried")
    .hide("yuki")
    .say("ken", tr("s2.debrief3.ken_agree"), "nervous")
    .say("tanaka", tr("s2.debrief3.tanaka_mistakes"), "encouraging")
    .show("yuki", "left", "curious")
    .hide("ken")
    .say("yuki", tr("s2.debrief3.yuki_question"), "interested")
    .say("tanaka", tr("s2.debrief3.tanaka_dialect"), "teaching")
    .say("tanaka", tr("s2.debrief3.tanaka_dialect_exp"), "reassuring")
    .jump("debrief4")
    // ============================================
    // DEBRIEF 4: Personal Sharing
    // ============================================
    .scene("debrief4", "personal_sharing")
    .say("tanaka", tr("s2.debrief4.tanaka_personal"), "gentle")
    .say("mei", tr("s2.debrief4.mei_shares"), "sad")
    .show("ken", "right", "sad")
    .hide("yuki")
    .say("ken", tr("s2.debrief4.ken_shares"), "vulnerable")
    .show("yuki", "left", "worried")
    .hide("ken")
    .say("yuki", tr("s2.debrief4.yuki_shares"), "quiet")
    .say("tanaka", tr("s2.debrief4.tanaka_gentle"), "warm")
    .say("tanaka", tr("s2.debrief4.tanaka_remind"), "wise")
    .say("tanaka", tr("s2.debrief4.tanaka_presence"), "encouraging")
    .jump("debrief5")
    // ============================================
    // DEBRIEF 5: Homework & Dismissal
    // ============================================
    .scene("debrief5", "homework")
    .say("tanaka", tr("s2.debrief5.tanaka_homework"), "teaching")
    .say("tanaka", tr("s2.debrief5.tanaka_question"), "thoughtful")
    .say("tanaka", tr("s2.debrief5.tanaka_can_be"), "warm")
    .show("ken", "right", "thinking")
    .hide("yuki")
    .say("ken", tr("s2.debrief5.ken_cooking"), "soft")
    .say("tanaka", tr("s2.debrief5.tanaka_exactly"), "pleased")
    .say("tanaka", tr("s2.debrief5.tanaka_dismiss"), "happy")
    .n(tr("s2.debrief5.class_laugh"))
    .hide("ken")
    .hide("mei")
    .hide("tanaka")
    .jump("after_class")
    // ============================================
    // DEBRIEF 6: After Class Moment
    // ============================================
    .scene("debrief6", "after_class")
    .bg("hallway", "afternoon")
    .show("yuki", "center", "shy")
    .n(tr("s2.debrief6.yuki_approaches"))
    .say("yuki", tr("s2.debrief6.yuki_talk"), "nervous")
    .say("yuki", tr("s2.debrief6.yuki_shares"), "thoughtful")
    .say("yuki", tr("s2.debrief6.yuki_thank_you"), "sincere")
    .n(tr("s2.debrief6.yuki_smile"))
    .menu()
    .choice(tr("s2.debrief6.player_response_kind"), "kind_response")
    .choice(tr("s2.debrief6.player_response_same"), "same_response")
    .endMenu()
    .scene("response_kind", "kind_response")
    .player(tr("s2.debrief6.player_response_kind"), "warm")
    .say("yuki", tr("s2.debrief6.yuki_goodbye"), "happy")
    .jump("final_fade")
    .scene("response_same", "same_response")
    .player(tr("s2.debrief6.player_response_same"), "gentle")
    .say("yuki", tr("s2.debrief6.yuki_goodbye"), "happy")
    .jump("final_fade")
    // ============================================
    // FINAL FADE
    // ============================================
    .scene("final", "final_fade")
    .hideAll()
    .n(tr("s2.debrief6.narrator_bond"))
    .fadeOut()
    .n(tr("s2.end"))
    .build();
