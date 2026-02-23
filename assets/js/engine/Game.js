/**
 * TSUZUKI CONNECT - Core Game Engine
 * Main game state and flow controller
 */
import { MAX_ACCESSIBLE_STORY_NUMBER, isStoryAccessible } from '../systems/StoryAccess.js';

export class Game {
    constructor(options) {
        this.container = options.container;
        this.width = options.width;
        this.height = options.height;
        
        // Game state
        this.state = {
            player: null,
            currentStory: 'story0',
            currentScene: 0,
            currentLine: 0,
            characters: [],
            background: null,
            relationships: {
                ken: 0,
                mei: 0,
                yuki: 0,
                tanaka: 0
            },
            kotobaLearned: [],
            choicesMade: [],
            playtime: 0,
            settings: this.getDefaultSettings()
        };
        
        // Runtime state
        this.currentScreen = 'main-menu';
        this.isTyping = false;
        this.autoMode = false;
        this.skipMode = false;
        this.autoTimer = null;
        this.textLog = [];
        
        // Managers (set externally)
        this.audio = null;
        this.save = null;
        this.ui = null;
        this.scene = null;
        this.kotoba = null;
        
        // Renderers (set externally)
        this.characterRenderer = null;
        this.backgroundRenderer = null;
        this.effectsRenderer = null;
        
        // Start playtime tracking
        this.playtimeInterval = null;
    }
    
    getDefaultSettings() {
        return {
            profileInitialized: false,
            playerName: '',
            playerReason: 'culture',
            playerLevel: 'beginner',
            playerAppearance: 0,
            language: 'en',
            textSpeed: 'medium',
            fontSize: 'medium',
            showSubtitles: true,
            showTranslation: true,
            showTranscription: true,
            furigana: 'all',
            masterVolume: 80,
            musicVolume: 70,
            sfxVolume: 60,
            voiceVolume: 90
        };
    }
    
    /**
     * Start a new game with player data
     */
    startNewGame(playerData) {
        this.state.player = {
            name: playerData.name,
            appearance: playerData.appearance || 0,
            reason: playerData.reason || 'culture',
            level: playerData.level || 'beginner'
        };

        // Persist profile so character setup is shown only once.
        this.state.settings.profileInitialized = true;
        this.state.settings.playerName = this.state.player.name;
        this.state.settings.playerReason = this.state.player.reason;
        this.state.settings.playerLevel = this.state.player.level;
        this.state.settings.playerAppearance = this.state.player.appearance;
        this.save.saveSettings(this.state.settings);
        
        // Reset state
        this.state.currentStory = 'story0';
        this.state.currentScene = 0;
        this.state.currentLine = 0;
        this.state.relationships = { ken: 0, mei: 0, yuki: 0, tanaka: 0 };
        this.state.kotobaLearned = [];
        this.state.choicesMade = [];
        this.state.playtime = 0;
        this.textLog = [];
        
        // Start game
        this.ui.showScreen('game-screen');
        this.currentScreen = 'game-screen';
        
        // Start playtime tracking
        this.startPlaytimeTracking();
        
        // Transition music
        this.audio.fadeToGameMusic('story0');
        
        // Start story
        this.scene.startStory('story0');
        
        // Auto-save
        this.save.autoSave(this.getState());
    }

    /**
     * Start from the beginning of a selected chapter/story.
     */
    startChapter(storyId) {
        if (!storyId || !this.scene?.stories?.[storyId]) {
            this.ui.showNotification(this.i18n?.t('runtime.chapter_select.invalid') ?? 'Selected chapter is unavailable.', 'info');
            return;
        }

        if (!this.isStoryAccessible(storyId)) {
            this.ui.showNotification(this.getStoryAccessDeniedMessage(), 'info');
            return;
        }

        // Prefer current player; if absent, recover from auto-save.
        if (!this.state.player?.name && this.save) {
            const autoSave = this.save.loadGame('auto');
            if (autoSave?.state?.player?.name) {
                this.state.player = { ...autoSave.state.player };
            }
        }

        if (!this.state.player?.name) {
            this.ui.showNotification(this.i18n?.t('runtime.name_required') ?? 'Please enter your name', 'info');
            this.ui.showScreen('character-creation');
            this.ui.initCharacterCreation();
            return;
        }

        this.autoMode = false;
        this.skipMode = false;
        this.ui.updateAutoButton(false);
        this.ui.updateSkipButton(false);
        this.textLog = [];
        this.isTyping = false;

        // Clear any leftover full-screen effects (e.g. fade-out overlays)
        // so the next chapter does not start under a dark cover.
        if (this.effectsRenderer?.stopEffect) {
            this.effectsRenderer.stopEffect();
        } else if (this.effectsRenderer?.clear) {
            this.effectsRenderer.clear();
        }

        this.state.currentStory = storyId;
        this.state.currentScene = 0;
        this.state.currentLine = 0;

        if (this.currentScreen !== 'game-screen') {
            this.ui.showScreen('game-screen');
        }
        this.currentScreen = 'game-screen';

        this.startPlaytimeTracking();
        this.audio.fadeToGameMusic(storyId);
        this.scene.startStory(storyId);

        this.save.autoSave(this.getState());
    }

    isStoryAccessible(storyId) {
        return isStoryAccessible(storyId);
    }

    getStoryAccessDeniedMessage() {
        return this.i18n?.t('runtime.chapter_select.story_limit', { n: MAX_ACCESSIBLE_STORY_NUMBER })
            ?? `Only Story ${MAX_ACCESSIBLE_STORY_NUMBER} is currently available.`;
    }
    
    /**
     * Load saved game state
     */
    loadState(saveData) {
        this.state = { ...this.state, ...saveData.state };
        this.textLog = saveData.textLog || [];
        
        // Resume at saved position
        this.scene.loadStoryAt(
            this.state.currentStory,
            this.state.currentScene,
            this.state.currentLine
        );
        
        this.startPlaytimeTracking();
        this.audio.fadeToGameMusic(this.state.currentStory);
    }
    
    /**
     * Get current game state for saving
     */
    getState() {
        return {
            state: { ...this.state },
            textLog: this.textLog.slice(-50), // Keep last 50 entries
            timestamp: Date.now(),
            screenshot: this.captureScreenshot()
        };
    }
    
    /**
     * Capture mini screenshot for save slots
     */
    captureScreenshot() {
        // Create a combined canvas
        const canvas = document.createElement('canvas');
        canvas.width = 160;
        canvas.height = 90;
        const ctx = canvas.getContext('2d');
        
        // Draw background
        const bgCanvas = document.getElementById('background-canvas');
        ctx.drawImage(bgCanvas, 0, 0, 160, 90);
        
        // Draw characters
        const charCanvas = document.getElementById('characters-canvas');
        ctx.drawImage(charCanvas, 0, 0, 160, 90);
        
        return canvas.toDataURL('image/jpeg', 0.6);
    }
    
    /**
     * Start tracking playtime
     */
    startPlaytimeTracking() {
        if (this.playtimeInterval) {
            clearInterval(this.playtimeInterval);
        }
        this.playtimeInterval = setInterval(() => {
            this.state.playtime++;
        }, 1000);
    }
    
    /**
     * Advance dialogue to next line
     */
    advanceDialogue() {
        if (this.isTyping) {
            // Complete current typing animation
            this.scene.completeTyping();
            return;
        }
        
        if (this.skipMode) {
            this.skipMode = false;
            this.ui.updateSkipButton(false);
        }
        
        this.scene.nextLine();
    }
    
    /**
     * Toggle auto-advance mode
     */
    toggleAutoMode() {
        this.autoMode = !this.autoMode;
        this.ui.updateAutoButton(this.autoMode);
        
        if (this.autoMode) {
            this.audio.playSFX('click');
        }
    }
    
    /**
     * Toggle skip mode
     */
    toggleSkipMode() {
        this.skipMode = !this.skipMode;
        this.ui.updateSkipButton(this.skipMode);
        
        if (this.skipMode) {
            this.scene.startSkipping();
        }
    }

    toggleTranslationDisplay() {
        this.state.settings.showTranslation = !this.state.settings.showTranslation;
        this.updateAssistButtons();
    }

    toggleTranscriptionDisplay() {
        this.state.settings.showTranscription = !this.state.settings.showTranscription;
        this.updateAssistButtons();
    }

    updateAssistButtons() {
        const translationBtn = document.getElementById('btn-toggle-translation');
        const transcriptionBtn = document.getElementById('btn-toggle-transcription');
        if (translationBtn) {
            translationBtn.classList.toggle('active', this.state.settings.showTranslation !== false);
        }
        if (transcriptionBtn) {
            transcriptionBtn.classList.toggle('active', this.state.settings.showTranscription !== false);
        }
    }
    
    /**
     * Add entry to text log
     */
    addToTextLog(speaker, japanese, english) {
        this.textLog.push({
            speaker,
            japanese,
            english,
            timestamp: Date.now()
        });
        
        // Limit log size
        if (this.textLog.length > 200) {
            this.textLog = this.textLog.slice(-200);
        }
    }
    
    /**
     * Handle choice selection
     */
    selectChoice(choiceIndex, choiceData) {
        this.state.choicesMade.push({
            story: this.state.currentStory,
            scene: this.state.currentScene,
            choice: choiceIndex,
            timestamp: Date.now()
        });
        
        // Apply relationship changes
        if (choiceData.relationships) {
            for (const [char, value] of Object.entries(choiceData.relationships)) {
                this.state.relationships[char] = 
                    Math.max(0, Math.min(100, this.state.relationships[char] + value));
            }
        }
        
        // Continue to next scene or specified target
        if (choiceData.goto) {
            this.scene.gotoLabel(choiceData.goto);
        } else {
            this.scene.nextLine();
        }
        
        this.audio.playSFX('select');
    }
    
    /**
     * Learn new vocabulary
     */
    learnVocab(vocabData) {
        const wordId = vocabData.japanese;
        if (!this.state.kotobaLearned.includes(wordId)) {
            this.state.kotobaLearned.push(wordId);
            this.kotoba.addWord(vocabData);
            this.ui.showVocabNotification(vocabData);
        }
    }
    
    /**
     * Save current settings
     */
    saveSettings() {
        const settingsNameRaw = document.getElementById('setting-player-name')?.value?.trim() || '';
        const settingsName = settingsNameRaw || this.state.settings.playerName || this.state.player?.name || '';
        const settings = {
            profileInitialized: this.state.settings.profileInitialized || Boolean(settingsName),
            playerName: settingsName,
            playerReason: this.state.settings.playerReason || this.state.player?.reason || 'culture',
            playerLevel: this.state.settings.playerLevel || this.state.player?.level || 'beginner',
            playerAppearance: this.state.settings.playerAppearance || this.state.player?.appearance || 0,
            language: document.getElementById('setting-language')?.value || 'en',
            textSpeed: document.getElementById('setting-text-speed').value,
            fontSize: document.getElementById('setting-font-size').value,
            showSubtitles: document.getElementById('setting-subtitles').checked,
            showTranslation: this.state.settings.showTranslation !== false,
            showTranscription: this.state.settings.showTranscription !== false,
            furigana: document.getElementById('setting-furigana').value,
            masterVolume: parseInt(document.getElementById('setting-master-vol').value),
            musicVolume: parseInt(document.getElementById('setting-music-vol').value),
            sfxVolume: parseInt(document.getElementById('setting-sfx-vol').value)
        };
        
        this.state.settings = settings;
        if (settings.playerName) {
            this.state.player = {
                name: settings.playerName,
                appearance: settings.playerAppearance || 0,
                reason: settings.playerReason || 'culture',
                level: settings.playerLevel || 'beginner'
            };
        }
        this.applySettings(settings);
        this.save.saveSettings(settings);
    }
    
    /**
     * Apply settings
     */
    applySettings(settings) {
        // Language / UI translations
        if (this.i18n) {
            this.i18n.setLanguage(settings.language || 'en');
            this.i18n.applyToDom(document);
        }

        // Text speed affects typing delay
        const speeds = { slow: 60, medium: 35, fast: 15 };
        this.scene.typingSpeed = speeds[settings.textSpeed] || 35;
        
        // Font size
        const sizes = { small: '18px', medium: '22px', large: '28px' };
        document.getElementById('dialogue-japanese').style.fontSize = 
            sizes[settings.fontSize] || '22px';
        
        // Subtitles
        document.getElementById('dialogue-english').style.display = 
            settings.showSubtitles && settings.showTranslation !== false ? 'block' : 'none';

        const transcriptionEl = document.getElementById('dialogue-transcription');
        if (transcriptionEl && settings.showTranscription === false) {
            transcriptionEl.style.display = 'none';
        }

        this.updateAssistButtons();
        
        // Audio volumes
        this.audio.setMasterVolume(settings.masterVolume / 100);
        this.audio.setMusicVolume(settings.musicVolume / 100);
        this.audio.setSFXVolume(settings.sfxVolume / 100);
    }
    
    /**
     * Return to title screen
     */
    returnToTitle() {
        this.save.autoSave(this.getState());
        
        if (this.playtimeInterval) {
            clearInterval(this.playtimeInterval);
        }
        
        this.autoMode = false;
        this.skipMode = false;
        this.ui.updateAutoButton(false);
        this.ui.updateSkipButton(false);
        
        this.audio.fadeToMenuMusic();
        this.ui.showScreen('main-menu');
        this.currentScreen = 'main-menu';
        
        // Re-enable continue button
        document.getElementById('btn-continue').disabled = false;
        document.getElementById('btn-chapter-select').disabled = false;
        document.getElementById('btn-kotoba-log').disabled = false;
    }
    
    /**
     * Skip current lesson
     */
    skipLesson() {
        this.scene.skipLesson();
    }
    
    /**
     * Advance lesson content
     */
    advanceLesson() {
        this.scene.advanceLesson();
    }
    
    /**
     * Format playtime for display
     */
    getFormattedPlaytime() {
        const hours = Math.floor(this.state.playtime / 3600);
        const minutes = Math.floor((this.state.playtime % 3600) / 60);
        return `${hours}h ${minutes}m`;
    }
}
