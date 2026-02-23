/**
 * TSUZUKI CONNECT - Kotoba Log System
 * Manages vocabulary tracking, mastery levels, and word collections
 */

export class KotobaLog {
    constructor(game) {
        this.game = game;
        
        // Vocabulary storage
        this.words = new Map();
        
        // Categories
        this.categories = {
            'greetings': '挨拶 (Aisatsu)',
            'family': '家族 (Kazoku)',
            'food': '食べ物 (Tabemono)',
            'places': '場所 (Basho)',
            'time': '時間 (Jikan)',
            'verbs': '動詞 (Doushi)',
            'adjectives': '形容詞 (Keiyoushi)',
            'particles': '助詞 (Joshi)',
            'classroom': '教室 (Kyoushitsu)',
            'daily-life': '日常生活 (Nichijou Seikatsu)',
            'emotions': '感情 (Kanjou)',
            'numbers': '数字 (Suuji)',
            'weather': '天気 (Tenki)',
            'body': '体 (Karada)',
            'colors': '色 (Iro)'
        };
        
        // Mastery levels
        this.masteryLevels = {
            1: { name: 'New', color: '#94B49F', threshold: 0 },
            2: { name: 'Learning', color: '#E8A87C', threshold: 3 },
            3: { name: 'Familiar', color: '#8B7355', threshold: 7 },
            4: { name: 'Mastered', color: '#FFD700', threshold: 12 }
        };
    }
    
    /**
     * Add a word to the Kotoba Log
     */
    addWord(wordData) {
        const word = {
            id: wordData.id || this.generateId(wordData.japanese),
            japanese: wordData.japanese,
            reading: wordData.reading || null,
            romaji: wordData.romaji || null,
            english: wordData.english,
            category: wordData.category || 'daily-life',
            jlptLevel: wordData.jlptLevel || 'N5',
            example: wordData.example || null,
            exampleTranslation: wordData.exampleTranslation || null,
            notes: wordData.notes || null,
            storyId: wordData.storyId || null,
            
            // Learning tracking
            encounters: 0,
            correctAnswers: 0,
            lastSeen: null,
            firstSeen: Date.now(),
            mastery: 1
        };
        
        if (!this.words.has(word.id)) {
            this.words.set(word.id, word);
            this.save();
            return word;
        }
        
        return this.words.get(word.id);
    }
    
    /**
     * Generate unique ID from Japanese text
     */
    generateId(japanese) {
        return 'word_' + japanese.replace(/[^ぁ-んァ-ン一-龯]/g, '') + '_' + Date.now();
    }
    
    /**
     * Record an encounter with a word
     */
    encounter(wordId) {
        const word = this.words.get(wordId);
        if (word) {
            word.encounters++;
            word.lastSeen = Date.now();
            this.updateMastery(word);
            this.save();
        }
    }
    
    /**
     * Record a correct answer in practice
     */
    recordCorrect(wordId) {
        const word = this.words.get(wordId);
        if (word) {
            word.correctAnswers++;
            word.encounters++;
            word.lastSeen = Date.now();
            this.updateMastery(word);
            this.save();
        }
    }
    
    /**
     * Record an incorrect answer in practice
     */
    recordIncorrect(wordId) {
        const word = this.words.get(wordId);
        if (word) {
            word.encounters++;
            word.lastSeen = Date.now();
            // Reduce mastery slightly on incorrect
            if (word.correctAnswers > 0) {
                word.correctAnswers = Math.max(0, word.correctAnswers - 1);
            }
            this.updateMastery(word);
            this.save();
        }
    }
    
    /**
     * Update word mastery level
     */
    updateMastery(word) {
        let newMastery = 1;
        
        for (const [level, data] of Object.entries(this.masteryLevels).reverse()) {
            if (word.correctAnswers >= data.threshold) {
                newMastery = parseInt(level);
                break;
            }
        }
        
        word.mastery = newMastery;
    }
    
    /**
     * Get a word by ID
     */
    getWord(wordId) {
        return this.words.get(wordId);
    }
    
    /**
     * Get all words
     */
    getAllWords() {
        return Array.from(this.words.values());
    }
    
    /**
     * Get words by category
     */
    getWordsByCategory(category) {
        return this.getAllWords().filter(w => w.category === category);
    }
    
    /**
     * Get words by JLPT level
     */
    getWordsByJLPT(level) {
        return this.getAllWords().filter(w => w.jlptLevel === level);
    }
    
    /**
     * Get words by mastery level
     */
    getWordsByMastery(mastery) {
        return this.getAllWords().filter(w => w.mastery === mastery);
    }
    
    /**
     * Get words from a specific story
     */
    getWordsByStory(storyId) {
        return this.getAllWords().filter(w => w.storyId === storyId);
    }
    
    /**
     * Get words for practice (prioritize low mastery and not recently seen)
     */
    getWordsForPractice(count = 10) {
        const words = this.getAllWords();
        
        // Sort by mastery (ascending) and lastSeen (oldest first)
        words.sort((a, b) => {
            if (a.mastery !== b.mastery) {
                return a.mastery - b.mastery;
            }
            return (a.lastSeen || 0) - (b.lastSeen || 0);
        });
        
        return words.slice(0, count);
    }
    
    /**
     * Get statistics
     */
    getStats() {
        const words = this.getAllWords();
        
        const stats = {
            totalWords: words.length,
            byMastery: {
                1: 0, 2: 0, 3: 0, 4: 0
            },
            byCategory: {},
            byJLPT: { N5: 0, N4: 0, N3: 0, N2: 0, N1: 0 },
            totalEncounters: 0,
            totalCorrect: 0,
            averageMastery: 0
        };
        
        words.forEach(word => {
            stats.byMastery[word.mastery]++;
            stats.byCategory[word.category] = (stats.byCategory[word.category] || 0) + 1;
            stats.byJLPT[word.jlptLevel]++;
            stats.totalEncounters += word.encounters;
            stats.totalCorrect += word.correctAnswers;
        });
        
        if (words.length > 0) {
            stats.averageMastery = words.reduce((sum, w) => sum + w.mastery, 0) / words.length;
        }
        
        return stats;
    }
    
    /**
     * Search words
     */
    search(query) {
        const q = query.toLowerCase();
        return this.getAllWords().filter(word => 
            word.japanese.includes(query) ||
            (word.reading && word.reading.includes(query)) ||
            (word.romaji && word.romaji.toLowerCase().includes(q)) ||
            word.english.toLowerCase().includes(q)
        );
    }
    
    /**
     * Save to localStorage
     */
    save() {
        const data = {
            words: Array.from(this.words.entries())
        };
        localStorage.setItem('tsuzuki_kotoba', JSON.stringify(data));
    }
    
    /**
     * Load from localStorage
     */
    load() {
        const saved = localStorage.getItem('tsuzuki_kotoba');
        if (saved) {
            try {
                const data = JSON.parse(saved);
                this.words = new Map(data.words);
                console.log(`Loaded ${this.words.size} words from Kotoba Log`);
            } catch (e) {
                console.error('Failed to load Kotoba Log:', e);
            }
        }
    }
    
    /**
     * Clear all words
     */
    clear() {
        this.words.clear();
        this.save();
    }
    
    /**
     * Export to JSON
     */
    export() {
        return JSON.stringify({
            words: Array.from(this.words.entries()),
            exportDate: new Date().toISOString()
        }, null, 2);
    }
    
    /**
     * Import from JSON
     */
    import(jsonString) {
        try {
            const data = JSON.parse(jsonString);
            this.words = new Map(data.words);
            this.save();
            return true;
        } catch (e) {
            console.error('Failed to import Kotoba Log:', e);
            return false;
        }
    }
    
    /**
     * Render word entry for UI
     */
    renderWordEntry(word) {
        const mastery = this.masteryLevels[word.mastery];
        
        return `
            <div class="kotoba-entry" data-word-id="${word.id}" data-mastery="${word.mastery}">
                <div class="kotoba-word">
                    <span class="kotoba-japanese">${word.japanese}</span>
                    ${word.reading ? `<span class="kotoba-reading">(${word.reading})</span>` : ''}
                </div>
                <div class="kotoba-meaning">${word.english}</div>
                <div class="kotoba-meta">
                    <span class="kotoba-category">${this.categories[word.category] || word.category}</span>
                    <span class="kotoba-jlpt">${word.jlptLevel}</span>
                    <span class="kotoba-mastery" style="background: ${mastery.color}">${mastery.name}</span>
                </div>
                ${word.example ? `
                    <div class="kotoba-example">
                        <div class="example-jp">${word.example}</div>
                        <div class="example-en">${word.exampleTranslation}</div>
                    </div>
                ` : ''}
            </div>
        `;
    }
    
    /**
     * Render full Kotoba Log UI
     */
    renderKotobaLogUI() {
        const words = this.getAllWords();
        const stats = this.getStats();
        
        // Sort by category, then by Japanese
        words.sort((a, b) => {
            if (a.category !== b.category) {
                return a.category.localeCompare(b.category);
            }
            return a.japanese.localeCompare(b.japanese);
        });
        
        // Group by category
        const grouped = {};
        words.forEach(word => {
            if (!grouped[word.category]) {
                grouped[word.category] = [];
            }
            grouped[word.category].push(word);
        });
        
        let html = `
            <div class="kotoba-stats">
                <div class="stat">
                    <span class="stat-value">${stats.totalWords}</span>
                    <span class="stat-label">Words Learned</span>
                </div>
                <div class="stat">
                    <span class="stat-value">${stats.byMastery[4]}</span>
                    <span class="stat-label">Mastered</span>
                </div>
                <div class="stat">
                    <span class="stat-value">${Math.round(stats.averageMastery * 10) / 10}</span>
                    <span class="stat-label">Avg. Mastery</span>
                </div>
            </div>
        `;
        
        if (words.length === 0) {
            html += `
                <div class="kotoba-empty">
                    <p>No words yet! Play stories to collect vocabulary.</p>
                    <p>言葉を集めましょう！</p>
                </div>
            `;
        } else {
            for (const [category, categoryWords] of Object.entries(grouped)) {
                html += `
                    <div class="kotoba-category-section">
                        <h3 class="kotoba-category-header">${this.categories[category] || category}</h3>
                        <div class="kotoba-words">
                            ${categoryWords.map(w => this.renderWordEntry(w)).join('')}
                        </div>
                    </div>
                `;
            }
        }
        
        return html;
    }
}

// Default vocabulary for Story 0
export const STORY_0_VOCABULARY = [
    {
        japanese: 'おはようございます',
        reading: null,
        romaji: 'ohayou gozaimasu',
        english: 'Good morning (polite)',
        category: 'greetings',
        jlptLevel: 'N5',
        example: '先生、おはようございます。',
        exampleTranslation: 'Good morning, teacher.',
        storyId: 0
    },
    {
        japanese: '初めまして',
        reading: 'はじめまして',
        romaji: 'hajimemashite',
        english: 'Nice to meet you',
        category: 'greetings',
        jlptLevel: 'N5',
        example: '初めまして、私は田中です。',
        exampleTranslation: 'Nice to meet you, I am Tanaka.',
        storyId: 0
    },
    {
        japanese: 'よろしくお願いします',
        reading: 'よろしくおねがいします',
        romaji: 'yoroshiku onegaishimasu',
        english: 'Please be kind to me / Nice to meet you',
        category: 'greetings',
        jlptLevel: 'N5',
        example: '田中です。よろしくお願いします。',
        exampleTranslation: 'I am Tanaka. Nice to meet you.',
        storyId: 0
    },
    {
        japanese: '私',
        reading: 'わたし',
        romaji: 'watashi',
        english: 'I / me',
        category: 'daily-life',
        jlptLevel: 'N5',
        example: '私は学生です。',
        exampleTranslation: 'I am a student.',
        storyId: 0
    },
    {
        japanese: '先生',
        reading: 'せんせい',
        romaji: 'sensei',
        english: 'Teacher',
        category: 'classroom',
        jlptLevel: 'N5',
        example: '田中先生は優しいです。',
        exampleTranslation: 'Tanaka-sensei is kind.',
        storyId: 0
    },
    {
        japanese: '学生',
        reading: 'がくせい',
        romaji: 'gakusei',
        english: 'Student',
        category: 'classroom',
        jlptLevel: 'N5',
        example: '私は日本語の学生です。',
        exampleTranslation: 'I am a Japanese language student.',
        storyId: 0
    },
    {
        japanese: '日本語',
        reading: 'にほんご',
        romaji: 'nihongo',
        english: 'Japanese language',
        category: 'classroom',
        jlptLevel: 'N5',
        example: '日本語は難しいですか？',
        exampleTranslation: 'Is Japanese difficult?',
        storyId: 0
    },
    {
        japanese: 'ありがとうございます',
        reading: null,
        romaji: 'arigatou gozaimasu',
        english: 'Thank you (polite)',
        category: 'greetings',
        jlptLevel: 'N5',
        example: '手伝ってくれて、ありがとうございます。',
        exampleTranslation: 'Thank you for helping me.',
        storyId: 0
    },
    {
        japanese: '友達',
        reading: 'ともだち',
        romaji: 'tomodachi',
        english: 'Friend',
        category: 'daily-life',
        jlptLevel: 'N5',
        example: 'ケンは私の友達です。',
        exampleTranslation: 'Ken is my friend.',
        storyId: 0
    },
    {
        japanese: 'カフェ',
        reading: null,
        romaji: 'kafe',
        english: 'Cafe',
        category: 'places',
        jlptLevel: 'N5',
        example: 'カフェでコーヒーを飲みましょう。',
        exampleTranslation: "Let's drink coffee at the cafe.",
        storyId: 0
    },
    {
        japanese: '教室',
        reading: 'きょうしつ',
        romaji: 'kyoushitsu',
        english: 'Classroom',
        category: 'classroom',
        jlptLevel: 'N5',
        example: '教室は二階にあります。',
        exampleTranslation: 'The classroom is on the second floor.',
        storyId: 0
    },
    {
        japanese: '名前',
        reading: 'なまえ',
        romaji: 'namae',
        english: 'Name',
        category: 'daily-life',
        jlptLevel: 'N5',
        example: 'お名前は何ですか？',
        exampleTranslation: 'What is your name?',
        storyId: 0
    },
    {
        japanese: 'どうぞ',
        reading: null,
        romaji: 'douzo',
        english: 'Please / Go ahead',
        category: 'greetings',
        jlptLevel: 'N5',
        example: 'どうぞ、座ってください。',
        exampleTranslation: 'Please, have a seat.',
        storyId: 0
    },
    {
        japanese: '勉強',
        reading: 'べんきょう',
        romaji: 'benkyou',
        english: 'Study',
        category: 'classroom',
        jlptLevel: 'N5',
        example: '毎日日本語を勉強します。',
        exampleTranslation: 'I study Japanese every day.',
        storyId: 0
    },
    {
        japanese: '頑張る',
        reading: 'がんばる',
        romaji: 'ganbaru',
        english: 'To do one\'s best',
        category: 'verbs',
        jlptLevel: 'N5',
        example: '頑張ります！',
        exampleTranslation: 'I will do my best!',
        storyId: 0
    }
];

// Story 1: The Exchange Partner - Vocabulary
export const STORY_1_VOCABULARY = [
    // Greetings & Meeting
    {
        japanese: '初めまして',
        reading: 'はじめまして',
        romaji: 'hajimemashite',
        english: 'Nice to meet you (first time)',
        category: 'greetings',
        jlptLevel: 'N5',
        example: '初めまして、りんです。',
        exampleTranslation: 'Nice to meet you, I\'m Rin.',
        storyId: 1
    },
    {
        japanese: '久しぶり',
        reading: 'ひさしぶり',
        romaji: 'hisashiburi',
        english: 'Long time no see',
        category: 'greetings',
        jlptLevel: 'N5',
        example: '久しぶり！元気だった？',
        exampleTranslation: 'Long time no see! How have you been?',
        storyId: 1
    },
    {
        japanese: 'やっと会えた',
        reading: 'やっとあえた',
        romaji: 'yatto aeta',
        english: 'Finally we meet',
        category: 'greetings',
        jlptLevel: 'N4',
        example: 'やっと会えた！嬉しい！',
        exampleTranslation: 'We finally meet! I\'m so happy!',
        storyId: 1
    },
    {
        japanese: 'お待たせしました',
        reading: 'おまたせしました',
        romaji: 'omatase shimashita',
        english: 'Sorry for making you wait',
        category: 'greetings',
        jlptLevel: 'N4',
        example: 'お待たせしました。行きましょう。',
        exampleTranslation: 'Sorry for the wait. Let\'s go.',
        storyId: 1
    },
    // Café vocabulary
    {
        japanese: 'コーヒー',
        reading: null,
        romaji: 'koohii',
        english: 'Coffee',
        category: 'food',
        jlptLevel: 'N5',
        example: 'コーヒーを一つください。',
        exampleTranslation: 'One coffee, please.',
        storyId: 1
    },
    {
        japanese: '抹茶ラテ',
        reading: 'まっちゃラテ',
        romaji: 'matcha rate',
        english: 'Matcha latte',
        category: 'food',
        jlptLevel: 'N4',
        example: '抹茶ラテ、おいしいですよ。',
        exampleTranslation: 'The matcha latte is delicious.',
        storyId: 1
    },
    {
        japanese: '注文',
        reading: 'ちゅうもん',
        romaji: 'chuumon',
        english: 'Order',
        category: 'daily-life',
        jlptLevel: 'N4',
        example: 'ご注文はお決まりですか？',
        exampleTranslation: 'Are you ready to order?',
        storyId: 1
    },
    {
        japanese: 'お願いします',
        reading: 'おねがいします',
        romaji: 'onegaishimasu',
        english: 'Please (request)',
        category: 'phrases',
        jlptLevel: 'N5',
        example: 'これ、お願いします。',
        exampleTranslation: 'This one, please.',
        storyId: 1
    },
    {
        japanese: 'いただきます',
        reading: null,
        romaji: 'itadakimasu',
        english: 'Phrase before eating/drinking',
        category: 'phrases',
        jlptLevel: 'N5',
        example: 'いただきます！',
        exampleTranslation: 'Let\'s eat! / Bon appétit!',
        notes: 'Said before eating to express gratitude for the meal',
        storyId: 1
    },
    // Emotions & Nervousness
    {
        japanese: '緊張',
        reading: 'きんちょう',
        romaji: 'kinchou',
        english: 'Nervousness/tension',
        category: 'emotions',
        jlptLevel: 'N4',
        example: '緊張しています。',
        exampleTranslation: 'I\'m nervous.',
        storyId: 1
    },
    {
        japanese: 'ドキドキ',
        reading: null,
        romaji: 'dokidoki',
        english: 'Heart pounding (onomatopoeia)',
        category: 'emotions',
        jlptLevel: 'N4',
        example: '心がドキドキする。',
        exampleTranslation: 'My heart is pounding.',
        notes: 'Onomatopoeia for heartbeat, used for nervousness or excitement',
        storyId: 1
    },
    {
        japanese: '心配',
        reading: 'しんぱい',
        romaji: 'shinpai',
        english: 'Worry/anxiety',
        category: 'emotions',
        jlptLevel: 'N5',
        example: '心配しないで。',
        exampleTranslation: 'Don\'t worry.',
        storyId: 1
    },
    {
        japanese: '嬉しい',
        reading: 'うれしい',
        romaji: 'ureshii',
        english: 'Happy/glad',
        category: 'emotions',
        jlptLevel: 'N5',
        example: '会えて嬉しいです。',
        exampleTranslation: 'I\'m glad to meet you.',
        storyId: 1
    },
    {
        japanese: '安心',
        reading: 'あんしん',
        romaji: 'anshin',
        english: 'Relief/peace of mind',
        category: 'emotions',
        jlptLevel: 'N4',
        example: '安心しました。',
        exampleTranslation: 'I\'m relieved.',
        storyId: 1
    },
    // Communication
    {
        japanese: 'メッセージ',
        reading: null,
        romaji: 'messeeji',
        english: 'Message',
        category: 'daily-life',
        jlptLevel: 'N4',
        example: 'メッセージを送りました。',
        exampleTranslation: 'I sent a message.',
        storyId: 1
    },
    {
        japanese: 'ビデオ通話',
        reading: 'ビデオつうわ',
        romaji: 'bideo tsuuwa',
        english: 'Video call',
        category: 'daily-life',
        jlptLevel: 'N4',
        example: 'ビデオ通話しよう。',
        exampleTranslation: 'Let\'s do a video call.',
        storyId: 1
    },
    {
        japanese: '言語交換',
        reading: 'げんごこうかん',
        romaji: 'gengo koukan',
        english: 'Language exchange',
        category: 'daily-life',
        jlptLevel: 'N3',
        example: '言語交換パートナーを探しています。',
        exampleTranslation: 'I\'m looking for a language exchange partner.',
        storyId: 1
    },
    {
        japanese: '友達',
        reading: 'ともだち',
        romaji: 'tomodachi',
        english: 'Friend',
        category: 'daily-life',
        jlptLevel: 'N5',
        example: '私たちは友達です。',
        exampleTranslation: 'We are friends.',
        storyId: 1
    },
    // Places
    {
        japanese: '駅',
        reading: 'えき',
        romaji: 'eki',
        english: 'Station',
        category: 'places',
        jlptLevel: 'N5',
        example: '駅で待っています。',
        exampleTranslation: 'I\'m waiting at the station.',
        storyId: 1
    },
    {
        japanese: '改札',
        reading: 'かいさつ',
        romaji: 'kaisatsu',
        english: 'Ticket gate',
        category: 'places',
        jlptLevel: 'N4',
        example: '改札の前で会いましょう。',
        exampleTranslation: 'Let\'s meet in front of the ticket gate.',
        storyId: 1
    },
    {
        japanese: 'カフェ',
        reading: null,
        romaji: 'kafe',
        english: 'Café',
        category: 'places',
        jlptLevel: 'N5',
        example: 'カフェでコーヒーを飲みました。',
        exampleTranslation: 'I drank coffee at a café.',
        storyId: 1
    },
    // Useful expressions
    {
        japanese: '本当に',
        reading: 'ほんとうに',
        romaji: 'hontou ni',
        english: 'Really/truly',
        category: 'phrases',
        jlptLevel: 'N5',
        example: '本当にありがとう。',
        exampleTranslation: 'Thank you so much.',
        storyId: 1
    },
    {
        japanese: 'やっぱり',
        reading: null,
        romaji: 'yappari',
        english: 'As expected / After all',
        category: 'phrases',
        jlptLevel: 'N4',
        example: 'やっぱりそうだと思った。',
        exampleTranslation: 'I thought so after all.',
        storyId: 1
    },
    {
        japanese: '実は',
        reading: 'じつは',
        romaji: 'jitsu wa',
        english: 'Actually / To tell the truth',
        category: 'phrases',
        jlptLevel: 'N4',
        example: '実は、緊張していました。',
        exampleTranslation: 'Actually, I was nervous.',
        storyId: 1
    },
    {
        japanese: '自分',
        reading: 'じぶん',
        romaji: 'jibun',
        english: 'Oneself / yourself',
        category: 'daily-life',
        jlptLevel: 'N5',
        example: '自分を信じて。',
        exampleTranslation: 'Believe in yourself.',
        storyId: 1
    },
    {
        japanese: '出会い',
        reading: 'であい',
        romaji: 'deai',
        english: 'Encounter/meeting',
        category: 'daily-life',
        jlptLevel: 'N4',
        example: '素敵な出会いでした。',
        exampleTranslation: 'It was a wonderful encounter.',
        storyId: 1
    },
    {
        japanese: '今日',
        reading: 'きょう',
        romaji: 'kyou',
        english: 'Today',
        category: 'time',
        jlptLevel: 'N5',
        example: '今日は楽しかったです。',
        exampleTranslation: 'Today was fun.',
        storyId: 1
    }
];

// Story 2: The Gardener's Daughter - Vocabulary
export const STORY_2_VOCABULARY = [
    {
        japanese: '田舎',
        reading: 'いなか',
        romaji: 'inaka',
        english: 'Countryside',
        category: 'places',
        jlptLevel: 'N4',
        example: '田舎の空気は静かです。',
        exampleTranslation: 'The countryside air is calm.',
        storyId: 2
    },
    {
        japanese: 'おかえり',
        reading: null,
        romaji: 'okaeri',
        english: 'Welcome home',
        category: 'greetings',
        jlptLevel: 'N5',
        example: 'おかえり、待ってたよ。',
        exampleTranslation: 'Welcome home, I was waiting for you.',
        storyId: 2
    },
    {
        japanese: '庭',
        reading: 'にわ',
        romaji: 'niwa',
        english: 'Garden',
        category: 'places',
        jlptLevel: 'N5',
        example: '庭で花を育てています。',
        exampleTranslation: 'I grow flowers in the garden.',
        storyId: 2
    },
    {
        japanese: '苗',
        reading: 'なえ',
        romaji: 'nae',
        english: 'Seedling',
        category: 'daily-life',
        jlptLevel: 'N4',
        example: '新しい苗を植えます。',
        exampleTranslation: 'I plant new seedlings.',
        storyId: 2
    },
    {
        japanese: '土',
        reading: 'つち',
        romaji: 'tsuchi',
        english: 'Soil',
        category: 'daily-life',
        jlptLevel: 'N5',
        example: 'この土はやわらかいです。',
        exampleTranslation: 'This soil is soft.',
        storyId: 2
    },
    {
        japanese: '水',
        reading: 'みず',
        romaji: 'mizu',
        english: 'Water',
        category: 'daily-life',
        jlptLevel: 'N5',
        example: '植物に水をあげます。',
        exampleTranslation: 'I give water to the plants.',
        storyId: 2
    },
    {
        japanese: '植える',
        reading: 'うえる',
        romaji: 'ueru',
        english: 'To plant',
        category: 'verbs',
        jlptLevel: 'N5',
        example: '花を植えます。',
        exampleTranslation: 'I plant flowers.',
        storyId: 2
    },
    {
        japanese: '手伝う',
        reading: 'てつだう',
        romaji: 'tetsudau',
        english: 'To help',
        category: 'verbs',
        jlptLevel: 'N5',
        example: '庭仕事を手伝います。',
        exampleTranslation: 'I help with garden work.',
        storyId: 2
    },
    {
        japanese: '心配',
        reading: 'しんぱい',
        romaji: 'shinpai',
        english: 'Worry',
        category: 'emotions',
        jlptLevel: 'N5',
        example: '心配しないでください。',
        exampleTranslation: 'Please do not worry.',
        storyId: 2
    },
    {
        japanese: '気持ち',
        reading: 'きもち',
        romaji: 'kimochi',
        english: 'Feelings',
        category: 'emotions',
        jlptLevel: 'N5',
        example: '気持ちを言葉にする。',
        exampleTranslation: 'Put feelings into words.',
        storyId: 2
    },
    {
        japanese: '一緒に',
        reading: 'いっしょに',
        romaji: 'issho ni',
        english: 'Together',
        category: 'phrases',
        jlptLevel: 'N5',
        example: '一緒に作業しましょう。',
        exampleTranslation: 'Let us work together.',
        storyId: 2
    },
    {
        japanese: 'みんな',
        reading: null,
        romaji: 'minna',
        english: 'Everyone',
        category: 'daily-life',
        jlptLevel: 'N5',
        example: 'みんなで植える。',
        exampleTranslation: 'Everyone plants together.',
        storyId: 2
    },
    {
        japanese: 'お願いします',
        reading: 'おねがいします',
        romaji: 'onegaishimasu',
        english: 'Please (request)',
        category: 'phrases',
        jlptLevel: 'N5',
        example: 'もう一回お願いします。',
        exampleTranslation: 'One more time, please.',
        storyId: 2
    },
    {
        japanese: '種',
        reading: 'たね',
        romaji: 'tane',
        english: 'Seed',
        category: 'daily-life',
        jlptLevel: 'N4',
        example: '春の種を買いました。',
        exampleTranslation: 'I bought spring seeds.',
        storyId: 2
    },
    {
        japanese: '袋',
        reading: 'ふくろ',
        romaji: 'fukuro',
        english: 'Bag/packet',
        category: 'daily-life',
        jlptLevel: 'N4',
        example: '二袋ください。',
        exampleTranslation: 'Two packets, please.',
        storyId: 2
    },
    {
        japanese: 'おかわり',
        reading: null,
        romaji: 'okawari',
        english: 'Another serving / refill',
        category: 'food',
        jlptLevel: 'N4',
        example: 'おかわりしてもいいですか。',
        exampleTranslation: 'May I have another serving?',
        storyId: 2
    },
    {
        japanese: 'もらう',
        reading: null,
        romaji: 'morau',
        english: 'To receive',
        category: 'verbs',
        jlptLevel: 'N4',
        example: 'もう一つもらってもいいですか。',
        exampleTranslation: 'May I receive one more?',
        storyId: 2
    },
    {
        japanese: 'ありがとう',
        reading: null,
        romaji: 'arigatou',
        english: 'Thank you',
        category: 'greetings',
        jlptLevel: 'N5',
        example: '手伝ってくれてありがとう。',
        exampleTranslation: 'Thank you for helping.',
        storyId: 2
    }
];
