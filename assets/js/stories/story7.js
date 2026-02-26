import { dialogue, word } from './DialogueBuilder.js';
import { tr } from '../systems/I18n.js';

// Vocabulary list for Story 7
const STORY_7_VOCABULARY = [
    // Expressing change / comparison (past vs. now)
    word("変わる", "かわる", "kawaru", "To change (intransitive)", { category: "verbs", jlpt: "N4" }),
    word("変える", "かえる", "kaeru", "To change (transitive)", { category: "verbs", jlpt: "N4" }),
    word("以前", "いぜん", "izen", "Before / previously / formerly", { category: "time", jlpt: "N3" }),
    word("当時", "とうじ", "touji", "At that time / back then", { category: "time", jlpt: "N3" }),
    word("昔", "むかし", "mukashi", "Long ago / the old days / once", { category: "time", jlpt: "N4" }),
    word("今でも", "いまでも", "ima demo", "Even now / still", { category: "time", jlpt: "N3" }),
    word("なくなる", null, "nakunaru", "To disappear / to be gone / to run out", { category: "verbs", jlpt: "N3" }),
    word("残る", "のこる", "nokoru", "To remain / to be left behind", { category: "verbs", jlpt: "N3" }),

    // Nostalgia / emotional states
    word("懐かしい", "なつかしい", "natsukashii", "Nostalgic / dear / fondly remembered", { category: "emotions", jlpt: "N3" }),
    word("寂しい", "さびしい", "sabishii", "Lonely / lonesome / desolate", { category: "emotions", jlpt: "N4" }),
    word("切ない", "せつない", "setsunai", "Bittersweet / aching / painfully sweet", { category: "emotions", jlpt: "N3" }),
    word("感慨深い", "かんがいぶかい", "kangai fukai", "Deeply moving / filled with emotion", { category: "emotions", jlpt: "N3" }),
    word("期待外れ", "きたいはずれ", "kitai hazure", "Disappointment / not living up to expectations", { category: "emotions", jlpt: "N3" }),

    // Travel / returning
    word("再訪", "さいほう", "saihou", "Return visit / revisiting", { category: "travel", jlpt: "N3" }),
    word("帰国", "きこく", "kikoku", "Returning to one's home country", { category: "travel", jlpt: "N3" }),
    word("滞在", "たいざい", "taizai", "Stay / sojourn", { category: "travel", jlpt: "N3" }),
    word("留学", "りゅうがく", "ryuugaku", "Study abroad", { category: "education", jlpt: "N3" }),

    // Identity / belonging
    word("居場所", "いばしょ", "ibasho", "One's place / somewhere one belongs", { category: "social", jlpt: "N3" }),
    word("よそ者", "よそもの", "yosomono", "Outsider / stranger / newcomer", { category: "social", jlpt: "N3" }),
    word("なじむ", null, "najimu", "To become familiar with / to fit in / to blend in", { category: "verbs", jlpt: "N3" }),
    word("懐に入る", "ふところにはいる", "futokoro ni hairu", "To be welcomed in / to be taken into someone's heart", { category: "phrases", jlpt: "N3" }),

    // Places / city change
    word("取り壊す", "とりこわす", "torikohawasu", "To demolish / to tear down", { category: "verbs", jlpt: "N3" }),
    word("建て替える", "たてかえる", "tatekaheru", "To rebuild / to reconstruct", { category: "verbs", jlpt: "N3" }),
    word("跡地", "あとち", "atochi", "Site of a demolished building / former location", { category: "nouns", jlpt: "N3" }),
    word("面影", "おもかげ", "omokage", "Trace / vestige / lingering image", { category: "literary", jlpt: "N3" }),

    // Grammar / expression
    word("〜たものだ", null, "~ta mono da", "Used to ~ (nostalgic recollection)", { category: "grammar", jlpt: "N3" }),
    word("〜ていた", null, "~te ita", "Was doing ~ / used to do ~ (continuous past)", { category: "grammar", jlpt: "N4" }),
    word("〜ようになった", null, "~you ni natta", "Has come to ~ / now ~ (change over time)", { category: "grammar", jlpt: "N3" }),
    word("〜なくなった", null, "~naku natta", "Has stopped ~ / no longer ~ (change / loss)", { category: "grammar", jlpt: "N3" }),
];

export const getStory7 = () => dialogue()
    .story(7, tr("s7.title"), tr("s7.subtitle"))
    .description(tr("s7.desc"))
    .estimatedTime("75-90 minutes")
    .jlptFocus("N3")
    .vocabularyList(STORY_7_VOCABULARY)

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

    .vocab("留学", "りゅうがく", "ryuugaku", "Study abroad", { category: "education" })
    .vocab("再訪", "さいほう", "saihou", "Return visit / revisiting", { category: "travel" })

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

    .thinkJp("懐かしい。", tr("s7.l018"), "natsukashii.", "feeling_it")

    .vocab("懐かしい", "なつかしい", "natsukashii", "Nostalgic / fondly remembered", { category: "emotions" })

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

    .vocab("変わる", "かわる", "kawaru", "To change (intransitive)", { category: "verbs" })
    .vocab("なくなる", null, "nakunaru", "To disappear / to be gone", { category: "verbs" })

    .think(tr("s7.l024"), "obvious_thought")
    .think(tr("s7.l025"), "honest")

    .n(tr("s7.l026"))
    .n(tr("s7.l027"))
    .n(tr("s7.l028"))
    .n(tr("s7.l029"))

    .vocab("おかえり", null, "okaeri", "Welcome back (said to someone returning)", { category: "greetings", jlpt: "N5" })

    .thinkJp("おかえり。", tr("s7.l030"), "okaeri.", "sitting_with_it")
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

    .vocab("跡地", "あとち", "atochi", "Site of a demolished building / former location", { category: "nouns" })
    .vocab("面影", "おもかげ", "omokage", "Trace / vestige / lingering image", { category: "literary" })

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

    .vocab("取り壊す", "とりこわす", "torikohawasu", "To demolish / to tear down", { category: "verbs" })

    .n(tr("s7.l053"))
    .n(tr("s7.l054"))
    .n(tr("s7.l055"))

    .think(tr("s7.l056"), "remembering")
    .think(tr("s7.l057"), "remembering_more")
    .think(tr("s7.l058"), "honest")

    .n(tr("s7.l059"))
    .n(tr("s7.l060"))
    .n(tr("s7.l061"))

    .vocab("当時", "とうじ", "touji", "At that time / back then", { category: "time" })

    .jump("act1_scene3")

    // ============================================
    .scene("act1_scene3", "reunion_sota")
    .bg("shimokitazawa_bar", "evening")
    .music("warm_reunion")

    .show("sota", "center", "delighted")

    .n(tr("s7.l062"))
    .n(tr("s7.l063"))

    .sayJp("sota", "ジェイミー！本物だ！", tr("s7.l064"), "jeimii! honmono da!", "amazed")

    .n(tr("s7.l065"))
    .n(tr("s7.l066"))

    .playerJp("そうだよ、本物。", tr("s7.l067"), "sou da yo, honmono.", "laughing")

    .sayJp("sota", "五年ぶりだろ。どんな気持ち？", tr("s7.l068"), "gonen buri daro. donna kimochi?", "curious")

    .vocab("〜ぶり", null, "~buri", "For the first time in ~ / after ~ (time expression)", { category: "grammar", jlpt: "N3" })

    .think(tr("s7.l069"), "translating")

    .playerJp("懐かしいっていう感じと、なんか違うっていう感じと、両方。", tr("s7.l070"), "natsukashii tte iu kanji to, nanka chigau tte iu kanji to, ryouhou.", "honest")

    .vocab("切ない", "せつない", "setsunai", "Bittersweet / aching / painfully sweet", { category: "emotions" })

    .sayJp("sota", "両方。そうだよな。", tr("s7.l071"), "ryouhou. sou da yo na.", "nodding")
    .sayJp("sota", "シェアハウス、なくなったの知ってた？", tr("s7.l072"), "shea hausu, nakunatta no shitteta?", "gentle")

    .playerJp("今日見た。", tr("s7.l073"), "kyou mita.", "quiet")
    .playerJp("駐車場になってた。", tr("s7.l074"), "chuushajou ni natteta.", "flat")

    .sayJp("sota", "去年だよ。取り壊したの。", tr("s7.l075"), "kyonen da yo. torikowashita no.", "matter_of_fact")
    .sayJp("sota", "俺も最初、なんか変な感じがしたよ。", tr("s7.l076"), "ore mo saisho, nanka hen na kanji ga shita yo.", "understanding")

    .playerJp("カズヤさんのレコード屋も。", tr("s7.l077"), "kazuya-san no rekoodoya mo.", "adding")

    .sayJp("sota", "ああ。三年前。カズヤさん、大阪に帰ったって聞いた。", tr("s7.l078"), "aa. sannen mae. kazuya-san, oosaka ni kaetta tte kiita.", "knowing")

    .n(tr("s7.l079"))
    .n(tr("s7.l080"))

    .sayJp("sota", "何を期待してたんだ？", tr("s7.l081"), "nani o kitai shitetanda?", "gently_challenging")

    .think(tr("s7.l082"), "translating_to_yourself")

    .menu()
    .choice(tr("s7.c001"), "expected_same", { hint: tr("s7.h001") })
    .choice(tr("s7.c002"), "expected_home", { hint: tr("s7.h002") })
    .choice(tr("s7.c003"), "expected_unknown", { hint: tr("s7.h003") })
    .endMenu()

    .scene("act1_choice_resolve", "sota_responds")
    .show("sota", "center", "thoughtful")

    .sayJp("sota", "ジェイミー。", tr("s7.l083"), "jeimii.", "careful")
    .sayJp("sota", "あの頃のことは消えてないよ。", tr("s7.l084"), "ano koro no koto wa kietenai yo.", "certain")
    .sayJp("sota", "ただ、あの頃の東京は、もう今の東京と同じ場所じゃないだけで。", tr("s7.l085"), "tada, ano koro no toukyou wa, mou ima no toukyou to onaji basho janai dake de.", "honest")

    .vocab("以前", "いぜん", "izen", "Before / previously / formerly", { category: "time" })

    .think(tr("s7.l086"), "absorbing")
    .think(tr("s7.l087"), "continuing")

    .sayJp("sota", "まあ、飲もうぜ。明日何するの？", tr("s7.l088"), "maa, nomou ze. ashita nani suru no?", "lightening")

    .playerJp("昔の場所を全部回ろうと思って。", tr("s7.l089"), "mukashi no basho o zenbu mawarou to omotte.", "explaining")

    .sayJp("sota", "全部？", tr("s7.l090"), "zenbu?", "raised_eyebrow")

    .playerJp("できる限り。", tr("s7.l091"), "dekiru kagiri.", "determined")

    .sayJp("sota", "じゃ、大変だな。", tr("s7.l092"), "ja, taihen da na.", "smiling")
    .sayJp("sota", "付き合おうか？", tr("s7.l093"), "tsukiaou ka?", "offering")

    .playerJp("一人でやってみたい。", tr("s7.l094"), "hitori de yatte mitai.", "decided")

    .sayJp("sota", "わかった。夜に連絡して。", tr("s7.l095"), "wakatta. yoru ni renraku shite.", "respecting")

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

    .vocab("昔", "むかし", "mukashi", "Long ago / the old days / once", { category: "time" })
    .vocab("〜たものだ", null, "~ta mono da", "Used to ~ (nostalgic recollection)", { category: "grammar" })

    .n(tr("s7.l099"))
    .n(tr("s7.l100"))
    .n(tr("s7.l101"))
    .n(tr("s7.l102"))
    .n(tr("s7.l103"))

    .show("cafe_owner", "center", "polite")

    .sayJp("cafe_owner", "お久しぶりですか？", tr("s7.l104"), "ohisashiburi desu ka?", "neutral")

    .playerJp("五年ぶりです。以前、よく来ていました。", tr("s7.l105"), "gonen buri desu. izen, yoku kiteimashita.", "offering")

    .vocab("〜ていた", null, "~te ita", "Was doing ~ / used to do ~ (continuous past)", { category: "grammar" })

    .sayJp("cafe_owner", "そうですか。ありがとうございます。", tr("s7.l106"), "sou desu ka. arigatou gozaimasu.", "warmly")
    .sayJp("cafe_owner", "またいつでもどうぞ。", tr("s7.l107"), "mata itsu demo douzo.", "genuine")

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

    .sayJp("nishimura", "パク・ジェイミーさん。わあ、大人になりましたね。", tr("s7.l116"), "paku jeimii-san. waa, otona ni narimashita ne.", "delighted")

    .playerJp("先生もあまり変わっていないですね。", tr("s7.l117"), "sensei mo amari kawatteinai desu ne.", "warm")

    .sayJp("nishimura", "お世辞ばかり。", tr("s7.l118"), "oseji bakari.", "laughing")
    .sayJp("nishimura", "座って。どうですか、東京？", tr("s7.l119"), "suwatte. dou desu ka, toukyou?", "inviting")

    .playerJp("変わりましたね。でも、変わっていないところもあって。", tr("s7.l120"), "kawarimashita ne. demo, kawatteinai tokoro mo atte.", "honest")

    .vocab("残る", "のこる", "nokoru", "To remain / to be left behind", { category: "verbs" })

    .sayJp("nishimura", "どちらが多いですか？", tr("s7.l121"), "dochira ga ooi desu ka?", "asking")

    .think(tr("s7.l122"), "considering")

    .playerJp("変わった方が多いと思います。でも、それが問題なのか、それとも私の問題なのか—", tr("s7.l123"), "kawatta hou ga ooi to omoimasu. demo, sore ga mondai na no ka, soretomo watashi no mondai na no ka-", "uncertain")
    .playerJp("よくわからないんです。", tr("s7.l124"), "yoku wakaranain desu.", "honest")

    .sayJp("nishimura", "それは正直な答えですね。", tr("s7.l125"), "sore wa shoujiki na kotae desu ne.", "approving")
    .sayJp("nishimura", "実は、留学生の子たちに、戻って来た時の話を聞くことが多いんです。", tr("s7.l126"), "jitsu wa, ryuugakusei no kotachi ni, modotte kita toki no hanashi o kiku koto ga ooi n desu.", "building")
    .sayJp("nishimura", "みんな同じことを言います。", tr("s7.l127"), "minna onaji koto o iimasu.", "meaningful")

    .playerJp("何と言うんですか？", tr("s7.l128"), "nani to iun desu ka?", "curious")

    .sayJp("nishimura", "「思っていたより悲しかった」", tr("s7.l129"), "omotteita yori kanashikatta.", "quoting")

    .n(tr("s7.l130"))

    .sayJp("nishimura", "変化を悲しんでいるのか、それとも自分が変わったことを悲しんでいるのか—", tr("s7.l131"), "henka o kanashindeiru no ka, soretomo jibun ga kawatta koto o kanashindeiru no ka-", "explaining")
    .sayJp("nishimura", "最初はなかなかわからないんです。", tr("s7.l132"), "saisho wa nakanaka wakaranain desu.", "wise")

    .think(tr("s7.l133"), "sitting_with")
    .think(tr("s7.l134"), "honesty")

    .vocab("感慨深い", "かんがいぶかい", "kangai fukai", "Deeply moving / filled with emotion", { category: "emotions" })

    .sayJp("nishimura", "でも、ほとんどの場合—", tr("s7.l135"), "demo, hotondo no baai-", "continuing")
    .sayJp("nishimura", "悲しいのは、ここが変わったからじゃなくて—", tr("s7.l136"), "kanashii no wa, koko ga kawatta kara janakute-", "building")
    .sayJp("nishimura", "あなたが変わったから、もう同じように見えないだけです。", tr("s7.l137"), "anata ga kawatta kara, mou onaji you ni mienai dake desu.", "landing")

    .n(tr("s7.l138"))

    .think(tr("s7.l139"), "rearranging")
    .think(tr("s7.l140"), "accepting")

    .sayJp("nishimura", "悪いことじゃないですよ。成長ですから。", tr("s7.l141"), "warui koto janai desu yo. seichou desu kara.", "gentle")

    .playerJp("成長って、ちょっと寂しいこともありますよね。", tr("s7.l142"), "seichou tte, chotto sabishii koto mo arimasu yo ne.", "quiet")

    .vocab("寂しい", "さびしい", "sabishii", "Lonely / lonesome / desolate", { category: "emotions" })

    .sayJp("nishimura", "ええ。", tr("s7.l143"), "ee.", "simply")
    .sayJp("nishimura", "でも、寂しさを感じられるのは、何かを大切にしていた証拠です。", tr("s7.l144"), "demo, sabishisa o kanjirareru no wa, nanika o taisetsu ni shiteita shouko desu.", "meaningful")

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

    .vocab("今でも", "いまでも", "ima demo", "Even now / still", { category: "time" })

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

    .vocab("期待外れ", "きたいはずれ", "kitai hazure", "Disappointment / not meeting expectations", { category: "emotions" })

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

    .sayJp("bartender_yuna", "いらっしゃい。一人ですか？", tr("s7.l182"), "irasshai. hitori desu ka?", "welcoming")

    .playerJp("そうです。一人で。", tr("s7.l183"), "sou desu. hitori de.", "settled")

    .sayJp("bartender_yuna", "カウンターどうぞ。今夜、ライブがあるんですよ。小さいですけど。", tr("s7.l184"), "kauntaa douzo. kon'ya, raibu ga arun desu yo. chiisai desu kedo.", "offering")

    .vocab("居場所", "いばしょ", "ibasho", "One's place / somewhere one belongs", { category: "social" })

    .n(tr("s7.l185"))
    .n(tr("s7.l186"))

    .n(tr("s7.l187"))
    .n(tr("s7.l188"))

    .n(tr("s7.l189"))

    .show("reading_woman", "right", "content")

    .sayJp("reading_woman", "いいでしょう、ここ。", tr("s7.l190"), "ii deshou, koko.", "casual")

    .playerJp("はい、初めて来ました。", tr("s7.l191"), "hai, hajimete kimashita.", "honest")

    .sayJp("reading_woman", "旅行ですか？", tr("s7.l192"), "ryokou desu ka?", "casual")

    .playerJp("昔、留学してたんです。久しぶりに来て。", tr("s7.l193"), "mukashi, ryuugaku shitetan desu. hisashiburi ni kite.", "explaining")

    .vocab("〜ようになった", null, "~you ni natta", "Has come to ~ / now ~ (change over time)", { category: "grammar" })

    .sayJp("reading_woman", "ああ、里帰りみたいな。", tr("s7.l194"), "aa, satogaeri mitai na.", "understanding")

    .thinkJp("里帰り。", tr("s7.l195"), "satogaeri.", "absorbing")
    .think(tr("s7.l196"), "sitting_with_it")

    .playerJp("そういう感じです。", tr("s7.l197"), "sou iu kanji desu.", "accepting")

    .sayJp("reading_woman", "どうですか？", tr("s7.l198"), "dou desu ka?", "curious")

    .playerJp("思ったより複雑ですね。", tr("s7.l199"), "omotta yori fukuzatsu desu ne.", "honest")
    .playerJp("変わったところが悲しくて、変わっていないところにほっとして。", tr("s7.l200"), "kawatta tokoro ga kanashikute, kawatteinai tokoro ni hotto shite.", "articulating")
    .playerJp("でも—こういう場所は知らなかった。", tr("s7.l201"), "demo-kou iu basho wa shiranakatta.", "gesturing_at_bar")
    .playerJp("前に住んでた時には来てなかった。", tr("s7.l202"), "mae ni sundeta toki ni wa kitenakatta.", "realizing")

    .sayJp("reading_woman", "そりゃそうでしょう。当時は知らなかったんだから。", tr("s7.l203"), "sorya sou deshou. touji wa shiranakattan dakara.", "simply")

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

    .sayJp("yamamoto_curry", "ああ？外国のお兄さん？前来たことある？", tr("s7.l213"), "aa? gaikoku no oniisan? mae kita koto aru?", "peering")

    .playerJp("はい、五年前に。よく来ていました。", tr("s7.l214"), "hai, gonen mae ni. yoku kiteimashita.", "hoping")

    .sayJp("yamamoto_curry", "五年前！", tr("s7.l215"), "gonen mae!", "calculating")
    .sayJp("yamamoto_curry", "…あ！チキンカレーの人！", tr("s7.l216"), "...a! chikin karee no hito!", "suddenly")

    .n(tr("s7.l217"))
    .n(tr("s7.l218"))

    .sayJp("yamamoto_curry", "いつもチキンカレー、辛口で頼んでた外国の学生でしょ。", tr("s7.l219"), "itsumo chikin karee, karakuchi de tanondeta gaikoku no gakusei desho.", "certain")
    .sayJp("yamamoto_curry", "おかえり！", tr("s7.l220"), "okaeri!", "warm")

    .vocab("面影", "おもかげ", "omokage", "Trace / vestige / lingering image", { category: "literary" })

    .thinkJp("おかえり。", tr("s7.l221"), "okaeri.", "floored")
    .think(tr("s7.l222"), "counting")

    .n(tr("s7.l223"))
    .n(tr("s7.l224"))

    .sayJp("sota", "大丈夫？", tr("s7.l225"), "daijoubu?", "gentle")

    .playerJp("うん。大丈夫。", tr("s7.l226"), "un. daijoubu.", "rough")

    .sayJp("yamamoto_curry", "チキンカレー？", tr("s7.l227"), "chikin karee?", "ready")

    .playerJp("辛口で。", tr("s7.l228"), "karakuchi de.", "immediately")

    .sayJp("yamamoto_curry", "変わってないな。", tr("s7.l229"), "kawattenai na.", "approving")

    .n(tr("s7.l230"))
    .n(tr("s7.l231"))

    .sayJp("sota", "それだよ。", tr("s7.l232"), "sore da yo.", "meaningful")

    .playerJp("何が？", tr("s7.l233"), "nani ga?", "asking")

    .sayJp("sota", "探してたものが、そこにあったじゃん。", tr("s7.l234"), "sagashiteta mono ga, soko ni atta jan.", "pointing_out")

    .vocab("〜なくなった", null, "~naku natta", "Has stopped ~ / no longer ~ (change / loss)", { category: "grammar" })

    .playerJp("シェアハウスがなくなって、レコード屋がなくなって—", tr("s7.l235"), "shea hausu ga nakunatte, rekoodoya ga nakunatte-", "listing")

    .sayJp("sota", "でも山本さんは覚えてた。", tr("s7.l236"), "demo yamamoto-san wa oboeteta.", "simple")

    .think(tr("s7.l237"), "sitting_with_it")
    .think(tr("s7.l238"), "continuing")
    .think(tr("s7.l239"), "honest")
    .think(tr("s7.l240"), "landing")

    .playerJp("それって、十分なのかな。", tr("s7.l241"), "sore tte, juubun na no ka na.", "quiet")

    .sayJp("sota", "俺は、十分だと思う。", tr("s7.l242"), "ore wa, juubun da to omou.", "certain")
    .sayJp("sota", "全部残ることはないよ。でも、何かが残る。", tr("s7.l243"), "zenbu nokoru koto wa nai yo. demo, nanika ga nokoru.", "wise")

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

    .vocab("なじむ", null, "najimu", "To become familiar with / to fit in / to blend in", { category: "verbs" })

    .think(tr("s7.l248"), "realizing")
    .think(tr("s7.l249"), "honest")
    .think(tr("s7.l250"), "present_tense")

    .n(tr("s7.l251"))
    .n(tr("s7.l252"))
    .n(tr("s7.l253"))

    .think(tr("s7.l254"), "reframing")
    .think(tr("s7.l255"), "seeing_it")
    .think(tr("s7.l256"), "wonder")

    .vocab("よそ者", "よそもの", "yosomono", "Outsider / stranger / newcomer", { category: "social" })
    .vocab("なじむ", null, "najimu", "To blend in / to become familiar", { category: "verbs" })

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

    .sayJp("sota", "明日帰るんだっけ。", tr("s7.l264"), "ashita kaerun dakke.", "remembering")

    .playerJp("うん。成田、十時半。", tr("s7.l265"), "un. narita, juuji han.", "matter_of_fact")

    .sayJp("sota", "どうだった？結局。", tr("s7.l266"), "dou datta? kekkyoku.", "full_question")

    .think(tr("s7.l267"), "translating")
    .think(tr("s7.l268"), "tallying")

    .playerJp("シェアハウスなかった。レコード屋なかった。", tr("s7.l269"), "shea hausu nakatta. rekoodoya nakatta.", "listing")
    .playerJp("でも、山本さんはいた。西村先生はいた。お前もいた。", tr("s7.l270"), "demo, yamamoto-san wa ita. nishimura-sensei wa ita. omae mo ita.", "continuing")
    .playerJp("新しい場所も見つけた。前には知らなかった場所。", tr("s7.l271"), "atarashii basho mo mitsuketa. mae ni wa shiranakatta basho.", "adding")

    .vocab("居場所", "いばしょ", "ibasho", "One's place / somewhere one belongs", { category: "social" })

    .playerJp("何かを探しに来たと思ってたけど。", tr("s7.l272"), "nanika o sagashi ni kita to omotteta kedo.", "honest")
    .playerJp("実は—自分が変わったことを確認しに来たのかも。", tr("s7.l273"), "jitsu wa-jibun ga kawatta koto o kakunin shi ni kita no kamo.", "arriving")

    .sayJp("sota", "どういう意味？", tr("s7.l274"), "dou iu imi?", "listening")

    .playerJp("ここで過ごした時間が、今の自分を作ったって。", tr("s7.l275"), "koko de sugoshita jikan ga, ima no jibun o tsukutta tte.", "explaining")
    .playerJp("それを確かめたかったのかな、と思って。", tr("s7.l276"), "sore o tashikametakatta no ka na, to omotte.", "completing")

    .sayJp("sota", "確かめられた？", tr("s7.l277"), "tashikamerareta?", "direct")

    .playerJp("うん。", tr("s7.l278"), "un.", "certain")

    .n(tr("s7.l279"))

    .sayJp("sota", "おかえり、ジェイミー。", tr("s7.l280"), "okaeri, jeimii.", "sincere")

    .vocab("おかえり", null, "okaeri", "Welcome back (said to someone returning home)", { category: "greetings" })

    .think(tr("s7.l281"), "landing")
    .think(tr("s7.l282"), "building")
    .think(tr("s7.l283"), "arriving")

    .playerJp("ただいま。", tr("s7.l284"), "tadaima.", "quiet")

    .vocab("ただいま", null, "tadaima", "I'm home / I'm back (said by person returning)", { category: "greetings", jlpt: "N5" })

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

    .vocab("帰国", "きこく", "kikoku", "Returning to one's home country", { category: "travel" })

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

    .vocab("〜たものだ", null, "~ta mono da", "Used to ~ (nostalgic recollection)", { category: "grammar" })
    .vocab("〜なくなった", null, "~naku natta", "Has stopped ~ / no longer ~", { category: "grammar" })

    .say("tanaka", tr("s7.l342"), "explaining")
    .sayJp("tanaka", "〜たものだ。", tr("s7.l343"), "~ta mono da.", "first")
    .sayJp("tanaka", "〜なくなった。", tr("s7.l344"), "~naku natta.", "second")
    .sayJp("tanaka", "〜ようになった。", tr("s7.l345"), "~you ni natta.", "third")

    .show("ken", "left", "connecting")

    .sayJp("ken", "シェアハウスは、なくなった。", tr("s7.l346"), "shea hausu wa, nakunatta.", "applying")
    .sayJp("ken", "ジェイミーは日本語の小説が読めるようになった。", tr("s7.l347"), "jeimii wa nihongo no shousetsu ga yomeru you ni natta.", "building")

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
    .sayJp("yuki", "居心地がいい。", tr("s7.l406"), "igokochi ga ii.", "landing_on_the_right_one")

    .vocab("居心地がいい", "いごこちがいい", "igokochi ga ii", "Comfortable / feels right / at ease there", { category: "emotions" })

    .sayJp("ken", "居心地がいい。", tr("s7.l407"), "igokochi ga ii.", "repeating_it")
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
