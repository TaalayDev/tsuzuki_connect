import { dialogue, word } from './DialogueBuilder.js';
import { tr } from '../systems/I18n.js';

// Vocabulary list for Story 5
const STORY_5_VOCABULARY = [
    // Medical/health vocabulary
    word("病院", "びょういん", "byouin", tr("s5.v.byouin"), { category: "medical", jlpt: "N5" }),
    word("薬局", "やっきょく", "yakkyoku", tr("s5.v.yakkyoku"), { category: "medical", jlpt: "N4" }),
    word("処方箋", "しょほうせん", "shohousen", tr("s5.v.shohousen"), { category: "medical", jlpt: "N3" }),
    word("血圧", "けつあつ", "ketsuatsu", tr("s5.v.ketsuatsu"), { category: "medical", jlpt: "N3" }),
    word("定期検診", "ていきけんしん", "teiki kenshin", tr("s5.v.teiki_kenshin"), { category: "medical", jlpt: "N3" }),
    word("症状", "しょうじょう", "shoujou", tr("s5.v.shoujou"), { category: "medical", jlpt: "N3" }),

    // Community center / daily life
    word("地域", "ちいき", "chiiki", tr("s5.v.chiiki"), { category: "community", jlpt: "N3" }),
    word("町内会", "ちょうないかい", "chounai kai", tr("s5.v.chounai_kai"), { category: "community", jlpt: "N3" }),
    word("公民館", "こうみんかん", "kouminkan", tr("s5.v.kouminkan"), { category: "community", jlpt: "N3" }),
    word("習い事", "ならいごと", "naraigoto", tr("s5.v.naraigoto"), { category: "community", jlpt: "N3" }),
    word("趣味", "しゅみ", "shumi", tr("s5.v.shumi"), { category: "lifestyle", jlpt: "N4" }),
    word("手芸", "しゅげい", "shugei", tr("s5.v.shugei"), { category: "hobbies", jlpt: "N3" }),

    // Asking for help / directions
    word("道に迷う", "みちにまよう", "michi ni mayou", tr("s5.v.michi_ni_mayou"), { category: "phrases", jlpt: "N4" }),
    word("教えていただけますか", null, "oshiete itadakemasu ka", tr("s5.v.oshiete_itadakemasu_ka"), { category: "polite_expressions", jlpt: "N3" }),
    word("もう一度", "もういちど", "mou ichido", tr("s5.v.mou_ichido"), { category: "phrases", jlpt: "N5" }),
    word("ゆっくり", null, "yukkuri", tr("s5.v.yukkuri"), { category: "adverbs", jlpt: "N5" }),
    word("すみません", null, "sumimasen", tr("s5.v.sumimasen"), { category: "phrases", jlpt: "N5" }),

    // Family / generational
    word("息子", "むすこ", "musuko", tr("s5.v.musuko"), { category: "family", jlpt: "N5" }),
    word("嫁", "よめ", "yome", tr("s5.v.yome"), { category: "family", jlpt: "N3" }),
    word("孫", "まご", "mago", tr("s5.v.mago"), { category: "family", jlpt: "N4" }),
    word("世話になる", "せわになる", "sewa ni naru", tr("s5.v.sewa_ni_naru"), { category: "phrases", jlpt: "N3" }),
    word("遠慮", "えんりょ", "enryo", tr("s5.v.enryo"), { category: "social", jlpt: "N3" }),

    // Emotions / growth
    word("恥ずかしい", "はずかしい", "hazukashii", tr("s5.v.hazukashii"), { category: "emotions", jlpt: "N4" }),
    word("諦める", "あきらめる", "akirameru", tr("s5.v.akirameru"), { category: "verbs", jlpt: "N3" }),
    word("挑戦", "ちょうせん", "chousen", tr("s5.v.chousen"), { category: "verbs", jlpt: "N3" }),
    word("自信", "じしん", "jishin", tr("s5.v.jishin"), { category: "emotions", jlpt: "N3" }),
    word("仲間", "なかま", "nakama", tr("s5.v.nakama"), { category: "social", jlpt: "N3" }),
    word("居心地がいい", "いごこちがいい", "igokochi ga ii", tr("s5.v.igokochi_ga_ii"), { category: "emotions", jlpt: "N3" }),
];

export const getStory5 = () => dialogue()
    .story(5, tr("s5.title"), tr("s5.subtitle"))
    .description(tr("s5.desc"))
    .estimatedTime("75-90 minutes")
    .jlptFocus("N3")
    .vocabularyList(STORY_5_VOCABULARY)

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

    .vocab("道に迷う", "みちにまよう", "michi ni mayou", tr("s5.v.michi_ni_mayou"), { category: "phrases" })

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

    .sayJp("yamamoto", "迷子ですか？", tr("s5.l019"), "maigo desu ka?", "friendly")

    .n(tr("s5.l020"))

    .playerJp("薬局？", tr("s5.l021"), "yakkyoku?", "attempting")

    .vocab("薬局", "やっきょく", "yakkyoku", tr("s5.v.yakkyoku"), { category: "medical" })

    .show("yamamoto", "center", "brightening")

    .sayJp("yamamoto", "ああ、薬局！わかります。", tr("s5.l022"), "aa, yakkyoku! wakarimasu.", "helpful")
    .sayJp("yamamoto", "まっすぐ行って—", tr("s5.l023"), "massugu itte-", "directing")

    .n(tr("s5.l024"))
    .n(tr("s5.l025"))

    .think(tr("s5.l026"), "decoding")

    .player(tr("s5.l027"), "confirming")

    .sayJp("yamamoto", "そうそう！上手ですね。", tr("s5.l028"), "sou sou! jouzu desu ne.", "approving")

    .vocab("そうそう", null, "sou sou", tr("s5.v.sou_sou"), { category: "phrases" })

    .n(tr("s5.l029"))

    .sayJp("yamamoto", "新しい方ですか？引っ越してきましたか？", tr("s5.l030"), "atarashii kata desu ka? hikkoshite kimashita ka?", "curious")

    .n(tr("s5.l031"))

    .player(tr("s5.l032"), "simple")

    .sayJp("yamamoto", "あら！どこから来たんですか？", tr("s5.l033"), "ara! doko kara kitan desu ka?", "interested")

    .player(tr("s5.l034"), "answering")

    .sayJp("yamamoto", "ポートランド！遠いですねえ。", tr("s5.l035"), "pootorando! tooi desu nee.", "impressed")
    .sayJp("yamamoto", "私は山本です。", tr("s5.l036"), "watashi wa yamamoto desu.", "introducing")

    .n(tr("s5.l037"))

    .player(tr("s5.l038"), "polite")

    .sayJp("yamamoto", "マーガレットさん。素敵な名前ですね。", tr("s5.l039"), "maagaretto-san. suteki na namae desu ne.", "warm")

    .n(tr("s5.l040"))
    .n(tr("s5.l041"))

    .sayJp("yamamoto", "薬局の後、もしよかったら—", tr("s5.l042"), "yakkyoku no ato, moshi yokattara-")
    .n(tr("s5.l043"))
    .sayJp("yamamoto", "お茶でもどうぞ。", tr("s5.l044"), "ocha demo douzo.", "inviting")

    .think(tr("s5.l045"), "surprised")
    .think(tr("s5.l046"), "hesitating")

    .menu()
    .choice(tr("s5.l047"), "accept_tea", { hint: "Yes, I'd like that." })
    .choice(tr("s5.l048"), "decline_tea", { hint: "Thank you, maybe another time." })
    .endMenu()

    .hide("yamamoto")

    .jump("pharmacy_errand")

    // ============================================
    .scene("act1_scene2", "pharmacy_errand")
    .bg("pharmacy", "morning")

    .n(tr("s5.l049"))
    .n(tr("s5.l050"))

    .show("pharmacist", "center", "professional")

    .n(tr("s5.l051"))

    .sayJp("pharmacist", "いらっしゃいませ。", tr("s5.l052"), "irasshaimase.", "polite")

    .vocab("いらっしゃいませ", null, "irasshaimase", tr("s5.v.irasshaimase"), { category: "service" })

    .n(tr("s5.l053"))

    .vocab("処方箋", "しょほうせん", "shohousen", tr("s5.v.shohousen"), { category: "medical" })

    .player(tr("s5.l054"), "explaining")

    .sayJp("pharmacist", "はい、処方箋ですね。少々お待ちください。", tr("s5.l055"), "hai, shohousen desu ne. shoushou omachi kudasai.", "professional")

    .n(tr("s5.l056"))
    .n(tr("s5.l057"))

    .vocab("血圧", "けつあつ", "ketsuatsu", tr("s5.v.ketsuatsu"), { category: "medical" })

    .show("pharmacist", "center", "returning")

    .sayJp("pharmacist", "お待たせしました。こちら、一日三回、食後に飲んでください。", tr("s5.l058"), "omatase shimashita. kochira, ichinichi sankai, shokugo ni nonde kudasai.", "instructing")

    .n(tr("s5.l059"))
    .n(tr("s5.l060"))

    .thinkJp("一日... 三回...", tr("s5.l061"), "ichinichi... sankai...", "working_through")

    .playerJp("食後？", tr("s5.l062"), "shokugo?", "confirming")

    .vocab("食後", "しょくご", "shokugo", tr("s5.v.shokugo"), { category: "medical" })

    .sayJp("pharmacist", "はい！食後に。", tr("s5.l063"), "hai! shokugo ni.", "confirming")

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

    .vocab("せんべい", null, "senbei", tr("s5.v.senbei"), { category: "food" })

    .sayJp("yamamoto", "どうぞ。召し上がってください。", tr("s5.l071"), "douzo. meshiagatte kudasai.", "hospitable")

    .n(tr("s5.l072"))

    .sayJp("yamamoto", "息子さんがいるんですか？", tr("s5.l073"), "musuko-san ga irun desu ka?", "curious")

    .vocab("息子", "むすこ", "musuko", tr("s5.v.musuko"), { category: "family" })

    .n(tr("s5.l074"))

    .player(tr("s5.l075"), "explaining")

    .sayJp("yamamoto", "ああ、お嫁さんは日本人ですか？", tr("s5.l076"), "aa, oyome-san wa nihonjin desu ka?", "interested")

    .vocab("嫁", "よめ", "yome", tr("s5.v.yome"), { category: "family" })

    .player(tr("s5.l077"), "answering")

    .sayJp("yamamoto", "いいですねえ。お孫さんも？", tr("s5.l078"), "ii desu nee. omago-san mo?", "warm")

    .vocab("孫", "まご", "mago", tr("s5.v.mago"), { category: "family" })

    .player(tr("s5.l079"), "smiling")

    .sayJp("yamamoto", "かわいい！", tr("s5.l080"), "kawaii!", "delighted")

    .n(tr("s5.l081"))

    .sayJp("yamamoto", "でも、大変でしょう？日本語、難しいから。", tr("s5.l082"), "demo, taihen deshou? nihongo, muzukashii kara.", "sympathetic")

    .n(tr("s5.l083"))

    .player(tr("s5.l084"), "honest")

    .sayJp("yamamoto", "そうですよね。教科書と実際は違いますから。", tr("s5.l085"), "sou desu yo ne. kyoukasho to jissai wa chigaimasu kara.", "understanding")

    .think(tr("s5.l086"), "recognizing")

    .sayJp("yamamoto", "でもね—", tr("s5.l087"), "demo ne-", "encouraging")
    .sayJp("yamamoto", "マーガレットさんは薬局で『食後』って言えたじゃないですか。", tr("s5.l088"), "maagaretto-san wa yakkyoku de 'shokugo' tte ieta janai desu ka.", "pointing_out")
    .sayJp("yamamoto", "それだけでも、すごいと思います。", tr("s5.l089"), "sore dake demo, sugoi to omoimasu.", "sincere")

    .n(tr("s5.l090"))

    .think(tr("s5.l091"), "reflecting")
    .think(tr("s5.l092"), "moved")

    .vocab("仲間", "なかま", "nakama", tr("s5.v.nakama"), { category: "social" })

    .sayJp("yamamoto", "あのね、月曜日、公民館で英会話クラスがあるんです。", tr("s5.l093"), "ano ne, getsuyoubi, kouminkan de eikaiwa kurasu ga arun desu.", "casually")

    .vocab("公民館", "こうみんかん", "kouminkan", tr("s5.v.kouminkan"), { category: "community" })

    .sayJp("yamamoto", "みんな、英語を勉強したくて。先生がいなくて困ってるんです。", tr("s5.l094"), "minna, eigo o benkyou shitakute. sensei ga inakute komatterun desu.", "meaningful")

    .n(tr("s5.l095"))
    .n(tr("s5.l096"))

    .think(tr("s5.l097"), "amused")

    .sayJp("yamamoto", "もし、よかったら—", tr("s5.l098"), "moshi, yokattara-", "carefully")

    .menu()
    .choice(tr("s5.l099"), "offer_help", { hint: "I was a teacher. For thirty years." })
    .choice(tr("s5.l100"), "deflect_offer", { hint: "I wouldn't want to impose..." })
    .endMenu()

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

    .vocab("習い事", "ならいごと", "naraigoto", tr("s5.v.naraigoto"), { category: "community" })

    .n(tr("s5.l103"))
    .n(tr("s5.l104"))

    .thinkJp("手芸... 趣味...", tr("s5.l105"), "shugei... shumi...", "small_pride")

    .vocab("手芸", "しゅげい", "shugei", tr("s5.v.shugei"), { category: "hobbies" })
    .vocab("趣味", "しゅみ", "shumi", tr("s5.v.shumi"), { category: "lifestyle" })

    .show("yamamoto", "right", "pleased")

    .n(tr("s5.l106"))

    .sayJp("yamamoto", "マーガレットさん！来てくれた！", tr("s5.l107"), "maagaretto-san! kite kureta!", "relieved")
    .sayJp("yamamoto", "みんな楽しみにしてましたよ。", tr("s5.l108"), "minna tanoshimi ni shitemashita yo.", "excited")

    .player(tr("s5.l109"), "humble")

    .sayJp("yamamoto", "大丈夫ですよ。みんないい人たちだから。", tr("s5.l110"), "daijoubu desu yo. minna ii hitotachi dakara.", "reassuring")

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

    .sayJp("obaa", "面白い！", tr("s5.l122"), "omoshiroi!", "enthusiastic")

    .vocab("面白い", "おもしろい", "omoshiroi", tr("s5.v.omoshiroi"), { category: "emotions", jlpt: "N5" })

    .n(tr("s5.l123"))
    .n(tr("s5.l124"))

    .show("tanaka_toru", "left", "earnest")
    .n(tr("s5.l125"))

    .say("tanaka_toru", tr("s5.l126"), "earnest")

    .player(tr("s5.l127"), "encouraging")

    .say("tanaka_toru", tr("s5.l128"), "smiling")
    .say("tanaka_toru", tr("s5.l129"), "hopeful")

    .player(tr("s5.l130"), "gentle_humor")
    .playerJp("すごく上手になっています。", tr("s5.l131"), "sugoku jouzu ni natte imasu.", "supporting")

    .vocab("上手", "じょうず", "jouzu", tr("s5.v.jouzu"), { category: "praise", jlpt: "N5" })

    .show("obaa", "right", "curious")

    .sayJp("obaa", "マーガレット先生、日本語はどのくらいできますか？", tr("s5.l132"), "maagaretto-sensei, nihongo wa dono kurai dekimasu ka?", "direct")

    .think(tr("s5.l133"), "self_assessing")

    .playerJp("少し。ほんの少し。でも—毎日勉強しています。", tr("s5.l134"), "sukoshi. honno sukoshi. demo-mainichi benkyou shiteimasu.", "earnest")

    .vocab("毎日", "まいにち", "mainichi", tr("s5.v.mainichi"), { category: "time", jlpt: "N5" })

    .sayJp("obaa", "毎日！", tr("s5.l135"), "mainichi!", "impressed")
    .sayJp("obaa", "それは一番大事ね。継続は力なり。", tr("s5.l136"), "sore wa ichiban daiji ne. keizoku wa chikara nari.", "wise")

    .vocab("継続は力なり", "けいぞくはちからなり", "keizoku wa chikara nari", tr("s5.v.keizoku_wa_chikara_nari"), { category: "proverbs", jlpt: "N3" })

    .n(tr("s5.l137"))

    .jump("lesson_exchange")

    // ============================================
    .scene("act2_scene3", "lesson_exchange")
    .bg("community_center_room", "morning")

    .n(tr("s5.l138"))
    .n(tr("s5.l139"))

    .n(tr("s5.l140"))
    .n(tr("s5.l141"))

    .vocab("助数詞", "じょすうし", "josuushi", tr("s5.v.josuushi"), { category: "grammar", jlpt: "N4" })

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

    .sayJp("obaa", "マーガレット先生、今度は私から。", tr("s5.l150"), "maagaretto-sensei, kondo wa watashi kara.", "playful")
    .sayJp("obaa", "教えていただけますか、と言えますか？", tr("s5.l151"), "oshiete itadakemasu ka, to iemasu ka?", "teaching")

    .vocab("教えていただけますか", null, "oshiete itadakemasu ka", tr("s5.v.oshiete_itadakemasu_ka"), { category: "polite_expressions" })

    .player(tr("s5.l152"), "attempting")

    .n(tr("s5.l153"))

    .sayJp("obaa", "上手！上手！", tr("s5.l154"), "jouzu! jouzu!", "thrilled")

    .think(tr("s5.l155"), "amused")
    .think(tr("s5.l156"), "warm")

    .hideAll()

    .jump("after_class_moment")

    // ============================================
    .scene("act2_scene4", "after_class_moment")
    .bg("community_center_hallway", "noon")

    .show("yamamoto", "center", "pleased")

    .n(tr("s5.l157"))

    .sayJp("yamamoto", "どうでしたか？", tr("s5.l158"), "dou deshita ka?", "curious")

    .player(tr("s5.l159"), "honest")

    .sayJp("yamamoto", "本当？", tr("s5.l160"), "hontou?", "happy")

    .player(tr("s5.l161"), "admitting")
    .player(tr("s5.l162"), "reflective")

    .sayJp("yamamoto", "でも今日は思い出しましたか？", tr("s5.l163"), "demo kyou wa omoidasimashita ka?", "gentle")

    .vocab("思い出す", "おもいだす", "omoidasu", tr("s5.v.omoidasu"), { category: "verbs", jlpt: "N4" })

    .playerJp("今日は... 思い出しました。", tr("s5.l164"), "kyou wa... omoidasimashita.", "moved")

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

    .vocab("遠慮", "えんりょ", "enryo", tr("s5.v.enryo"), { category: "social" })

    .player(tr("s5.l180"), "stubborn")
    .playerJp("遠慮... ご迷惑をかけたくなかった。", tr("s5.l181"), "enryo... gomeiwaku o kaketakunakatta.", "honest")

    .say("david", tr("s5.l182"), "softly")

    .player(tr("s5.l183"), "frustrated")
    .player(tr("s5.l184"), "defeated")

    .vocab("もう一度", "もういちど", "mou ichido", tr("s5.v.mou_ichido"), { category: "phrases" })

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

    .vocab("世話になる", "せわになる", "sewa ni naru", tr("s5.v.sewa_ni_naru"), { category: "phrases" })

    .thinkJp("世話になる。", tr("s5.l196"), "sewa ni naru.", "absorbing")
    .think(tr("s5.l197"), "shifting")

    .n(tr("s5.l198"))

    .show("kenta", "center", "sleepy")

    .sayJp("kenta", "ばーちゃん...", tr("s5.l199"), "baa-chan...", "half_asleep")

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

    .vocab("諦める", "あきらめる", "akirameru", tr("s5.v.akirameru"), { category: "verbs" })
    .vocab("挑戦", "ちょうせん", "chousen", tr("s5.v.chousen"), { category: "verbs" })

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

    .sayJp("obaa", "マーガレット先生、今日は特別です！", tr("s5.l241"), "maagaretto-sensei, kyou wa tokubetsu desu!", "excited")

    .playerJp("特別ですか？", tr("s5.l242"), "tokubetsu desu ka?", "curious")

    .vocab("特別", "とくべつ", "tokubetsu", tr("s5.v.tokubetsu"), { category: "adjectives", jlpt: "N4" })

    .sayJp("obaa", "はい！町内会のみなさんを招待しました。", tr("s5.l243"), "hai! chounaikai no minasan o shoutai shimashita.", "proud")

    .vocab("町内会", "ちょうないかい", "chounai kai", tr("s5.v.chounai_kai"), { category: "community" })

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

    .sayJp("fujita", "あの、すみません。えき... はどこですか？", tr("s5.l256"), "ano, sumimasen. eki... wa doko desu ka?", "performing")

    .vocab("すみません", null, "sumimasen", tr("s5.v.sumimasen"), { category: "phrases" })
    .vocab("駅", "えき", "eki", tr("s5.v.eki"), { category: "transport", jlpt: "N5" })

    .n(tr("s5.l257"))

    .n(tr("s5.l258"))

    .show("obaa", "center", "inviting")

    .sayJp("obaa", "マーガレット先生の番です。何か日本語で言ってみてください。", tr("s5.l259"), "maagaretto-sensei no ban desu. nanika nihongo de itte mite kudasai.", "encouraging")

    .n(tr("s5.l260"))

    .n(tr("s5.l261"))
    .n(tr("s5.l262"))

    .playerJp("ここに来て、よかったと思っています。", tr("s5.l263"), "koko ni kite, yokatta to omotteimasu.", "quiet")

    .n(tr("s5.l264"))

    .vocab("ここに来て", null, "koko ni kite", tr("s5.v.koko_ni_kite"), { category: "phrases", jlpt: "N3" })
    .vocab("よかった", null, "yokatta", tr("s5.v.yokatta"), { category: "phrases", jlpt: "N4" })

    .n(tr("s5.l265"))
    .n(tr("s5.l266"))

    .show("yamamoto", "right", "moved")

    .sayJp("yamamoto", "私たちもです。", tr("s5.l267"), "watashitachi mo desu.", "sincere")

    .n(tr("s5.l268"))

    .vocab("居心地がいい", "いごこちがいい", "igokochi ga ii", tr("s5.v.igokochi_ga_ii"), { category: "emotions" })

    .thinkJp("居心地がいい。", tr("s5.l269"), "igokochi ga ii.", "settling")
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

    .vocab("定期検診", "ていきけんしん", "teiki kenshin", tr("s5.v.teiki_kenshin"), { category: "medical" })

    .n(tr("s5.l279"))

    .show("nurse_akemi", "center", "professional")

    .n(tr("s5.l280"))

    .sayJp("nurse_akemi", "今日はどうですか？何か症状はありますか？", tr("s5.l281"), "kyou wa dou desu ka? nanika shoujou wa arimasu ka?", "routine")

    .vocab("症状", "しょうじょう", "shoujou", tr("s5.v.shoujou"), { category: "medical" })

    .playerJp("症状は... ありません。元気です。", tr("s5.l282"), "shoujou wa... arimasen. genki desu.", "confident")

    .n(tr("s5.l283"))

    .n(tr("s5.l284"))

    .sayJp("nurse_akemi", "上手ですね。前より日本語が上手になりましたね。", tr("s5.l285"), "jouzu desu ne. mae yori nihongo ga jouzu ni narimashita ne.", "surprised")

    .n(tr("s5.l286"))

    .playerJp("毎日練習しています。", tr("s5.l287"), "mainichi renshuu shiteimasu.", "simple_pride")

    .vocab("練習", "れんしゅう", "renshuu", tr("s5.v.renshuu"), { category: "verbs", jlpt: "N4" })

    .sayJp("nurse_akemi", "ゆっくり話しましょうか？", tr("s5.l288"), "yukkuri hanashimashou ka?", "thoughtful")

    .vocab("ゆっくり", null, "yukkuri", tr("s5.v.yukkuri"), { category: "adverbs" })

    .playerJp("いいえ、大丈夫です。ゆっくりじゃなくていい。", tr("s5.l289"), "iie, daijoubu desu. yukkuri janakute ii.", "accepting_the_challenge")

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

    .sayJp("dr_ito", "血圧が下がりましたね。", tr("s5.l296"), "ketsuatsu ga sagarimashita ne.", "pleased")

    .n(tr("s5.l297"))

    .playerJp("本当ですか！", tr("s5.l298"), "hontou desu ka!", "happy")

    .sayJp("dr_ito", "ええ。何か変えましたか？", tr("s5.l299"), "ee. nanika kaemashita ka?", "curious")

    .player(tr("s5.l300"), "answering")
    .player(tr("s5.l301"), "simple")
    .player(tr("s5.l302"), "quiet")

    .thinkJp("あの言葉。友達。", tr("s5.l303"), "ano kotoba. tomodachi.", "realizing")

    .vocab("友達", "ともだち", "tomodachi", tr("s5.v.tomodachi"), { category: "social", jlpt: "N5" })

    .sayJp("dr_ito", "なるほど。コミュニティの力ですね。", tr("s5.l304"), "naruhodo. komyuniti no chikara desu ne.", "thoughtful")

    .n(tr("s5.l305"))

    .vocab("地域", "ちいき", "chiiki", tr("s5.v.chiiki"), { category: "community" })

    .sayJp("dr_ito", "続けてください。", tr("s5.l306"), "tsuzukete kudasai.", "recommending")

    .playerJp("はい、続けます。", tr("s5.l307"), "hai, tsuzukemasu.", "certain")

    .vocab("続ける", "つづける", "tsuzukeru", tr("s5.v.tsuzukeru"), { category: "verbs", jlpt: "N4" })

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

    .playerJp("綺麗ですね。", tr("s5.l312"), "kirei desu ne.", "admiring")

    .vocab("綺麗", "きれい", "kirei", tr("s5.v.kirei"), { category: "adjectives", jlpt: "N5" })

    .sayJp("yamamoto", "どうぞ。", tr("s5.l313"), "douzo.", "offering")

    .n(tr("s5.l314"))

    .sayJp("yamamoto", "来週の月曜日—大倉さんが、新しい人を連れてきたいって。", tr("s5.l315"), "raishuu no getsuyoubi-ookura-san ga, atarashii hito o tsurete kitai tte.", "casually")
    .sayJp("yamamoto", "外国人の方で、日本語を勉強したいそうです。", tr("s5.l316"), "gaikokujin no kata de, nihongo o benkyou shitai sou desu.", "continuing")

    .n(tr("s5.l317"))

    .player(tr("s5.l318"), "curious")

    .sayJp("yamamoto", "六十四歳だそうです。", tr("s5.l319"), "rokujuuyon-sai da sou desu.", "calm")

    .n(tr("s5.l320"))

    .think(tr("s5.l321"), "smiling_inside")

    .player(tr("s5.l322"), "welcoming")
    .player(tr("s5.l323"), "certain")

    .vocab("仲間", "なかま", "nakama", tr("s5.v.nakama"), { category: "social" })

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

    .sayJp("tanaka", "継続は力なり。", tr("s5.l322"), "keizoku wa chikara nari.", "nodding")

    .say("mei", tr("s5.l323"), "translating")

    .say("tanaka", tr("s5.l324"), "smiling")
    .say("tanaka", tr("s5.l325"), "meaningful")

    .n(tr("s5.l326"))

    .sayJp("tanaka", "挑戦。", tr("s5.l327"), "chousen.", "teaching")
    .say("tanaka", tr("s5.l328"), "explaining")
    .say("tanaka", tr("s5.l329"), "distinguishing")

    .jump("debrief3")

    // ============================================
    // DEBRIEF 3: Cultural Context
    // ============================================
    .scene("debrief3", "cultural_context")
    .show("tanaka", "center", "cultural_teaching")

    .sayJp("tanaka", "遠慮。", tr("s5.l330"), "enryo.", "pointing")

    .vocab("遠慮", "えんりょ", "enryo", tr("s5.v.enryo"), { category: "social" })

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
    .choice(tr("s5.l341"), "player_shares", { hint: "I remember arriving here and not understanding anything." })
    .choice(tr("s5.l342"), "listen_mode", { hint: "..." })
    .endMenu()

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
