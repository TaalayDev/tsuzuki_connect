import { dialogue, word } from './DialogueBuilder.js';
import { tr } from '../systems/I18n.js';

// Vocabulary list for Story 3
const STORY_3_VOCABULARY = [
    word("家族", "かぞく", "kazoku", "Family", { category: "family" }),
    word("父", "ちち", "chichi", "Father (my)", { category: "family" }),
    word("母", "はは", "haha", "Mother (my)", { category: "family" }),
    word("お父さん", "おとうさん", "otousan", "Father (someone else's)", { category: "family" }),
    word("お母さん", "おかあさん", "okaasan", "Mother (someone else's)", { category: "family" }),
    word("初めまして", "はじめまして", "hajimemashite", "Nice to meet you (first time)", { category: "greetings" }),
    word("よろしくお願いします", null, "yoroshiku onegaishimasu", "Please treat me well", { category: "greetings" }),
    word("失礼します", "しつれいします", "shitsurei shimasu", "Excuse me (formal)", { category: "phrases" }),
    word("緊張", "きんちょう", "kinchou", "Nervous/Tension", { category: "emotions" }),
    word("料理", "りょうり", "ryouri", "Cooking/Cuisine", { category: "food" }),
    word("美味しい", "おいしい", "oishii", "Delicious", { category: "food" }),
    word("作る", "つくる", "tsukuru", "To make", { category: "verbs" }),
    word("教える", "おしえる", "oshieru", "To teach", { category: "verbs" }),
    word("頑張る", "がんばる", "ganbaru", "To do one's best", { category: "verbs" }),
    word("将来", "しょうらい", "shourai", "Future", { category: "time" }),
];

export const getStory3 = () => dialogue()
    .story(3, tr("s3.title"), tr("s3.subtitle"))
    .description(tr("s3.desc"))
    .estimatedTime("60-75 minutes")
    .jlptFocus("N4-N3")
    .vocabularyList(STORY_3_VOCABULARY)

    // ============================================
    // PROLOGUE: The Morning Before
    // ============================================
    .scene("prologue", "morning_anxiety")
    .titleCard(tr("s3.card_title"), tr("s3.card_subtitle"))
    .music("tense")
    .bg("apartment", "morning")
    .n(tr("s3.l001"))
    .n(tr("s3.l002"))

    .think(tr("s3.l003"), "nervous")

    .n(tr("s3.l004"))
    .n(tr("s3.l005"))
    .n(tr("s3.l006"))

    .vocab("家族", "かぞく", "kazoku", "Family", { category: "family" })

    .n(tr("s3.l007"))
    .n(tr("s3.l008"))

    .show("kana", "center", "neutral")

    .n(tr("s3.l009"))

    .say("kana", tr("s3.l010"), "sleepy")

    .player(tr("s3.l011"), "nervous")

    .say("kana", tr("s3.l012"), "gentle")

    .player(tr("s3.l013"), "worried")

    .say("kana", tr("s3.l014"), "firm")

    .n(tr("s3.l015"))

    .say("kana", tr("s3.l016"), "warm")

    .n(tr("s3.l017"))

    .say("kana", tr("s3.l018"), "encouraging")

    .player(tr("s3.l019"), "anxious")

    .say("kana", tr("s3.l020"), "determined")

    .jump("practice_session")

    // ============================================
    // SCENE 1: Practice Session
    // ============================================
    .scene("scene1", "practice_session")
    .bg("livingroom", "morning")
    .show("kana", "center", "teaching")

    .n(tr("s3.l021"))

    .say("kana", tr("s3.l022"), "serious")

    .vocab("初めまして", "はじめまして", "hajimemashite", "Nice to meet you (first time)", { category: "greetings" })

    .player(tr("s3.l023"), "nervous")

    .say("kana", tr("s3.l024"), "encouraging")

    .vocab("よろしくお願いします", null, "yoroshiku onegaishimasu", "Please treat me well", { category: "greetings" })

    .player(tr("s3.l025"), "focused")

    .say("kana", tr("s3.l026"), "thinking")

    .vocab("教える", "おしえる", "oshieru", "To teach", { category: "verbs" })

    .playerJp("英語を教えています。", tr("s3.l027"), "eigo o oshiete imasu.", "concentrating")

    .say("kana", tr("s3.l028"), "correcting")

    .n(tr("s3.l029"))

    .say("kana", tr("s3.l030"), "quiz")

    .vocab("料理", "りょうり", "ryouri", "Cooking/Cuisine", { category: "food" })

    .playerJp("Uh... 日本の料理が大好きです？", tr("s3.l031"), "uh... nihon no ryouri ga daisuki desu?", "unsure")

    .say("kana", tr("s3.l032"), "testing")

    .player(tr("s3.l033"), "struggling")

    .sayJp("kana", tr("s3.l034"), "Please teach me.", "oshiete kudasai.", "patient")

    .playerJp("教えてください。", tr("s3.l035"), "oshiete kudasai.", "repeating")

    .say("kana", tr("s3.l036"), "confident")

    .player(tr("s3.l037"), "worried")

    .say("kana", tr("s3.l038"), "gentle")

    .player(tr("s3.l039"), "curious")

    .say("kana", tr("s3.l040"), "warm")

    .n(tr("s3.l041"))

    .say("kana", tr("s3.l042"), "cheerful")

    .menu()
    .choice(tr("s3.l043"), "breakfast_out")
    .choice(tr("s3.l044"), "stay_practice")
    .endMenu()

    // SCENE 2A: Breakfast Out
    .scene("scene2a", "breakfast_out")
    .bg("cafe", "morning")
    .n(tr("s3.l045"))
    .n(tr("s3.l046"))

    .show("kana", "center", "happy")

    .say("kana", tr("s3.l047"), "thoughtful")

    .player(tr("s3.l048"), "surprised")

    .say("kana", tr("s3.l049"), "laughing")

    .player(tr("s3.l050"), "shocked")

    .say("kana", tr("s3.l051"), "embarrassed")

    .player(tr("s3.l052"), "amused")

    .say("kana", tr("s3.l053"), "remembering")
    .say("kana", tr("s3.l054"), "reassuring")

    .jump("afternoon_prep")

    // SCENE 2B: Stay and Practice
    .scene("scene2b", "stay_practice")
    .bg("livingroom", "morning")
    .show("kana", "center", "gentle")

    .say("kana", tr("s3.l055"), "concerned")

    .n(tr("s3.l056"))
    .n(tr("s3.l057"))

    .say("kana", tr("s3.l058"), "encouraging")

    .player(tr("s3.l059"), "anxious")

    .say("kana", tr("s3.l060"), "supportive")

    .n(tr("s3.l061"))

    .say("kana", tr("s3.l062"), "warm")

    .jump("afternoon_prep")

    // ============================================
    // SCENE 3: Afternoon Preparation
    // ============================================
    .scene("scene3", "afternoon_prep")
    .bg("apartment", "afternoon")
    .show("kana", "center", "thinking")

    .n(tr("s3.l063"))
    .n(tr("s3.l064"))

    .say("kana", tr("s3.l065"), "amused")

    .player(tr("s3.l066"), "stressed")

    .say("kana", tr("s3.l067"), "decisive")

    .n(tr("s3.l068"))
    .n(tr("s3.l069"))

    .say("kana", tr("s3.l070"), "briefing")

    .vocab("お父さん", "おとうさん", "otousan", "Father (someone else's)", { category: "family" })

    .say("kana", tr("s3.l071"), "instructing")

    .player(tr("s3.l072"), "nervous")

    .say("kana", tr("s3.l073"), "continuing")

    .vocab("お母さん", "おかあさん", "okaasan", "Mother (someone else's)", { category: "family" })

    .say("kana", tr("s3.l074"), "warning")

    .say("kana", tr("s3.l075"), "nervous")

    .player(tr("s3.l076"), "alarmed")

    .say("kana", tr("s3.l077"), "shy")

    .say("kana", tr("s3.l078"), "laughing")

    .player(tr("s3.l079"), "curious")

    .say("kana", tr("s3.l080"), "fond")

    .n(tr("s3.l081"))
    .n(tr("s3.l082"))

    .think(tr("s3.l083"), "terrified")

    .jump("the_call_begins")

    // ============================================
    // SCENE 4: The Call Begins
    // ============================================
    .scene("scene4", "the_call_begins")
    .bg("apartment", "evening")
    .music("tense")

    .n(tr("s3.l084"))
    .n(tr("s3.l085"))

    .show("father", "center", "neutral")

    .n(tr("s3.l086"))

    .sayJp("kana", tr("s3.l087"), "Father, good evening!", "otousan, konbanwa!", "cheerful")

    .sayJp("father", tr("s3.l088"), "Kana. Are you well?", "kana. genki ka?", "serious")

    .n(tr("s3.l089"))

    .sayJp("kana", tr("s3.l090"), "Yes! Um, this is Alex.", "hai! etto, kochira wa arekkusu desu.", "introducing")

    .n(tr("s3.l091"))

    .vocab("失礼します", "しつれいします", "shitsurei shimasu", "Excuse me (formal)", { category: "phrases" })

    .playerJp("初めまして。失礼します。アレックスと申します。", tr("s3.l092"), "hajimemashite. shitsurei shimasu. arekkusu to moushimasu.", "formal")

    .n(tr("s3.l093"))

    .playerJp("よろしくお願いします。", tr("s3.l094"), "yoroshiku onegaishimasu.", "nervous")

    .sayJp("father", tr("s3.l095"), "...Alex-san.", "...arekkusu-san.", "evaluating")

    .n(tr("s3.l096"))

    .sayJp("father", tr("s3.l097"), "Can you speak Japanese?", "nihongo ga hanasemasu ka?", "testing")

    .think(tr("s3.l098"), "panicked")

    .playerJp("はい、少し...", tr("s3.l099"), "hai, sukoshi...", "humble")
    .player(tr("s3.l100"), "humble")

    .sayJp("father", tr("s3.l101"), "I see.", "sou desu ka.", "neutral")

    .n(tr("s3.l102"))

    .sayJp("kana", tr("s3.l103"), "Alex is an English teacher. He's doing his very best!", "arekkusu wa eigo no sensei desu. totemo ganbatte imasu!", "defending")

    .vocab("頑張る", "がんばる", "ganbaru", "To do one's best", { category: "verbs" })

    .sayJp("father", tr("s3.l104"), "English teacher.", "eigo no sensei.", "considering")
    .say("father", tr("s3.l105"), "questioning")

    .n(tr("s3.l106"))

    .player(tr("s3.l107"), "professional")

    .say("father", tr("s3.l108"), "probing")

    .player(tr("s3.l109"), "respectful")

    .show("mother", "left", "neutral")
    .hide("father")

    .n(tr("s3.l110"))

    .sayJp("mother", tr("s3.l111"), "Masaru, don't ask only such questions!", "masaru, sonna shitsumon bakari shinaide!", "scolding")

    .n(tr("s3.l112"))

    .sayJp("mother", tr("s3.l113"), "Alex-san, nice to meet you. I'm Kana's mother.", "arekkusu-san, hajimemashite. kana no okaasan desu.", "warm")

    .playerJp("初めまして、お母さん。よろしくお願いします。", tr("s3.l114"), "hajimemashite, okaasan. yoroshiku onegaishimasu.", "polite")

    .sayJp("mother", tr("s3.l115"), "My, your Japanese is good!", "maa, nihongo jouzu desu ne!", "impressed")

    .n(tr("s3.l116"))

    .sayJp("mother", tr("s3.l117"), "Kana, you look well. Are you eating properly?", "kana, genkisou ne. chanto tabeteru?", "concerned")

    .sayJp("kana", tr("s3.l118"), "I'm eating, Mom. Because Alex cooks for me.", "tabeteru yo, okaasan. arekkusu ga ryouri tsukutte kureru kara.", "reassuring")

    .sayJp("mother", tr("s3.l119"), "Really? Alex-san, you can cook?", "hontou? arekkusu-san, ryouri dekiru no?", "interested")

    .vocab("作る", "つくる", "tsukuru", "To make", { category: "verbs" })

    .playerJp("はい、少し...", tr("s3.l120"), "hai, sukoshi...", "modest")
    .player(tr("s3.l121"), "modest")

    .sayJp("mother", tr("s3.l122"), "Wonderful! What can you make?", "subarashii! nani ga tsukuremasu ka?", "excited")

    .think(tr("s3.l123"), "panicked")

    .playerJp("えっと... カレー？", tr("s3.l124"), "etto... karee?", "uncertain")
    .player(tr("s3.l125"), "uncertain")

    .sayJp("mother", tr("s3.l126"), "That's good! Next time, I'll teach you nikujaga!", "ii desu ne! kondo, nikujaga oshiete ageru!", "enthusiastic")

    .say("kana", tr("s3.l127"), "translating")

    .vocab("教えてください", "おしえてください", "oshiete kudasai", "Please teach me", { category: "phrases" })

    .playerJp("教えてください！", tr("s3.l128"), "oshiete kudasai!", "grateful")
    .player(tr("s3.l129"), "grateful")

    .jump("meeting_grandparents")

    // ============================================
    // SCENE 5: Meeting the Grandparents
    // ============================================
    .scene("scene5", "meeting_grandparents")
    .hide("mother")
    .show("grandpa", "right", "neutral")
    .show("grandma", "left", "neutral")

    .n(tr("s3.l130"))

    .sayJp("kana", tr("s3.l131"), "Grandpa, Grandma!", "ojiichan, obaachan!", "excited")

    .sayJp("grandma", tr("s3.l132"), "Oh, Kana-chan!", "ara, kana-chan!", "delighted")

    .n(tr("s3.l133"))

    .sayJp("grandma", tr("s3.l134"), "Is this Alex-san?", "kore ga arekkusu-san?", "curious")

    .playerJp("初めまして、おばあちゃん。", tr("s3.l135"), "hajimemashite, obaachan.", "respectful")

    .n(tr("s3.l136"))

    .sayJp("grandma", tr("s3.l137"), "My, how polite.", "maa, reigi tadashii wa ne.", "pleased")

    .n(tr("s3.l138"))

    .sayJp("grandma", tr("s3.l139"), "Alex-san, do you like Japanese food?", "arekkusu-san, nihon no tabemono wa suki?", "asking")

    .vocab("美味しい", "おいしい", "oishii", "Delicious", { category: "food" })

    .playerJp("はい！とても美味しいです。", tr("s3.l140"), "hai! totemo oishii desu.", "enthusiastic")
    .player(tr("s3.l141"), "enthusiastic")

    .sayJp("grandma", tr("s3.l142"), "What do you like best?", "nani ga ichiban suki?", "interested")

    .think(tr("s3.l143"), "stressed")

    .playerJp("えっと... お寿司？", tr("s3.l144"), "etto... osushi?", "listing")
    .player(tr("s3.l145"), "listing")

    .sayJp("grandma", tr("s3.l146"), "Fufu, so you like everything.", "fufu, zenbu suki na no ne.", "amused")

    .n(tr("s3.l147"))

    .sayJp("grandma", tr("s3.l148"), "Next time you come to Japan, I'll make my fried chicken for you.", "kondo, nihon ni kuru toki, obaachan no karaage tsukutte ageru.", "promising")

    .say("kana", tr("s3.l149"), "translating")

    .playerJp("本当ですか？ありがとうございます！", tr("s3.l150"), "hontou desu ka? arigatou gozaimasu!", "excited")

    .n(tr("s3.l151"))

    .jump("the_question")

    // ============================================
    // SCENE 6: The Big Question
    // ============================================
    .scene("scene6", "the_question")
    .hide("grandpa")
    .n(tr("s3.l152"))

    .sayJp("grandma", tr("s3.l153"), "Alex-san, may I ask one thing?", "arekkusu-san, hitotsu kiitemo ii?", "gentle")

    .playerJp("はい。", tr("s3.l154"), "hai.", "nervous")

    .vocab("将来", "しょうらい", "shourai", "Future", { category: "time" })

    .sayJp("grandma", tr("s3.l155"), "Are you thinking about a future... with Kana?", "kana to no shourai... kangaeteru?", "serious")

    .n(tr("s3.l156"))

    .think(tr("s3.l157"), "intense")

    .show("kana", "right", "nervous")

    .n(tr("s3.l158"))

    .menu()
    .choice(tr("s3.l159"), "answer_japanese")
    .choice(tr("s3.l160"), "answer_english")
    .endMenu()

    // SCENE 7A: Answer in Japanese
    .scene("scene7a", "answer_japanese")
    .hide("kana")

    .n(tr("s3.l161"))

    .playerJp("はい。私は... 加奈さんと... um...", tr("s3.l162"), "hai. watashi wa... kana-san to... um...", "struggling")

    .think(tr("s3.l163"), "panicking")

    .playerJp("加奈さんと... together... want... 一緒に...", tr("s3.l164"), "kana-san to... together... want... issho ni...", "fumbling")

    .n(tr("s3.l165"))

    .playerJp("Future... together... very... 大切です。", tr("s3.l166"), "future... together... very... taisetsu desu.", "desperate")

    .n(tr("s3.l167"))
    .n(tr("s3.l168"))
    .n(tr("s3.l169"))

    .show("kana", "right", "gentle")

    .n(tr("s3.l170"))

    .say("kana", tr("s3.l171"), "translating")

    .sayJp("grandma", tr("s3.l172"), "...I understand.", "...wakatta wa.", "softening")

    .n(tr("s3.l173"))

    .sayJp("grandma", tr("s3.l174"), "Thank you for speaking with all your might.", "isshoukenmei ni hanashite kurete, arigatou.", "moved")

    .say("kana", tr("s3.l175"), "translating")

    .jump("sister_interruption")

    // SCENE 7B: Answer in English
    .scene("scene7b", "answer_english")
    .hide("kana")

    .player(tr("s3.l176"), "sincere")

    .n(tr("s3.l177"))

    .player(tr("s3.l178"), "honest")
    .player(tr("s3.l179"), "emotional")
    .player(tr("s3.l180"), "determined")

    .show("kana", "right", "crying")

    .n(tr("s3.l181"))

    .sayJp("grandma", tr("s3.l182"), "...I see.", "...sou.", "understanding")

    .n(tr("s3.l183"))

    .sayJp("grandma", tr("s3.l184"), "Your feelings came through.", "kimochi wa tsutawatta wa.", "gentle")

    .say("kana", tr("s3.l185"), "tearful")

    .jump("sister_interruption")

    // ============================================
    // SCENE 8: Little Sister Interruption
    // ============================================
    .scene("scene8", "sister_interruption")
    .hide("kana")
    .hide("grandma")
    .show("little_girl", "center", "neutral")

    .n(tr("s3.l186"))

    .say("little_girl", tr("s3.l187"), "excited")

    .n(tr("s3.l188"))

    .player(tr("s3.l189"), "amused")

    .say("little_girl", tr("s3.l190"), "loud")

    .show("kana", "right", "embarrassed")

    .say("kana", tr("s3.l191"), "mortified")

    .say("little_girl", tr("s3.l192"), "continuing")

    .n(tr("s3.l193"))

    .show("mother", "left", "laughing")
    .hide("little_girl")

    .sayJp("mother", tr("s3.l194"), "I'm sorry. My daughter is...", "gomennasai. musume ga...", "apologizing")

    .n(tr("s3.l195"))

    .jump("wrapping_up")

    // ============================================
    // SCENE 9: Wrapping Up
    // ============================================
    .scene("scene9", "wrapping_up")
    .hide("mother")
    .show("father", "center", "neutral")

    .n(tr("s3.l196"))

    .sayJp("father", tr("s3.l197"), "Alex-san.", "arekkusu-san.", "serious")

    .playerJp("はい。", tr("s3.l198"), "hai.", "attentive")

    .say("father", tr("s3.l199"), "formal")

    .n(tr("s3.l200"))

    .player(tr("s3.l201"), "grateful")

    .say("father", tr("s3.l202"), "firm")

    .player(tr("s3.l203"), "sincere")

    .n(tr("s3.l204"))

    .say("father", tr("s3.l205"), "encouraging")

    .playerJp("はい、頑張ります！", tr("s3.l206"), "hai, ganbarimasu!", "determined")

    .hide("father")
    .show("mother", "left", "warm")
    .show("grandma", "right", "gentle")

    .sayJp("mother", tr("s3.l207"), "Well then, contact us again!", "jaa, mata renraku shite ne!", "cheerful")

    .sayJp("grandma", tr("s3.l208"), "Alex-san, let's talk again.", "arekkusu-san, mata hanashimashou.", "kind")

    .playerJp("はい、ありがとうございました！", tr("s3.l209"), "hai, arigatou gozaimashita!", "bowing")

    .n(tr("s3.l210"))
    .n(tr("s3.l211"))

    .hide("mother")
    .hide("grandma")

    .jump("after_call")

    // ============================================
    // SCENE 10: After the Call
    // ============================================
    .scene("scene10", "after_call")
    .bg("apartment", "evening")
    .music("warm")
    .show("kana", "center", "crying")

    .n(tr("s3.l212"))
    .n(tr("s3.l213"))

    .player(tr("s3.l214"), "worried")

    .say("kana", tr("s3.l215"), "laughing")

    .n(tr("s3.l216"))

    .say("kana", tr("s3.l217"), "emotional")

    .player(tr("s3.l218"), "uncertain")

    .say("kana", tr("s3.l219"), "excited")

    .n(tr("s3.l220"))

    .say("kana", tr("s3.l221"), "shy")

    .player(tr("s3.l222"), "sincere")

    .say("kana", tr("s3.l223"), "tender")

    .player(tr("s3.l224"), "warm")

    .n(tr("s3.l225"))

    .say("kana", tr("s3.l226"), "remembering")

    .player(tr("s3.l227"), "curious")

    .sayJp("kana", tr("s3.l228"), "Your feelings came through.", "kimochi wa tsutawatta.", "gentle")
    .say("kana", tr("s3.l229"), "gentle")
    .say("kana", tr("s3.l230"), "wise")

    .player(tr("s3.l231"), "grateful")

    .say("kana", tr("s3.l232"), "smiling")

    .n(tr("s3.l233"))

    .jump("epilogue")

    // ============================================
    // EPILOGUE: Six Months Later
    // ============================================
    .scene("epilogue", "six_months_later")
    .bg("sitting_room", "afternoon")
    .music("hopeful")

    .n(tr("s3.l234"))
    .n(tr("s3.l235"))

    .show("mother", "left", "teaching")

    .n(tr("s3.l236"))

    .sayJp("mother", tr("s3.l237"), "Next, put in the meat...", "tsugi wa, oniku o irete...", "instructing")

    .playerJp("お肉... meat... はい！", tr("s3.l238"), "oniku... meat... hai!", "following")

    .n(tr("s3.l239"))

    .show("grandma", "right", "pleased")

    .sayJp("grandma", tr("s3.l240"), "You've gotten good, Alex-san.", "jouzu ni natta wa ne, arekkusu-san.", "proud")

    .playerJp("ありがとうございます。毎日、勉強しています。", tr("s3.l241"), "arigatou gozaimasu. mainichi, benkyou shite imasu.", "humble")

    .show("father", "center", "neutral")
    .hide("mother")

    .n(tr("s3.l242"))

    .sayJp("father", tr("s3.l243"), "Alex, do you have a moment?", "arekkusu, chotto ii ka?", "serious")

    .playerJp("はい。", tr("s3.l244"), "hai.", "attentive")

    .n(tr("s3.l245"))

    .hide("grandma")
    .hide("father")
    .bg("park", "afternoon")
    .show("father", "center", "serious")

    .n(tr("s3.l246"))

    .say("father", tr("s3.l247"), "acknowledging")

    .player(tr("s3.l248"), "sincere")

    .say("father", tr("s3.l249"), "honest")
    .say("father", tr("s3.l250"), "approving")

    .player(tr("s3.l251"), "earnest")

    .say("father", tr("s3.l252"), "softening")

    .n(tr("s3.l253"))

    .say("father", tr("s3.l254"), "warm")

    .n(tr("s3.l255"))

    .player(tr("s3.l256"), "grateful")

    .show("kana", "right", "happy")

    .n(tr("s3.l257"))

    .say("kana", tr("s3.l258"), "calling")

    .n(tr("s3.l259"))

    .hide("father")
    .bg("sitting_room", "evening")

    .n(tr("s3.l260"))
    .n(tr("s3.l261"))
    .n(tr("s3.l262"))
    .n(tr("s3.l263"))

    .think(tr("s3.l264"), "content")
    .think(tr("s3.l265"), "peaceful")

    .say("kana", tr("s3.l266"), "concerned")

    .player(tr("s3.l267"), "happy")

    .n(tr("s3.l268"))

    .fadeOut()
    .wait(1000)

    .jump("debrief1")

    // ============================================
    // DEBRIEF 1: Initial Reactions
    // ============================================
    .scene("debrief1", "classroom_return")
    .bg("classroom", "afternoon")
    .fadeIn()
    .music("calm")

    .n(tr("s3.l269"))

    .show("tanaka", "center", "warm")

    .say("tanaka", tr("s3.l270"), "gentle")

    .show("mei", "left", "emotional")

    .say("mei", tr("s3.l271"), "stressed")

    .show("ken", "right", "thoughtful")

    .say("ken", tr("s3.l272"), "relating")

    .say("tanaka", tr("s3.l273"), "understanding")

    .hide("mei")
    .show("yuki", "left", "gentle")

    .say("yuki", tr("s3.l274"), "thoughtful")

    .jump("debrief2")

    // ============================================
    // DEBRIEF 2: Language Points
    // ============================================
    .scene("debrief2", "language_discussion")
    .say("tanaka", tr("s3.l275"), "teaching")
    .say("tanaka", tr("s3.l276"), "quiz")

    .say("ken", tr("s3.l277"), "observing")

    .say("tanaka", tr("s3.l278"), "explaining")
    .say("tanaka", tr("s3.l279"), "instructing")

    .say("mei", tr("s3.l280"), "confused")

    .say("tanaka", tr("s3.l281"), "teaching")
    .say("tanaka", tr("s3.l282"), "explaining")

    .jump("debrief3")

    // ============================================
    // DEBRIEF 3: Cultural Context
    // ============================================
    .scene("debrief3", "cultural_discussion")
    .say("tanaka", tr("s3.l283"), "serious")
    .sayJp("tanaka", tr("s3.l284"), "kimochi wa tsutawatta - 'your feelings came through.'", "kimochi wa tsutawatta", "emphasizing")

    .say("yuki", tr("s3.l285"), "remembering")

    .say("tanaka", tr("s3.l286"), "teaching")
    .say("tanaka", tr("s3.l287"), "wise")
    .say("tanaka", tr("s3.l288"), "warm")

    .say("ken", tr("s3.l289"), "relieved")

    .say("tanaka", tr("s3.l290"), "encouraging")

    .jump("debrief4")

    // ============================================
    // DEBRIEF 4: Personal Sharing
    // ============================================
    .scene("debrief4", "personal_sharing")
    .say("tanaka", tr("s3.l291"), "asking")

    .say("mei", tr("s3.l292"), "sharing")
    .say("mei", tr("s3.l293"), "embarrassed")

    .n(tr("s3.l294"))

    .say("ken", tr("s3.l295"), "groaning")

    .say("yuki", tr("s3.l296"), "encouraging")

    .say("ken", tr("s3.l297"), "sheepish")

    .say("tanaka", tr("s3.l298"), "affirming")
    .say("tanaka", tr("s3.l299"), "inspiring")

    .jump("debrief5")

    // ============================================
    // DEBRIEF 5: Looking Forward
    // ============================================
    .scene("debrief5", "looking_forward")
    .say("tanaka", tr("s3.l300"), "assigning")
    .say("tanaka", tr("s3.l301"), "question")

    .say("mei", tr("s3.l302"), "anxious")

    .say("ken", tr("s3.l303"), "thinking")

    .say("yuki", tr("s3.l304"), "worried")

    .say("tanaka", tr("s3.l305"), "supportive")
    .say("tanaka", tr("s3.l306"), "wise")

    .n(tr("s3.l307"))

    .say("tanaka", tr("s3.l308"), "cheerful")

    .hide("ken")
    .hide("mei")
    .hide("yuki")
    .hide("tanaka")

    .jump("after_class")

    // ============================================
    // DEBRIEF 6: After Class
    // ============================================
    .scene("debrief6", "after_class")
    .bg("hallway", "afternoon")

    .show("mei", "center", "grateful")

    .n(tr("s3.l309"))

    .say("mei", tr("s3.l310"), "sincere")

    .player(tr("s3.l311"), "curious")

    .say("mei", tr("s3.l312"), "vulnerable")
    .say("mei", tr("s3.l313"), "hopeful")

    .player(tr("s3.l314"), "encouraging")

    .say("mei", tr("s3.l315"), "smiling")

    .hideAll()

    .n(tr("s3.l316"))

    .fadeOut()
    .n(tr("s3.l317"))
    .build();
