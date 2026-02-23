/**
 * TSUZUKI CONNECT - Dialogue Builder
 * Ren'Py-style fluent API for writing visual novel scenes
 * Adapted for Japanese learning visual novel with vocabulary support
 */

class DialogueBuilder {
    constructor() {
        this.scenes = [];
        this.currentScene = null;
        this.pendingChoices = null;
        this.storyMeta = {
            id: 0,
            title: '',
            titleJp: '',
            description: '',
            estimatedTime: '',
            jlptFocus: 'N5',
            vocabulary: []
        };
    }

    // ========================================
    // STORY METADATA
    // ========================================

    story(id, title, titleJp) {
        this.storyMeta.id = id;
        this.storyMeta.title = title;
        this.storyMeta.titleJp = titleJp;
        return this;
    }

    description(text) {
        this.storyMeta.description = text;
        return this;
    }

    estimatedTime(time) {
        this.storyMeta.estimatedTime = time;
        return this;
    }

    jlptFocus(level) {
        this.storyMeta.jlptFocus = level;
        return this;
    }

    vocabularyList(vocab) {
        this.storyMeta.vocabulary = vocab;
        return this;
    }

    // ========================================
    // SCENES & LABELS
    // ========================================

    scene(id, label = null) {
        this._flushPending();
        this.currentScene = {
            id,
            label: label || id,
            lines: []
        };
        this.scenes.push(this.currentScene);
        return this;
    }

    label(labelName) {
        if (this.currentScene) {
            this.currentScene.label = labelName;
        }
        return this;
    }

    // ========================================
    // FLOW CONTROL
    // ========================================

    jump(targetLabel) {
        this._addLine({ type: 'jump', target: targetLabel });
        return this;
    }

    end() {
        this._addLine({ type: 'end' });
        return this;
    }

    // ========================================
    // BACKGROUNDS & SCENES
    // ========================================

    bg(background, time = 'afternoon', transition = 'fade') {
        this._addLine({
            type: 'background',
            bg: background,
            time,
            transition
        });
        return this;
    }

    // Shorthand for common backgrounds
    classroom(time = 'morning') { return this.bg('classroom', time); }
    street(time = 'afternoon') { return this.bg('street', time); }
    cafe(time = 'afternoon') { return this.bg('cafe', time); }
    apartment(time = 'evening') { return this.bg('apartment', time); }
    station(time = 'afternoon') { return this.bg('station', time); }
    park(time = 'afternoon') { return this.bg('park', time); }
    train(time = 'afternoon') { return this.bg('train', time); }
    izakaya(time = 'evening') { return this.bg('izakaya', time); }
    hallway(time = 'morning') { return this.bg('hallway', time); }

    // ========================================
    // CHARACTERS
    // ========================================

    show(name, position = 'center', expression = 'neutral') {
        this._addLine({
            type: 'character',
            name,
            position,
            expression
        });
        return this;
    }

    hide(name) {
        this._addLine({
            type: 'character-hide',
            name
        });
        return this;
    }

    hideAll() {
        this._addLine({ type: 'character-hide-all' });
        return this;
    }

    move(name, position) {
        this._addLine({
            type: 'character-move',
            name,
            position
        });
        return this;
    }

    express(name, expression) {
        this._addLine({
            type: 'character-express',
            name,
            expression
        });
        return this;
    }

    // ========================================
    // DIALOGUE & NARRATION
    // ========================================

    // Narration (no speaker)
    n(text) {
        this._addLine({ type: 'narration', text });
        return this;
    }

    // Generic dialogue
    say(speaker, text, expression = null) {
        const line = { type: 'dialogue', speaker, text };
        if (expression) line.expression = expression;
        this._addLine(line);
        return this;
    }

    // Dialogue with explicit Japanese/English/transcription support (bypasses i18n lookup)
    sayJp(speaker, japanese, english = '', transcription = '', expression = null) {
        const line = { type: 'dialogue', speaker, japanese, english, transcription };
        if (expression) line.expression = expression;
        this._addLine(line);
        return this;
    }

    // Player speaks/thinks
    player(text, expression = 'neutral') {
        return this.say('player', text, expression);
    }

    playerJp(japanese, english = '', transcription = '', expression = 'neutral') {
        return this.sayJp('player', japanese, english, transcription, expression);
    }

    think(text, expression = 'thinking') {
        return this.say('player', `(${text})`, expression);
    }

    thinkJp(japanese, english = '', transcription = '', expression = 'thinking') {
        // Keep parentheses visual style for thoughts in Japanese too
        const wrapped = japanese ? `(${japanese})` : '';
        return this.sayJp('player', wrapped, english, transcription, expression);
    }

    // Character shorthands
    ken(text, expression = 'neutral') {
        return this.say('ken', text, expression);
    }

    mei(text, expression = 'neutral') {
        return this.say('mei', text, expression);
    }

    yuki(text, expression = 'neutral') {
        return this.say('yuki', text, expression);
    }

    tanaka(text, expression = 'neutral') {
        return this.say('tanaka', text, expression);
    }

    // Anthology story character aliases
    sora(text, expression = 'neutral') {
        return this.say('sora', text, expression);
    }

    server(text, expression = 'neutral') {
        return this.say('server', text, expression);
    }

    // Pause (ellipsis from any speaker)
    pause(speaker = null) {
        if (speaker) {
            return this.say(speaker, '...', 'neutral');
        }
        return this.n('...');
    }

    // ========================================
    // VOCABULARY & LEARNING
    // ========================================

    vocab(japanese, reading, romaji, english, options = {}) {
        this._addLine({
            type: 'vocab',
            word: {
                japanese,
                reading,
                romaji,
                english,
                category: options.category || 'general',
                jlptLevel: options.jlpt || 'N5',
                storyId: this.storyMeta.id,
                ...options
            }
        });
        return this;
    }

    // Common vocabulary patterns
    greeting(japanese, reading, romaji, english) {
        return this.vocab(japanese, reading, romaji, english, { category: 'greetings' });
    }

    phrase(japanese, reading, romaji, english) {
        return this.vocab(japanese, reading, romaji, english, { category: 'phrases' });
    }

    noun(japanese, reading, romaji, english, category = 'nouns') {
        return this.vocab(japanese, reading, romaji, english, { category });
    }

    verb(japanese, reading, romaji, english) {
        return this.vocab(japanese, reading, romaji, english, { category: 'verbs' });
    }

    adjective(japanese, reading, romaji, english) {
        return this.vocab(japanese, reading, romaji, english, { category: 'adjectives' });
    }

    // ========================================
    // CHOICES
    // ========================================

    menu() {
        this.pendingChoices = [];
        return this;
    }

    choice(text, next, options = {}) {
        if (!this.pendingChoices) {
            throw new Error('choice() must be called after menu()');
        }
        this.pendingChoices.push({
            text,
            next,
            hint: options.hint || null,
            relationship: options.relationship || null,
            ...options
        });
        return this;
    }

    endMenu() {
        if (this.pendingChoices && this.pendingChoices.length > 0) {
            this._addLine({
                type: 'choice',
                choices: this.pendingChoices
            });
        }
        this.pendingChoices = null;
        return this;
    }

    // ========================================
    // RELATIONSHIPS
    // ========================================

    relationship(character, change, reason = '') {
        this._addLine({
            type: 'relationship',
            character,
            change,
            reason
        });
        return this;
    }

    // Shorthands
    befriend(character, reason = '') {
        return this.relationship(character, 1, reason);
    }

    bond(character, reason = '') {
        return this.relationship(character, 2, reason);
    }

    upset(character, reason = '') {
        return this.relationship(character, -1, reason);
    }

    // ========================================
    // EFFECTS & AUDIO
    // ========================================

    effect(effectName, duration = null) {
        this._addLine({ type: 'effect', effect: effectName, duration });
        return this;
    }

    stopEffect() {
        return this.effect('stop');
    }

    // Common effects
    cherryBlossoms() { return this.effect('cherry-blossoms'); }
    rain() { return this.effect('rain'); }
    snow() { return this.effect('snow'); }
    sparkle() { return this.effect('sparkle'); }
    shake() { return this.effect('shake'); }
    fadeIn() { return this.effect('fade-in'); }
    fadeOut() { return this.effect('fade-out'); }

    music(track, fadeIn = false) {
        this._addLine({ type: 'music', track, fadeIn });
        return this;
    }

    stopMusic() {
        return this.music('stop');
    }

    sfx(sound) {
        this._addLine({ type: 'sfx', sound });
        return this;
    }

    // ========================================
    // GAME STATE
    // ========================================

    setFlag(flag, value = true) {
        this._addLine({ type: 'flag', flag, value });
        return this;
    }

    checkFlag(flag, ifTrue, ifFalse = null) {
        this._addLine({
            type: 'condition',
            flag,
            ifTrue,
            ifFalse
        });
        return this;
    }

    // ========================================
    // LESSON MODE
    // ========================================

    lesson(lessonData) {
        this._addLine({ type: 'lesson', ...lessonData });
        return this;
    }

    quiz(question, options = {}) {
        this._addLine({
            type: 'quiz',
            question,
            ...options
        });
        return this;
    }

    // ========================================
    // SPECIAL
    // ========================================

    wait(ms = 1000) {
        this._addLine({ type: 'wait', duration: ms });
        return this;
    }

    titleCard(title, subtitle = '', duration = 4000) {
        this._addLine({
            type: 'title-card',
            title,
            subtitle,
            duration
        });
        return this;
    }

    // Add a comment (for organization, not rendered)
    comment(text) {
        // Comments are stripped in build, useful for organizing source
        this._addLine({ type: '_comment', text });
        return this;
    }

    // ========================================
    // INTERNAL HELPERS
    // ========================================

    _addLine(line) {
        if (!this.currentScene) {
            throw new Error('Must call scene() before adding content');
        }
        this.currentScene.lines.push(line);
    }

    _getCurrentLine() {
        if (!this.currentScene || this.currentScene.lines.length === 0) {
            throw new Error('No lines in current scene');
        }
        return this.currentScene.lines[this.currentScene.lines.length - 1];
    }

    _flushPending() {
        if (this.pendingChoices && this.pendingChoices.length > 0) {
            this.endMenu();
        }
    }

    // ========================================
    // BUILD OUTPUT
    // ========================================

    build() {
        this._flushPending();

        // Clean up internal comment lines
        const cleanedScenes = this.scenes.map(scene => ({
            ...scene,
            lines: scene.lines.filter(line => line.type !== '_comment')
        }));

        return {
            id: this.storyMeta.id,
            title: this.storyMeta.title,
            titleJp: this.storyMeta.titleJp,
            description: this.storyMeta.description,
            estimatedTime: this.storyMeta.estimatedTime,
            jlptFocus: this.storyMeta.jlptFocus,
            vocabulary: this.storyMeta.vocabulary,
            scenes: cleanedScenes
        };
    }
}

// ========================================
// FACTORY & UTILITIES
// ========================================

/**
 * Create a new dialogue builder
 */
export function dialogue() {
    return new DialogueBuilder();
}

/**
 * Merge multiple stories or extend a story
 */
export function mergeScenes(...builders) {
    const scenes = [];
    for (const builder of builders) {
        const data = builder instanceof DialogueBuilder ? builder.build() : builder;
        scenes.push(...(data.scenes || []));
    }
    return scenes;
}

/**
 * Create a vocabulary entry helper
 */
export function word(japanese, reading, romaji, english, options = {}) {
    return {
        japanese,
        reading,
        romaji,
        english,
        category: options.category || 'general',
        jlptLevel: options.jlpt || 'N5',
        ...options
    };
}

export { DialogueBuilder };
