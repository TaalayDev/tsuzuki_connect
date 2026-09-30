import '../dialogue_builder.dart';

// Vocabulary list for Story 6
final story6Vocabulary = <StoryWord>[
  // Literary / poetry vocabulary
  word("俳句", "はいく", "haiku", "Haiku (17-syllable poem)", {
    'category': "literary",
    'jlpt': "N3",
  }),
  word("短歌", "たんか", "tanka", "Tanka (31-syllable poem)", {
    'category': "literary",
    'jlpt': "N3",
  }),
  word("季語", "きご", "kigo", "Season word (required in haiku)", {
    'category': "literary",
    'jlpt': "N3",
  }),
  word("余白", "よはく", "yohaku", "Blank space / margin / what is left unsaid", {
    'category': "literary",
    'jlpt': "N3",
  }),
  word("間", "ま", "ma", "Pause / negative space / interval", {
    'category': "literary",
    'jlpt': "N3",
  }),
  word("物語", "ものがたり", "monogatari", "Story / narrative / tale", {
    'category': "literary",
    'jlpt': "N4",
  }),
  word("詩", "し", "shi", "Poem / poetry (modern)", {
    'category': "literary",
    'jlpt': "N3",
  }),
  word("言葉", "ことば", "kotoba", "Words / language / expression", {
    'category': "core",
    'jlpt': "N4",
  }),
  word("表現", "ひょうげん", "hyougen", "Expression / representation", {
    'category': "literary",
    'jlpt': "N3",
  }),
  word("翻訳", "ほんやく", "hon'yaku", "Translation", {
    'category': "work",
    'jlpt': "N3",
  }),

  // Nuanced emotion / expression words
  word(
    "もののあわれ",
    null,
    "mono no aware",
    "The pathos of things / bittersweet sensitivity to transience",
    {'category': "literary", 'jlpt': "N3"},
  ),
  word("わびさび", null, "wabi-sabi", "Beauty in imperfection and impermanence", {
    'category': "literary",
    'jlpt': "N3",
  }),
  word("木漏れ日", "こもれび", "komorebi", "Sunlight filtering through leaves", {
    'category': "nature",
    'jlpt': "N3",
  }),
  word("木枯らし", "こがらし", "kogarashi", "Cold winter wind that strips leaves", {
    'category': "nature",
    'jlpt': "N3",
  }),
  word("郷愁", "きょうしゅう", "kyoushuu", "Nostalgia / homesickness", {
    'category': "emotions",
    'jlpt': "N3",
  }),
  word("侘しい", "わびしい", "wabishii", "Lonely / desolate / forlorn", {
    'category': "emotions",
    'jlpt': "N3",
  }),

  // Work / professional life
  word("締め切り", "しめきり", "shimekiri", "Deadline", {
    'category': "work",
    'jlpt': "N3",
  }),
  word("仕事", "しごと", "shigoto", "Work / job", {
    'category': "work",
    'jlpt': "N5",
  }),
  word("やりがい", null, "yarigai", "A sense of purpose / fulfillment in work", {
    'category': "work",
    'jlpt': "N3",
  }),
  word(
    "燃え尽きる",
    "もえつきる",
    "moetsukiru",
    "To burn out (emotionally / professionally)",
    {'category': "emotions", 'jlpt': "N3"},
  ),
  word("機械的", "きかいてき", "kikaiteki", "Mechanical / robotic (of manner)", {
    'category': "adjectives",
    'jlpt': "N3",
  }),

  // Craft / reflection
  word("丁寧", "ていねい", "teinei", "Careful / polite / thorough", {
    'category': "adjectives",
    'jlpt': "N4",
  }),
  word("伝える", "つたえる", "tsutaeru", "To convey / to communicate / to pass on", {
    'category': "verbs",
    'jlpt': "N4",
  }),
  word("感じる", "かんじる", "kanjiru", "To feel / to sense", {
    'category': "verbs",
    'jlpt': "N4",
  }),
  word("気づく", "きづく", "kizuku", "To notice / to realize", {
    'category': "verbs",
    'jlpt': "N3",
  }),
  word("原文", "げんぶん", "genbun", "Original text", {
    'category': "literary",
    'jlpt': "N3",
  }),
  word("訳す", "やくす", "yakusu", "To translate", {
    'category': "verbs",
    'jlpt': "N3",
  }),
  word("響く", "ひびく", "hibiku", "To resonate / to echo / to ring out", {
    'category': "verbs",
    'jlpt': "N3",
  }),
];

StoryData getStory6() => dialogue()
    .story(6, tr("s6.title"), tr("s6.subtitle"))
    .description(tr("s6.desc"))
    .estimatedTime("75-90 minutes")
    .jlptFocus("N3")
    .vocabularyList(story6Vocabulary)
    // ============================================
    // PROLOGUE
    // ============================================
    .scene("prologue", "monday_morning")
    .titleCard(tr("s6.card_title"), tr("s6.card_subtitle"))
    .music("written_words")
    .bg("home_office", "morning")
    .n(tr("s6.l001"))
    .n(tr("s6.l002"))
    .n(tr("s6.l003"))
    .n(tr("s6.l004"))
    .n(tr("s6.l005"))
    .n(tr("s6.l006"))
    .n(tr("s6.l007"))
    .n(tr("s6.l008"))
    .vocab("翻訳", "ほんやく", "hon'yaku", "Translation", {'category': "work"})
    .vocab("燃え尽きる", "もえつきる", "moetsukiru", "To burn out", {
      'category': "emotions",
    })
    .think(tr("s6.l009"), "counting")
    .think(tr("s6.l010"), "flat")
    .think(tr("s6.l011"), "hollow")
    .n(tr("s6.l012"))
    .bg("phone_screen", "morning")
    .n(tr("s6.l013"))
    .n(tr("s6.l014"))
    .n(tr("s6.l015"))
    .n(tr("s6.l016"))
    .vocab("俳句", "はいく", "haiku", "Haiku (17-syllable poem)", {
      'category': "literary",
    })
    .vocab("短歌", "たんか", "tanka", "Tanka (31-syllable poem)", {
      'category': "literary",
    })
    .n(tr("s6.l017"))
    .n(tr("s6.l018"))
    .think(tr("s6.l019"), "flat")
    .think(tr("s6.l020"), "searching")
    .think(tr("s6.l021"), "searching")
    .think(tr("s6.l022"), "finding_it")
    .bg("home_office", "morning")
    .n(tr("s6.l023"))
    .n(tr("s6.l024"))
    .n(tr("s6.l025"))
    .jump("act1_enter")
    // ============================================
    // ACT 1: THE FIRST POEM
    // ============================================
    .scene("act1_scene1", "act1_enter")
    .bg("home_office", "morning")
    .music("written_words")
    .n(tr("s6.l026"))
    .n(tr("s6.l027"))
    .n(tr("s6.l028"))
    .think(tr("s6.l029"), "reading_it")
    .think(tr("s6.l030"), "defaulting")
    .n(tr("s6.l031"))
    .n(tr("s6.l032"))
    .n(tr("s6.l033"))
    .n(tr("s6.l034"))
    .n(tr("s6.l035"))
    .n(tr("s6.l036"))
    .n(tr("s6.l037"))
    .n(tr("s6.l038"))
    .think(tr("s6.l039"), "uncomfortable_pause")
    .n(tr("s6.l040"))
    .n(tr("s6.l041"))
    .n(tr("s6.l042"))
    .think(tr("s6.l043"), "asking_honestly")
    .think(tr("s6.l044"), "defensive")
    .think(tr("s6.l045"), "cracking")
    .n(tr("s6.l046"))
    .n(tr("s6.l047"))
    .n(tr("s6.l048"))
    .think(tr("s6.l049"), "avoiding")
    .jump("act1_scene2")
    // ============================================
    .scene("act1_scene2", "ueda_call")
    .bg("home_office", "afternoon")
    .show("ueda", "center", "professional")
    .n(tr("s6.l050"))
    .say("ueda", tr("s6.l051"), "routine")
    .player(tr("s6.l052"), "automatic")
    .vocab("締め切り", "しめきり", "shimekiri", "Deadline", {'category': "work"})
    .say("ueda", tr("s6.l053"), "casual")
    .say("ueda", tr("s6.l054"), "passing_it_on")
    .vocab("伝える", "つたえる", "tsutaeru", "To convey / communicate", {
      'category': "verbs",
    })
    .think(tr("s6.l055"), "hearing_it")
    .think(tr("s6.l056"), "processing")
    .player(tr("s6.l057"), "brief")
    .say("ueda", tr("s6.l058"), "concerned")
    .think(tr("s6.l059"), "noted")
    .player(tr("s6.l060"), "automatic_reassurance")
    .n(tr("s6.l061"))
    .say("ueda", tr("s6.l062"), "not_convinced")
    .hide("ueda")
    .n(tr("s6.l063"))
    .n(tr("s6.l064"))
    .jump("act1_scene3")
    // ============================================
    .scene("act1_scene3", "library_visit")
    .bg("library_stacks", "afternoon")
    .music("quiet_study")
    .n(tr("s6.l065"))
    .n(tr("s6.l066"))
    .n(tr("s6.l067"))
    .n(tr("s6.l068"))
    .n(tr("s6.l069"))
    .n(tr("s6.l070"))
    .vocab("詩", "し", "shi", "Poem / poetry (modern)", {'category': "literary"})
    .vocab("言葉", "ことば", "kotoba", "Words / language / expression", {
      'category': "core",
    })
    .n(tr("s6.l071"))
    .n(tr("s6.l072"))
    .n(tr("s6.l073"))
    .n(tr("s6.l074"))
    .n(tr("s6.l075"))
    .n(tr("s6.l076"))
    .n(tr("s6.l077"))
    .n(tr("s6.l078"))
    .vocab("間", "ま", "ma", "Pause / negative space / interval", {
      'category': "literary",
    })
    .think(tr("s6.l079"), "relearning")
    .think(tr("s6.l080"), "understanding")
    .think(tr("s6.l081"), "realizing")
    .n(tr("s6.l082"))
    .n(tr("s6.l083"))
    .n(tr("s6.l084"))
    .jump("act2_enter")
    // ============================================
    // ACT 2: WHAT CANNOT BE TRANSLATED
    // ============================================
    .scene("act2_scene1", "act2_enter")
    .bg("home_office", "evening")
    .music("written_words")
    .n(tr("s6.l085"))
    .n(tr("s6.l086"))
    .n(tr("s6.l087"))
    .n(tr("s6.l088"))
    .vocab("表現", "ひょうげん", "hyougen", "Expression / representation", {
      'category': "literary",
    })
    .n(tr("s6.l089"))
    .n(tr("s6.l090"))
    .n(tr("s6.l091"))
    .n(tr("s6.l092"))
    .think(tr("s6.l069"), "pausing")
    .think(tr("s6.l070"), "reading_it")
    .think(tr("s6.l071"), "feeling_it")
    .n(tr("s6.l096"))
    .n(tr("s6.l097"))
    .n(tr("s6.l098"))
    .vocab(
      "もののあわれ",
      null,
      "mono no aware",
      "The pathos of things / bittersweet sensitivity to transience",
      {'category': "literary"},
    )
    .think(tr("s6.l124"), "reaching")
    .think(tr("s6.l167"), "finding_it")
    .think(tr("s6.l125"), "turning_it_over")
    .think(tr("s6.l126"), "honest")
    .think(tr("s6.l127"), "changed")
    .n(tr("s6.l104"))
    .n(tr("s6.l105"))
    .n(tr("s6.l106"))
    .jump("act2_scene2")
    // ============================================
    .scene("act2_scene2", "neighbor_encounter")
    .bg("apartment_hallway", "evening")
    .show("nakamura_child", "center", "bright")
    .n(tr("s6.l107"))
    .n(tr("s6.l108"))
    .n(tr("s6.l109"))
    .say("nakamura_child", tr("s6.l110"), "curious")
    .player(tr("s6.l111"), "brief")
    .say("nakamura_child", tr("s6.l112"), "asking")
    .n(tr("s6.l128"))
    .n(tr("s6.l129"))
    .n(tr("s6.l130"))
    .n(tr("s6.l131"))
    .vocab("木漏れ日", "こもれび", "komorebi", "Sunlight filtering through leaves", {
      'category': "nature",
    })
    .n(tr("s6.l084"))
    .n(tr("s6.l132"))
    .n(tr("s6.l133"))
    .say("nakamura_child", tr("s6.l085"), "innocent")
    .think(tr("s6.l086"), "reading")
    .player(tr("s6.l087"), "gentle")
    .player(tr("s6.l088"), "continuing")
    .say("nakamura_child", tr("s6.l089"), "simple")
    .think(tr("s6.l089"), "absorbing")
    .think(tr("s6.l090"), "noticing")
    .think(tr("s6.l091"), "seeing_something")
    .n(tr("s6.l301"))
    .n(tr("s6.l302"))
    .hide("nakamura_child")
    .vocab("感じる", "かんじる", "kanjiru", "To feel / to sense", {
      'category': "verbs",
    })
    .jump("act2_scene3")
    // ============================================
    .scene("act2_scene3", "rachel_email")
    .bg("home_office", "night")
    .music("classical_piano_gentle")
    .n(tr("s6.l092"))
    .n(tr("s6.l093"))
    .n(tr("s6.l306"))
    .n(tr("s6.l095"))
    .n(tr("s6.l096"))
    .n(tr("s6.l097"))
    .n(tr("s6.l098"))
    .n(tr("s6.l099"))
    .n(tr("s6.l303"))
    .think(tr("s6.l100"), "turning_it_over")
    .think(tr("s6.l101"), "realizing")
    .think(tr("s6.l102"), "searching_memory")
    .vocab(
      "余白",
      "よはく",
      "yohaku",
      "Blank space / margin / what is left unsaid",
      {'category': "literary"},
    )
    .think(tr("s6.l103"), "explaining_to_self")
    .think(tr("s6.l104"), "challenge")
    .think(tr("s6.l105"), "condition")
    .think(tr("s6.l304"), "question_for_himself")
    .n(tr("s6.l305"))
    .n(tr("s6.l306"))
    .n(tr("s6.l307"))
    .n(tr("s6.l308"))
    .n(tr("s6.l309"))
    .jump("act3_enter")
    // ============================================
    // ACT 3: THE CRISIS
    // ============================================
    .scene("act3_scene1", "act3_enter")
    .bg("home_office", "night")
    .music("quiet_melancholy")
    .n(tr("s6.l310"))
    .n(tr("s6.l106"))
    .n(tr("s6.l107"))
    .n(tr("s6.l108"))
    .n(tr("s6.l311"))
    .think(tr("s6.l109"), "noting")
    .think(tr("s6.l110"), "noting_again")
    .think(tr("s6.l111"), "practical")
    .think(tr("s6.l112"), "remembering")
    .think(tr("s6.l113"), "defending")
    .think(tr("s6.l114"), "honest")
    .n(tr("s6.l312"))
    .n(tr("s6.l313"))
    .n(tr("s6.l314"))
    .n(tr("s6.l115"))
    .n(tr("s6.l116"))
    .n(tr("s6.l117"))
    .vocab("木枯らし", "こがらし", "kogarashi", "Cold winter wind that strips leaves", {
      'category': "nature",
    })
    .vocab("侘しい", "わびしい", "wabishii", "Lonely / desolate / forlorn", {
      'category': "emotions",
    })
    .think(tr("s6.l315"), "starting")
    .think(tr("s6.l118"), "remembering")
    .think(tr("s6.l119"), "origin")
    .think(tr("s6.l120"), "young_self")
    .think(tr("s6.l316"), "when_did_that_happen")
    .jump("act3_scene2")
    // ============================================
    .scene("act3_scene2", "ueda_visit")
    .bg("coffee_shop", "afternoon")
    .music("cafe_gentle")
    .show("ueda", "center", "careful")
    .n(tr("s6.l040"))
    .say("ueda", tr("s6.l041"), "direct")
    .player(tr("s6.l042"), "honest")
    .say("ueda", tr("s6.l043"), "asking")
    .n(tr("s6.l045"))
    .n(tr("s6.l046"))
    .n(tr("s6.l047"))
    .menu()
    .choice(tr("s6.l317"), "professional_answer", {
      'hint': "The source material is more complex than anticipated.",
    })
    .choice(tr("s6.l318"), "honest_answer", {
      'hint': "I keep caring too much about doing it right.",
    })
    .endMenu()
    .scene("honest_answer_scene", "honest_answer")
    .show("ueda", "center", "surprised")
    .player(tr("s6.l318"), "quiet")
    .player(tr("s6.l113"), "continuing")
    .player(tr("s6.l316"), "surprised_at_self")
    .n(tr("s6.l061"))
    .say("ueda", tr("s6.l062"), "measured")
    .say("ueda", tr("s6.l053"), "careful")
    .player(tr("s6.l110"), "self_critical")
    .say("ueda", tr("s6.l043"), "simple")
    .say("ueda", tr("s6.l044"), "decided")
    .vocab(
      "やりがい",
      null,
      "yarigai",
      "A sense of purpose / fulfillment in work",
      {'category': "work"},
    )
    .think(tr("s6.l051"), "processing")
    .think(tr("s6.l059"), "realizing")
    .say("ueda", tr("s6.l051"), "gentle")
    .say("ueda", tr("s6.l052"), "asking")
    .player(tr("s6.l053"), "honest")
    .say("ueda", tr("s6.l054"), "softly")
    .say("ueda", tr("s6.l055"), "wise")
    .n(tr("s6.l319"))
    .n(tr("s6.l320"))
    .n(tr("s6.l321"))
    .hide("ueda")
    .jump("act3_scene3")
    // ============================================
    .scene("act3_scene3", "the_breakthrough_word")
    .bg("home_office", "late_night")
    .music("classical_piano_gentle")
    .n(tr("s6.l322"))
    .n(tr("s6.l323"))
    .n(tr("s6.l324"))
    .n(tr("s6.l325"))
    .n(tr("s6.l326"))
    .think(tr("s6.l089"), "reading")
    .think(tr("s6.l090"), "understanding_it")
    .think(tr("s6.l091"), "articulating")
    .vocab("郷愁", "きょうしゅう", "kyoushuu", "Nostalgia / homesickness", {
      'category': "emotions",
    })
    .n(tr("s6.l327"))
    .n(tr("s6.l135"))
    .n(tr("s6.l136"))
    .n(tr("s6.l328"))
    .n(tr("s6.l329"))
    .n(tr("s6.l330"))
    .n(tr("s6.l331"))
    .n(tr("s6.l137"))
    .n(tr("s6.l138"))
    .n(tr("s6.l139"))
    .n(tr("s6.l140"))
    .n(tr("s6.l141"))
    .n(tr("s6.l332"))
    .n(tr("s6.l333"))
    .n(tr("s6.l334"))
    .n(tr("s6.l335"))
    .vocab("響く", "ひびく", "hibiku", "To resonate / to echo / to ring out", {
      'category': "verbs",
    })
    .vocab("気づく", "きづく", "kizuku", "To notice / to realize", {
      'category': "verbs",
    })
    .think(tr("s6.l112"), "arriving")
    .think(tr("s6.l029"), "arriving")
    .n(tr("s6.l336"))
    .n(tr("s6.l091"))
    .jump("act4_enter")
    // ============================================
    // ACT 4: THE POETRY READING
    // ============================================
    .scene("act4_scene1", "act4_enter")
    .bg("bookshop_event_space", "evening")
    .music("written_words_full")
    .n(tr("s6.l337"))
    .n(tr("s6.l338"))
    .n(tr("s6.l339"))
    .n(tr("s6.l340"))
    .n(tr("s6.l341"))
    .n(tr("s6.l342"))
    .show("ishii", "center", "confident")
    .n(tr("s6.l343"))
    .n(tr("s6.l344"))
    .say("ishii", tr("s6.l051"), "to_the_room")
    .say("ishii", tr("s6.l345"), "explaining")
    .say("ishii", tr("s6.l346"), "poetic")
    .n(tr("s6.l345"))
    .n(tr("s6.l346"))
    .vocab("伝える", "つたえる", "tsutaeru", "To convey", {'category': "verbs"})
    .think(tr("s6.l152"), "absorbing")
    .think(tr("s6.l153"), "understanding")
    .n(tr("s6.l347"))
    .n(tr("s6.l348"))
    .show("ishii", "center", "open")
    .player(tr("s6.l063"), "earnest")
    .say("ishii", tr("s6.l054"), "noticing")
    .player(tr("s6.l043"), "humble")
    .say("ishii", tr("s6.l054"), "knowing")
    .player(tr("s6.l056"), "struggling_to_explain")
    .say("ishii", tr("s6.l058"), "completing_it")
    .vocab(
      "わびさび",
      null,
      "wabi-sabi",
      "Beauty in imperfection and impermanence",
      {'category': "literary"},
    )
    .player(tr("s6.l352"), "honest")
    .say("ishii", tr("s6.l063"), "gently")
    .say("ishii", tr("s6.l064"), "wise")
    .say("ishii", tr("s6.l065"), "explaining")
    .say("ishii", tr("s6.l066"), "smiling")
    .vocab(
      "余白",
      "よはく",
      "yohaku",
      "Blank space / margin / what is left unsaid",
      {'category': "literary"},
    )
    .think(tr("s6.l064"), "struck")
    .think(tr("s6.l065"), "working_through")
    .think(tr("s6.l066"), "arriving")
    .think(tr("s6.l074"), "wonder")
    .n(tr("s6.l342"))
    .hide("ishii")
    .jump("act4_scene2")
    // ============================================
    .scene("act4_scene2", "rachel_call")
    .bg("home_office", "morning")
    .music("classical_piano_gentle")
    .n(tr("s6.l349"))
    .show("rachel", "center", "warm")
    .say("rachel", tr("r6.l101"), "excited")
    .say("rachel", tr("r6.l102"), "pausing")
    .say("rachel", tr("r6.l103"), "comparing")
    .say("rachel", tr("r6.l104"), "moved")
    .vocab("丁寧", "ていねい", "teinei", "Careful / polite / thorough", {
      'category': "adjectives",
    })
    .player(tr("r6.l105"), "attempting_to_explain")
    .say("rachel", tr("r6.l106"), "affirming")
    .say("rachel", tr("r6.l107"), "continuing")
    .say("rachel", tr("r6.l108"), "reading_aloud")
    .say("rachel", tr("r6.l109"), "curious")
    .player(tr("r6.l110"), "quiet")
    .player(tr("r6.l111"), "honest")
    .say("rachel", tr("r6.l112"), "carefully")
    .say("rachel", tr("r6.l113"), "decided")
    .think(tr("r6.l114"), "surprised")
    .think(tr("r6.l115"), "understanding")
    .think(tr("r6.l116"), "seen")
    .player(tr("r6.l117"), "accepting")
    .hide("rachel")
    .jump("act5_enter")
    // ============================================
    // ACT 5: THE INTRODUCTION
    // ============================================
    .scene("act5_scene1", "act5_enter")
    .bg("home_office", "morning")
    .music("written_words")
    .n(tr("s6.l401"))
    .n(tr("s6.l402"))
    .n(tr("s6.l191"))
    .n(tr("s6.l403"))
    .n(tr("s6.l404"))
    .n(tr("s6.l405"))
    .n(tr("s6.l312"))
    .n(tr("s6.l355"))
    .n("─────────────────────────────────────────")
    .n(tr("s6.l406"))
    .n("")
    .n(tr("s6.l407"))
    .n(tr("s6.l408"))
    .n(tr("s6.l409"))
    .n("")
    .n(tr("s6.l410"))
    .n(tr("s6.l411"))
    .n("")
    .n(tr("s6.l412"))
    .n(tr("s6.l413"))
    .n(tr("s6.l414"))
    .n(tr("s6.l415"))
    .n(tr("s6.l416"))
    .n("─────────────────────────────────────────")
    .vocab("余白", "よはく", "yohaku", "Blank space / what is left unsaid", {
      'category': "literary",
    })
    .n(tr("s6.l104"))
    .n(tr("s6.l309"))
    .n(tr("s6.l650"))
    .think(tr("s6.l205"), "taking_stock")
    .think(tr("s6.l206"), "measuring")
    .think(tr("s6.l207"), "true")
    .think(tr("s6.l208"), "changed")
    .think(tr("s6.l316"), "relieved")
    .jump("epilogue")
    // ============================================
    // EPILOGUE
    // ============================================
    .scene("epilogue_scene1", "epilogue")
    .bg("home_office", "afternoon")
    .music("written_words_reprise")
    .n(tr("s6.l209"))
    .n(tr("s6.l210"))
    .n(tr("s6.l211"))
    .n(tr("s6.l202"))
    .show("ueda", "center", "pleased")
    .say("ueda", tr("s6.l212"), "pleased")
    .say("ueda", tr("s6.l213"), "delivering_good_news")
    .player(tr("s6.l214"), "quiet")
    .say("ueda", tr("s6.l215"), "asking")
    .n(tr("s6.l352"))
    .n(tr("s6.l353"))
    .n(tr("s6.l354"))
    .player(tr("s6.l216"), "decided")
    .n(tr("s6.l355"))
    .n(tr("s6.l356"))
    .n(tr("s6.l154"))
    .n(tr("s6.l357"))
    .n(tr("s6.l217"))
    .vocab("言葉", "ことば", "kotoba", "Words / language / expression", {
      'category': "core",
    })
    .n(tr("s6.l217"))
    .n(tr("s6.l110"))
    .n(tr("s6.l218"))
    .n(tr("s6.l358"))
    .n(tr("s6.l359"))
    .n(tr("s6.l360"))
    .n(tr("s6.l361"))
    .n(tr("s6.l362"))
    .hideAll()
    .fadeOut()
    .wait(2000)
    .n(tr("s6.l220"))
    .fadeIn()
    .jump("debrief1")
    // ============================================
    // DEBRIEF 1: Initial Reactions
    // ============================================
    .scene("debrief1", "classroom_return")
    .bg("classroom", "afternoon")
    .music("calm")
    .n(tr("s6.l221"))
    .n(tr("s6.l222"))
    .show("tanaka", "center", "thoughtful")
    .say("tanaka", tr("s6.l223"), "beginning")
    .say("tanaka", tr("s6.l223"), "noting")
    .show("ken", "right", "animated")
    .say("ken", tr("s6.l224"), "observing")
    .say("ken", tr("s6.l225"), "continuing")
    .say("ken", tr("s6.l226"), "asking")
    .show("mei", "left", "having_thought_about_it")
    .say("mei", tr("s6.l227"), "slow")
    .say("mei", tr("s6.l228"), "building")
    .say("tanaka", tr("s6.l043"), "prompting")
    .say("mei", tr("s6.l229"), "explaining")
    .say("mei", tr("s6.l230"), "precise")
    .say("ken", tr("s6.l231"), "naming_it")
    .say("mei", tr("s6.l232"), "affirming")
    .jump("debrief2")
    // ============================================
    // DEBRIEF 2: Language Focus
    // ============================================
    .scene("debrief2", "language_lesson")
    .show("tanaka", "center", "teaching")
    .say("tanaka", tr("s6.l233"), "focusing")
    .say("tanaka", tr("s6.l234"), "building")
    .say("tanaka", tr("s6.l167"), "writing_it")
    .say("tanaka", tr("s6.l235"), "asking")
    .show("yuki", "right", "thinking")
    .say("yuki", tr("s6.l236"), "uncertain")
    .say("tanaka", tr("s6.l237"), "guiding")
    .say("tanaka", tr("s6.l238"), "expanding")
    .say("tanaka", tr("s6.l239"), "precise")
    .say("tanaka", tr("s6.l240"), "honest")
    .show("ken", "left", "intrigued")
    .say("ken", tr("s6.l241"), "realizing")
    .say("tanaka", tr("s6.l242"), "prompting")
    .show("mei", "right", "remembering")
    .say("mei", tr("s6.l243"), "recalling")
    .say("mei", tr("s6.l244"), "connecting")
    .say("tanaka", tr("s6.l245"), "genuine")
    .say("tanaka", tr("s6.l246"), "directing")
    .vocab("余白", "よはく", "yohaku", "Blank space / what is left unsaid", {
      'category': "literary",
    })
    .say("tanaka", tr("s6.l247"), "teaching")
    .say("tanaka", tr("s6.l248"), "summarizing")
    .jump("debrief3")
    // ============================================
    // DEBRIEF 3: Cultural Context
    // ============================================
    .scene("debrief3", "cultural_context")
    .show("tanaka", "center", "cultural")
    .say("tanaka", tr("s6.l249"), "building")
    .show("yuki", "left", "listening")
    .say("tanaka", tr("s6.l250"), "naming")
    .vocab("やりがい", null, "yarigai", "Sense of purpose / fulfillment in work", {
      'category': "work",
    })
    .say("tanaka", tr("s6.l251"), "explaining")
    .say("tanaka", tr("s6.l252"), "deepening")
    .say("tanaka", tr("s6.l253"), "connecting")
    .show("ken", "right", "recognizing")
    .say("ken", tr("s6.l254"), "observing")
    .say("ken", tr("s6.l255"), "honest")
    .say("tanaka", tr("s6.l256"), "broadening")
    .say("tanaka", tr("s6.l257"), "wise")
    .jump("debrief4")
    // ============================================
    // DEBRIEF 4: Personal Connection
    // ============================================
    .scene("debrief4", "personal")
    .show("tanaka", "center", "open")
    .say("tanaka", tr("s6.l063"), "preparing")
    .say("tanaka", tr("s6.l258"), "asking")
    .say("tanaka", tr("s6.l259"), "continuing")
    .n(tr("s6.l260"))
    .show("yuki", "left", "unexpectedly_speaking")
    .say("yuki", tr("s6.l261"), "unexpectedly_speaking")
    .say("yuki", tr("s6.l261"), "clarifying")
    .n(tr("s6.l262"))
    .say("yuki", tr("s6.l263"), "continuing")
    .say("yuki", tr("s6.l264"), "small")
    .say("yuki", tr("s6.l265"), "honest")
    .say("yuki", tr("s6.l266"), "admitting")
    .say("tanaka", tr("s6.l267"), "gentle")
    .say("yuki", tr("s6.l268"), "simple")
    .n(tr("s6.l269"))
    .n(tr("s6.l269"))
    .say("tanaka", tr("s6.l270"), "echoing_it")
    .show("ken", "right", "moved")
    .show("mei", "left", "soft")
    .say("ken", tr("s6.l271"), "earnest")
    .jump("debrief5")
    // ============================================
    // DEBRIEF 5: Closing
    // ============================================
    .scene("debrief5", "closing")
    .show("tanaka", "center", "warm")
    .say("tanaka", tr("s6.l272"), "asking")
    .show("mei", "left", "remembering")
    .say("mei", tr("s6.l273"), "quoting")
    .say("mei", tr("s6.l273"), "translating")
    .say("tanaka", tr("s6.l274"), "meaningful")
    .say("tanaka", tr("s6.l275"), "asking")
    .show("ken", "right", "searching")
    .say("ken", tr("s6.l276"), "remembering")
    .say("ken", tr("s6.l277"), "pinpointing")
    .say("tanaka", tr("s6.l278"), "pleased")
    .say("tanaka", tr("s6.l279"), "asking")
    .menu()
    .choice(tr("s6.l280"), "yes_different", {
      'hint': "Yes. Before it was a sentence. Now it's something I know.",
    })
    .choice(tr("s6.l281"), "more_specific", {
      'hint': "Now I can name more of the ways it's true.",
    })
    .endMenu()
    .scene("closing_resolution", "final_beat")
    .show("tanaka", "center", "moved")
    .say("tanaka", tr("s6.l282"), "quiet")
    .say("tanaka", tr("s6.l283"), "to_himself")
    .n(tr("s6.l110"))
    .say("tanaka", tr("s6.l284"), "returning")
    .say("tanaka", tr("s6.l285"), "closing")
    .hide("tanaka")
    .hide("ken")
    .hide("mei")
    .hide("yuki")
    .jump("after_class")
    // ============================================
    // DEBRIEF 6: After Class
    // ============================================
    .scene("debrief6", "after_class")
    .bg("hallway", "late_afternoon")
    .music("gentle_close")
    .show("mei", "center", "waiting")
    .n(tr("s6.l286"))
    .say("mei", tr("s6.l287"), "careful")
    .player(tr("s6.l288"), "open")
    .say("mei", tr("s6.l289"), "setting_up")
    .say("mei", tr("s6.l290"), "noting")
    .say("mei", tr("s6.l291"), "observing")
    .player(tr("s6.l062"), "agreeing")
    .say("mei", tr("s6.l292"), "quiet")
    .say("mei", tr("s6.l293"), "honest")
    .say("mei", tr("s6.l294"), "continuing")
    .say("mei", tr("s6.l295"), "admitting")
    .say("mei", tr("s6.l296"), "vulnerable")
    .n(tr("s6.l045"))
    .n(tr("s6.l263"))
    .n(tr("s6.l295"))
    .menu()
    .choice(tr("s6.l297"), "home_answer", {
      'hint': "That's not a problem. That's knowing where you actually live.",
    })
    .choice(tr("s6.l298"), "both_true", {
      'hint': "Your real feelings live there. And your reach keeps growing.",
    })
    .endMenu()
    .scene("mei_response", "mei_final")
    .show("mei", "center", "settled")
    .n(tr("s6.l260"))
    .say("mei", tr("s6.l273"), "softly")
    .say("mei", tr("s6.l299"), "adding_to_it")
    .vocab("自分", "じぶん", "jibun", "Oneself", {
      'category': "pronouns",
      'jlpt': "N4",
    })
    .n(tr("s6.l299"))
    .n(tr("s6.l134"))
    .n(tr("s6.l362"))
    .n(tr("s6.l221"))
    .n(tr("s6.l300"))
    .n(tr("s6.l219"))
    .hideAll()
    .fadeOut()
    .n(tr("s6.l220"))
    .build();
