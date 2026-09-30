import '../dialogue_builder.dart';

// Vocabulary list for Story 7
final story7Vocabulary = <StoryWord>[
  // Expressing change / comparison (past vs. now)
  word("変わる", "かわる", "kawaru", "To change (intransitive)", {
    'category': "verbs",
    'jlpt': "N4",
  }),
  word("変える", "かえる", "kaeru", "To change (transitive)", {
    'category': "verbs",
    'jlpt': "N4",
  }),
  word("以前", "いぜん", "izen", "Before / previously / formerly", {
    'category': "time",
    'jlpt': "N3",
  }),
  word("当時", "とうじ", "touji", "At that time / back then", {
    'category': "time",
    'jlpt': "N3",
  }),
  word("昔", "むかし", "mukashi", "Long ago / the old days / once", {
    'category': "time",
    'jlpt': "N4",
  }),
  word("今でも", "いまでも", "ima demo", "Even now / still", {
    'category': "time",
    'jlpt': "N3",
  }),
  word("なくなる", null, "nakunaru", "To disappear / to be gone / to run out", {
    'category': "verbs",
    'jlpt': "N3",
  }),
  word("残る", "のこる", "nokoru", "To remain / to be left behind", {
    'category': "verbs",
    'jlpt': "N3",
  }),

  // Nostalgia / emotional states
  word("懐かしい", "なつかしい", "natsukashii", "Nostalgic / dear / fondly remembered", {
    'category': "emotions",
    'jlpt': "N3",
  }),
  word("寂しい", "さびしい", "sabishii", "Lonely / lonesome / desolate", {
    'category': "emotions",
    'jlpt': "N4",
  }),
  word("切ない", "せつない", "setsunai", "Bittersweet / aching / painfully sweet", {
    'category': "emotions",
    'jlpt': "N3",
  }),
  word(
    "感慨深い",
    "かんがいぶかい",
    "kangai fukai",
    "Deeply moving / filled with emotion",
    {'category': "emotions", 'jlpt': "N3"},
  ),
  word(
    "期待外れ",
    "きたいはずれ",
    "kitai hazure",
    "Disappointment / not living up to expectations",
    {'category': "emotions", 'jlpt': "N3"},
  ),

  // Travel / returning
  word("再訪", "さいほう", "saihou", "Return visit / revisiting", {
    'category': "travel",
    'jlpt': "N3",
  }),
  word("帰国", "きこく", "kikoku", "Returning to one's home country", {
    'category': "travel",
    'jlpt': "N3",
  }),
  word("滞在", "たいざい", "taizai", "Stay / sojourn", {
    'category': "travel",
    'jlpt': "N3",
  }),
  word("留学", "りゅうがく", "ryuugaku", "Study abroad", {
    'category': "education",
    'jlpt': "N3",
  }),

  // Identity / belonging
  word("居場所", "いばしょ", "ibasho", "One's place / somewhere one belongs", {
    'category': "social",
    'jlpt': "N3",
  }),
  word("よそ者", "よそもの", "yosomono", "Outsider / stranger / newcomer", {
    'category': "social",
    'jlpt': "N3",
  }),
  word(
    "なじむ",
    null,
    "najimu",
    "To become familiar with / to fit in / to blend in",
    {'category': "verbs", 'jlpt': "N3"},
  ),
  word(
    "懐に入る",
    "ふところにはいる",
    "futokoro ni hairu",
    "To be welcomed in / to be taken into someone's heart",
    {'category': "phrases", 'jlpt': "N3"},
  ),

  // Places / city change
  word("取り壊す", "とりこわす", "torikohawasu", "To demolish / to tear down", {
    'category': "verbs",
    'jlpt': "N3",
  }),
  word("建て替える", "たてかえる", "tatekaheru", "To rebuild / to reconstruct", {
    'category': "verbs",
    'jlpt': "N3",
  }),
  word(
    "跡地",
    "あとち",
    "atochi",
    "Site of a demolished building / former location",
    {'category': "nouns", 'jlpt': "N3"},
  ),
  word("面影", "おもかげ", "omokage", "Trace / vestige / lingering image", {
    'category': "literary",
    'jlpt': "N3",
  }),

  // Grammar / expression
  word("〜たものだ", null, "~ta mono da", "Used to ~ (nostalgic recollection)", {
    'category': "grammar",
    'jlpt': "N3",
  }),
  word(
    "〜ていた",
    null,
    "~te ita",
    "Was doing ~ / used to do ~ (continuous past)",
    {'category': "grammar", 'jlpt': "N4"},
  ),
  word(
    "〜ようになった",
    null,
    "~you ni natta",
    "Has come to ~ / now ~ (change over time)",
    {'category': "grammar", 'jlpt': "N3"},
  ),
  word(
    "〜なくなった",
    null,
    "~naku natta",
    "Has stopped ~ / no longer ~ (change / loss)",
    {'category': "grammar", 'jlpt': "N3"},
  ),
];

StoryData getStory7() => dialogue()
    .story(7, tr("s7.title"), tr("s7.subtitle"))
    .description(tr("s7.desc"))
    .estimatedTime("75-90 minutes")
    .jlptFocus("N3")
    .vocabularyList(story7Vocabulary)
    // ============================================
    // PROLOGUE
    // ============================================
    .scene("prologue", "landing")
    .titleCard(tr("s7.card_title"), tr("s7.card_subtitle"))
    .music("return_bittersweet")
    .bg("narita_arrivals", "morning")
    .n(tr("s7.l001"))
    .n(tr("s7.l002"))
    .n(tr("s7.l003"))
    .n(tr("s7.l004"))
    .n(tr("s7.l005"))
    .n(tr("s7.l006"))
    .n(tr("s7.l007"))
    .vocab("留学", "りゅうがく", "ryuugaku", "Study abroad", {'category': "education"})
    .vocab("再訪", "さいほう", "saihou", "Return visit / revisiting", {
      'category': "travel",
    })
    .think(tr("s7.l008"), "counting")
    .think(tr("s7.l009"), "honest")
    .think(tr("s7.l010"), "more_honest")
    .think(tr("s7.l011"), "landing")
    .n(tr("s7.l012"))
    .n(tr("s7.l013"))
    .n(tr("s7.l014"))
    .bg("narita_arrivals", "morning")
    .n(tr("s7.l015"))
    .n(tr("s7.l016"))
    .n(tr("s7.l017"))
    .think(tr("s7.l018"), "feeling_it")
    .vocab("懐かしい", "なつかしい", "natsukashii", "Nostalgic / fondly remembered", {
      'category': "emotions",
    })
    .n(tr("s7.l019"))
    .jump("act1_enter")
    // ============================================
    // ACT 1: THE CITY HAS MOVED ON
    // ============================================
    .scene("act1_scene1", "act1_enter")
    .bg("tokyo_train_window", "morning")
    .music("return_bittersweet")
    .n(tr("s7.l020"))
    .n(tr("s7.l021"))
    .n(tr("s7.l022"))
    .n(tr("s7.l023"))
    .vocab("変わる", "かわる", "kawaru", "To change (intransitive)", {
      'category': "verbs",
    })
    .vocab("なくなる", null, "nakunaru", "To disappear / to be gone", {
      'category': "verbs",
    })
    .think(tr("s7.l024"), "obvious_thought")
    .think(tr("s7.l025"), "honest")
    .n(tr("s7.l026"))
    .n(tr("s7.l027"))
    .n(tr("s7.l028"))
    .n(tr("s7.l029"))
    .vocab("おかえり", null, "okaeri", "Welcome back (said to someone returning)", {
      'category': "greetings",
      'jlpt': "N5",
    })
    .think(tr("s7.l030"), "sitting_with_it")
    .think(tr("s7.l031"), "noticing")
    .think(tr("s7.l032"), "asking")
    .n(tr("s7.l033"))
    .n(tr("s7.l034"))
    .jump("act1_scene2")
    // ============================================
    .scene("act1_scene2", "shimokitazawa_arrival")
    .bg("shimokitazawa_street", "afternoon")
    .music("acoustic_nostalgia")
    .n(tr("s7.l035"))
    .n(tr("s7.l036"))
    .n(tr("s7.l037"))
    .n(tr("s7.l038"))
    .n(tr("s7.l039"))
    .think(tr("s7.l040"), "looking")
    .think(tr("s7.l041"), "arriving")
    .vocab(
      "跡地",
      "あとち",
      "atochi",
      "Site of a demolished building / former location",
      {'category': "nouns"},
    )
    .vocab("面影", "おもかげ", "omokage", "Trace / vestige / lingering image", {
      'category': "literary",
    })
    .n(tr("s7.l042"))
    .n(tr("s7.l043"))
    .think(tr("s7.l044"), "absorbing")
    .think(tr("s7.l045"), "rationalizing")
    .think(tr("s7.l046"), "insisting")
    .n(tr("s7.l047"))
    .n(tr("s7.l048"))
    .n(tr("s7.l049"))
    .n(tr("s7.l050"))
    .n(tr("s7.l051"))
    .think(tr("s7.l052"), "stopped")
    .vocab("取り壊す", "とりこわす", "torikohawasu", "To demolish / to tear down", {
      'category': "verbs",
    })
    .n(tr("s7.l053"))
    .n(tr("s7.l054"))
    .n(tr("s7.l055"))
    .think(tr("s7.l056"), "remembering")
    .think(tr("s7.l057"), "remembering_more")
    .think(tr("s7.l058"), "honest")
    .n(tr("s7.l059"))
    .n(tr("s7.l060"))
    .n(tr("s7.l061"))
    .vocab("当時", "とうじ", "touji", "At that time / back then", {
      'category': "time",
    })
    .jump("act1_scene3")
    // ============================================
    .scene("act1_scene3", "reunion_sota")
    .bg("shimokitazawa_bar", "evening")
    .music("warm_reunion")
    .show("sota", "center", "delighted")
    .n(tr("s7.l062"))
    .n(tr("s7.l063"))
    .say("sota", tr("s7.l064"), "amazed")
    .n(tr("s7.l065"))
    .n(tr("s7.l066"))
    .player(tr("s7.l067"), "laughing")
    .say("sota", tr("s7.l068"), "curious")
    .vocab(
      "〜ぶり",
      null,
      "~buri",
      "For the first time in ~ / after ~ (time expression)",
      {'category': "grammar", 'jlpt': "N3"},
    )
    .think(tr("s7.l069"), "translating")
    .player(tr("s7.l070"), "honest")
    .vocab(
      "切ない",
      "せつない",
      "setsunai",
      "Bittersweet / aching / painfully sweet",
      {'category': "emotions"},
    )
    .say("sota", tr("s7.l071"), "nodding")
    .say("sota", tr("s7.l072"), "gentle")
    .player(tr("s7.l073"), "quiet")
    .player(tr("s7.l074"), "flat")
    .say("sota", tr("s7.l075"), "matter_of_fact")
    .say("sota", tr("s7.l076"), "understanding")
    .player(tr("s7.l077"), "adding")
    .say("sota", tr("s7.l078"), "knowing")
    .n(tr("s7.l079"))
    .n(tr("s7.l080"))
    .say("sota", tr("s7.l081"), "gently_challenging")
    .think(tr("s7.l082"), "translating_to_yourself")
    .menu()
    .choice(tr("s7.c001"), "expected_same", {'hint': tr("s7.h001")})
    .choice(tr("s7.c002"), "expected_home", {'hint': tr("s7.h002")})
    .choice(tr("s7.c003"), "expected_unknown", {'hint': tr("s7.h003")})
    .endMenu()
    .scene("act1_choice_resolve", "sota_responds")
    .show("sota", "center", "thoughtful")
    .say("sota", tr("s7.l083"), "careful")
    .say("sota", tr("s7.l084"), "certain")
    .say("sota", tr("s7.l085"), "honest")
    .vocab("以前", "いぜん", "izen", "Before / previously / formerly", {
      'category': "time",
    })
    .think(tr("s7.l086"), "absorbing")
    .think(tr("s7.l087"), "continuing")
    .say("sota", tr("s7.l088"), "lightening")
    .player(tr("s7.l089"), "explaining")
    .say("sota", tr("s7.l090"), "raised_eyebrow")
    .player(tr("s7.l091"), "determined")
    .say("sota", tr("s7.l092"), "smiling")
    .say("sota", tr("s7.l093"), "offering")
    .player(tr("s7.l094"), "decided")
    .say("sota", tr("s7.l095"), "respecting")
    .hideAll()
    .jump("act2_enter")
    // ============================================
    // ACT 2: THE TOUR
    // ============================================
    .scene("act2_scene1", "act2_enter")
    .bg("harajuku_street", "morning")
    .music("acoustic_nostalgia")
    .n(tr("s7.l096"))
    .n(tr("s7.l097"))
    .n(tr("s7.l098"))
    .vocab("昔", "むかし", "mukashi", "Long ago / the old days / once", {
      'category': "time",
    })
    .vocab("〜たものだ", null, "~ta mono da", "Used to ~ (nostalgic recollection)", {
      'category': "grammar",
    })
    .n(tr("s7.l099"))
    .n(tr("s7.l100"))
    .n(tr("s7.l101"))
    .n(tr("s7.l102"))
    .n(tr("s7.l103"))
    .show("cafe_owner", "center", "polite")
    .say("cafe_owner", tr("s7.l104"), "neutral")
    .player(tr("s7.l105"), "offering")
    .vocab(
      "〜ていた",
      null,
      "~te ita",
      "Was doing ~ / used to do ~ (continuous past)",
      {'category': "grammar"},
    )
    .say("cafe_owner", tr("s7.l106"), "warmly")
    .say("cafe_owner", tr("s7.l107"), "genuine")
    .think(tr("s7.l108"), "hearing_it")
    .think(tr("s7.l109"), "noting")
    .think(tr("s7.l110"), "accepting")
    .hideAll()
    .jump("act2_scene2")
    // ============================================
    .scene("act2_scene2", "sensei_visit")
    .bg("university_building", "afternoon")
    .music("quiet_contemplative")
    .n(tr("s7.l111"))
    .n(tr("s7.l112"))
    .n(tr("s7.l113"))
    .n(tr("s7.l114"))
    .show("nishimura", "center", "warm")
    .n(tr("s7.l115"))
    .say("nishimura", tr("s7.l116"), "delighted")
    .player(tr("s7.l117"), "warm")
    .say("nishimura", tr("s7.l118"), "laughing")
    .say("nishimura", tr("s7.l119"), "inviting")
    .player(tr("s7.l120"), "honest")
    .vocab("残る", "のこる", "nokoru", "To remain / to be left behind", {
      'category': "verbs",
    })
    .say("nishimura", tr("s7.l121"), "asking")
    .think(tr("s7.l122"), "considering")
    .player(tr("s7.l123"), "uncertain")
    .player(tr("s7.l124"), "honest")
    .say("nishimura", tr("s7.l125"), "approving")
    .say("nishimura", tr("s7.l126"), "building")
    .say("nishimura", tr("s7.l127"), "meaningful")
    .player(tr("s7.l128"), "curious")
    .say("nishimura", tr("s7.l129"), "quoting")
    .n(tr("s7.l130"))
    .say("nishimura", tr("s7.l131"), "explaining")
    .say("nishimura", tr("s7.l132"), "wise")
    .think(tr("s7.l133"), "sitting_with")
    .think(tr("s7.l134"), "honesty")
    .vocab(
      "感慨深い",
      "かんがいぶかい",
      "kangai fukai",
      "Deeply moving / filled with emotion",
      {'category': "emotions"},
    )
    .say("nishimura", tr("s7.l135"), "continuing")
    .say("nishimura", tr("s7.l136"), "building")
    .say("nishimura", tr("s7.l137"), "landing")
    .n(tr("s7.l138"))
    .think(tr("s7.l139"), "rearranging")
    .think(tr("s7.l140"), "accepting")
    .say("nishimura", tr("s7.l141"), "gentle")
    .player(tr("s7.l142"), "quiet")
    .vocab("寂しい", "さびしい", "sabishii", "Lonely / lonesome / desolate", {
      'category': "emotions",
    })
    .say("nishimura", tr("s7.l143"), "simply")
    .say("nishimura", tr("s7.l144"), "meaningful")
    .n(tr("s7.l145"))
    .n(tr("s7.l146"))
    .hideAll()
    .jump("act3_enter")
    // ============================================
    // ACT 3: THE OLD SPOT
    // ============================================
    .scene("act3_scene1", "act3_enter")
    .bg("yoyogi_park", "late_afternoon")
    .music("acoustic_nostalgia")
    .n(tr("s7.l147"))
    .n(tr("s7.l148"))
    .n(tr("s7.l149"))
    .n(tr("s7.l150"))
    .n(tr("s7.l151"))
    .n(tr("s7.l152"))
    .vocab("今でも", "いまでも", "ima demo", "Even now / still", {'category': "time"})
    .n(tr("s7.l153"))
    .n(tr("s7.l154"))
    .n(tr("s7.l155"))
    .think(tr("s7.l156"), "realizing")
    .think(tr("s7.l157"), "arriving")
    .think(tr("s7.l158"), "seeing_it")
    .n(tr("s7.l159"))
    .n(tr("s7.l160"))
    .n(tr("s7.l161"))
    .n(tr("s7.l162"))
    .n(tr("s7.l163"))
    .think(tr("s7.l164"), "honest")
    .think(tr("s7.l165"), "searching")
    .n(tr("s7.l166"))
    .n(tr("s7.l167"))
    .n(tr("s7.l168"))
    .n(tr("s7.l169"))
    .vocab(
      "期待外れ",
      "きたいはずれ",
      "kitai hazure",
      "Disappointment / not meeting expectations",
      {'category': "emotions"},
    )
    .n(tr("s7.l170"))
    .n(tr("s7.l171"))
    .n(tr("s7.l172"))
    .n(tr("s7.l173"))
    .think(tr("s7.l174"), "landing")
    .think(tr("s7.l175"), "honest")
    .think(tr("s7.l176"), "continuing")
    .think(tr("s7.l177"), "surprised")
    .jump("act3_scene2")
    // ============================================
    .scene("act3_scene2", "the_unexpected")
    .bg("shimokitazawa_alley", "evening")
    .music("quiet_discovery")
    .n(tr("s7.l178"))
    .n(tr("s7.l179"))
    .n(tr("s7.l180"))
    .show("bartender_yuna", "center", "relaxed")
    .n(tr("s7.l181"))
    .say("bartender_yuna", tr("s7.l182"), "welcoming")
    .player(tr("s7.l183"), "settled")
    .say("bartender_yuna", tr("s7.l184"), "offering")
    .vocab("居場所", "いばしょ", "ibasho", "One's place / somewhere one belongs", {
      'category': "social",
    })
    .n(tr("s7.l185"))
    .n(tr("s7.l186"))
    .n(tr("s7.l187"))
    .n(tr("s7.l188"))
    .n(tr("s7.l189"))
    .show("reading_woman", "right", "content")
    .say("reading_woman", tr("s7.l190"), "casual")
    .player(tr("s7.l191"), "honest")
    .say("reading_woman", tr("s7.l192"), "casual")
    .player(tr("s7.l193"), "explaining")
    .vocab(
      "〜ようになった",
      null,
      "~you ni natta",
      "Has come to ~ / now ~ (change over time)",
      {'category': "grammar"},
    )
    .say("reading_woman", tr("s7.l194"), "understanding")
    .think(tr("s7.l195"), "absorbing")
    .think(tr("s7.l196"), "sitting_with_it")
    .player(tr("s7.l197"), "accepting")
    .say("reading_woman", tr("s7.l198"), "curious")
    .player(tr("s7.l199"), "honest")
    .player(tr("s7.l200"), "articulating")
    .player(tr("s7.l201"), "gesturing_at_bar")
    .player(tr("s7.l202"), "realizing")
    .say("reading_woman", tr("s7.l203"), "simply")
    .think(tr("s7.l204"), "obvious_but_new")
    .think(tr("s7.l205"), "turning_it_over")
    .think(tr("s7.l206"), "shifting")
    .n(tr("s7.l207"))
    .n(tr("s7.l208"))
    .n(tr("s7.l209"))
    .hideAll()
    .jump("act4_enter")
    // ============================================
    // ACT 4: WHAT REMAINS
    // ============================================
    .scene("act4_scene1", "act4_enter")
    .bg("shimokitazawa_morning", "morning")
    .music("return_gentle")
    .n(tr("s7.l210"))
    .n(tr("s7.l211"))
    .show("sota", "center", "comfortable")
    .n(tr("s7.l212"))
    .show("yamamoto_curry", "left", "squinting")
    .say("yamamoto_curry", tr("s7.l213"), "peering")
    .player(tr("s7.l214"), "hoping")
    .say("yamamoto_curry", tr("s7.l215"), "calculating")
    .say("yamamoto_curry", tr("s7.l216"), "suddenly")
    .n(tr("s7.l217"))
    .n(tr("s7.l218"))
    .say("yamamoto_curry", tr("s7.l219"), "certain")
    .say("yamamoto_curry", tr("s7.l220"), "warm")
    .vocab("面影", "おもかげ", "omokage", "Trace / vestige / lingering image", {
      'category': "literary",
    })
    .think(tr("s7.l221"), "floored")
    .think(tr("s7.l222"), "counting")
    .n(tr("s7.l223"))
    .n(tr("s7.l224"))
    .say("sota", tr("s7.l225"), "gentle")
    .player(tr("s7.l226"), "rough")
    .say("yamamoto_curry", tr("s7.l227"), "ready")
    .player(tr("s7.l228"), "immediately")
    .say("yamamoto_curry", tr("s7.l229"), "approving")
    .n(tr("s7.l230"))
    .n(tr("s7.l231"))
    .say("sota", tr("s7.l232"), "meaningful")
    .player(tr("s7.l233"), "asking")
    .say("sota", tr("s7.l234"), "pointing_out")
    .vocab(
      "〜なくなった",
      null,
      "~naku natta",
      "Has stopped ~ / no longer ~ (change / loss)",
      {'category': "grammar"},
    )
    .player(tr("s7.l235"), "listing")
    .say("sota", tr("s7.l236"), "simple")
    .think(tr("s7.l237"), "sitting_with_it")
    .think(tr("s7.l238"), "continuing")
    .think(tr("s7.l239"), "honest")
    .think(tr("s7.l240"), "landing")
    .player(tr("s7.l241"), "quiet")
    .say("sota", tr("s7.l242"), "certain")
    .say("sota", tr("s7.l243"), "wise")
    .n(tr("s7.l244"))
    .hideAll()
    .jump("act4_scene2")
    // ============================================
    .scene("act4_scene2", "language_moment")
    .bg("bookshop", "afternoon")
    .music("quiet_discovery")
    .n(tr("s7.l245"))
    .n(tr("s7.l246"))
    .n(tr("s7.l247"))
    .vocab(
      "なじむ",
      null,
      "najimu",
      "To become familiar with / to fit in / to blend in",
      {'category': "verbs"},
    )
    .think(tr("s7.l248"), "realizing")
    .think(tr("s7.l249"), "honest")
    .think(tr("s7.l250"), "present_tense")
    .n(tr("s7.l251"))
    .n(tr("s7.l252"))
    .n(tr("s7.l253"))
    .think(tr("s7.l254"), "reframing")
    .think(tr("s7.l255"), "seeing_it")
    .think(tr("s7.l256"), "wonder")
    .vocab("よそ者", "よそもの", "yosomono", "Outsider / stranger / newcomer", {
      'category': "social",
    })
    .vocab("なじむ", null, "najimu", "To blend in / to become familiar", {
      'category': "verbs",
    })
    .n(tr("s7.l257"))
    .n(tr("s7.l258"))
    .n(tr("s7.l259"))
    .n(tr("s7.l260"))
    .jump("act5_enter")
    // ============================================
    // ACT 5: THE LAST EVENING
    // ============================================
    .scene("act5_scene1", "act5_enter")
    .bg("shimokitazawa_night", "night")
    .music("return_full_reprise")
    .n(tr("s7.l261"))
    .n(tr("s7.l262"))
    .n(tr("s7.l263"))
    .show("sota", "center", "relaxed")
    .say("sota", tr("s7.l264"), "remembering")
    .player(tr("s7.l265"), "matter_of_fact")
    .say("sota", tr("s7.l266"), "full_question")
    .think(tr("s7.l267"), "translating")
    .think(tr("s7.l268"), "tallying")
    .player(tr("s7.l269"), "listing")
    .player(tr("s7.l270"), "continuing")
    .player(tr("s7.l271"), "adding")
    .vocab("居場所", "いばしょ", "ibasho", "One's place / somewhere one belongs", {
      'category': "social",
    })
    .player(tr("s7.l272"), "honest")
    .player(tr("s7.l273"), "arriving")
    .say("sota", tr("s7.l274"), "listening")
    .player(tr("s7.l275"), "explaining")
    .player(tr("s7.l276"), "completing")
    .say("sota", tr("s7.l277"), "direct")
    .player(tr("s7.l278"), "certain")
    .n(tr("s7.l279"))
    .say("sota", tr("s7.l280"), "sincere")
    .vocab(
      "おかえり",
      null,
      "okaeri",
      "Welcome back (said to someone returning home)",
      {'category': "greetings"},
    )
    .think(tr("s7.l281"), "landing")
    .think(tr("s7.l282"), "building")
    .think(tr("s7.l283"), "arriving")
    .player(tr("s7.l284"), "quiet")
    .vocab(
      "ただいま",
      null,
      "tadaima",
      "I'm home / I'm back (said by person returning)",
      {'category': "greetings", 'jlpt': "N5"},
    )
    .n(tr("s7.l285"))
    .n(tr("s7.l286"))
    .n(tr("s7.l287"))
    .n(tr("s7.l288"))
    .n(tr("s7.l289"))
    .hideAll()
    .jump("epilogue")
    // ============================================
    // EPILOGUE
    // ============================================
    .scene("epilogue_scene1", "epilogue")
    .bg("narita_departures", "morning")
    .music("return_bittersweet")
    .n(tr("s7.l290"))
    .n(tr("s7.l291"))
    .n(tr("s7.l292"))
    .n(tr("s7.l293"))
    .n(tr("s7.l294"))
    .n(tr("s7.l295"))
    .n(tr("s7.l296"))
    .n(tr("s7.l297"))
    .think(tr("s7.l298"), "summarizing")
    .think(tr("s7.l299"), "landing")
    .vocab("帰国", "きこく", "kikoku", "Returning to one's home country", {
      'category': "travel",
    })
    .n(tr("s7.l300"))
    .n(tr("s7.l301"))
    .n(tr("s7.l302"))
    .think(tr("s7.l303"), "clear")
    .think(tr("s7.l304"), "precise")
    .think(tr("s7.l305"), "certain")
    .n(tr("s7.l306"))
    .n(tr("s7.l307"))
    .n(tr("s7.l308"))
    .n(tr("s7.l309"))
    .n(tr("s7.l310"))
    .fadeOut()
    .wait(2000)
    .n(tr("s7.l311"))
    .fadeIn()
    .jump("debrief1")
    // ============================================
    // DEBRIEF 1: Initial Reactions
    // ============================================
    .scene("debrief1", "classroom_return")
    .bg("classroom", "afternoon")
    .music("calm")
    .n(tr("s7.l312"))
    .n(tr("s7.l313"))
    .n(tr("s7.l314"))
    .show("tanaka", "center", "quiet")
    .n(tr("s7.l315"))
    .n(tr("s7.l316"))
    .n(tr("s7.l317"))
    .n(tr("s7.l318"))
    .say("tanaka", tr("s7.l319"), "finally")
    .show("ken", "right", "reflective")
    .show("mei", "left", "soft")
    .say("tanaka", tr("s7.l320"), "stating")
    .n(tr("s7.l321"))
    .show("yuki", "left", "still")
    .say("ken", tr("s7.l322"), "quiet")
    .say("ken", tr("s7.l323"), "also_true")
    .say("tanaka", tr("s7.l324"), "understanding")
    .say("tanaka", tr("s7.l325"), "gentle_redirect")
    .jump("debrief2")
    // ============================================
    // DEBRIEF 2: The Story Discussion
    // ============================================
    .scene("debrief2", "story_discussion")
    .show("tanaka", "center", "teaching")
    .say("mei", tr("s7.l326"), "beginning")
    .say("mei", tr("s7.l327"), "continuing")
    .say("mei", tr("s7.l328"), "small")
    .say("tanaka", tr("s7.l329"), "observing")
    .say("ken", tr("s7.l330"), "immediately")
    .say("ken", tr("s7.l331"), "laughing_and_meaning_it")
    .say("tanaka", tr("s7.l332"), "asking")
    .show("yuki", "right", "thinking")
    .say("yuki", tr("s7.l333"), "careful")
    .say("yuki", tr("s7.l334"), "building")
    .say("yuki", tr("s7.l335"), "landing")
    .say("tanaka", tr("s7.l336"), "meaningful")
    .say("tanaka", tr("s7.l337"), "wise")
    .say("tanaka", tr("s7.l338"), "certain")
    .jump("debrief3")
    // ============================================
    // DEBRIEF 3: Language Focus
    // ============================================
    .scene("debrief3", "language_focus")
    .show("tanaka", "center", "teaching")
    .say("tanaka", tr("s7.l339"), "building")
    .n(tr("s7.l340"))
    .n(tr("s7.l341"))
    .vocab("〜たものだ", null, "~ta mono da", "Used to ~ (nostalgic recollection)", {
      'category': "grammar",
    })
    .vocab("〜なくなった", null, "~naku natta", "Has stopped ~ / no longer ~", {
      'category': "grammar",
    })
    .say("tanaka", tr("s7.l342"), "explaining")
    .say("tanaka", tr("s7.l343"), "first")
    .say("tanaka", tr("s7.l344"), "second")
    .say("tanaka", tr("s7.l345"), "third")
    .show("ken", "left", "connecting")
    .say("ken", tr("s7.l346"), "applying")
    .say("ken", tr("s7.l347"), "building")
    .say("tanaka", tr("s7.l348"), "pleased")
    .say("tanaka", tr("s7.l349"), "meaningful")
    .say("tanaka", tr("s7.l350"), "full_picture")
    .jump("debrief4")
    // ============================================
    // DEBRIEF 4: The Heavy Part
    // ============================================
    .scene("debrief4", "the_heavy")
    .show("tanaka", "center", "careful")
    .say("tanaka", tr("s7.l351"), "preparing")
    .say("tanaka", tr("s7.l352"), "permission")
    .n(tr("s7.l353"))
    .say("tanaka", tr("s7.l354"), "asking")
    .say("tanaka", tr("s7.l355"), "broadening")
    .say("tanaka", tr("s7.l356"), "specific")
    .n(tr("s7.l357"))
    .n(tr("s7.l358"))
    .show("ken", "right", "deciding")
    .say("ken", tr("s7.l359"), "quiet")
    .say("ken", tr("s7.l360"), "continuing")
    .say("ken", tr("s7.l361"), "explaining")
    .say("ken", tr("s7.l362"), "honest")
    .say("ken", tr("s7.l363"), "stopping")
    .n(tr("s7.l364"))
    .say("mei", tr("s7.l365"), "gently_completing")
    .say("ken", tr("s7.l366"), "just_that")
    .show("mei", "left", "quiet")
    .say("mei", tr("s7.l367"), "surprising_herself")
    .say("mei", tr("s7.l368"), "continuing")
    .say("mei", tr("s7.l369"), "honest")
    .say("mei", tr("s7.l370"), "even_more_honest")
    .show("yuki", "right", "present")
    .n(tr("s7.l371"))
    .n(tr("s7.l372"))
    .n(tr("s7.l373"))
    .say("tanaka", tr("s7.l374"), "pointing")
    .say("tanaka", tr("s7.l375"), "summarizing")
    .say("tanaka", tr("s7.l376"), "final")
    .jump("debrief5")
    // ============================================
    // DEBRIEF 5: Looking Forward
    // ============================================
    .scene("debrief5", "goodbye_beginning")
    .show("tanaka", "center", "changed")
    .n(tr("s7.l377"))
    .n(tr("s7.l378"))
    .n(tr("s7.l379"))
    .say("tanaka", tr("s7.l380"), "steady")
    .show("ken", "right", "something_happening_in_his_face")
    .show("mei", "left", "going_still")
    .show("yuki", "center", "quiet")
    .say("ken", tr("s7.l381"), "soft")
    .say("ken", tr("s7.l382"), "honest")
    .say("mei", tr("s7.l383"), "carefully")
    .say("tanaka", tr("s7.l384"), "careful")
    .say("tanaka", tr("s7.l385"), "meaningful")
    .say("yuki", tr("s7.l386"), "direct_for_her")
    .say("tanaka", tr("s7.l387"), "building")
    .say("tanaka", tr("s7.l388"), "assigning")
    .say("tanaka", tr("s7.l389"), "question")
    .say("tanaka", tr("s7.l390"), "second_question")
    .n(tr("s7.l391"))
    .n(tr("s7.l392"))
    .n(tr("s7.l393"))
    .say("tanaka", tr("s7.l394"), "with_weight")
    .hide("tanaka")
    .hide("ken")
    .hide("mei")
    .hide("yuki")
    .jump("after_class")
    // ============================================
    // DEBRIEF 6: After Class
    // ============================================
    .scene("debrief6", "after_class")
    .bg("classroom", "late_afternoon")
    .music("gentle_close")
    .n(tr("s7.l395"))
    .n(tr("s7.l396"))
    .n(tr("s7.l397"))
    .show("ken", "center", "leaning_on_desk")
    .say("ken", tr("s7.l398"), "casual")
    .say("ken", tr("s7.l399"), "gesturing")
    .show("mei", "left", "considering")
    .say("mei", tr("s7.l400"), "simple")
    .show("yuki", "right", "small_smile")
    .say("yuki", tr("s7.l401"), "quiet_confidence")
    .n(tr("s7.l402"))
    .n(tr("s7.l403"))
    .say("yuki", tr("s7.l404"), "adding")
    .say("yuki", tr("s7.l405"), "searching_for_the_word")
    .say("yuki", tr("s7.l406"), "landing_on_the_right_one")
    .vocab(
      "居心地がいい",
      "いごこちがいい",
      "igokochi ga ii",
      "Comfortable / feels right / at ease there",
      {'category': "emotions"},
    )
    .say("ken", tr("s7.l407"), "repeating_it")
    .say("ken", tr("s7.l408"), "certain")
    .show("mei", "center", "warm")
    .say("mei", tr("s7.l409"), "proposing")
    .n(tr("s7.l410"))
    .n(tr("s7.l411"))
    .n(tr("s7.l412"))
    .n(tr("s7.l413"))
    .n(tr("s7.l414"))
    .n(tr("s7.l415"))
    .n(tr("s7.l416"))
    .n(tr("s7.l417"))
    .show("tanaka", "left", "warm")
    .say("tanaka", tr("s7.l418"), "promising")
    .say("tanaka", tr("s7.l419"), "gentle")
    .hideAll()
    .fadeOut()
    .n(tr("s7.l420"))
    .build();
