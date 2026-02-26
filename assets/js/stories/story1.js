import { dialogue } from './DialogueBuilder.js';
import { STORY_1_VOCABULARY } from '../systems/KotobaLog.js';
import { tr } from '../systems/I18n.js';

export const getStory1 = () => dialogue()
    .story(1, tr("s1.title"), tr("s1.subtitle"))
    .description(tr("s1.desc"))
    .estimatedTime("45-60 minutes")
    .jlptFocus("N5-N4")
    .vocabularyList(STORY_1_VOCABULARY)

    // ============================================
    // PROLOGUE: Morning Anxiety
    // ============================================
    .scene("prologue", "opening")
    .titleCard(tr("s1.card_title"), tr("s1.card_subtitle"))
    .music("calm")
    .bg("bedroom", "morning")
    .n(tr("s1.s0.alarm"))
    .n(tr("s1.s0.today_dread"))

    // Set up the protagonist (Rin - we're playing as them)
    .think(tr("s1.s0.think_meet"), "neutral")

    .vocab("今日", "きょう", "kyou", "Today", { category: "time" })

    .n(tr("s1.s0.check_phone"))
    .n(tr("s1.s0.message_from_sora"))

    .vocab("言語交換", "げんごこうかん", "gengo koukan", "Language exchange", { category: "daily-life" })

    // Show Ken as "Sora" (we'll use his asset)
    .say("sora", tr("s1.s0.sora_msg"), "happy")

    .think(tr("s1.s0.think_history"), "thinking")
    .think(tr("s1.s0.think_face_to_face"), "neutral")

    .vocab("ドキドキ", null, "dokidoki", "Heart pounding (onomatopoeia)", { category: "emotions" })

    .n(tr("s1.s0.heart_pounding"))

    .think(tr("s1.s0.think_different"), "worried")
    .think(tr("s1.s0.think_screen"), "worried")

    .player(tr("s1.s0.get_ready"), "neutral")

    .jump("getting_ready")

    // ============================================
    // SCENE 1: Getting Ready
    // ============================================
    .scene("scene1", "getting_ready")
    .bg("bathroom", "morning")
    .n(tr("s1.s1.splash"))
    .n(tr("s1.s1.mirror"))

    .player(tr("s1.s1.practice_fail"), "embarrassed")

    .vocab("初めまして", "はじめまして", "hajimemashite", "Nice to meet you (first meeting)", { category: "greetings" })

    .player(tr("s1.s1.practice_retry"), "thinking")

    .vocab("久しぶり", "ひさしぶり", "hisashiburi", "Long time no see", { category: "greetings" })

    .n(tr("s1.s1.confusion"))

    .think(tr("s1.s1.think_advice"), "neutral")
    .think(tr("s1.s1.think_hope"), "worried")

    .jump("train_ride")

    // ============================================
    // SCENE 2: The Train Ride
    // ============================================
    .scene("scene2", "train_ride")
    .bg("train", "morning")
    .n(tr("s1.s2.train_sway"))
    .n(tr("s1.s2.scroll"))

    .n(tr("s1.s2.stranger"))
    .n(tr("s1.s2.now"))

    .think(tr("s1.s2.think_help"), "neutral")
    .think(tr("s1.s2.think_give_up"), "neutral")

    .n(tr("s1.s2.remember_cry"))

    .say("sora", tr("s1.s2.sora_comfort"), "concerned")

    .think(tr("s1.s2.think_no_judgment"), "neutral")
    .think(tr("s1.s2.think_belief"), "neutral")

    .vocab("緊張", "きんちょう", "kinchou", "Nervousness/tension", { category: "emotions" })

    .n(tr("s1.s2.nervous_overwhelming"))

    .think(tr("s1.s2.think_reality"), "worried")

    .n(tr("s1.s2.announcement"))
    .n(tr("s1.s2.train_voice"))

    .vocab("駅", "えき", "eki", "Station", { category: "places" })

    .think(tr("s1.s2.think_stop"), "neutral")

    .jump("at_the_station")

    // ============================================
    // SCENE 3: At the Station
    // ============================================
    .scene("scene3", "at_the_station")
    .bg("station", "morning")
    .n(tr("s1.s3.crowded"))
    .n(tr("s1.s3.scan"))

    .vocab("改札", "かいさつ", "kaisatsu", "Ticket gate", { category: "places" })

    .think(tr("s1.s3.think_blue"), "neutral")

    .n(tr("s1.s3.phone_buzz"))

    .say("sora", tr("s1.s3.sora_here"), "happy")

    .think(tr("s1.s3.think_close"), "nervous")

    .n(tr("s1.s3.look_frantic"))
    .n(tr("s1.s3.and_then"))

    .show("ken", "center", "happy")

    .n(tr("s1.s3.see_him"))
    .n(tr("s1.s3.really_him"))

    .say("sora", tr("s1.s3.sora_wave"), "happy")

    .n(tr("s1.s3.freeze"))
    .n(tr("s1.s3.person_real"))
    .n(tr("s1.s3.tangible"))

    .menu()
    .choice(tr("s1.s3.choice.run"), "excited_meeting")
    .choice(tr("s1.s3.choice.walk"), "nervous_meeting")
    .endMenu()

    // ============================================
    // SCENE 4A: Excited Meeting
    // ============================================
    .scene("scene4a", "excited_meeting")
    .show("ken", "center", "surprised")
    .n(tr("s1.s4a.run"))

    .player(tr("s1.s4a.call"), "happy")

    .say("sora", tr("s1.s4a.sora_meet"), "happy")

    .vocab("やっと会えた", "やっとあえた", "yatto aeta", "Finally we meet", { category: "greetings" })

    .n(tr("s1.s4a.hug"))
    .n(tr("s1.s4a.awkward"))

    .say("sora", tr("s1.s4a.sora_glad"), "happy")

    .player(tr("s1.s4a.player_disbelief"), "happy")

    .befriend("ken", tr("s1.bond.ken_meeting"))
    .jump("first_conversation")

    // ============================================
    // SCENE 4B: Nervous Meeting
    // ============================================
    .scene("scene4b", "nervous_meeting")
    .show("ken", "center", "neutral")
    .n(tr("s1.s4b.walk"))
    .n(tr("s1.s4b.bow"))

    .player(tr("s1.s4b.stutter"), "embarrassed")

    .say("sora", tr("s1.s4b.sora_nervous"), "happy")

    .n(tr("s1.s4b.admission"))

    .vocab("緊張してる", "きんちょうしてる", "kinchou shiteru", "Being nervous", { category: "emotions" })

    .player(tr("s1.s4b.player_surprised"), "surprised")

    .say("sora", tr("s1.s4b.sora_course"), "neutral")

    .n(tr("s1.s4b.scratch"))

    .say("sora", tr("s1.s4b.sora_happy"), "happy")

    .vocab("嬉しい", "うれしい", "ureshii", "Happy/glad", { category: "emotions" })

    .befriend("ken", tr("s1.bond.ken_vulnerability"))
    .jump("first_conversation")

    // ============================================
    // SCENE 5: First Real Conversation
    // ============================================
    .scene("scene5", "first_conversation")
    .show("ken", "center", "happy")
    .n(tr("s1.s5.stand"))

    .say("sora", tr("s1.s5.sora_diff"), "neutral")

    .player(tr("s1.s5.player_taller"), "neutral")

    .say("sora", tr("s1.s5.sora_really"), "surprised")

    .vocab("本当に", "ほんとうに", "hontou ni", "Really/truly", { category: "phrases" })

    .n(tr("s1.s5.silence"))
    .n(tr("s1.s5.online_time"))
    .n(tr("s1.s5.real_time"))

    .say("sora", tr("s1.s5.sora_cafe"), "happy")

    .vocab("カフェ", null, "kafe", "Café", { category: "places" })

    .player(tr("s1.s5.player_lead"), "happy")

    .jump("walking_together")

    // ============================================
    // SCENE 6: Walking Together
    // ============================================
    .scene("scene6", "walking_together")
    .bg("street", "morning")
    .show("ken", "left", "neutral")
    .n(tr("s1.s6.walk"))
    .n(tr("s1.s6.surreal"))

    .say("sora", tr("s1.s6.sora_time"), "neutral")

    .player(tr("s1.s6.player_3mo"), "neutral")

    .say("sora", tr("s1.s6.sora_praise"), "happy")

    .n(tr("s1.s6.glow"))

    .player(tr("s1.s6.player_hontou"), "embarrassed")

    .say("sora", tr("s1.s6.sora_english"), "happy")

    .n(tr("s1.s6.dissolve"))

    .think(tr("s1.s6.think_natural"), "happy")

    .jump("at_the_cafe")

    // ============================================
    // SCENE 7: At the Café
    // ============================================
    .scene("scene7", "at_the_cafe")
    .bg("cafe", "morning")
    .music("cafe")
    .show("ken", "left", "neutral")
    .n(tr("s1.s7.cafe_desc"))
    .n(tr("s1.s7.lead_table"))

    .say("sora", tr("s1.s7.sora_fave"), "happy")

    .n(tr("s1.s7.server"))

    .say("server", tr("s1.s7.server_ask"), "neutral")

    .vocab("注文", "ちゅうもん", "chuumon", "Order", { category: "daily-life" })

    .say("sora", tr("s1.s7.sora_order"), "neutral")

    .vocab("抹茶ラテ", "まっちゃラテ", "matcha rate", "Matcha latte", { category: "food" })

    .menu()
    .choice(tr("s1.s7.choice.jp"), "order_japanese")
    .choice(tr("s1.s7.choice.en"), "order_english")
    .endMenu()

    // ============================================
    // SCENE 8A: Ordering in Japanese
    // ============================================
    .scene("scene8a", "order_japanese")
    .show("ken", "left", "neutral")

    .player(tr("s1.s8a.player_order"), "nervous")

    .vocab("コーヒー", null, "koohii", "Coffee", { category: "food" })
    .vocab("お願いします", "おねがいします", "onegaishimasu", "Please (request)", { category: "phrases" })

    .say("server", tr("s1.s8a.server_confirm"), "neutral")

    .n(tr("s1.s8a.walk_away"))

    .say("sora", tr("s1.s8a.sora_perfect"), "happy")

    .player(tr("s1.s8a.player_shaking"), "embarrassed")

    .say("sora", tr("s1.s8a.sora_fine"), "happy")

    .think(tr("s1.s8a.think_encourage"), "happy")

    .jump("cafe_conversation")

    // ============================================
    // SCENE 8B: Ordering in English
    // ============================================
    .scene("scene8b", "order_english")
    .show("ken", "left", "neutral")

    .player(tr("s1.s8b.player_order"), "neutral")

    .n(tr("s1.s8b.server_nod"))

    .say("sora", tr("s1.s8b.sora_challenge"), "happy")

    .player(tr("s1.s8b.player_sorry"), "embarrassed")

    .say("sora", tr("s1.s8b.sora_comfort"), "neutral")

    .think(tr("s1.s8b.think_easy"), "neutral")

    .jump("cafe_conversation")

    // ============================================
    // SCENE 9: Café Conversation - Opening Up
    // ============================================
    .scene("scene9", "cafe_conversation")
    .show("ken", "left", "neutral")
    .n(tr("s1.s9.arrive"))

    .vocab("いただきます", null, "itadakimasu", "Phrase before eating/drinking", { category: "phrases" })

    .say("sora", tr("s1.s9.sora_itadakimasu"), "happy")

    .player(tr("s1.s9.player_itadakimasu"), "neutral")

    .n(tr("s1.s9.sip"))
    .n(tr("s1.s9.silence"))

    .say("sora", tr("s1.s9.sora_actually"), "neutral")

    .vocab("実は", "じつは", "jitsu wa", "Actually / To tell the truth", { category: "phrases" })

    .say("sora", tr("s1.s9.sora_confess"), "neutral")

    .player(tr("s1.s9.player_confused"), "surprised")

    .say("sora", tr("s1.s9.sora_online"), "neutral")

    .say("sora", tr("s1.s9.sora_real"), "concerned")

    .n(tr("s1.s9.resonate"))

    .player(tr("s1.s9.player_same"), "neutral")

    .player(tr("s1.s9.player_worry"), "worried")

    .jump("heart_to_heart")

    // ============================================
    // SCENE 10: Heart to Heart
    // ============================================
    .scene("scene10", "heart_to_heart")
    .show("ken", "left", "concerned")
    .n(tr("s1.s10.look_down"))

    .say("sora", tr("s1.s10.sora_friend"), "serious")

    .vocab("友達", "ともだち", "tomodachi", "Friend", { category: "daily-life" })

    .say("sora", tr("s1.s10.sora_change"), "neutral")

    .n(tr("s1.s10.loosen"))

    .player(tr("s1.s10.player_name"), "neutral")

    .say("sora", tr("s1.s10.sora_important"), "happy")

    .think(tr("s1.s10.unnecessary"), "neutral")

    .player(tr("s1.s10.player_feel"), "happy")
    .player(tr("s1.s10.player_important"), "happy")

    .say("sora", tr("s1.s10.sora_glad_jp"), "happy")

    .vocab("安心", "あんしん", "anshin", "Relief/peace of mind", { category: "emotions" })

    .n(tr("s1.s10.wash"))

    .bond("ken", tr("s1.bond.ken_heart_to_heart"))

    .jump("afternoon_walk")

    // ============================================
    // SCENE 11: Afternoon Together
    // ============================================
    .scene("scene11", "afternoon_walk")
    .bg("park", "afternoon")
    .show("ken", "left", "happy")
    .n(tr("s1.s11.park"))
    .n(tr("s1.s11.sun"))

    .say("sora", tr("s1.s11.sora_think"), "neutral")

    .n(tr("s1.s11.bench"))

    .player(tr("s1.s11.player_thank"), "happy")

    .say("sora", tr("s1.s11.sora_thank"), "happy")

    .n(tr("s1.s11.serious"))

    .say("sora", tr("s1.s11.sora_honest"), "neutral")

    .say("sora", tr("s1.s11.sora_pressure"), "concerned")

    .player(tr("s1.s11.player_pressure"), "surprised")

    .say("sora", tr("s1.s11.sora_whatif"), "concerned")

    .jump("shared_fears")

    // ============================================
    // SCENE 12: Shared Fears
    // ============================================
    .scene("scene12", "shared_fears")
    .show("ken", "left", "neutral")

    .player(tr("s1.s12.player_thought"), "neutral")

    .player(tr("s1.s12.player_worry1"), "worried")
    .player(tr("s1.s12.player_worry2"), "worried")

    .say("sora", tr("s1.s12.sora_surprised"), "surprised")

    .vocab("やっぱり", null, "yappari", "As expected / After all", { category: "phrases" })

    .n(tr("s1.s12.laugh"))

    .say("sora", tr("s1.s12.sora_realize"), "happy")

    .say("sora", tr("s1.s12.sora_conclusion"), "happy")

    .player(tr("s1.s12.player_touch"), "happy")

    .n(tr("s1.s12.sunset"))

    .think(tr("s1.s12.think_connection"), "happy")
    .think(tr("s1.s12.think_real"), "happy")
    .think(tr("s1.s12.think_more"), "happy")

    .jump("evening_farewell")

    // ============================================
    // SCENE 13: Evening Farewell
    // ============================================
    .scene("scene13", "evening_farewell")
    .bg("station", "evening")
    .show("ken", "left", "neutral")
    .n(tr("s1.s13.sky"))

    .say("sora", tr("s1.s13.sora_fun"), "happy")

    .player(tr("s1.s13.player_met"), "happy")

    .say("sora", tr("s1.s13.sora_next"), "happy")

    .player(tr("s1.s13.player_def"), "happy")

    .n(tr("s1.s13.gate"))

    .say("sora", tr("s1.s13.sora_bye"), "happy")

    .n(tr("s1.s13.wave"))
    .n(tr("s1.s13.smile_vid"))
    .n(tr("s1.s13.smile_new"))

    .player(tr("s1.s13.player_bye"), "happy")

    .hide("ken")
    .n(tr("s1.s13.home"))

    .think(tr("s1.s13.think_worried"), "neutral")
    .think(tr("s1.s13.think_same"), "happy")
    .think(tr("s1.s13.think_medium"), "happy")

    .jump("epilogue")

    // ============================================
    // EPILOGUE: Night Reflection
    // ============================================
    .scene("epilogue", "epilogue")
    .bg("bedroom", "night")
    .n(tr("s1.epilogue.night"))
    .n(tr("s1.epilogue.msg"))

    .say("sora", tr("s1.epilogue.sora_msg"), "happy")

    .n(tr("s1.epilogue.smile"))

    .player(tr("s1.epilogue.player_reply"), "happy")

    .n(tr("s1.epilogue.ceiling"))

    .think(tr("s1.epilogue.scared"), "neutral")
    .think(tr("s1.epilogue.not_first"), "neutral")
    .think(tr("s1.epilogue.reunion"), "happy")

    .n(tr("s1.epilogue.barrier"))
    .n(tr("s1.epilogue.connect"))
    .n(tr("s1.epilogue.real"))

    .n(tr("s1.epilogue.more_so"))

    .effect("fade-out")
    .wait(1500)

    .jump("classroom_debrief")

    // ============================================
    // CLASSROOM DEBRIEF: Back to Frame Narrative
    // ============================================
    .scene("debrief1", "classroom_debrief")
    .bg("classroom", "afternoon")
    .music("classroom")
    .effect("fade-in")
    .hideAll()
    .n(tr("s1.debrief1.fade"))
    .n(tr("s1.debrief1.back"))

    .show("tanaka", "center", "happy")
    .tanaka(tr("s1.debrief1.tanaka_ask"), "happy")

    .n(tr("s1.debrief1.tanaka_look"))

    .show("ken", "left", "neutral")
    .show("yuki", "right", "neutral")

    .ken(tr("s1.debrief1.ken_relate"), "neutral")
    .ken(tr("s1.debrief1.ken_terrifying"), "concerned")

    .yuki(tr("s1.debrief1.yuki_beautiful"), "neutral")
    .yuki(tr("s1.debrief1.yuki_same"), "neutral")

    .tanaka(tr("s1.debrief1.tanaka_why"), "neutral")

    .ken(tr("s1.debrief1.ken_edit"), "thinking")
    .ken(tr("s1.debrief1.ken_just_you"), "neutral")

    .vocab("自分", "じぶん", "jibun", "Oneself / yourself", { category: "daily-life" })

    .tanaka(tr("s1.debrief1.tanaka_jibun"), "neutral")

    .jump("debrief_discussion")

    // ============================================
    // DEBRIEF: Class Discussion
    // ============================================
    .scene("debrief2", "debrief_discussion")
    .show("tanaka", "center", "neutral")
    .show("ken", "left", "neutral")
    .show("yuki", "right", "neutral")

    .tanaka(tr("s1.debrief2.tanaka_talk"), "happy")

    .tanaka(tr("s1.debrief2.tanaka_dokidoki"), "neutral")

    .yuki(tr("s1.debrief2.yuki_ono"), "thinking")

    .tanaka(tr("s1.debrief2.tanaka_subarashii"), "happy")
    .tanaka(tr("s1.debrief2.tanaka_use"), "happy")

    .ken(tr("s1.debrief2.ken_class"), "happy")

    .tanaka(tr("s1.debrief2.tanaka_laugh"), "laugh")

    .n(tr("s1.debrief2.class_laugh"))

    .jump("debrief_cultural")

    // ============================================
    // DEBRIEF: Cultural Point
    // ============================================
    .scene("debrief3", "debrief_cultural")
    .show("tanaka", "center", "neutral")
    .show("ken", "left", "neutral")
    .show("yuki", "right", "neutral")

    .tanaka(tr("s1.debrief3.tanaka_culture"), "neutral")
    .tanaka(tr("s1.debrief3.tanaka_diff"), "neutral")

    .ken(tr("s1.debrief3.ken_confused"), "surprised")

    .tanaka(tr("s1.debrief3.tanaka_exactly"), "neutral")
    .tanaka(tr("s1.debrief3.tanaka_history"), "neutral")

    .tanaka(tr("s1.debrief3.tanaka_first"), "neutral")
    .tanaka(tr("s1.debrief3.tanaka_two_years"), "neutral")

    .yuki(tr("s1.debrief3.yuki_puzzle"), "thinking")

    .tanaka(tr("s1.debrief3.tanaka_question"), "happy")
    .tanaka(tr("s1.debrief3.tanaka_reflect"), "neutral")

    .vocab("出会い", "であい", "deai", "Encounter/meeting", { category: "daily-life" })

    .tanaka(tr("s1.debrief3.tanaka_deai"), "neutral")
    .tanaka(tr("s1.debrief3.tanaka_deai_exp"), "happy")

    .jump("debrief_personal")

    // ============================================
    // DEBRIEF: Personal Connection
    // ============================================
    .scene("debrief4", "debrief_personal")
    .show("tanaka", "center", "neutral")
    .show("ken", "left", "neutral")
    .show("yuki", "right", "neutral")

    .tanaka(tr("s1.debrief4.tanaka_exp"), "neutral")
    .tanaka(tr("s1.debrief4.tanaka_online"), "neutral")

    .n(tr("s1.debrief4.silence"))

    .yuki(tr("s1.debrief4.yuki_have"), "embarrassed")

    .n(tr("s1.debrief4.surprise"))

    .yuki(tr("s1.debrief4.yuki_story"), "neutral")
    .yuki(tr("s1.debrief4.yuki_scary"), "worried")

    .tanaka(tr("s1.debrief4.tanaka_go"), "concerned")

    .yuki(tr("s1.debrief4.yuki_same"), "neutral")
    .yuki(tr("s1.debrief4.yuki_real"), "happy")

    .tanaka(tr("s1.debrief4.tanaka_beautiful"), "happy")

    .bond("yuki", tr("s1.bond.yuki_experience"))

    .ken(tr("s1.debrief4.ken_deep"), "happy")

    .yuki(tr("s1.debrief4.yuki_ken"), "embarrassed")

    .n(tr("s1.debrief4.laughter"))

    .jump("debrief_closing")

    // ============================================
    // DEBRIEF: Closing
    // ============================================
    .scene("debrief5", "debrief_closing")
    .show("tanaka", "center", "happy")
    .show("ken", "left", "neutral")
    .show("yuki", "right", "neutral")

    .tanaka(tr("s1.debrief5.tanaka_practice"), "happy")

    .tanaka(tr("s1.debrief5.tanaka_repeat"), "neutral")

    .n(tr("s1.debrief5.class_repeat"))

    .ken(tr("s1.debrief5.ken_repeat"), "happy")
    .yuki(tr("s1.debrief5.yuki_repeat"), "neutral")
    .player(tr("s1.debrief5.player_repeat"), "happy")

    .tanaka(tr("s1.debrief5.tanaka_meaning"), "happy")
    .tanaka(tr("s1.debrief5.tanaka_relief"), "neutral")

    .tanaka(tr("s1.debrief5.tanaka_aeta"), "neutral")

    .tanaka(tr("s1.debrief5.tanaka_together"), "happy")

    .n(tr("s1.debrief5.clap"))

    .tanaka(tr("s1.debrief5.great_work"), "happy")

    .tanaka(tr("s1.debrief5.next_story"), "happy")

    .hide("tanaka")
    .hide("ken")
    .hide("yuki")

    .n(tr("s1.debrief5.packing"))
    .n(tr("s1.debrief5.warm"))
    .n(tr("s1.debrief5.learning"))
    .n(tr("s1.debrief5.deeper"))

    .think(tr("s1.debrief5.bridge"), "neutral")
    .think(tr("s1.debrief5.connection"), "happy")

    .n(tr("s1.debrief5.complete"))

    .hideAll()

    .end()

    .build();

export default getStory1;
