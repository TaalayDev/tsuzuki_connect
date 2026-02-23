/**
 * TSUZUKI CONNECT - Scene Manager
 * Handles story progression, dialogue, and scene rendering
 */

export class SceneManager {
    constructor(game) {
        this.game = game;
        this.stories = {};
        this.currentStory = null;
        this.currentSceneIndex = 0;
        this.currentLineIndex = 0;
        this.typingSpeed = 35; // ms per character
        this.typingTimeout = null;
        this.isTyping = false;
        this.fullText = '';
        this.currentCharIndex = 0;
        this.labels = {}; // Label to line index mapping
    }

    /**
     * Load a story into the manager
     */
    loadStory(storyId, storyData) {
        this.stories[storyId] = storyData;

        // Build label index
        this.buildLabelIndex(storyId, storyData);
    }

    /**
     * Build index of labels for jumping
     */
    buildLabelIndex(storyId, storyData) {
        this.labels[storyId] = {};

        storyData.scenes.forEach((scene, sceneIndex) => {
            // Index by ID if available
            if (scene.id) {
                this.labels[storyId][scene.id] = {
                    scene: sceneIndex,
                    line: 0
                };
            }

            // Check scene-level label
            if (scene.label) {
                this.labels[storyId][scene.label] = {
                    scene: sceneIndex,
                    line: 0
                };
            }

            // Check line-level labels
            scene.lines.forEach((line, lineIndex) => {
                if (line.label) {
                    this.labels[storyId][line.label] = {
                        scene: sceneIndex,
                        line: lineIndex
                    };
                }
            });
        });
    }

    /**
     * Start a story from the beginning
     */
    startStory(storyId) {
        if (!this.stories[storyId]) {
            console.error(`Story ${storyId} not found`);
            return;
        }

        this.currentStory = this.stories[storyId];
        this.currentSceneIndex = 0;
        this.currentLineIndex = 0;

        this.game.state.currentStory = storyId;
        this.game.state.currentScene = 0;
        this.game.state.currentLine = 0;

        this.startScene(0);
    }

    /**
     * Load story at specific position
     */
    loadStoryAt(storyId, sceneIndex, lineIndex) {
        if (!this.stories[storyId]) {
            console.error(`Story ${storyId} not found`);
            return;
        }

        this.currentStory = this.stories[storyId];
        this.currentSceneIndex = sceneIndex;
        this.currentLineIndex = lineIndex;

        // Rebuild visual state that would already be in effect at the saved line.
        this.restoreBackgroundAt(sceneIndex, lineIndex);

        this.startScene(sceneIndex, lineIndex);
    }

    restoreBackgroundAt(sceneIndex, lineIndex) {
        if (!this.currentStory?.scenes?.length || !this.game?.backgroundRenderer) return;

        let lastBackground = null;
        let lastTime = null;

        for (let s = 0; s <= sceneIndex; s++) {
            const scene = this.currentStory.scenes[s];
            if (!scene) continue;

            if (scene.background) {
                lastBackground = scene.background;
            }

            const maxLine = s === sceneIndex ? Math.max(0, lineIndex) : scene.lines.length;
            for (let i = 0; i < maxLine; i++) {
                const line = scene.lines[i];
                if (line?.type === 'background') {
                    lastBackground = line.bg || lastBackground;
                    if (line.time) lastTime = line.time;
                }
            }
        }

        if (lastBackground) {
            this.game.backgroundRenderer.setBackground(lastBackground, lastTime, 'none');
        }
    }

    /**
     * Start a scene
     */
    startScene(sceneIndex, startLine = 0) {
        const scene = this.currentStory.scenes[sceneIndex];
        if (!scene) {
            console.error(`Scene ${sceneIndex} not found`);
            return;
        }

        this.currentSceneIndex = sceneIndex;
        this.currentLineIndex = startLine;

        // Update scene indicator
        this.game.ui.updateSceneIndicator(
            this.currentStory.title,
            sceneIndex + 1,
            this.currentStory.scenes.length
        );

        // Set background
        if (scene.background) {
            this.game.backgroundRenderer.setBackground(scene.background);
        }

        // Set initial characters
        if (scene.characters) {
            this.game.characterRenderer.setCharacters(scene.characters);
        }

        // Start effects
        if (scene.effect) {
            this.game.effectsRenderer.startEffect(scene.effect);
        }

        // Play scene music if specified
        if (scene.music) {
            this.game.audio.playGameMusic(scene.music);
        }

        // Process first line
        this.processLine(scene.lines[startLine]);
    }

    /**
     * Process a dialogue line or command
     */
    processLine(line) {
        if (!line) {
            this.nextScene();
            return;
        }

        // Handle different line types
        switch (line.type) {
            case 'dialogue':
                this.showDialogue(line);
                break;
            case 'narration':
                this.showNarration(line);
                break;
            case 'choice':
                this.showChoices(line);
                break;
            case 'character':
                this.updateCharacter(line);
                this.nextLine();
                break;
            case 'character-hide':
                this.game.characterRenderer.hideCharacter(line.name);
                this.nextLine();
                break;
            case 'character-hide-all':
                this.game.characterRenderer.hideAllCharacters();
                this.nextLine();
                break;
            case 'character-move':
                this.game.characterRenderer.moveCharacter(line.name, line.position);
                this.nextLine();
                break;
            case 'character-express':
                this.game.characterRenderer.setExpression(line.name, line.expression);
                this.nextLine();
                break;
            case 'background':
                this.game.backgroundRenderer.setBackground(line.bg, line.time);
                this.nextLine();
                break;
            case 'effect':
                if (line.effect === 'stop') {
                    this.game.effectsRenderer.stopEffect();
                } else {
                    this.game.effectsRenderer.startEffect(line.effect, line.duration);
                }
                this.nextLine();
                break;
            case 'music':
                this.game.audio.playGameMusic(line.track, line.fadeIn);
                this.nextLine();
                break;
            case 'relationship':
                this.updateRelationship(line);
                this.nextLine();
                break;
            case 'sfx':
                this.game.audio.playSFX(line.sfx);
                this.nextLine();
                break;
            case 'vocab':
                this.game.learnVocab(line.word);
                this.nextLine();
                break;
            case 'wait':
                setTimeout(() => this.nextLine(), line.duration || 1000);
                break;
            case 'jump':
                this.gotoLabel(line.target);
                break;
            case 'title-card':
                this.game.ui.showTitleCard(line.title, line.subtitle, line.duration);
                // Wait for the duration plus a bit before automatically proceeding if desired
                // Or just proceed immediately to render background behind it?
                // Let's pause narration until after duration
                setTimeout(() => this.nextLine(), line.duration);
                break;
            case 'end':
                this.endStory();
                break;
            default:
                // Treat as dialogue by default
                if (line.text || line.japanese) {
                    this.showDialogue(line);
                } else {
                    this.nextLine();
                }
        }
    }

    /**
     * Show dialogue with typing effect
     */
    showDialogue(line) {
        const speakerEl = document.getElementById('speaker-name');
        const japaneseEl = document.getElementById('dialogue-japanese');
        const transcriptionEl = document.getElementById('dialogue-transcription');
        const englishEl = document.getElementById('dialogue-english');
        const assistControlsEl = document.getElementById('dialogue-assist-controls');

        // Set speaker
        const speaker = this.resolveSpeaker(line.speaker);
        speakerEl.textContent = speaker || '';

        // Clear current text
        japaneseEl.textContent = '';
        if (transcriptionEl) transcriptionEl.textContent = '';
        englishEl.textContent = '';

        // Hide choices
        document.getElementById('choice-container').classList.add('hidden');
        document.getElementById('dialogue-container').classList.remove('hidden');

        // Update character expression if specified
        if (line.expression) {
            this.game.characterRenderer.setExpression(line.speaker, line.expression);
        }

        // Highlight speaking character
        if (line.speaker) {
            this.game.characterRenderer.highlightCharacter(line.speaker);
        }

        // Get text to display
        const sourceText = line.japanese || line.text || '';
        const key = this.getLineTranslationKey(sourceText);
        const japanese = this.resolveDisplayJapanese(sourceText, key);
        const english = this.resolveDisplayTranslation(line, key);
        const transcription = (typeof line.transcription === 'string' && line.transcription.length > 0)
            ? this.resolveText(line.transcription)
            : this.resolveDisplayTranscription(japanese, key);
        const hasJapaneseSupport = this.lineHasJapaneseSupport(japanese, key);

        if (assistControlsEl) {
            assistControlsEl.style.display = hasJapaneseSupport ? 'flex' : 'none';
        }

        // Add to text log
        this.game.addToTextLog(speaker, japanese, english);

        // Start typing effect
        this.typeText(japaneseEl, japanese, () => {
            this.renderTranscription(transcriptionEl, transcription);
            englishEl.textContent = english;
            englishEl.style.display =
                this.game.state.settings.showSubtitles && this.game.state.settings.showTranslation !== false && english
                    ? 'block'
                    : 'none';

            // Handle auto mode
            if (this.game.autoMode) {
                const readTime = Math.max(2000, japanese.length * 50);
                setTimeout(() => {
                    if (this.game.autoMode && !this.isTyping) {
                        this.nextLine();
                    }
                }, readTime);
            }
        });
    }

    /**
     * Show narration (no speaker)
     */
    showNarration(line) {
        line.speaker = null;
        this.showDialogue(line);
    }

    /**
     * Show choice buttons
     */
    showChoices(line) {
        const container = document.getElementById('choice-container');
        const dialogueContainer = document.getElementById('dialogue-container');

        // Hide dialogue, show choices
        dialogueContainer.classList.add('hidden');
        container.classList.remove('hidden');

        // Clear previous choices
        container.innerHTML = '';

        // Create choice buttons
        line.choices.forEach((choice, index) => {
            const btn = document.createElement('button');
            btn.className = 'choice-btn';
            btn.innerHTML = `
                ${this.resolveText(choice.text)}
                ${choice.hint ? `<span class="choice-hint">(${choice.hint})</span>` : ''}
            `;
            btn.addEventListener('click', () => {
                container.classList.add('hidden');
                dialogueContainer.classList.remove('hidden');

                // Jump to specified label if provided
                if (choice.next) {
                    this.gotoLabel(choice.next);
                } else if (choice.goto) {
                    this.gotoLabel(choice.goto);
                } else {
                    this.game.selectChoice(index, choice);
                }
            });
            container.appendChild(btn);
        });
    }

    /**
     * Update character on screen
     */
    updateCharacter(line) {
        if (line.action === 'enter' || line.name) {
            // New format: { type: "character", name: "ken", position: "left", expression: "happy" }
            this.game.characterRenderer.addCharacter(
                line.name || line.character,
                line.position,
                line.expression
            );
        } else if (line.action === 'exit') {
            this.game.characterRenderer.removeCharacter(line.character);
        } else if (line.action === 'move') {
            this.game.characterRenderer.moveCharacter(line.character, line.position);
        } else if (line.action === 'expression') {
            this.game.characterRenderer.setExpression(line.character, line.expression);
        }
    }

    /**
     * Update relationship with a character
     */
    updateRelationship(line) {
        const char = line.character;
        const change = line.change || 0;

        if (this.game.state.relationships[char] !== undefined) {
            this.game.state.relationships[char] += change;
            this.game.state.relationships[char] = Math.max(0, Math.min(100, this.game.state.relationships[char]));

            if (line.reason) {
                console.log(`Relationship with ${char}: ${line.change > 0 ? '+' : ''}${change} (${line.reason})`);
            }
        }
    }

    /**
     * Type text with animation
     */
    typeText(element, text, callback) {
        this.isTyping = true;
        this.game.isTyping = true;
        this.fullText = text;
        this.currentCharIndex = 0;

        const typeNext = () => {
            if (this.currentCharIndex < this.fullText.length) {
                element.textContent = this.fullText.substring(0, this.currentCharIndex + 1);
                this.currentCharIndex++;

                // Play typing sound occasionally
                if (this.currentCharIndex % 3 === 0) {
                    // Subtle typing sound could go here
                }

                this.typingTimeout = setTimeout(typeNext, this.typingSpeed);
            } else {
                this.isTyping = false;
                this.game.isTyping = false;
                if (callback) callback();
            }
        };

        typeNext();
    }

    /**
     * Complete typing immediately
     */
    completeTyping() {
        if (this.typingTimeout) {
            clearTimeout(this.typingTimeout);
        }

        const japaneseEl = document.getElementById('dialogue-japanese');
        const transcriptionEl = document.getElementById('dialogue-transcription');
        japaneseEl.textContent = this.fullText;
        if (transcriptionEl && this.game.state.settings.showTranscription === false) {
            transcriptionEl.style.display = 'none';
        }

        this.isTyping = false;
        this.game.isTyping = false;
    }

    /**
     * Advance to next line
     */
    nextLine() {
        this.currentLineIndex++;
        this.game.state.currentLine = this.currentLineIndex;

        const scene = this.currentStory.scenes[this.currentSceneIndex];

        if (this.currentLineIndex >= scene.lines.length) {
            this.nextScene();
        } else {
            this.processLine(scene.lines[this.currentLineIndex]);
        }

        // Auto-save periodically
        if (this.currentLineIndex % 10 === 0) {
            this.game.save.autoSave(this.game.getState());
        }
    }

    /**
     * Advance to next scene
     */
    nextScene() {
        this.currentSceneIndex++;
        this.game.state.currentScene = this.currentSceneIndex;
        this.game.state.currentLine = 0;

        if (this.currentSceneIndex >= this.currentStory.scenes.length) {
            this.endStory();
        } else {
            // Transition effect
            this.game.effectsRenderer.fadeTransition(() => {
                this.startScene(this.currentSceneIndex);
            });
        }
    }

    /**
     * Jump to a labeled position
     */
    gotoLabel(label) {
        const storyId = this.game.state.currentStory;
        const target = this.labels[storyId]?.[label];

        if (target) {
            this.currentSceneIndex = target.scene;
            this.currentLineIndex = target.line;
            this.game.state.currentScene = target.scene;
            this.game.state.currentLine = target.line;

            const scene = this.currentStory.scenes[target.scene];
            this.processLine(scene.lines[target.line]);
        } else {
            console.error(`Label ${label} not found`);
            this.nextLine();
        }
    }

    /**
     * End current story
     */
    endStory() {
        console.log('Story complete!');

        const completedStoryId = this.game.state.currentStory;
        const nextStoryId = this.getNextStoryId(completedStoryId);

        // Show completion screen
        this.game.ui.showStoryComplete({
            title: this.currentStory.title,
            playtime: this.game.getFormattedPlaytime(),
            vocabLearned: this.game.state.kotobaLearned.length,
            nextStoryId,
            nextStoryTitle: nextStoryId ? this.stories[nextStoryId]?.title : ''
        });

        this.game.save.autoSave(this.game.getState());
    }

    getNextStoryId(storyId) {
        if (!storyId || typeof storyId !== 'string') return null;
        const match = /^story(\d+)$/.exec(storyId);
        if (!match) return null;
        const nextId = `story${Number.parseInt(match[1], 10) + 1}`;
        return this.stories[nextId] ? nextId : null;
    }

    /**
     * Resolve speaker name (handle player name substitution)
     */
    resolveSpeaker(speaker) {
        if (!speaker) return null;
        if (speaker === 'player' || speaker === 'you') {
            return this.game.state.player?.name || 'You';
        }
        if (this.game.characterRenderer?.getDisplayName) {
            return this.game.characterRenderer.getDisplayName(speaker);
        }
        return speaker;
    }

    /**
     * Resolve text with variable substitution
     */
    resolveText(text) {
        if (!text) return '';

        return text
            .replace(/\{player\}/g, this.game.state.player?.name || 'You')
            .replace(/\{name\}/g, this.game.state.player?.name || 'You');
    }

    getLineTranslationKey(sourceText) {
        if (!sourceText || typeof sourceText !== 'string' || !this.game.i18n) return null;
        return this.game.i18n.findKeyByLocalizedText(sourceText);
    }

    resolveDisplayJapanese(sourceText, key) {
        if (key && this.game.i18n?.hasTranslation('jp', key)) {
            return this.resolveText(this.game.i18n.tForLanguage('jp', key));
        }
        return this.resolveText(sourceText || '');
    }

    resolveDisplayTranslation(line, key) {
        if (this.game.state.settings.showTranslation === false) return '';

        // 1. Try legacy explicit _en key
        if (key && this.game.i18n?.hasTranslation('en', `${key}_en`)) {
            return this.resolveText(this.game.i18n.tForLanguage('en', `${key}_en`));
        }

        // 2. Try parsing from main key 'en' field if it contains the translation
        // Pattern matches appended translation: "JP (Transc) (Translation)"
        if (key && this.game.i18n?.hasTranslation('en', key)) {
            const enText = this.game.i18n.tForLanguage('en', key);

            // Look for the last parenthesized group
            const match = /\s+\(([^)]+)\)$/.exec(enText);

            if (match) {
                const extractedText = match[1];

                // Avoid treating transcription as translation if that's all there is
                const transcription = this.game.i18n.hasTranslation('transc', key)
                    ? this.game.i18n.tForLanguage('transc', key)
                    : null;

                // If extracted text is NOT the transcription, it must be the translation
                if (!transcription || extractedText !== transcription) {
                    return this.resolveText(extractedText);
                }
            }
        }

        return this.resolveText(line.english || '');
    }

    resolveDisplayTranscription(japanese, key) {
        if (this.game.state.settings.showTranscription === false) return '';
        if (key && this.game.i18n?.hasTranslation('transc', key)) {
            return this.resolveText(this.game.i18n.tForLanguage('transc', key));
        }
        return this.resolveTranscription(japanese);
    }

    lineHasJapaneseSupport(japanese, key) {
        if (key && this.game.i18n?.hasTranslation('jp', key)) return true;
        return /[ぁ-んァ-ン一-龯々]/.test(japanese || '');
    }

    renderTranscription(element, text) {
        if (!element) return;
        const value = text || '';
        element.textContent = value;
        element.style.display = value ? 'block' : 'none';
    }

    resolveTranscription(text) {
        const trimmed = (text || '').trim();
        if (!trimmed || !/[ぁ-んァ-ン一-龯々]/.test(trimmed)) return '';

        const pairTranscriptions = [];
        const pairRegex = /([ぁ-んァ-ン一-龯々ー]+)\s*[\(（]([A-Za-z][A-Za-z0-9' !?,.\-]+)[\)）]/g;
        let pairMatch = pairRegex.exec(trimmed);
        while (pairMatch) {
            pairTranscriptions.push(`${pairMatch[1]}: ${pairMatch[2].trim()}`);
            pairMatch = pairRegex.exec(trimmed);
        }
        if (pairTranscriptions.length > 0) {
            return pairTranscriptions.join(' | ');
        }
        return '';
    }

    /**
     * Start skip mode
     */
    startSkipping() {
        const skipInterval = setInterval(() => {
            if (this.game.skipMode && !this.isTyping) {
                this.nextLine();
            } else if (!this.game.skipMode) {
                clearInterval(skipInterval);
            }
        }, 100);
    }

    /**
     * Skip lesson and go to story
     */
    skipLesson() {
        // Jump to after lesson
        const postLessonLabel = 'post_lesson';
        if (this.labels[this.game.state.currentStory]?.[postLessonLabel]) {
            this.gotoLabel(postLessonLabel);
        } else {
            this.nextScene();
        }
    }

    /**
     * Advance lesson content
     */
    advanceLesson() {
        this.nextLine();
    }
}
