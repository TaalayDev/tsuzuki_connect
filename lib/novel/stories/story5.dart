import '../dialogue_builder.dart';

// Vocabulary list for Story 5
final story5Vocabulary = <StoryWord>[
  // Medical/health vocabulary
  word("病院", "びょういん", "byouin", tr("s5.v.byouin"), {
    'category': "medical",
    'jlpt': "N5",
  }),
  word("薬局", "やっきょく", "yakkyoku", tr("s5.v.yakkyoku"), {
    'category': "medical",
    'jlpt': "N4",
  }),
  word("処方箋", "しょほうせん", "shohousen", tr("s5.v.shohousen"), {
    'category': "medical",
    'jlpt': "N3",
  }),
  word("血圧", "けつあつ", "ketsuatsu", tr("s5.v.ketsuatsu"), {
    'category': "medical",
    'jlpt': "N3",
  }),
  word("定期検診", "ていきけんしん", "teiki kenshin", tr("s5.v.teiki_kenshin"), {
    'category': "medical",
    'jlpt': "N3",
  }),
  word("症状", "しょうじょう", "shoujou", tr("s5.v.shoujou"), {
    'category': "medical",
    'jlpt': "N3",
  }),

  // Community center / daily life
  word("地域", "ちいき", "chiiki", tr("s5.v.chiiki"), {
    'category': "community",
    'jlpt': "N3",
  }),
  word("町内会", "ちょうないかい", "chounai kai", tr("s5.v.chounai_kai"), {
    'category': "community",
    'jlpt': "N3",
  }),
  word("公民館", "こうみんかん", "kouminkan", tr("s5.v.kouminkan"), {
    'category': "community",
    'jlpt': "N3",
  }),
  word("習い事", "ならいごと", "naraigoto", tr("s5.v.naraigoto"), {
    'category': "community",
    'jlpt': "N3",
  }),
  word("趣味", "しゅみ", "shumi", tr("s5.v.shumi"), {
    'category': "lifestyle",
    'jlpt': "N4",
  }),
  word("手芸", "しゅげい", "shugei", tr("s5.v.shugei"), {
    'category': "hobbies",
    'jlpt': "N3",
  }),

  // Asking for help / directions
  word("道に迷う", "みちにまよう", "michi ni mayou", tr("s5.v.michi_ni_mayou"), {
    'category': "phrases",
    'jlpt': "N4",
  }),
  word(
    "教えていただけますか",
    null,
    "oshiete itadakemasu ka",
    tr("s5.v.oshiete_itadakemasu_ka"),
    {'category': "polite_expressions", 'jlpt': "N3"},
  ),
  word("もう一度", "もういちど", "mou ichido", tr("s5.v.mou_ichido"), {
    'category': "phrases",
    'jlpt': "N5",
  }),
  word("ゆっくり", null, "yukkuri", tr("s5.v.yukkuri"), {
    'category': "adverbs",
    'jlpt': "N5",
  }),
  word("すみません", null, "sumimasen", tr("s5.v.sumimasen"), {
    'category': "phrases",
    'jlpt': "N5",
  }),

  // Family / generational
  word("息子", "むすこ", "musuko", tr("s5.v.musuko"), {
    'category': "family",
    'jlpt': "N5",
  }),
  word("嫁", "よめ", "yome", tr("s5.v.yome"), {
    'category': "family",
    'jlpt': "N3",
  }),
  word("孫", "まご", "mago", tr("s5.v.mago"), {
    'category': "family",
    'jlpt': "N4",
  }),
  word("世話になる", "せわになる", "sewa ni naru", tr("s5.v.sewa_ni_naru"), {
    'category': "phrases",
    'jlpt': "N3",
  }),
  word("遠慮", "えんりょ", "enryo", tr("s5.v.enryo"), {
    'category': "social",
    'jlpt': "N3",
  }),

  // Emotions / growth
  word("恥ずかしい", "はずかしい", "hazukashii", tr("s5.v.hazukashii"), {
    'category': "emotions",
    'jlpt': "N4",
  }),
  word("諦める", "あきらめる", "akirameru", tr("s5.v.akirameru"), {
    'category': "verbs",
    'jlpt': "N3",
  }),
  word("挑戦", "ちょうせん", "chousen", tr("s5.v.chousen"), {
    'category': "verbs",
    'jlpt': "N3",
  }),
  word("自信", "じしん", "jishin", tr("s5.v.jishin"), {
    'category': "emotions",
    'jlpt': "N3",
  }),
  word("仲間", "なかま", "nakama", tr("s5.v.nakama"), {
    'category': "social",
    'jlpt': "N3",
  }),
  word("居心地がいい", "いごこちがいい", "igokochi ga ii", tr("s5.v.igokochi_ga_ii"), {
    'category': "emotions",
    'jlpt': "N3",
  }),
];

StoryData getStory5() => dialogue()
    .story(5, tr("s5.title"), tr("s5.subtitle"))
    .description(tr("s5.desc"))
    .estimatedTime("75-90 minutes")
    .jlptFocus("N3")
    .vocabularyList(story5Vocabulary)
    // ============================================
    // PROLOGUE
    // ============================================
    .scene("prologue", "arrival")
    .titleCard(tr("s5.card_title"), tr("s5.card_subtitle"))
    .music("never_too_late")
    .bg("suburban_street", "morning")
    .n(tr("s5.l001"))
    .n(tr("s5.l002"))
    .n(tr("s5.l003"))
    .n(tr("s5.l004"))
    .n(tr("s5.l005"))
    .think(tr("s5.l006"), "frustrated")
    .n(tr("s5.l007"))
    .n(tr("s5.l008"))
    .n(tr("s5.l009"))
    .bg("narrow_street", "morning")
    .vocab("道に迷う", "みちにまよう", "michi ni mayou", tr("s5.v.michi_ni_mayou"), {
      'category': "phrases",
    })
    .n(tr("s5.l010"))
    .n(tr("s5.l011"))
    .n(tr("s5.l012"))
    .think(tr("s5.l013"), "nostalgic")
    .think(tr("s5.l014"), "helpless")
    .n(tr("s5.l015"))
    .n(tr("s5.l016"))
    .n(tr("s5.l017"))
    .jump("meet_yamamoto")
    // ============================================
    // ACT 1: THE NEIGHBORHOOD
    // ============================================
    .scene("act1_scene1", "meet_yamamoto")
    .bg("residential_gate", "morning")
    .show("yamamoto", "center", "curious")
    .n(tr("s5.l018"))
    .say("yamamoto", tr("s5.l019"), "friendly")
    .n(tr("s5.l020"))
    .player(tr("s5.l021"), "attempting")
    .vocab("薬局", "やっきょく", "yakkyoku", tr("s5.v.yakkyoku"), {
      'category': "medical",
    })
    .show("yamamoto", "center", "brightening")
    .say("yamamoto", tr("s5.l022"), "helpful")
    .say("yamamoto", tr("s5.l023"), "directing")
    .n(tr("s5.l024"))
    .n(tr("s5.l025"))
    .think(tr("s5.l026"), "decoding")
    .player(tr("s5.l027"), "confirming")
    .say("yamamoto", tr("s5.l028"), "approving")
    .vocab("そうそう", null, "sou sou", tr("s5.v.sou_sou"), {'category': "phrases"})
    .n(tr("s5.l029"))
    .say("yamamoto", tr("s5.l030"), "curious")
    .n(tr("s5.l031"))
    .player(tr("s5.l032"), "simple")
    .say("yamamoto", tr("s5.l033"), "interested")
    .player(tr("s5.l034"), "answering")
    .say("yamamoto", tr("s5.l035"), "impressed")
    .say("yamamoto", tr("s5.l036"), "introducing")
    .n(tr("s5.l037"))
    .player(tr("s5.l038"), "polite")
    .say("yamamoto", tr("s5.l039"), "warm")
    .n(tr("s5.l040"))
    .n(tr("s5.l041"))
    .say("yamamoto", tr("s5.l042"))
    .n(tr("s5.l043"))
    .say("yamamoto", tr("s5.l044"), "inviting")
    .think(tr("s5.l045"), "surprised")
    .think(tr("s5.l046"), "hesitating")
    .menu()
    .choice(tr("s5.l047"), "accept_tea", {'hint': "Yes, I'd like that."})
    .choice(tr("s5.l048"), "decline_tea", {
      'hint': "Thank you, maybe another time.",
    })
    .endMenu()
    .hide("yamamoto")
    .jump("pharmacy_errand")
    .scene("accept_tea_scene", "accept_tea")
    .player(tr("s5.b001"), "polite")
    .say("yamamoto", tr("s5.b002"), "warm")
    .hide("yamamoto")
    .jump("pharmacy_errand")
    .scene("decline_tea_scene", "decline_tea")
    .player(tr("s5.b003"), "polite")
    .say("yamamoto", tr("s5.b004"), "warm")
    .hide("yamamoto")
    .jump("pharmacy_errand")
    // ============================================
    .scene("act1_scene2", "pharmacy_errand")
    .bg("pharmacy", "morning")
    .n(tr("s5.l049"))
    .n(tr("s5.l050"))
    .show("pharmacist", "center", "professional")
    .n(tr("s5.l051"))
    .say("pharmacist", tr("s5.l052"), "polite")
    .vocab("いらっしゃいませ", null, "irasshaimase", tr("s5.v.irasshaimase"), {
      'category': "service",
    })
    .n(tr("s5.l053"))
    .vocab("処方箋", "しょほうせん", "shohousen", tr("s5.v.shohousen"), {
      'category': "medical",
    })
    .player(tr("s5.l054"), "explaining")
    .say("pharmacist", tr("s5.l055"), "professional")
    .n(tr("s5.l056"))
    .n(tr("s5.l057"))
    .vocab("血圧", "けつあつ", "ketsuatsu", tr("s5.v.ketsuatsu"), {
      'category': "medical",
    })
    .show("pharmacist", "center", "returning")
    .say("pharmacist", tr("s5.l058"), "instructing")
    .n(tr("s5.l059"))
    .n(tr("s5.l060"))
    .think(tr("s5.l061"), "working_through")
    .player(tr("s5.l062"), "confirming")
    .vocab("食後", "しょくご", "shokugo", tr("s5.v.shokugo"), {'category': "medical"})
    .say("pharmacist", tr("s5.l063"), "confirming")
    .n(tr("s5.l064"))
    .n(tr("s5.l065"))
    .think(tr("s5.l066"), "surprised")
    .think(tr("s5.l067"), "honest")
    .hide("pharmacist")
    .jump("tea_with_yamamoto")
    // ============================================
    .scene("act1_scene3", "tea_with_yamamoto")
    .bg("yamamoto_kitchen", "morning")
    .music("calm_domestic")
    .show("yamamoto", "center", "busy")
    .n(tr("s5.l068"))
    .n(tr("s5.l069"))
    .n(tr("s5.l070"))
    .vocab("せんべい", null, "senbei", tr("s5.v.senbei"), {'category': "food"})
    .say("yamamoto", tr("s5.l071"), "hospitable")
    .n(tr("s5.l072"))
    .say("yamamoto", tr("s5.l073"), "curious")
    .vocab("息子", "むすこ", "musuko", tr("s5.v.musuko"), {'category': "family"})
    .n(tr("s5.l074"))
    .player(tr("s5.l075"), "explaining")
    .say("yamamoto", tr("s5.l076"), "interested")
    .vocab("嫁", "よめ", "yome", tr("s5.v.yome"), {'category': "family"})
    .player(tr("s5.l077"), "answering")
    .say("yamamoto", tr("s5.l078"), "warm")
    .vocab("孫", "まご", "mago", tr("s5.v.mago"), {'category': "family"})
    .player(tr("s5.l079"), "smiling")
    .say("yamamoto", tr("s5.l080"), "delighted")
    .n(tr("s5.l081"))
    .say("yamamoto", tr("s5.l082"), "sympathetic")
    .n(tr("s5.l083"))
    .player(tr("s5.l084"), "honest")
    .say("yamamoto", tr("s5.l085"), "understanding")
    .think(tr("s5.l086"), "recognizing")
    .say("yamamoto", tr("s5.l087"), "encouraging")
    .say("yamamoto", tr("s5.l088"), "pointing_out")
    .say("yamamoto", tr("s5.l089"), "sincere")
    .n(tr("s5.l090"))
    .think(tr("s5.l091"), "reflecting")
    .think(tr("s5.l092"), "moved")
    .vocab("仲間", "なかま", "nakama", tr("s5.v.nakama"), {'category': "social"})
    .say("yamamoto", tr("s5.l093"), "casually")
    .vocab("公民館", "こうみんかん", "kouminkan", tr("s5.v.kouminkan"), {
      'category': "community",
    })
    .say("yamamoto", tr("s5.l094"), "meaningful")
    .n(tr("s5.l095"))
    .n(tr("s5.l096"))
    .think(tr("s5.l097"), "amused")
    .say("yamamoto", tr("s5.l098"), "carefully")
    .menu()
    .choice(tr("s5.l099"), "offer_help", {
      'hint': "I was a teacher. For thirty years.",
    })
    .choice(tr("s5.l100"), "deflect_offer", {
      'hint': "I wouldn't want to impose...",
    })
    .endMenu()
    .hide("yamamoto")
    .jump("act2_enter")
    .scene("offer_help_scene", "offer_help")
    .player(tr("s5.b005"), "humble")
    .say("yamamoto", tr("s5.b006"), "excited")
    .hide("yamamoto")
    .jump("act2_enter")
    .scene("deflect_offer_scene", "deflect_offer")
    .player(tr("s5.b007"), "humble")
    .say("yamamoto", tr("s5.b008"), "reassuring")
    .hide("yamamoto")
    .jump("act2_enter")
    // ============================================
    // ACT 2: THE COMMUNITY CENTER
    // ============================================
    .scene("act2_scene1", "act2_enter")
    .bg("community_center_hallway", "morning")
    .music("calm")
    .n(tr("s5.l101"))
    .n(tr("s5.l102"))
    .vocab("習い事", "ならいごと", "naraigoto", tr("s5.v.naraigoto"), {
      'category': "community",
    })
    .n(tr("s5.l103"))
    .n(tr("s5.l104"))
    .think(tr("s5.l105"), "small_pride")
    .vocab("手芸", "しゅげい", "shugei", tr("s5.v.shugei"), {'category': "hobbies"})
    .vocab("趣味", "しゅみ", "shumi", tr("s5.v.shumi"), {'category': "lifestyle"})
    .show("yamamoto", "right", "pleased")
    .n(tr("s5.l106"))
    .say("yamamoto", tr("s5.l107"), "relieved")
    .say("yamamoto", tr("s5.l108"), "excited")
    .player(tr("s5.l109"), "humble")
    .say("yamamoto", tr("s5.l110"), "reassuring")
    .jump("meet_the_class")
    // ============================================
    .scene("act2_scene2", "meet_the_class")
    .bg("community_center_room", "morning")
    .music("warm_ensemble")
    .n(tr("s5.l111"))
    .n(tr("s5.l112"))
    .n(tr("s5.l113"))
    .show("class_members", "center", "expectant")
    .n(tr("s5.l114"))
    .n(tr("s5.l115"))
    .n(tr("s5.l116"))
    .player(tr("s5.l117"), "warm")
    .player(tr("s5.l118"), "honest")
    .player(tr("s5.l119"), "inviting")
    .n(tr("s5.l120"))
    .n(tr("s5.l121"))
    .show("obaa", "center", "delighted")
    .say("obaa", tr("s5.l122"), "enthusiastic")
    .vocab("面白い", "おもしろい", "omoshiroi", tr("s5.v.omoshiroi"), {
      'category': "emotions",
      'jlpt': "N5",
    })
    .n(tr("s5.l123"))
    .n(tr("s5.l124"))
    .show("tanaka_toru", "left", "earnest")
    .n(tr("s5.l125"))
    .say("tanaka_toru", tr("s5.l126"), "earnest")
    .player(tr("s5.l127"), "encouraging")
    .say("tanaka_toru", tr("s5.l128"), "smiling")
    .say("tanaka_toru", tr("s5.l129"), "hopeful")
    .player(tr("s5.l130"), "gentle_humor")
    .player(tr("s5.l131"), "supporting")
    .vocab("上手", "じょうず", "jouzu", tr("s5.v.jouzu"), {
      'category': "praise",
      'jlpt': "N5",
    })
    .show("obaa", "right", "curious")
    .say("obaa", tr("s5.l132"), "direct")
    .think(tr("s5.l133"), "self_assessing")
    .player(tr("s5.l134"), "earnest")
    .vocab("毎日", "まいにち", "mainichi", tr("s5.v.mainichi"), {
      'category': "time",
      'jlpt': "N5",
    })
    .say("obaa", tr("s5.l135"), "impressed")
    .say("obaa", tr("s5.l136"), "wise")
    .vocab(
      "継続は力なり",
      "けいぞくはちからなり",
      "keizoku wa chikara nari",
      tr("s5.v.keizoku_wa_chikara_nari"),
      {'category': "proverbs", 'jlpt': "N3"},
    )
    .n(tr("s5.l137"))
    .jump("lesson_exchange")
    // ============================================
    .scene("act2_scene3", "lesson_exchange")
    .bg("community_center_room", "morning")
    .n(tr("s5.l138"))
    .n(tr("s5.l139"))
    .n(tr("s5.l140"))
    .n(tr("s5.l141"))
    .vocab("助数詞", "じょすうし", "josuushi", tr("s5.v.josuushi"), {
      'category': "grammar",
      'jlpt': "N4",
    })
    .n(tr("s5.l142"))
    .n(tr("s5.l143"))
    .n(tr("s5.l144"))
    .show("tanaka_toru", "left", "trying")
    .say("tanaka_toru", tr("s5.l145"), "curious")
    .player(tr("s5.l146"), "teaching")
    .say("tanaka_toru", tr("s5.l147"), "practicing")
    .say("tanaka_toru", tr("s5.l148"), "unsure")
    .player(tr("s5.l149"), "approving")
    .show("obaa", "right", "raising_hand")
    .say("obaa", tr("s5.l150"), "playful")
    .say("obaa", tr("s5.l151"), "teaching")
    .vocab(
      "教えていただけますか",
      null,
      "oshiete itadakemasu ka",
      tr("s5.v.oshiete_itadakemasu_ka"),
      {'category': "polite_expressions"},
    )
    .player(tr("s5.l152"), "attempting")
    .n(tr("s5.l153"))
    .say("obaa", tr("s5.l154"), "thrilled")
    .think(tr("s5.l155"), "amused")
    .think(tr("s5.l156"), "warm")
    .hideAll()
    .jump("after_class_moment")
    // ============================================
    .scene("act2_scene4", "after_class_moment")
    .bg("community_center_hallway", "noon")
    .show("yamamoto", "center", "pleased")
    .n(tr("s5.l157"))
    .say("yamamoto", tr("s5.l158"), "curious")
    .player(tr("s5.l159"), "honest")
    .say("yamamoto", tr("s5.l160"), "happy")
    .player(tr("s5.l161"), "admitting")
    .player(tr("s5.l162"), "reflective")
    .say("yamamoto", tr("s5.l163"), "gentle")
    .vocab("思い出す", "おもいだす", "omoidasu", tr("s5.v.omoidasu"), {
      'category': "verbs",
      'jlpt': "N4",
    })
    .player(tr("s5.l164"), "moved")
    .n(tr("s5.l165"))
    .n(tr("s5.l166"))
    .hideAll()
    .jump("act3_enter")
    // ============================================
    // ACT 3: THE HARD DAYS
    // ============================================
    .scene("act3_scene1", "act3_enter")
    .bg("david_apartment", "evening")
    .music("quiet_domestic")
    .n(tr("s5.l167"))
    .n(tr("s5.l168"))
    .n(tr("s5.l169"))
    .show("david", "left", "concerned")
    .show("yuko", "right", "gentle")
    .say("david", tr("s5.l170"), "concerned")
    .think(tr("s5.l171"), "noting")
    .think(tr("s5.l172"), "reading_him")
    .player(tr("s5.l173"), "deflecting")
    .say("david", tr("s5.l174"), "questioning")
    .n(tr("s5.l175"))
    .player(tr("s5.l176"), "sighing")
    .player(tr("s5.l177"), "explaining")
    .player(tr("s5.l178"), "explaining")
    .say("yuko", tr("s5.l179"), "gentle")
    .vocab("遠慮", "えんりょ", "enryo", tr("s5.v.enryo"), {'category': "social"})
    .player(tr("s5.l180"), "stubborn")
    .player(tr("s5.l181"), "honest")
    .say("david", tr("s5.l182"), "softly")
    .player(tr("s5.l183"), "frustrated")
    .player(tr("s5.l184"), "defeated")
    .vocab("もう一度", "もういちど", "mou ichido", tr("s5.v.mou_ichido"), {
      'category': "phrases",
    })
    .player(tr("s5.l185"), "small")
    .show("yuko", "right", "empathetic")
    .say("yuko", tr("s5.l186"), "moved")
    .player(tr("s5.l187"), "proud")
    .player(tr("s5.l188"), "listing")
    .player(tr("s5.l189"), "bitter")
    .say("david", tr("s5.l190"), "firm")
    .player(tr("s5.l191"), "conceding")
    .player(tr("s5.l192"), "honest")
    .show("yuko", "center", "deciding")
    .say("yuko", tr("s5.l193"), "gentle_call")
    .say("yuko", tr("s5.l194"), "supportive")
    .say("yuko", tr("s5.l195"), "wise")
    .vocab("世話になる", "せわになる", "sewa ni naru", tr("s5.v.sewa_ni_naru"), {
      'category': "phrases",
    })
    .think(tr("s5.l196"), "absorbing")
    .think(tr("s5.l197"), "shifting")
    .n(tr("s5.l198"))
    .show("kenta", "center", "sleepy")
    .say("kenta", tr("s5.l199"), "half_asleep")
    .n(tr("s5.l200"))
    .n(tr("s5.l201"))
    .think(tr("s5.l202"), "pierced")
    .think(tr("s5.l203"), "clarity")
    .hideAll()
    .jump("act3_scene2")
    // ============================================
    .scene("act3_scene2", "the_bad_morning")
    .bg("margaret_apartment", "morning")
    .music("quiet_melancholy")
    .n(tr("s5.l204"))
    .n(tr("s5.l205"))
    .n(tr("s5.l206"))
    .n(tr("s5.l207"))
    .think(tr("s5.l208"), "dark_thought")
    .think(tr("s5.l209"), "sinking")
    .n(tr("s5.l210"))
    .n(tr("s5.l211"))
    .n(tr("s5.l212"))
    .n(tr("s5.l213"))
    .think(tr("s5.l214"), "recognizing")
    .think(tr("s5.l215"), "seeing_her")
    .n(tr("s5.l216"))
    .n(tr("s5.l217"))
    .n(tr("s5.l218"))
    .vocab("諦める", "あきらめる", "akirameru", tr("s5.v.akirameru"), {
      'category': "verbs",
    })
    .vocab("挑戦", "ちょうせん", "chousen", tr("s5.v.chousen"), {'category': "verbs"})
    .think(tr("s5.l219"), "realizing")
    .think(tr("s5.l220"), "remembering")
    .n(tr("s5.l221"))
    .jump("act4_enter")
    // ============================================
    // ACT 4: BELONGING
    // ============================================
    .scene("act4_scene1", "act4_enter")
    .bg("community_center_room", "morning")
    .music("warm_ensemble")
    .n(tr("s5.l237"))
    .n(tr("s5.l238"))
    .n(tr("s5.l239"))
    .show("obaa", "center", "waiting")
    .n(tr("s5.l240"))
    .say("obaa", tr("s5.l241"), "excited")
    .player(tr("s5.l242"), "curious")
    .vocab("特別", "とくべつ", "tokubetsu", tr("s5.v.tokubetsu"), {
      'category': "adjectives",
      'jlpt': "N4",
    })
    .say("obaa", tr("s5.l243"), "proud")
    .vocab("町内会", "ちょうないかい", "chounai kai", tr("s5.v.chounai_kai"), {
      'category': "community",
    })
    .n(tr("s5.l244"))
    .n(tr("s5.l245"))
    .show("tanaka_toru", "left", "proud")
    .say("tanaka_toru", tr("s5.l246"), "smiling")
    .say("tanaka_toru", tr("s5.l247"), "laughing")
    .player(tr("s5.l248"), "surprised")
    .say("tanaka_toru", tr("s5.l249"), "wise")
    .think(tr("s5.l250"), "turning_it_over")
    .think(tr("s5.l251"), "understanding")
    .jump("act4_scene2")
    // ============================================
    .scene("act4_scene2", "mini_showcase")
    .bg("community_center_room", "morning")
    .n(tr("s5.l252"))
    .n(tr("s5.l253"))
    .n(tr("s5.l254"))
    .n(tr("s5.l255"))
    .show("fujita", "center", "nervous_then_proud")
    .say("fujita", tr("s5.l256"), "performing")
    .vocab("すみません", null, "sumimasen", tr("s5.v.sumimasen"), {
      'category': "phrases",
    })
    .vocab("駅", "えき", "eki", tr("s5.v.eki"), {
      'category': "transport",
      'jlpt': "N5",
    })
    .n(tr("s5.l257"))
    .n(tr("s5.l258"))
    .show("obaa", "center", "inviting")
    .say("obaa", tr("s5.l259"), "encouraging")
    .n(tr("s5.l260"))
    .n(tr("s5.l261"))
    .n(tr("s5.l262"))
    .player(tr("s5.l263"), "quiet")
    .n(tr("s5.l264"))
    .vocab("ここに来て", null, "koko ni kite", tr("s5.v.koko_ni_kite"), {
      'category': "phrases",
      'jlpt': "N3",
    })
    .vocab("よかった", null, "yokatta", tr("s5.v.yokatta"), {
      'category': "phrases",
      'jlpt': "N4",
    })
    .n(tr("s5.l265"))
    .n(tr("s5.l266"))
    .show("yamamoto", "right", "moved")
    .say("yamamoto", tr("s5.l267"), "sincere")
    .n(tr("s5.l268"))
    .vocab("居心地がいい", "いごこちがいい", "igokochi ga ii", tr("s5.v.igokochi_ga_ii"), {
      'category': "emotions",
    })
    .think(tr("s5.l269"), "settling")
    .think(tr("s5.l270"), "wonder")
    .think(tr("s5.l271"), "arrived")
    .hideAll()
    .jump("act5_enter")
    // ============================================
    // ACT 5: THE CHECKUP
    // ============================================
    .scene("act5_scene1", "act5_enter")
    .bg("clinic_waiting_room", "morning")
    .music("gentle_strings")
    .n(tr("s5.l276"))
    .n(tr("s5.l277"))
    .n(tr("s5.l278"))
    .vocab("定期検診", "ていきけんしん", "teiki kenshin", tr("s5.v.teiki_kenshin"), {
      'category': "medical",
    })
    .n(tr("s5.l279"))
    .show("nurse_akemi", "center", "professional")
    .n(tr("s5.l280"))
    .say("nurse_akemi", tr("s5.l281"), "routine")
    .vocab("症状", "しょうじょう", "shoujou", tr("s5.v.shoujou"), {
      'category': "medical",
    })
    .player(tr("s5.l282"), "confident")
    .n(tr("s5.l283"))
    .n(tr("s5.l284"))
    .say("nurse_akemi", tr("s5.l285"), "surprised")
    .n(tr("s5.l286"))
    .player(tr("s5.l287"), "simple_pride")
    .vocab("練習", "れんしゅう", "renshuu", tr("s5.v.renshuu"), {
      'category': "verbs",
      'jlpt': "N4",
    })
    .say("nurse_akemi", tr("s5.l288"), "thoughtful")
    .vocab("ゆっくり", null, "yukkuri", tr("s5.v.yukkuri"), {'category': "adverbs"})
    .player(tr("s5.l289"), "accepting_the_challenge")
    .n(tr("s5.l290"))
    .n(tr("s5.l291"))
    .n(tr("s5.l292"))
    .think(tr("s5.l293"), "proud")
    .think(tr("s5.l294"), "competent")
    .hideAll()
    .jump("act5_scene2")
    // ============================================
    .scene("act5_scene2", "blood_pressure_results")
    .bg("clinic_exam_room", "morning")
    .show("dr_ito", "center", "reviewing")
    .n(tr("s5.l295"))
    .say("dr_ito", tr("s5.l296"), "pleased")
    .n(tr("s5.l297"))
    .player(tr("s5.l298"), "happy")
    .say("dr_ito", tr("s5.l299"), "curious")
    .player(tr("s5.l300"), "answering")
    .player(tr("s5.l301"), "simple")
    .player(tr("s5.l302"), "quiet")
    .think(tr("s5.l303"), "realizing")
    .vocab("友達", "ともだち", "tomodachi", tr("s5.v.tomodachi"), {
      'category': "social",
      'jlpt': "N5",
    })
    .say("dr_ito", tr("s5.l304"), "thoughtful")
    .n(tr("s5.l305"))
    .vocab("地域", "ちいき", "chiiki", tr("s5.v.chiiki"), {'category': "community"})
    .say("dr_ito", tr("s5.l306"), "recommending")
    .player(tr("s5.l307"), "certain")
    .vocab("続ける", "つづける", "tsuzukeru", tr("s5.v.tsuzukeru"), {
      'category': "verbs",
      'jlpt': "N4",
    })
    .n(tr("s5.l308"))
    .hideAll()
    .jump("epilogue")
    // ============================================
    // EPILOGUE
    // ============================================
    .scene("epilogue_scene1", "epilogue")
    .bg("suburban_street", "golden_afternoon")
    .music("never_too_late_reprise")
    .n(tr("s5.l309"))
    .n(tr("s5.l310"))
    .show("yamamoto", "center", "watering")
    .n(tr("s5.l311"))
    .player(tr("s5.l312"), "admiring")
    .vocab("綺麗", "きれい", "kirei", tr("s5.v.kirei"), {
      'category': "adjectives",
      'jlpt': "N5",
    })
    .say("yamamoto", tr("s5.l313"), "offering")
    .n(tr("s5.l314"))
    .say("yamamoto", tr("s5.l315"), "casually")
    .say("yamamoto", tr("s5.l316"), "continuing")
    .n(tr("s5.l317"))
    .player(tr("s5.l318"), "curious")
    .say("yamamoto", tr("s5.l319"), "calm")
    .n(tr("s5.l320"))
    .think(tr("s5.l321"), "smiling_inside")
    .player(tr("s5.l322"), "welcoming")
    .player(tr("s5.l323"), "certain")
    .vocab("仲間", "なかま", "nakama", tr("s5.v.nakama"), {'category': "social"})
    .n(tr("s5.l324"))
    .n(tr("s5.l325"))
    .n(tr("s5.l326"))
    .n(tr("s5.l327"))
    .n(tr("s5.l328"))
    .n(tr("s5.l329"))
    .hideAll()
    .fadeOut()
    .wait(2000)
    .n(tr("s5.l330"))
    .fadeIn()
    .jump("debrief1")
    // ============================================
    // DEBRIEF 1: Initial Reactions
    // ============================================
    .scene("debrief1", "classroom_return")
    .bg("classroom", "afternoon")
    .music("calm")
    .n(tr("s5.l301"))
    .n(tr("s5.l302"))
    .show("tanaka", "center", "thoughtful")
    .say("tanaka", tr("s5.l303"), "beginning")
    .say("tanaka", tr("s5.l304"), "opening")
    .show("ken", "right", "moved")
    .say("ken", tr("s5.l305"), "honest")
    .say("ken", tr("s5.l306"), "qualifying")
    .say("ken", tr("s5.l307"), "admitting")
    .show("mei", "left", "nodding")
    .say("mei", tr("s5.l308"), "relating")
    .say("mei", tr("s5.l309"), "quietly")
    .say("tanaka", tr("s5.l310"), "curious")
    .say("mei", tr("s5.l311"), "sharing")
    .say("mei", tr("s5.l312"), "small")
    .say("mei", tr("s5.l313"), "honest")
    .jump("debrief2")
    // ============================================
    // DEBRIEF 2: Language & Age
    // ============================================
    .scene("debrief2", "age_and_language")
    .show("tanaka", "center", "teaching")
    .say("tanaka", tr("s5.l314"), "building")
    .say("tanaka", tr("s5.l315"), "prompting")
    .show("yuki", "right", "raising_hand")
    .say("yuki", tr("s5.l316"), "clear")
    .say("tanaka", tr("s5.l317"), "affirming")
    .say("tanaka", tr("s5.l318"), "pressing")
    .show("ken", "left", "thinking")
    .say("ken", tr("s5.l319"), "analytical")
    .say("ken", tr("s5.l320"), "pointing_out")
    .say("ken", tr("s5.l321"), "wry")
    .say("tanaka", tr("s5.l322"), "nodding")
    .say("mei", tr("s5.l323"), "translating")
    .say("tanaka", tr("s5.l324"), "smiling")
    .say("tanaka", tr("s5.l325"), "meaningful")
    .n(tr("s5.l326"))
    .say("tanaka", tr("s5.l327"), "teaching")
    .say("tanaka", tr("s5.l328"), "explaining")
    .say("tanaka", tr("s5.l329"), "distinguishing")
    .jump("debrief3")
    // ============================================
    // DEBRIEF 3: Cultural Context
    // ============================================
    .scene("debrief3", "cultural_context")
    .show("tanaka", "center", "cultural_teaching")
    .say("tanaka", tr("s5.l330"), "pointing")
    .vocab("遠慮", "えんりょ", "enryo", tr("s5.v.enryo"), {'category': "social"})
    .say("tanaka", tr("s5.l331"), "connecting")
    .say("tanaka", tr("s5.l332"), "example")
    .say("tanaka", tr("s5.l333"), "explaining")
    .show("yuki", "right", "engaged")
    .say("yuki", tr("s5.l334"), "nodding")
    .say("yuki", tr("s5.l335"), "explaining")
    .say("tanaka", tr("s5.l336"), "prompting")
    .show("mei", "left", "remembering")
    .say("mei", tr("s5.l337"), "quoting")
    .say("tanaka", tr("s5.l338"), "thoughtful")
    .say("tanaka", tr("s5.l339"), "wise")
    .jump("debrief4")
    // ============================================
    // DEBRIEF 4: Personal Sharing
    // ============================================
    .scene("debrief4", "personal_sharing")
    .show("tanaka", "center", "open")
    .say("tanaka", tr("s5.l340"), "asking")
    .menu()
    .choice(tr("s5.l341"), "player_shares_scene", {
      'hint': "I remember arriving here and not understanding anything.",
    })
    .choice(tr("s5.l342"), "listen_mode", {'hint': "..."})
    .endMenu()
    .scene("listen_mode_scene", "listen_mode")
    .show("tanaka", "center", "gentle")
    .say("tanaka", tr("s5.b009"), "gentle")
    .jump("debrief5")
    .scene("player_shares_alt", "player_shares_scene")
    .show("tanaka", "center", "listening")
    .player(tr("s5.l343"), "vulnerable")
    .player(tr("s5.l344"), "listing")
    .player(tr("s5.l345"), "specific")
    .say("ken", tr("s5.l346"), "laughing")
    .say("tanaka", tr("s5.l347"), "gentle")
    .player(tr("s5.l348"), "surprised_at_self")
    .say("tanaka", tr("s5.l349"), "connecting")
    .jump("debrief5")
    // ============================================
    // DEBRIEF 5: Closing
    // ============================================
    .scene("debrief5", "closing")
    .show("tanaka", "center", "warm")
    .say("tanaka", tr("s5.l350"), "summarizing")
    .say("tanaka", tr("s5.l351"), "smiling")
    .show("ken", "right", "laughing")
    .say("ken", tr("s5.l352"), "delighted")
    .say("tanaka", tr("s5.l353"), "asking")
    .show("yuki", "left", "thoughtful")
    .say("yuki", tr("s5.l354"), "slow_realization")
    .say("yuki", tr("s5.l355"), "building")
    .say("tanaka", tr("s5.l356"), "affirming")
    .say("tanaka", tr("s5.l357"), "meaningful")
    .n(tr("s5.l358"))
    .say("tanaka", tr("s5.l359"), "transitioning")
    .say("tanaka", tr("s5.l360"), "genuine")
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
    .show("yuki", "center", "soft")
    .n(tr("s5.l361"))
    .say("yuki", tr("s5.l362"), "careful")
    .player(tr("s5.l363"), "open")
    .say("yuki", tr("s5.l364"), "beginning")
    .say("yuki", tr("s5.l365"), "sad")
    .say("yuki", tr("s5.l366"), "quiet")
    .say("yuki", tr("s5.l367"), "aching")
    .player(tr("s5.l368"), "genuine")
    .say("yuki", tr("s5.l369"), "connecting")
    .say("yuki", tr("s5.l370"), "simple")
    .say("yuki", tr("s5.l371"), "naming_them")
    .say("yuki", tr("s5.l372"), "honest")
    .n(tr("s5.l373"))
    .player(tr("s5.l374"), "quiet")
    .n(tr("s5.l375"))
    .n(tr("s5.l376"))
    .n(tr("s5.l377"))
    .hideAll()
    .fadeOut()
    .n(tr("s5.l300"))
    .build();
