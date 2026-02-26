import { dialogue, word } from './DialogueBuilder.js';
import { tr } from '../systems/I18n.js';

// Vocabulary list for Story 4
const STORY_4_VOCABULARY = [
    // Nightlife/Service vocabulary
    word("常連", "じょうれん", "jouren", tr("s4.v.jouren"), { category: "nightlife", jlpt: "N3" }),
    word("カウンター", null, "kauntaa", tr("s4.v.kauntaa"), { category: "nightlife", jlpt: "N4" }),
    word("ボトルキープ", null, "botoru kiipu", tr("s4.v.botoru_kiipu"), { category: "nightlife", jlpt: "N3" }),
    word("お通し", "おとおし", "otooshi", tr("s4.v.otooshi"), { category: "nightlife", jlpt: "N3" }),
    word("割り勘", "わりかん", "warikan", tr("s4.v.warikan"), { category: "nightlife", jlpt: "N3" }),
    word("スナック", null, "sunakku", tr("s4.v.sunakku"), { category: "nightlife", jlpt: "N4" }),

    // Emotional labor expressions
    word("気を遣う", "きをつかう", "ki wo tsukau", tr("s4.v.ki_wo_tsukau"), { category: "emotions", jlpt: "N3" }),
    word("空気を読む", "くうきをよむ", "kuuki wo yomu", tr("s4.v.kuuki_wo_yomu"), { category: "phrases", jlpt: "N3" }),
    word("愚痴", "ぐち", "guchi", tr("s4.v.guchi"), { category: "emotions", jlpt: "N3" }),
    word("相槌", "あいづち", "aizuchi", tr("s4.v.aizuchi"), { category: "phrases", jlpt: "N3" }),

    // Family/relationship terms
    word("疎遠", "そえん", "soen", tr("s4.v.soen"), { category: "family", jlpt: "N2" }),
    word("娘", "むすめ", "musume", tr("s4.v.musume"), { category: "family", jlpt: "N5" }),
    word("育てる", "そだてる", "sodateru", tr("s4.v.sodateru"), { category: "verbs", jlpt: "N4" }),
    word("一人で", "ひとりで", "hitori de", tr("s4.v.hitori_de"), { category: "phrases", jlpt: "N5" }),

    // Business/financial
    word("家賃", "やちん", "yachin", tr("s4.v.yachin"), { category: "business", jlpt: "N3" }),
    word("閉店", "へいてん", "heiten", tr("s4.v.heiten"), { category: "business", jlpt: "N3" }),
    word("開業", "かいぎょう", "kaigyou", tr("s4.v.kaigyou"), { category: "business", jlpt: "N3" }),
    word("思い出", "おもいで", "omoide", tr("s4.v.omoide"), { category: "emotions", jlpt: "N4" }),

    // Expressing regret/reflection
    word("後悔", "こうかい", "koukai", tr("s4.v.koukai"), { category: "emotions", jlpt: "N3" }),
    word("振り返る", "ふりかえる", "furikaeru", tr("s4.v.furikaeru"), { category: "verbs", jlpt: "N3" }),
];

export const getStory4 = () => dialogue()
    .story(4, tr("s4.title"), tr("s4.subtitle"))
    .description(tr("s4.desc"))
    .estimatedTime("75-90 minutes")
    .jlptFocus("N4-N3")
    .vocabularyList(STORY_4_VOCABULARY)

    // ============================================
    // PROLOGUE: The Assignment
    // ============================================
    .scene("prologue", "the_assignment")
    .titleCard(tr("s4.card_title"), tr("s4.card_subtitle"))
    .music("urban_night")
    .bg("city", "night")

    .n(tr("s4.l001"))
    .n(tr("s4.l002"))

    .think(tr("s4.l003"), "focused")
    .think(tr("s4.l004"), "professional")

    .n(tr("s4.l005"))
    .n(tr("s4.l006"))

    .bg("backstreet", "night")

    .n(tr("s4.l007"))
    .n(tr("s4.l008"))
    .n(tr("s4.l009"))

    .vocab("スナック", null, "sunakku", tr("s4.v.sunakku"), { category: "nightlife" })

    .n(tr("s4.l010"))
    .n(tr("s4.l011"))
    .n(tr("s4.l012"))

    .think(tr("s4.l013"), "dismissive")

    .n(tr("s4.l014"))
    .n(tr("s4.l015"))
    .n(tr("s4.l016"))

    .n(tr("s4.l017"))

    .jump("enter_bar")

    // ============================================
    // ACT I: THE INTERVIEW BEGINS
    // ============================================

    // SCENE 1: Entering Snack Hotaru
    .scene("act1_scene1", "enter_bar")
    .bg("izakaya", "night")
    .music("jazz_mellow")

    .n(tr("s4.l018"))
    .n(tr("s4.l019"))
    .n(tr("s4.l020"))
    .n(tr("s4.l021"))

    .vocab("カウンター", null, "kauntaa", tr("s4.v.kauntaa"), { category: "nightlife" })

    .n(tr("s4.l022"))
    .n(tr("s4.l023"))
    .n(tr("s4.l024"))

    .show("junko", "center", "neutral")

    .say("junko", tr("s4.l025"), "calm")

    .n(tr("s4.l026"))

    .player(tr("s4.l027"), "polite")

    .say("junko", tr("s4.l028"), "welcoming")

    .n(tr("s4.l029"))

    .say("junko", tr("s4.l030"), "hospitable")

    .menu()
    .choice(tr("s4.l031"), "water_choice")
    .choice(tr("s4.l032"), "recommend_choice")
    .choice(tr("s4.l033"), "whiskey_choice")
    .endMenu()

    // SCENE 1A: Water choice
    .scene("scene1a", "water_choice")
    .show("junko", "center", "amused")

    .say("junko", tr("s4.l034"), "knowing")

    .n(tr("s4.l035"))

    .vocab("お通し", "おとおし", "otooshi", tr("s4.v.otooshi"), { category: "nightlife" })

    .sayJp("junko", "お通し。今夜はサービスです。", tr("s4.l036"), "otooshi. kon'ya wa saabisu desu.", "generous")

    .think(tr("s4.l037"), "skeptical")

    .jump("awkward_start")

    // SCENE 1B: Recommend choice
    .scene("scene1b", "recommend_choice")
    .show("junko", "center", "pleased")

    .say("junko", tr("s4.l038"), "teasing")

    .n(tr("s4.l039"))

    .say("junko", tr("s4.l040"), "fond")

    .n(tr("s4.l041"))

    .player(tr("s4.l042"), "surprised")

    .say("junko", tr("s4.l043"), "meaningful")

    .jump("awkward_start")

    // SCENE 1C: Whiskey choice
    .scene("scene1c", "whiskey_choice")
    .show("junko", "center", "approving")

    .say("junko", tr("s4.l044"), "pleased")

    .n(tr("s4.l045"))

    .say("junko", tr("s4.l046"), "gentle")
    .say("junko", tr("s4.l047"), "remembering")

    .n(tr("s4.l048"))

    .say("junko", tr("s4.l049"), "thoughtful")

    .n(tr("s4.l050"))

    .jump("awkward_start")

    // SCENE 2: Awkward Beginnings
    .scene("act1_scene2", "awkward_start")
    .show("junko", "center", "waiting")

    .n(tr("s4.l051"))

    .player(tr("s4.l052"), "professional")

    .say("junko", tr("s4.l053"), "deflecting")

    .n(tr("s4.l054"))

    .player(tr("s4.l055"), "interviewing")

    .say("junko", tr("s4.l056"), "matter-of-fact")

    .player(tr("s4.l057"), "curious")

    .show("junko", "center", "guarded")

    .say("junko", tr("s4.l058"), "careful")

    .n(tr("s4.l059"))

    .player(tr("s4.l060"), "probing")

    .say("junko", tr("s4.l061"), "repeating")

    .n(tr("s4.l062"))

    .say("junko", tr("s4.l063"), "honest")

    .n(tr("s4.l064"))

    .say("junko", tr("s4.l065"), "direct")

    .player(tr("s4.l066"), "caught_off_guard")

    .say("junko", tr("s4.l067"), "resigned")

    .sfx("door_open")
    .n(tr("s4.l068"))

    .jump("tetsu_arrives")

    // SCENE 3: First Regular Arrives — Tetsu
    .scene("act1_scene3", "tetsu_arrives")
    .show("tetsu", "right", "neutral")

    .n(tr("s4.l069"))
    .n(tr("s4.l070"))

    .vocab("常連", "じょうれん", "jouren", tr("s4.v.jouren"), { category: "nightlife" })

    .say("tetsu", tr("s4.l071"), "gruff")

    .show("junko", "center", "warm")

    .n(tr("s4.l072"))

    .say("junko", tr("s4.l073"), "delighted")

    .say("tetsu", tr("s4.l074"), "grumbling")

    .n(tr("s4.l075"))

    .say("tetsu", tr("s4.l076"), "suspicious")

    .say("junko", tr("s4.l077"), "explaining")

    .say("tetsu", tr("s4.l078"), "wary")

    .n(tr("s4.l079"))

    .say("tetsu", tr("s4.l080"), "threatening")

    .show("junko", "center", "laughing")

    .say("junko", tr("s4.l081"), "scolding")

    .say("tetsu", tr("s4.l082"), "earnest")

    .n(tr("s4.l083"))
    .hide("tetsu")

    .think(tr("s4.l084"), "curious")

    .jump("bar_fills")

    // SCENE 4: The Bar Fills
    .scene("act1_scene4", "bar_fills")
    .show("junko", "center", "working")

    .n(tr("s4.l086"))

    .show("mimi", "left", "cheerful")

    .n(tr("s4.l087"))
    .n(tr("s4.l088"))

    .say("junko", tr("s4.l089"), "introducing")

    .say("mimi", tr("s4.l090"), "friendly")

    .say("junko", tr("s4.l091"), "warning")

    .say("mimi", tr("s4.l092"), "teasing")

    .n(tr("s4.l093"))

    .show("yamada", "right", "dejected")

    .n(tr("s4.l094"))
    .n(tr("s4.l095"))

    .show("junko", "center", "observing")

    .n(tr("s4.l096"))
    .n(tr("s4.l097"))

    .say("mimi", tr("s4.l098"), "understanding")

    .n(tr("s4.l099"))
    .n(tr("s4.l100"))
    .n(tr("s4.l101"))
    .n(tr("s4.l102"))

    .vocab("気を遣う", "きをつかう", "ki wo tsukau", tr("s4.v.ki_wo_tsukau"), { category: "emotions" })

    .think(tr("s4.l103"), "observing")
    .think(tr("s4.l104"), "analyzing")

    .jump("mimi_talks")

    // SCENE 5: Mimi's Story
    .scene("act1_scene5", "mimi_talks")
    .hide("yamada")
    .show("mimi", "center", "warm")

    .n(tr("s4.l105"))

    .say("mimi", tr("s4.l106"), "curious")

    .player(tr("s4.l107"), "explaining")

    .say("mimi", tr("s4.l108"), "philosophical")

    .player(tr("s4.l109"), "observing")

    .say("mimi", tr("s4.l110"), "sincere")

    .n(tr("s4.l111"))

    .say("mimi", tr("s4.l112"), "confidential")

    .player(tr("s4.l113"), "agreeing")

    .say("mimi", tr("s4.l114"), "remembering")
    .say("mimi", tr("s4.l115"), "emotional")
    .say("mimi", tr("s4.l116"), "grateful")

    .player(tr("s4.l117"), "impressed")

    .say("mimi", tr("s4.l118"), "smiling")
    .say("mimi", tr("s4.l119"), "amused")

    .n(tr("s4.l120"))

    .say("mimi", tr("s4.l121"), "understanding")
    .say("mimi", tr("s4.l122"), "admiring")

    .n(tr("s4.l123"))

    .think(tr("s4.l124"), "wondering")

    .jump("act2_start")

    // ============================================
    // ACT II: LAYERS EMERGE
    // ============================================

    .scene("act2_scene1", "act2_start")
    .hide('mimi')
    .hide("yamada")
    .show("junko", "center", "tired")

    .n(tr("s4.l125"))

    .say("junko", tr("s4.l126"), "explaining")

    .player(tr("s4.l127"), "understanding")

    .show("junko", "center", "correcting")

    .say("junko", tr("s4.l128"), "repeating")

    .n(tr("s4.l129"))

    .say("junko", tr("s4.l130"), "thoughtful")

    .player(tr("s4.l131"), "curious")

    .say("junko", tr("s4.l132"), "honest")

    .n(tr("s4.l133"))

    .vocab("愚痴", "ぐち", "guchi", tr("s4.v.guchi"), { category: "emotions" })

    .sayJp("junko", "人はここに話しに来る。愚痴を言う。そして、聞いてもらう。", tr("s4.l134"), "hito wa koko ni hanashi ni kuru. guchi o iu. soshite, kiite morau.", "explaining")
    .say("junko", tr("s4.l135"), "wise")

    .jump("harder_questions")

    // SCENE 6: Harder Questions
    .scene("act2_scene2", "harder_questions")
    .show("junko", "center", "neutral")

    .player(tr("s4.l136"), "hesitant")

    .say("junko", tr("s4.l137"), "guarded")

    .player(tr("s4.l138"), "probing")

    .n(tr("s4.l139"))

    .say("junko", tr("s4.l140"), "observing")

    .player(tr("s4.l141"), "self-aware")

    .say("junko", tr("s4.l142"), "accepting")

    .n(tr("s4.l143"))

    .say("junko", tr("s4.l144"), "matter-of-fact")
    .say("junko", tr("s4.l145"), "remembering")

    .player(tr("s4.l146"), "sympathetic")

    .say("junko", tr("s4.l147"), "careful")
    .say("junko", tr("s4.l148"), "unapologetic")

    .n(tr("s4.l149"))

    .say("junko", tr("s4.l150"), "proud")
    .say("junko", tr("s4.l151"), "determined")

    .vocab("開業", "かいぎょう", "kaigyou", tr("s4.v.kaigyou"), { category: "business" })

    .player(tr("s4.l152"), "genuine")

    .say("junko", tr("s4.l153"), "self-deprecating")

    .jump("flashback_opening")

    // SCENE 7: Flashback — Opening Night
    .scene("act2_scene3", "flashback_opening")
    .hideAll()
    .fadeOut()
    .bg("izakaya", "evening")
    .music("nostalgic")
    .fadeIn()

    .n(tr("s4.l154"))

    .n(tr("s4.l155"))
    .n(tr("s4.l156"))

    .show("junko_young", "center", "hopeful")

    .n(tr("s4.l157"))
    .n(tr("s4.l158"))

    .show("saito", "right", "kind")

    .n(tr("s4.l159"))
    .n(tr("s4.l160"))

    .say("saito", tr("s4.l161"), "understanding")

    .say("junko_young", tr("s4.l162"), "honest")

    .say("saito", tr("s4.l163"), "wise")

    .n(tr("s4.l164"))

    .say("saito", tr("s4.l165"), "thoughtful")

    .say("junko_young", tr("s4.l166"), "eager")

    .say("saito", tr("s4.l167"), "meaningful")
    .say("saito", tr("s4.l168"), "observing")
    .say("saito", tr("s4.l169"), "advising")

    .say("junko_young", tr("s4.l170"), "uncertain")

    .say("saito", tr("s4.l171"), "certain")

    .n(tr("s4.l172"))

    .say("saito", tr("s4.l173"), "toasting")

    .hide("saito")
    .hide("junko_young")
    .fadeOut()
    .wait(1000)

    .jump("back_to_present")

    // SCENE 8: Back to Present
    .scene("act2_scene4", "back_to_present")
    .hideAll()
    .fadeIn()
    .bg("izakaya", "night")
    .music("jazz_mellow")
    .show("junko", "center", "nostalgic")

    .n(tr("s4.l174"))

    .say("junko", tr("s4.l175"), "sad")

    .n(tr("s4.l176"))

    .say("junko", tr("s4.l177"), "wistful")
    .say("junko", tr("s4.l178"), "remembering")

    .player(tr("s4.l179"), "gentle")

    .say("junko", tr("s4.l180"), "conflicted")

    .n(tr("s4.l181"))

    .say("junko", tr("s4.l182"), "tense")

    .n(tr("s4.l183"))
    .hide("junko")

    .jump("phone_call")

    // ============================================
    // ACT III: THE WOUND
    // ============================================

    .scene("act3_scene1", "phone_call")
    .show("mimi", "left", "concerned")

    .n(tr("s4.l184"))

    .n(tr("s4.l185"))
    .n(tr("s4.l186"))
    .n(tr("s4.l187"))

    .n(tr("s4.l188"))
    .n(tr("s4.l189"))

    .n(tr("s4.l190"))

    .show("tetsu", "right", "protective")

    .say("tetsu", tr("s4.l191"), "quiet")

    .n(tr("s4.l192"))

    .say("tetsu", tr("s4.l193"), "explaining")

    .player(tr("s4.l194"), "curious")

    .say("tetsu", tr("s4.l195"), "firm")

    .n(tr("s4.l196"))

    .jump("junko_returns")

    // SCENE 9: Junko Returns
    .scene("act3_scene2", "junko_returns")
    .hide("tetsu")
    .show("junko", "center", "composed")

    .say("junko", tr("s4.l197"), "deflecting")

    .player(tr("s4.l198"), "considerate")

    .say("junko", tr("s4.l199"), "clipped")

    .n(tr("s4.l200"))

    .player(tr("s4.l201"), "probing")

    .show("junko", "center", "walls_up")

    .say("junko", tr("s4.l202"), "sharp")

    .player(tr("s4.l203"), "backtracking")

    .say("junko", tr("s4.l204"), "accusatory")

    .n(tr("s4.l205"))

    .show("mimi", "left", "mediating")

    .say("mimi", tr("s4.l206"), "gentle")

    .n(tr("s4.l207"))

    .show("junko", "center", "exhausted")

    .say("junko", tr("s4.l208"), "quiet")
    .say("junko", tr("s4.l209"), "painful")

    .player(tr("s4.l210"), "surprised")

    .say("junko", tr("s4.l211"), "bitter")

    .vocab("娘", "むすめ", "musume", tr("s4.v.musume"), { category: "family" })

    .say("junko", tr("s4.l212"), "blunt")
    .say("junko", tr("s4.l213"), "raw")
    .say("junko", tr("s4.l214"), "mocking")

    .n(tr("s4.l215"))

    .jump("junko_confession")

    // SCENE 10: Junko's Confession
    .scene("act3_scene3", "junko_confession")
    .show("junko", "center", "vulnerable")

    .say("junko", tr("s4.l216"), "matter-of-fact")

    .vocab("育てる", "そだてる", "sodateru", tr("s4.v.sodateru"), { category: "verbs" })
    .vocab("一人で", "ひとりで", "hitori de", tr("s4.v.hitori_de"), { category: "phrases" })

    .say("junko", tr("s4.l217"), "remembering")
    .say("junko", tr("s4.l218"), "struggling")

    .player(tr("s4.l219"), "completing")

    .say("junko", tr("s4.l220"), "broken")

    .n(tr("s4.l221"))

    .say("junko", tr("s4.l222"), "hurt")
    .say("junko", tr("s4.l223"), "defeated")

    .vocab("疎遠", "そえん", "soen", tr("s4.v.soen"), { category: "family" })

    .sayJp("junko", "私たちは疎遠。丁寧に言うなら、そういうこと。", tr("s4.l224"), "watashitachi wa soen. teinei ni iu nara, sou iu koto.", "clinical")

    .player(tr("s4.l225"), "guilty")

    .say("junko", tr("s4.l226"), "resigned")
    .say("junko", tr("s4.l227"), "honest")
    .say("junko", tr("s4.l228"), "tragic")

    .n(tr("s4.l229"))

    .jump("the_question")

    // SCENE 11: The Question
    .scene("act3_scene4", "the_question")
    .show("junko", "center", "waiting")

    .player("Do you regret it?", "direct")

    .vocab("後悔", "こうかい", "koukai", "Regret", { category: "emotions" })

    .sayJp("junko", "後悔？", "Regret?", "koukai?", "considering")

    .n("She looks around the bar. The photos. The bottles. The faces.")

    .say("junko", "I regret the hurt I caused her. Every day.", "sincere")
    .say("junko", "But the choices I made? The life I built?", "conflicted")

    .n("She picks up a photo from behind the bar. An old group shot—younger Junko, laughing, surrounded by people.")

    .say("junko", "These people needed somewhere to go. I gave them that.", "proud")
    .say("junko", "Tetsu-san's wife died and he didn't know how to be alone. He came here.", "remembering")
    .say("junko", "Mimi had nowhere to sleep. I gave her a room.", "matter-of-fact")
    .say("junko", "That man tonight—his wife left him. He needed someone to listen.", "explaining")

    .say("junko", "Was it worth it? I don't know.", "honest")
    .say("junko", "But I couldn't have been anyone else.", "certain")

    .jump("act4_start")

    // ============================================
    // ACT IV: CONNECTION
    // ============================================

    .scene("act4_scene1", "act4_start")
    .show("junko", "center", "observing")

    .n("The recorder has been off for a while. You're not sure when you stopped it.")

    .say("junko", "You're quiet. Usually journalists have more questions.", "curious")

    .player("I...", "hesitant")

    .n("Something is shifting in you. The professional distance crumbling.")

    .think("This wasn't supposed to happen.", "conflicted")

    .player("Can I tell you something? Off the record.", "vulnerable")

    .say("junko", "Of course.", "open")

    .jump("saki_confession")

    // SCENE 12: Saki's Confession
    .scene("act4_scene2", "saki_confession")
    .show("junko", "center", "listening")

    .player("I haven't talked to my mother in six months.", "admitting")

    .say("junko", "...", "waiting")

    .player("She wanted me to be a teacher. Stable. Respectable.", "explaining")
    .player("I quit to be a freelance journalist. She said I was throwing my life away.", "bitter")

    .say("junko", "And you said?", "prompting")

    .player("I said she never supported anything I wanted.", "ashamed")
    .player("We haven't spoken since.", "quiet")

    .n("Junko pours two drinks. Slides one to you.")

    .say("junko", "Mothers and daughters.", "knowing")
    .say("junko", "We hurt each other the most, don't we?", "understanding")

    .player("I came here thinking I knew what this place was.", "confessing")
    .player("Sad old bar. Nostalgia piece. Easy story.", "self-critical")

    .say("junko", "And now?", "curious")

    .player("Now I don't know anything.", "honest")

    .n("Junko laughs. Not mocking—genuine.")

    .say("junko", "That's the first honest thing you've said all night.", "warm")

    .jump("parallel_wounds")

    // SCENE 13: Parallel Wounds
    .scene("act4_scene3", "parallel_wounds")
    .show("junko", "center", "gentle")

    .say("junko", "You know what I see when I look at you?", "thoughtful")

    .player("What?", "wary")

    .say("junko", "Someone running. Just like I was at your age.", "knowing")
    .say("junko", "Running toward something. Running away from something.", "observing")

    .player("Is that bad?", "defensive")

    .say("junko", "No. But eventually you have to stop.", "wise")
    .say("junko", "You have to figure out what you're actually looking for.", "meaningful")

    .n("She refills your glass.")

    .say("junko", "Your mother. Does she know why you quit?", "probing")

    .player("She never asked.", "hurt")

    .say("junko", "Did you ever tell her?", "gentle")

    .n("The question lands like a weight.")

    .player("...No.", "admitting")

    .say("junko", "Mm.", "understanding")

    .n("She doesn't lecture. Doesn't judge. Just lets the silence sit.")

    .say("junko", "I spent twenty years waiting for Emi to understand me.", "confessing")
    .say("junko", "I never stopped to wonder if I understood her.", "regretful")

    .jump("tetsu_haiku")

    // SCENE 14: Tetsu's Haiku
    .scene("act4_scene4", "tetsu_haiku")
    .show("tetsu", "right", "slightly_drunk")

    .n("Tetsu, who has been quietly drinking, suddenly clears his throat.")

    .say("tetsu", "I wrote something. For the bar.", "gruff")

    .say("mimi", "Tetsu-san writes haiku. He's actually really good.", "explaining")

    .say("tetsu", "Shut up. I'm not good.", "embarrassed")

    .say("junko", "Let's hear it.", "encouraging")

    .n("He pulls a crumpled paper from his pocket. Unfolds it carefully.")

    .sayJp("tetsu", "小さな灯... 集まる人の... 心を照らす", "A small light... illuminating the hearts... of those who gather.", "chiisana hi... atsumaru hito no... kokoro o terasu.", "reading")

    .n("A small light... People gather... Hearts illuminated.")

    .n("The bar goes quiet.")

    .show("mimi", "left", "emotional")

    .n("Mimi wipes her eyes. Even you feel something catch in your throat.")

    .say("junko", "Tetsu-san...", "moved")

    .say("tetsu", "It's nothing. Just words.", "deflecting")

    .say("junko", "It's not nothing. It's exactly what this place is.", "grateful")

    .vocab("思い出", "おもいで", "omoide", "Memories", { category: "emotions" })

    .sayJp("tetsu", "二十年分の思い出。全部、ここにある。", "Twenty years of memories. All here.", "nijuu-nen bun no omoide. zenbu, koko ni aru.", "sentimental")
    .say("tetsu", "Whatever happens... that doesn't go away.", "certain")

    .jump("closing_question")

    // SCENE 15: The Closing Question
    .scene("act4_scene5", "closing_question")
    .show("junko", "center", "contemplative")

    .player("Miyamoto-san... are you going to close?", "direct")

    .vocab("閉店", "へいてん", "heiten", "Closing (a business)", { category: "business" })
    .vocab("家賃", "やちん", "yachin", "Rent", { category: "business" })

    .sayJp("junko", "建物は三か月で売れる。その後、家賃は三倍になる。", tr("s4.l239"), "tatemono wa san-kagetsu de ureru. sono ato, yachin wa sanbai ni naru.", "factual")
    .say("junko", tr("s4.l240"), "considering")

    .player(tr("s4.l241"), "curious")

    .say("junko", tr("s4.l242"), "tired")
    .say("junko", tr("s4.l243"), "philosophical")

    .n(tr("s4.l244"))

    .say("junko", tr("s4.l245"), "conflicted")
    .say("junko", tr("s4.l246"), "honest")

    .jump("act5_start")

    // ============================================
    // ACT V: RESOLUTION
    // ============================================

    .scene("act5_scene1", "act5_start")
    .bg("izakaya", "night")
    .n(tr("s4.l247"))
    .n(tr("s4.l248"))

    .n(tr("s4.l249"))
    .n(tr("s4.l250"))
    .n(tr("s4.l251"))

    .vocab("空気を読む", "くうきをよむ", "kuuki wo yomu", tr("s4.v.kuuki_wo_yomu"), { category: "phrases" })

    .n(tr("s4.l252"))
    .n(tr("s4.l253"))

    .jump("last_call")

    // SCENE 16: Last Call
    .scene("act5_scene2", "last_call")
    .show("tetsu", "right", "tired")

    .n(tr("s4.l254"))

    .say("tetsu", tr("s4.l255"), "sighing")

    .say("junko", tr("s4.l256"), "warm")

    .say("tetsu", tr("s4.l257"), "matter-of-fact")

    .n(tr("s4.l258"))

    .say("tetsu", tr("s4.l259"), "loyal")

    .n(tr("s4.l260"))

    .hide("tetsu")
    .show("mimi", "left", "supportive")

    .say("mimi", tr("s4.l261"), "apologetic")

    .say("junko", tr("s4.l262"), "grateful")

    .say("mimi", tr("s4.l263"), "sincere")

    .n(tr("s4.l264"))

    .say("mimi", tr("s4.l265"), "loyal")

    .hide("mimi")

    .jump("alone_with_junko")

    // SCENE 17: Alone
    .scene("act5_scene3", "alone_with_junko")
    .show("junko", "center", "tired")

    .n(tr("s4.l266"))
    .n(tr("s4.l267"))

    .say("junko", tr("s4.l268"), "observing")

    .player(tr("s4.l269"), "honest")

    .say("junko", tr("s4.l270"), "amused")

    .n(tr("s4.l271"))

    .say("junko", tr("s4.l272"), "curious")

    .player(tr("s4.l273"), "truthful")

    .say("junko", tr("s4.l274"), "teasing")

    .player(tr("s4.l275"), "admitting")

    .n(tr("s4.l276"))

    .player(tr("s4.l277"), "confessing")

    .say("junko", tr("s4.l278"), "unbothered")

    .player(tr("s4.l279"), "confused")

    .say("junko", tr("s4.l280"), "certain")

    .player(tr("s4.l281"), "curious")

    .sayJp("junko", "空気を読む。三十年、人を読んできた。", tr("s4.l282"), "kuuki o yomu. sanjuu-nen, hito o yonde kita.", "wise")
    .say("junko", tr("s4.l283"), "knowing")

    .jump("the_decision")

    // SCENE 18: The Decision
    .scene("act5_scene4", "the_decision")
    .show("junko", "center", "contemplative")

    .n(tr("s4.l284"))
    .n(tr("s4.l285"))

    .say("junko", tr("s4.l286"), "remembering")

    .player(tr("s4.l287"), "careful")

    .say("junko", tr("s4.l288"), "sincere")

    .vocab("振り返る", "ふりかえる", "furikaeru", tr("s4.v.furikaeru"), { category: "verbs" })

    .sayJp("junko", "振り返ると、失ったものばかり見える。", tr("s4.l289"), "furikaeru to, ushinatta mono bakari mieru.", "philosophical")
    .say("junko", tr("s4.l290"), "listing")
    .say("junko", tr("s4.l291"), "proud")

    .n(tr("s4.l292"))

    .say("junko", tr("s4.l293"), "certain")
    .say("junko", tr("s4.l294"), "grateful")

    .player(tr("s4.l295"), "gentle")

    .say("junko", tr("s4.l296"), "honest")

    .n(tr("s4.l297"))

    .say("junko", tr("s4.l298"), "observing")
    .say("junko", tr("s4.l299"), "touched")
    .say("junko", tr("s4.l300"), "hopeful")

    .menu()
    .choice(tr("s4.l301"), "choice_fight")
    .choice(tr("s4.l302"), "choice_rest")
    .choice(tr("s4.l303"), "choice_neutral")
    .endMenu()

    // Choice A: Fight
    .scene("choice_a", "choice_fight")
    .show("junko", "center", "considering")

    .player(tr("s4.l304"), "earnest")
    .player(tr("s4.l305"), "thoughtful")

    .say("junko", tr("s4.l306"), "uncertain")

    .player(tr("s4.l307"), "encouraging")
    .player(tr("s4.l308"), "gentle")

    .n(tr("s4.l309"))

    .say("junko", tr("s4.l310"), "surprised")

    .player(tr("s4.l311"), "sincere")

    .say("junko", tr("s4.l312"), "hopeful")

    .jump("dawn")

    // Choice B: Rest
    .scene("choice_b", "choice_rest")
    .show("junko", "center", "considering")

    .player(tr("s4.l313"), "admiring")
    .player(tr("s4.l314"), "gentle")

    .say("junko", tr("s4.l315"), "lost")

    .player(tr("s4.l316"), "thoughtful")
    .player(tr("s4.l317"), "kind")

    .n(tr("s4.l318"))

    .say("junko", tr("s4.l319"), "remembering")

    .player(tr("s4.l320"), "gentle")

    .say("junko", tr("s4.l321"), "peaceful")
    .say("junko", tr("s4.l322"), "accepting")

    .jump("dawn")

    // Choice C: Neutral
    .scene("choice_c", "choice_neutral")
    .show("junko", "center", "considering")

    .player(tr("s4.l323"), "honest")
    .player(tr("s4.l324"), "sincere")

    .say("junko", tr("s4.l325"), "doubtful")

    .player(tr("s4.l326"), "explaining")
    .player(tr("s4.l327"), "certain")

    .n(tr("s4.l328"))

    .say("junko", tr("s4.l329"), "moved")

    .player(tr("s4.l330"), "confused")

    .say("junko", tr("s4.l331"), "grateful")

    .jump("dawn")

    // SCENE 19: Dawn
    .scene("act5_scene5", "dawn")
    .fadeOut()
    .bg("izakaya", "morning")
    .music("hopeful")
    .fadeIn()

    .show("junko", "center", "peaceful")

    .n(tr("s4.l332"))
    .n(tr("s4.l333"))
    .n(tr("s4.l334"))

    .say("junko", tr("s4.l335"), "concerned")

    .player(tr("s4.l336"), "honest")

    .n(tr("s4.l337"))

    .player(tr("s4.l338"), "hesitant")

    .say("junko", tr("s4.l339"), "warm")

    .player(tr("s4.l340"), "grateful")

    .say("junko", tr("s4.l341"), "sincere")

    .n(tr("s4.l342"))

    .say("junko", tr("s4.l343"), "curious")

    .player(tr("s4.l344"), "honest")

    .say("junko", tr("s4.l345"), "wise")

    .player(tr("s4.l346"), "simple")

    .n(tr("s4.l347"))

    .say("junko", tr("s4.l348"), "trusting")
    .hideAll()

    .jump("epilogue")

    // SCENE 20: Epilogue
    .scene("act5_scene6", "epilogue")
    .bg("city", "morning")

    .n(tr("s4.l349"))
    .n(tr("s4.l350"))

    .n(tr("s4.l351"))
    .n(tr("s4.l352"))

    .n(tr("s4.l353"))

    .think(tr("s4.l354"), "reflecting")
    .think(tr("s4.l355"), "changed")

    .n(tr("s4.l356"))
    .n(tr("s4.l357"))

    .n(tr("s4.l358"))

    .fadeOut()
    .wait(2000)

    .n(tr("s4.l359"))

    .fadeIn()

    .jump("debrief1")

    // ============================================
    // DEBRIEF 1: Initial Reactions
    // ============================================
    .scene("debrief1", "classroom_return")
    .hideAll()
    .bg("classroom", "afternoon")
    .music("calm")

    .n(tr("s4.l360"))

    .show("tanaka", "center", "warm")

    .say("tanaka", tr("s4.d01"), "thoughtful")

    .show("mei", "left", "emotional")

    .say("mei", tr("s4.d02"), "surprised")

    .show("ken", "right", "thoughtful")

    .say("ken", tr("s4.d03"), "admitting")
    .say("ken", tr("s4.d04"), "honest")

    .say("tanaka", tr("s4.d05"), "prompting")

    .say("ken", tr("s4.d06"), "reflective")

    .jump("debrief2")

    // ============================================
    // DEBRIEF 2: Judgment Discussion
    // ============================================
    .scene("debrief2", "judgment_discussion")
    .show("tanaka", "center", "teaching")

    .sayJp("tanaka", "この物語は判断の話です。", tr("s4.d08"), "kono monogatari wa handan no hanashi desu.", "explaining")
    .say("tanaka", tr("s4.d09"), "serious")

    .hide("ken")
    .show("yuki", "right", "quiet")

    .say("yuki", tr("s4.d10"), "sharing")

    .n(tr("s4.d11"))

    .say("yuki", tr("s4.d12"), "sharing")
    .say("yuki", tr("s4.d13"), "sad")

    .say("tanaka", tr("s4.d14"), "gentle")

    .show("mei", "left", "guilty")

    .say("mei", tr("s4.d15"), "honest")
    .say("mei", tr("s4.d16"), "admitting")

    .say("tanaka", tr("s4.d17"), "curious")

    .say("mei", tr("s4.d18"), "changed")
    .say("mei", tr("s4.d19"), "respectful")

    .jump("debrief3")

    // ============================================
    // DEBRIEF 3: Language Points
    // ============================================
    .scene("debrief3", "language_points")
    .show("tanaka", "center", "teaching")

    .say("tanaka", tr("s4.d20"), "transitioning")
    .sayJp("tanaka", "空気を読む。", tr("s4.d21"), "kuuki o yomu.", "explaining")

    .show("ken", "right", "interested")

    .say("ken", tr("s4.d22"), "curious")

    .say("tanaka", tr("s4.d23"), "emphatic")
    .say("tanaka", tr("s4.d24"), "explaining")
    .say("tanaka", tr("s4.d25"), "admiring")

    .sayJp("mei", "愚痴はどうですか？", tr("s4.d26"), "guchi wa dou desu ka?", "asking")

    .sayJp("tanaka", "はい。愚痴を聞く。", tr("s4.d28"), "hai. guchi o kiku.", "confirming")
    .say("tanaka", tr("s4.d29"), "thoughtful")
    .say("tanaka", tr("s4.d30"), "impressed")

    .jump("debrief4")

    // ============================================
    // DEBRIEF 4: Personal Reflection
    // ============================================
    .scene("debrief4", "personal_reflection")
    .show("tanaka", "center", "gentle")

    .say("tanaka", tr("s4.d31"), "serious")
    .say("tanaka", tr("s4.d32"), "asking")

    .n(tr("s4.d33"))

    .say("tanaka", tr("s4.d34"), "reassuring")
    .say("tanaka", tr("s4.d35"), "meaningful")

    .show("ken", "right", "uncomfortable")

    .say("ken", tr("s4.d36"), "admitting")
    .say("ken", tr("s4.d37"), "realizing")

    .show("mei", "left", "thoughtful")

    .say("mei", tr("s4.d38"), "honest")
    .say("mei", tr("s4.d39"), "reconsidering")

    .n(tr("s4.d40"))

    .say("tanaka", tr("s4.d41"), "encouraging")
    .say("tanaka", tr("s4.d42"), "meaningful")

    .jump("debrief5")

    // ============================================
    // DEBRIEF 5: Closing
    // ============================================
    .scene("debrief5", "closing")
    .show("tanaka", "center", "warm")

    .say("tanaka", tr("s4.d43"), "pausing")
    .say("tanaka", tr("s4.d44"), "remembering")

    .say("mei", tr("s4.d45"), "noting")

    .say("tanaka", tr("s4.d46"), "explaining")
    .say("tanaka", tr("s4.d47"), "wise")
    .say("tanaka", tr("s4.d48"), "hopeful")

    .n(tr("s4.ac01"))

    .say("tanaka", tr("s4.ac02"), "concluding")

    .hide("tanaka")
    .hide("ken")
    .hide("mei")
    .hide("yuki")

    .jump("after_class")

    // ============================================
    // DEBRIEF 6: After Class
    // ============================================
    .scene("debrief6", "after_class")
    .hideAll()
    .bg("hallway", "afternoon")

    .show("ken", "center", "hesitant")

    .n(tr("s4.ac03"))

    .say("ken", tr("s4.ac04"), "earnest")

    .player(tr("s4.ac05"), "agreeing")

    .say("ken", tr("s4.ac06"), "deciding")
    .say("ken", tr("s4.ac07"), "nervous")

    .player(tr("s4.ac05"), "honest")

    .say("ken", tr("s4.ac08"), "reflecting")
    .say("ken", tr("s4.ac09"), "determined")

    .player(tr("s4.ac06"), "supportive")

    .say("ken", tr("s4.ac07"), "laughing")

    .n(tr("s4.ac10"))

    .hideAll()

    .n(tr("s4.ac08"))
    .n(tr("s4.ac09"))

    .n(tr("s4.ac10"))

    .fadeOut()
    .n(tr("s4.l359"))
    .build();
