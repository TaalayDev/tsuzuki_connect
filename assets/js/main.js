/**
 * TSUZUKI CONNECT - Main Entry Point
 * Visual Novel Engine for Japanese Language Learning
 */

import { Game } from './engine/Game.js';
import { AudioManager } from './engine/AudioManager.js';
import { SaveManager } from './engine/SaveManager.js';
import { UIManager } from './engine/UIManager.js';
import { SceneManager } from './engine/SceneManager.js';
import { CharacterRenderer } from './graphics/CharacterRenderer.js';
import { BackgroundRenderer } from './graphics/BackgroundRenderer.js';
import { EffectsRenderer } from './graphics/EffectsRenderer.js';
import { KotobaLog } from './systems/KotobaLog.js';
import { I18n } from './systems/I18n.js';
import { AssetPreloader } from './systems/AssetPreloader.js';
import { getStory0 } from './stories/story0.js';
import { getStory1 } from './stories/story1.js';
import { getStory2 } from './stories/story2.js';
import { getStory3 } from './stories/story3.js';
import { getStory4 } from './stories/story4.js';
import { getStory5 } from './stories/story5.js';
import { getStory6 } from './stories/story6.js';
import { getStory7 } from './stories/story7.js';

// Wait for DOM to be ready
document.addEventListener('DOMContentLoaded', async () => {
    console.log('🌸 Tsuzuki Connect - Initializing...');

    // Initialize game instance
    const game = new Game({
        container: document.getElementById('game-container'),
        width: 1920,
        height: 1080
    });

    // Make game globally accessible for debugging
    window.game = game;

    // Initialize managers
    game.audio = new AudioManager();
    game.save = new SaveManager();
    game.ui = new UIManager(game);
    game.scene = new SceneManager(game);
    game.kotoba = new KotobaLog(game);
    game.kotoba.load();
    game.i18n = new I18n();
    window.i18n = game.i18n;
    // Global translation helper
    window.tr = (key, vars) => game.i18n.t(key, vars);

    // Initialize renderers
    game.characterRenderer = new CharacterRenderer(
        document.getElementById('characters-canvas'),
        game
    );
    game.backgroundRenderer = new BackgroundRenderer(
        document.getElementById('background-canvas'),
        game
    );
    game.effectsRenderer = new EffectsRenderer(
        document.getElementById('effects-canvas'),
        game
    );

    // Warm image caches ASAP for smooth in-game transitions
    const startPreload = () => {
        try {
            const preload = AssetPreloader.preloadCoreAssets({
                concurrency: 6,
                onProgress: ({ completed, total }) => {
                    if (completed === total) {
                        console.log(`🧩 Assets preloaded (${total} images)`);
                    }
                }
            });
            game.assets = { preload };
            window.preloadAssets = preload;
            preload.catch(() => { });
        } catch (e) {
            console.warn('Asset preloading failed to start:', e);
        }
    };
    if (typeof window.requestIdleCallback === 'function') {
        window.requestIdleCallback(startPreload, { timeout: 2000 });
    } else {
        setTimeout(startPreload, 0);
    }

    // Initialize UI event handlers
    initMenuHandlers(game);
    initGameHandlers(game);

    // Load and apply saved settings (including language)
    const savedSettings = game.save.loadSettings();
    if (savedSettings) {
        game.state.settings = { ...game.state.settings, ...savedSettings };
    }
    if (game.state.settings.playerName) {
        game.state.player = {
            name: game.state.settings.playerName,
            appearance: game.state.settings.playerAppearance || 0,
            reason: game.state.settings.playerReason || 'culture',
            level: game.state.settings.playerLevel || 'beginner'
        };
    }
    hydrateSettingsControls(game.state.settings);
    game.applySettings(game.state.settings);

    // Load stories after language/settings are applied so tr(...) resolves correctly.
    reloadStories(game);

    initSettingsHandlers(game);

    // Start menu music after user interaction (or immediately if supported)
    let musicStarted = false;
    const startMusic = async () => {
        if (!musicStarted) {
            musicStarted = true;
            try {
                await game.audio.init();
                game.audio.playMenuMusic();
            } catch (e) {
                console.log('Autoplay blocked, waiting for interaction', e);
                musicStarted = false; // allow retry on click
            }
        }
    };

    // Attempt autoplay immediately (WebView might allow it directly via mediaPlaybackRequiresUserGesture: false)
    startMusic();

    document.addEventListener('click', startMusic, { once: true });
    document.addEventListener('keydown', startMusic, { once: true });

    // Check for save data
    const hasSave = game.save.hasSaveData();
    if (hasSave) {
        document.getElementById('btn-continue').disabled = false;
        document.getElementById('btn-chapter-select').disabled = false;
        document.getElementById('btn-kotoba-log').disabled = false;
    }

    // Start menu particles
    game.effectsRenderer.startMenuParticles(document.getElementById('menu-particles'));

    console.log('🌸 Tsuzuki Connect - Ready!');
});

/**
 * Initialize main menu event handlers
 */
function initMenuHandlers(game) {
    // New Game
    document.getElementById('btn-new-game').addEventListener('click', () => {
        const hasProfileName = Boolean(game.state.settings.profileInitialized && game.state.settings.playerName?.trim());
        if (!hasProfileName) {
            game.ui.showScreen('character-creation');
            game.ui.initCharacterCreation();
            return;
        }

        game.startNewGame({
            name: game.state.settings.playerName,
            appearance: game.state.settings.playerAppearance || 0,
            reason: game.state.settings.playerReason || 'culture',
            level: game.state.settings.playerLevel || 'beginner'
        });
    });

    // Continue
    document.getElementById('btn-continue').addEventListener('click', () => {
        const saveData = game.save.loadGame('auto');
        if (saveData) {
            game.loadState(saveData);
            game.ui.showScreen('game-screen');
        }
    });

    // Chapter Select
    document.getElementById('btn-chapter-select').addEventListener('click', () => {
        game.ui.showChapterSelect();
    });

    // Kotoba Log
    document.getElementById('btn-kotoba-log').addEventListener('click', () => {
        game.ui.showKotobaLog();
    });

    // Settings
    document.getElementById('btn-settings').addEventListener('click', () => {
        game.ui.showModal('settings-modal');
    });

    // Credits
    document.getElementById('btn-credits').addEventListener('click', () => {
        game.ui.showModal('credits-modal');
    });


    // Character creation
    document.getElementById('btn-start-story').addEventListener('click', () => {
        const playerData = game.ui.getPlayerData();
        if (playerData.name) {
            game.startNewGame(playerData);
        } else {
            game.ui.showNotification(game.i18n?.t('runtime.name_required') ?? 'Please enter your name', 'info');
        }
    });
}

/**
 * Initialize game screen event handlers
 */
function initGameHandlers(game) {
    // Menu button
    document.getElementById('btn-menu').addEventListener('click', () => {
        game.ui.showModal('quick-menu');
    });

    // Quick settings
    document.getElementById('btn-quick-settings').addEventListener('click', () => {
        game.ui.showModal('settings-modal');
    });

    // Dialogue controls
    document.getElementById('btn-auto').addEventListener('click', () => {
        game.toggleAutoMode();
    });

    document.getElementById('btn-skip').addEventListener('click', () => {
        game.toggleSkipMode();
    });

    document.getElementById('btn-log').addEventListener('click', () => {
        game.ui.showTextLog();
    });

    document.getElementById('btn-toggle-translation').addEventListener('click', (e) => {
        e.stopPropagation();
        game.toggleTranslationDisplay();
        if (game.currentScreen === 'game-screen' && game.scene?.currentStory) {
            const scene = game.scene.currentStory.scenes[game.scene.currentSceneIndex];
            const line = scene?.lines?.[game.scene.currentLineIndex];
            if (line && (line.type === 'dialogue' || line.type === 'narration' || !line.type)) {
                game.scene.showDialogue(line);
            }
        }
    });

    document.getElementById('btn-toggle-transcription').addEventListener('click', (e) => {
        e.stopPropagation();
        game.toggleTranscriptionDisplay();
        if (game.currentScreen === 'game-screen' && game.scene?.currentStory) {
            const scene = game.scene.currentStory.scenes[game.scene.currentSceneIndex];
            const line = scene?.lines?.[game.scene.currentLineIndex];
            if (line && (line.type === 'dialogue' || line.type === 'narration' || !line.type)) {
                game.scene.showDialogue(line);
            }
        }
    });

    // Click/tap to advance
    document.getElementById('dialogue-box').addEventListener('click', () => {
        game.advanceDialogue();
    });

    // Keyboard controls
    document.addEventListener('keydown', (e) => {
        if (game.currentScreen !== 'game-screen') return;

        switch (e.key) {
            case ' ':
            case 'Enter':
                e.preventDefault();
                game.advanceDialogue();
                break;
            case 'Escape':
                game.ui.toggleModal('quick-menu');
                break;
            case 'a':
            case 'A':
                game.toggleAutoMode();
                break;
            case 's':
            case 'S':
                if (e.ctrlKey) {
                    e.preventDefault();
                    game.save.quickSave(game.getState());
                }
                break;
            case 'l':
            case 'L':
                game.ui.showTextLog();
                break;
        }
    });

    // Quick menu handlers
    document.getElementById('qm-save').addEventListener('click', () => {
        game.ui.hideModal('quick-menu');
        game.ui.showSaveLoad('save');
    });

    document.getElementById('qm-load').addEventListener('click', () => {
        game.ui.hideModal('quick-menu');
        game.ui.showSaveLoad('load');
    });

    document.getElementById('qm-log').addEventListener('click', () => {
        game.ui.hideModal('quick-menu');
        game.ui.showTextLog();
    });

    document.getElementById('qm-kotoba').addEventListener('click', () => {
        game.ui.hideModal('quick-menu');
        game.ui.showKotobaLog();
    });

    document.getElementById('qm-settings').addEventListener('click', () => {
        game.ui.hideModal('quick-menu');
        game.ui.showModal('settings-modal');
    });

    document.getElementById('qm-title').addEventListener('click', () => {
        const message = game.i18n?.t('runtime.confirm.return_to_title') ?? 'Return to title? Unsaved progress will be lost.';
        if (confirm(message)) {
            game.ui.hideModal('quick-menu');
            game.returnToTitle();
        }
    });

    document.getElementById('qm-return').addEventListener('click', () => {
        game.ui.hideModal('quick-menu');
    });

    // Modal close handlers
    document.getElementById('settings-close').addEventListener('click', () => {
        game.ui.hideModal('settings-modal');
        game.saveSettings();
        reloadStories(game);
    });

    document.getElementById('credits-close').addEventListener('click', () => {
        game.ui.hideModal('credits-modal');
    });

    document.getElementById('log-close').addEventListener('click', () => {
        game.ui.hideModal('text-log-modal');
    });

    document.getElementById('save-load-close').addEventListener('click', () => {
        game.ui.hideModal('save-load-modal');
    });

    document.getElementById('chapter-select-close').addEventListener('click', () => {
        game.ui.hideModal('chapter-select-modal');
    });

    document.getElementById('kotoba-close').addEventListener('click', () => {
        game.ui.hideModal('kotoba-modal');
    });

    document.getElementById('vocab-close').addEventListener('click', () => {
        game.ui.hideVocabPopup();
    });

    // Lesson screen handlers
    document.getElementById('skip-lesson').addEventListener('click', () => {
        game.skipLesson();
    });

    document.getElementById('lesson-continue').addEventListener('click', () => {
        game.advanceLesson();
    });
}

function hydrateSettingsControls(settings) {
    const playerNameEl = document.getElementById('setting-player-name');
    if (playerNameEl) playerNameEl.value = settings.playerName || '';

    const language = settings.language || 'en';

    const languageEl = document.getElementById('setting-language');
    if (languageEl) languageEl.value = language;

    const textSpeedEl = document.getElementById('setting-text-speed');
    if (textSpeedEl && settings.textSpeed) textSpeedEl.value = settings.textSpeed;

    const fontSizeEl = document.getElementById('setting-font-size');
    if (fontSizeEl && settings.fontSize) fontSizeEl.value = settings.fontSize;

    const subtitlesEl = document.getElementById('setting-subtitles');
    if (subtitlesEl) subtitlesEl.checked = settings.showSubtitles ?? true;

    if (typeof settings.showTranslation !== 'boolean') settings.showTranslation = true;
    if (typeof settings.showTranscription !== 'boolean') settings.showTranscription = true;

    const furiganaEl = document.getElementById('setting-furigana');
    if (furiganaEl && settings.furigana) furiganaEl.value = settings.furigana;

    const masterVolEl = document.getElementById('setting-master-vol');
    if (masterVolEl && typeof settings.masterVolume === 'number') masterVolEl.value = String(settings.masterVolume);

    const musicVolEl = document.getElementById('setting-music-vol');
    if (musicVolEl && typeof settings.musicVolume === 'number') musicVolEl.value = String(settings.musicVolume);

    const sfxVolEl = document.getElementById('setting-sfx-vol');
    if (sfxVolEl && typeof settings.sfxVolume === 'number') sfxVolEl.value = String(settings.sfxVolume);
}

function initSettingsHandlers(game) {
    const languageEl = document.getElementById('setting-language');
    if (!languageEl) return;

    languageEl.addEventListener('change', () => {
        game.saveSettings();
        reloadStories(game);
    });
}

function reloadStories(game) {
    const currentStoryId = game.state.currentStory;

    // Reload story definitions
    game.scene.loadStory('story0', getStory0());
    game.scene.loadStory('story1', getStory1());
    game.scene.loadStory('story2', getStory2());
    game.scene.loadStory('story3', getStory3());
    game.scene.loadStory('story4', getStory4());
    game.scene.loadStory('story5', getStory5());
    game.scene.loadStory('story6', getStory6());
    game.scene.loadStory('story7', getStory7());

    // If we are currently IN a story, we need to update the reference and refresh the screen
    if (game.currentScreen === 'game-screen' && game.scene.currentStory && game.state.currentStory === currentStoryId) {
        // Update reference
        game.scene.currentStory = game.scene.stories[currentStoryId];

        // Refresh current line
        const scene = game.scene.currentStory.scenes[game.scene.currentSceneIndex];
        if (scene) {
            const line = scene.lines[game.scene.currentLineIndex];
            if (line) {
                // Determine type and re-render
                if (line.type === 'dialogue' || line.type === 'narration' || !line.type) {
                    game.scene.showDialogue(line);
                } else if (line.type === 'choice') {
                    game.scene.showChoices(line);
                }
            }
        }
    }
}
