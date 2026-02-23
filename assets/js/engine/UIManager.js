/**
 * TSUZUKI CONNECT - UI Manager
 * Handles all UI interactions and screen management
 */

export class UIManager {
    constructor(game) {
        this.game = game;
        this.currentScreen = 'main-menu';
        this.activeModal = null;
        this.playerData = {
            name: '',
            appearance: 0,
            reason: 'culture',
            level: 'beginner'
        };

        // Listen for subscription status changes
        window.addEventListener('subscriptionStatusUnlocked', (e) => {
            if (this.activeModal === 'chapter-select-modal') {
                this.showChapterSelect();
            }
        });
    }

    /**
     * Show a screen with transition
     */
    showScreen(screenId) {
        // Hide current screen
        const currentScreen = document.querySelector('.screen.active');
        if (currentScreen) {
            currentScreen.classList.remove('active');
            currentScreen.classList.add('fade-out');

            setTimeout(() => {
                currentScreen.classList.remove('fade-out');
            }, 500);
        }

        // Show new screen
        const newScreen = document.getElementById(screenId);
        if (newScreen) {
            setTimeout(() => {
                newScreen.classList.add('active', 'fade-in');
                this.currentScreen = screenId;
                this.game.currentScreen = screenId;

                setTimeout(() => {
                    newScreen.classList.remove('fade-in');
                }, 500);
            }, 300);
        }
    }

    /**
     * Initialize character creation screen
     */
    initCharacterCreation() {
        // Setup reason buttons
        document.querySelectorAll('.reason-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                document.querySelectorAll('.reason-btn').forEach(b => b.classList.remove('selected'));
                btn.classList.add('selected');
                this.playerData.reason = btn.dataset.reason;
            });
        });

        // Setup level buttons
        document.querySelectorAll('.level-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                document.querySelectorAll('.level-btn').forEach(b => b.classList.remove('selected'));
                btn.classList.add('selected');
                this.playerData.level = btn.dataset.level;
            });
        });

        // Select defaults
        document.querySelector('.reason-btn').classList.add('selected');
        document.querySelector('.level-btn').classList.add('selected');
    }

    /**
     * Get player creation data
     */
    getPlayerData() {
        return {
            name: document.getElementById('player-name').value.trim(),
            appearance: this.playerData.appearance,
            reason: this.playerData.reason,
            level: this.playerData.level
        };
    }

    /**
     * Show a modal
     */
    showModal(modalId) {
        const modal = document.getElementById(modalId);
        if (modal) {
            modal.classList.remove('hidden');
            this.activeModal = modalId;
        }
    }

    /**
     * Hide a modal
     */
    hideModal(modalId) {
        const modal = document.getElementById(modalId);
        if (modal) {
            modal.classList.add('hidden');
            if (this.activeModal === modalId) {
                this.activeModal = null;
            }
        }
    }

    /**
     * Toggle a modal
     */
    toggleModal(modalId) {
        const modal = document.getElementById(modalId);
        if (modal.classList.contains('hidden')) {
            this.showModal(modalId);
        } else {
            this.hideModal(modalId);
        }
    }

    /**
     * Update scene indicator
     */
    updateSceneIndicator(storyTitle, sceneNum, totalScenes) {
        const indicator = document.getElementById('scene-indicator');
        if (!indicator) return;
        // Hide scene indicator text entirely.
        indicator.textContent = '';
    }

    /**
     * Update auto mode button state
     */
    updateAutoButton(active) {
        const btn = document.getElementById('btn-auto');
        btn.classList.toggle('active', active);
    }

    /**
     * Update skip mode button state
     */
    updateSkipButton(active) {
        const btn = document.getElementById('btn-skip');
        btn.classList.toggle('active', active);
    }

    /**
     * Show text log modal
     */
    showTextLog() {
        const container = document.getElementById('text-log-entries');
        container.innerHTML = '';

        this.game.textLog.forEach(entry => {
            const div = document.createElement('div');
            div.className = 'log-entry';
            div.innerHTML = `
                ${entry.speaker ? `<div class="log-entry-speaker">${entry.speaker}</div>` : ''}
                <div class="log-entry-japanese">${entry.japanese}</div>
                ${entry.english ? `<div class="log-entry-english">${entry.english}</div>` : ''}
            `;
            container.appendChild(div);
        });

        // Scroll to bottom
        container.scrollTop = container.scrollHeight;

        this.showModal('text-log-modal');
    }

    /**
     * Show save/load modal
     */
    showSaveLoad(mode) {
        const title = document.getElementById('save-load-title');
        const container = document.getElementById('save-slots');

        title.textContent = mode === 'save'
            ? (this.game.i18n?.t('runtime.save.title.save') ?? 'Save Game')
            : (this.game.i18n?.t('runtime.save.title.load') ?? 'Load Game');
        container.innerHTML = '';

        // Auto-save slot
        const autoSave = this.game.save.loadGame('auto');
        this.createSaveSlot(
            container,
            'auto',
            autoSave,
            mode,
            this.game.i18n?.t('runtime.save.label.auto') ?? 'Auto-Save'
        );

        // Manual slots
        for (let i = 1; i <= 6; i++) {
            const saveData = this.game.save.loadGame(`slot${i}`);
            this.createSaveSlot(
                container,
                `slot${i}`,
                saveData,
                mode,
                this.game.i18n?.t('runtime.save.label.slot', { n: i }) ?? `Slot ${i}`
            );
        }

        this.showModal('save-load-modal');
    }

    /**
     * Create a save slot element
     */
    createSaveSlot(container, slotId, saveData, mode, label) {
        const div = document.createElement('div');
        div.className = 'save-slot' + (saveData ? '' : ' empty');

        if (saveData) {
            const date = new Date(saveData.timestamp);
            const playtime = this.formatPlaytime(saveData.state.playtime);
            const actionLabel = mode === 'save'
                ? (this.game.i18n?.t('runtime.save.action.save') ?? 'Save')
                : (this.game.i18n?.t('runtime.save.action.load') ?? 'Load');
            const deleteLabel = this.game.i18n?.t('runtime.save.action.delete') ?? 'Delete';

            div.innerHTML = `
                <div class="save-slot-preview">
                    <canvas width="80" height="45"></canvas>
                </div>
                <div class="save-slot-info">
                    <div class="save-slot-title">${label}</div>
                    <div class="save-slot-details">
                        ${saveData.state.currentStory} - ${(this.game.i18n?.t('runtime.scene') ?? 'Scene')} ${saveData.state.currentScene + 1}<br>
                        ${date.toLocaleDateString()} ${date.toLocaleTimeString()} - ${playtime}
                    </div>
                </div>
                <div class="save-slot-actions">
                    <button class="save-slot-btn">${actionLabel}</button>
                    ${slotId !== 'auto' && saveData ? `<button class="save-slot-btn delete">${deleteLabel}</button>` : ''}
                </div>
            `;

            // Load screenshot preview
            if (saveData.screenshot) {
                const canvas = div.querySelector('canvas');
                const ctx = canvas.getContext('2d');
                const img = new Image();
                img.onload = () => ctx.drawImage(img, 0, 0, 80, 45);
                img.src = saveData.screenshot;
            }

            // Add event listeners
            const actionBtn = div.querySelector('.save-slot-btn:not(.delete)');
            actionBtn.addEventListener('click', (e) => {
                e.stopPropagation();
                if (mode === 'save') {
                    this.game.save.saveGame(slotId, this.game.getState());
                    this.showNotification(this.game.i18n?.t('runtime.saved') ?? 'Game saved!', 'success');
                    this.showSaveLoad(mode); // Refresh
                } else {
                    this.game.loadState(saveData);
                    this.hideModal('save-load-modal');
                    this.showScreen('game-screen');
                }
            });

            const deleteBtn = div.querySelector('.delete');
            if (deleteBtn) {
                deleteBtn.addEventListener('click', (e) => {
                    e.stopPropagation();
                    const message = this.game.i18n?.t('runtime.confirm.delete_save') ?? 'Delete this save?';
                    if (confirm(message)) {
                        this.game.save.deleteSave(slotId);
                        this.showSaveLoad(mode);
                    }
                });
            }
        } else {
            div.innerHTML = `
                <div class="save-slot-info">
                    <div class="save-slot-title">${label}</div>
                    <div class="save-slot-details">${this.game.i18n?.t('runtime.save.empty') ?? 'Empty Slot'}</div>
                </div>
            `;

            if (mode === 'save') {
                div.style.cursor = 'pointer';
                div.addEventListener('click', () => {
                    this.game.save.saveGame(slotId, this.game.getState());
                    this.showNotification(this.game.i18n?.t('runtime.saved') ?? 'Game saved!', 'success');
                    this.showSaveLoad(mode);
                });
            }
        }

        container.appendChild(div);
    }

    /**
     * Format playtime for display
     */
    formatPlaytime(seconds) {
        const hours = Math.floor(seconds / 3600);
        const minutes = Math.floor((seconds % 3600) / 60);
        return `${hours}h ${minutes}m`;
    }

    /**
     * Show Kotoba Log modal
     */
    showKotobaLog() {
        const container = document.getElementById('kotoba-entries');
        container.innerHTML = '';

        const words = this.game.kotoba.getAllWords();

        if (words.length === 0) {
            const message = this.game.i18n?.t('runtime.kotoba.none') ?? 'No words learned yet!';
            container.innerHTML = `<p style="text-align:center;color:#a67c52;padding:40px;">${message}</p>`;
        } else {
            words.forEach(word => {
                const div = document.createElement('div');
                div.className = 'kotoba-entry';
                div.innerHTML = `
                    <div class="kotoba-word">${word.japanese}</div>
                    <div class="kotoba-reading">${word.reading || word.romaji || ''}</div>
                    <div class="kotoba-meaning">${word.english}</div>
                    <div class="kotoba-mastery">${'⭐'.repeat(word.mastery || 1)}${'☆'.repeat(4 - (word.mastery || 1))}</div>
                `;

                div.addEventListener('click', () => {
                    this.showVocabPopup(word, div);
                });

                container.appendChild(div);
            });
        }

        // Setup tab switching
        document.querySelectorAll('.kotoba-tab').forEach(tab => {
            tab.addEventListener('click', () => {
                document.querySelectorAll('.kotoba-tab').forEach(t => t.classList.remove('active'));
                tab.classList.add('active');
                // TODO: Filter by tab type
            });
        });

        this.showModal('kotoba-modal');
    }

    /**
     * Show chapter select
     */
    showChapterSelect() {
        const modalId = 'chapter-select-modal';
        const container = document.getElementById('chapter-select-list');
        if (!container) {
            this.showNotification(this.game.i18n?.t('runtime.chapter_select.invalid') ?? 'Selected chapter is unavailable.', 'info');
            return;
        }

        const chapters = Object.entries(this.game.scene.stories || {})
            .map(([storyId, story]) => ({
                storyId,
                story,
                number: Number.parseInt(String(storyId).replace('story', ''), 10)
            }))
            .filter((entry) => Number.isFinite(entry.number))
            .sort((a, b) => a.number - b.number);

        const chapterLabel = this.game.i18n?.t('runtime.chapter_select.chapter') ?? 'Chapter';
        const startLabel = this.game.i18n?.t('runtime.chapter_select.start') ?? 'Start';
        const lockedLabel = this.game.i18n?.t('runtime.chapter_select.locked') ?? 'Locked';
        const timeLabel = this.game.i18n?.t('runtime.chapter_select.time') ?? 'Time';
        const jlptLabel = this.game.i18n?.t('runtime.chapter_select.jlpt') ?? 'JLPT';

        container.innerHTML = '';

        chapters.forEach(({ storyId, story, number }) => {
            const unlocked = this.game.isStoryAccessible ? this.game.isStoryAccessible(storyId) : true;
            const card = document.createElement('div');
            card.className = `chapter-card${unlocked ? '' : ' locked'}`;
            card.dataset.storyId = storyId;
            card.dataset.unlocked = unlocked ? '1' : '0';

            const subtitle = story.titleJp ? `<div class="chapter-subtitle">${story.titleJp}</div>` : '';
            const estimatedTime = story.estimatedTime ? `<span>${timeLabel}: ${story.estimatedTime}</span>` : '';
            const jlptFocus = story.jlptFocus ? `<span>${jlptLabel}: ${story.jlptFocus}</span>` : '';
            const meta = (estimatedTime || jlptFocus)
                ? `<div class="chapter-meta">${[estimatedTime, jlptFocus].filter(Boolean).join(' • ')}</div>`
                : '';
            const action = unlocked
                ? `<button class="chapter-open-btn" data-story-id="${storyId}">${startLabel}</button>`
                : '';

            card.innerHTML = `
                <div class="chapter-card-header">
                    <div class="chapter-number">${chapterLabel} ${number}</div>
                    ${!unlocked ? `<div class="chapter-lock">${lockedLabel}</div>` : ''}
                </div>
                <div class="chapter-title">${story.title || `${chapterLabel} ${number}`}</div>
                ${subtitle}
                ${meta}
                ${action}
            `;
            container.appendChild(card);
        });

        container.querySelectorAll('.chapter-open-btn').forEach((btn) => {
            btn.addEventListener('click', () => {
                const storyId = btn.dataset.storyId;
                this.hideModal(modalId);
                this.game.startChapter(storyId);
            });
        });

        container.querySelectorAll('.chapter-card.locked').forEach((card) => {
            card.addEventListener('click', () => {
                this.showNotification(this.game.getStoryAccessDeniedMessage?.() ?? 'This chapter is currently locked.', 'info');
            });
        });

        this.showModal(modalId);
    }

    getHighestUnlockedChapter() {
        // Story 0 is always available when chapter select is enabled.
        let highest = 0;
        const saves = this.game.save?.getAllSaves?.() || {};
        Object.values(saves).forEach((saveData) => {
            const storyId = saveData?.state?.currentStory;
            const match = typeof storyId === 'string' ? /story(\d+)/.exec(storyId) : null;
            if (match) {
                highest = Math.max(highest, Number.parseInt(match[1], 10));
            }
        });
        return highest;
    }

    /**
     * Show vocabulary popup
     */
    showVocabPopup(vocab, anchorEl) {
        const popup = document.getElementById('vocab-popup');

        document.getElementById('vocab-word').textContent = vocab.japanese;
        document.getElementById('vocab-reading').textContent = vocab.reading || vocab.romaji || '';
        document.getElementById('vocab-meaning').textContent = vocab.english;

        // Position popup near anchor
        if (anchorEl) {
            const rect = anchorEl.getBoundingClientRect();
            popup.style.left = `${rect.left + rect.width / 2 - 150}px`;
            popup.style.top = `${rect.top - 10}px`;
        }

        popup.classList.remove('hidden');
    }

    /**
     * Hide vocabulary popup
     */
    hideVocabPopup() {
        document.getElementById('vocab-popup').classList.add('hidden');
    }

    /**
     * Show notification for new vocabulary
     */
    showVocabNotification(vocab) {
        const message = this.game.i18n?.t('runtime.vocab.new_word', { jp: vocab.japanese, en: vocab.english })
            ?? `New word: ${vocab.japanese} - ${vocab.english}`;
        this.showNotification(message, 'success');
        this.game.audio.playSFX('vocab');
    }

    /**
     * Show a notification toast
     */
    showNotification(message, type = 'info') {
        const notification = document.createElement('div');
        notification.className = `notification ${type}`;
        notification.innerHTML = `
            <div class="notification-title">${type === 'success' ? '✓' : 'ℹ'}</div>
            <div class="notification-text">${message}</div>
        `;

        document.getElementById('game-container').appendChild(notification);

        setTimeout(() => {
            notification.remove();
        }, 3500);
    }

    /**
     * Show story completion screen
     */
    showStoryComplete(data) {
        const titleText = this.game.i18n?.t('runtime.story_complete.title') ?? 'Story Complete!';
        const timePlayedText = this.game.i18n?.t('runtime.story_complete.time_played', { time: data.playtime })
            ?? `Time Played: ${data.playtime}`;
        const wordsLearnedText = this.game.i18n?.t('runtime.story_complete.words_learned', { count: data.vocabLearned })
            ?? `New Words Learned: ${data.vocabLearned}`;
        const praiseText = this.game.i18n?.t('runtime.story_complete.praise') ?? 'Great progress!';
        const mainMenuText = this.game.i18n?.t('runtime.story_complete.main_menu') ?? 'Main Menu';
        const nextStoryText = this.game.i18n?.t('runtime.story_complete.next_story') ?? 'Next Story';
        const continuedText = this.game.i18n?.t('runtime.story_complete.more_coming') ?? 'More stories will continue.';
        const hasNextStory = Boolean(data.nextStoryId);
        const nextStoryAccessible = hasNextStory
            ? (this.game.isStoryAccessible ? this.game.isStoryAccessible(data.nextStoryId) : true)
            : false;

        // Build action buttons based on access
        let actionsHtml = '';
        if (hasNextStory && nextStoryAccessible) {
            actionsHtml = `<button class="modal-close story-complete-next" id="complete-next">${nextStoryText}${data.nextStoryTitle ? `: ${data.nextStoryTitle}` : ''}</button>`;
        } else if (hasNextStory && !nextStoryAccessible) {
            actionsHtml = `
                <button id="complete-unlock" style="
                    background: linear-gradient(135deg, #7c4dff 0%, #e040fb 100%);
                    color: #fff; border: none; border-radius: 14px;
                    padding: 16px 32px; font-size: 17px; font-weight: 700;
                    cursor: pointer; letter-spacing: 0.3px;
                    box-shadow: 0 4px 24px rgba(124,77,255,0.45);
                    display: flex; align-items: center; gap: 10px;
                    width: 100%; justify-content: center;
                    transition: transform 0.15s, box-shadow 0.15s;
                ">
                    <span style="font-size:20px;">⭐</span> Unlock All Stories
                </button>
                <p style="font-size:12px;color:#a07fd4;margin:6px 0 4px;">One-time purchase &middot; All 8 chapters</p>
            `;
        }

        const overlay = document.createElement('div');
        overlay.className = 'modal';
        overlay.innerHTML = `
            <div class="modal-content" style="text-align:center;">
                <h2>${titleText}</h2>
                <p style="font-size:24px;color:#a67c52;margin:20px 0;">${data.title}</p>
                <p>${timePlayedText}</p>
                <p>${wordsLearnedText}</p>
                <p style="margin-top:20px;color:#94b49f;">🎓 ${praiseText}</p>
                ${!hasNextStory ? `<p class="story-complete-note">${continuedText}</p>` : ''}
                <div class="story-complete-actions" style="display:flex;flex-direction:column;align-items:center;gap:8px;margin-top:24px;">
                    ${actionsHtml}
                    <button class="modal-close" id="complete-main-menu" style="margin-top:4px;">${mainMenuText}</button>
                </div>
            </div>
        `;

        document.getElementById('game-container').appendChild(overlay);

        const nextBtn = document.getElementById('complete-next');
        if (nextBtn) {
            nextBtn.addEventListener('click', () => {
                overlay.remove();
                this.game.startChapter(data.nextStoryId);
            });
        }

        const unlockBtn = document.getElementById('complete-unlock');
        if (unlockBtn) {
            unlockBtn.addEventListener('mouseenter', () => {
                unlockBtn.style.transform = 'translateY(-2px)';
                unlockBtn.style.boxShadow = '0 8px 32px rgba(124,77,255,0.6)';
            });
            unlockBtn.addEventListener('mouseleave', () => {
                unlockBtn.style.transform = '';
                unlockBtn.style.boxShadow = '0 4px 24px rgba(124,77,255,0.45)';
            });
            unlockBtn.addEventListener('click', () => {
                if (window.flutter_inappwebview) {
                    // Start waiting for the purchase to complete
                    const onSubscribed = (e) => {
                        if (!e.detail?.isSubscribed) return;

                        const actionsDiv = overlay.querySelector('.story-complete-actions');
                        if (!actionsDiv) return;

                        // Fade out unlock button and hint text
                        const hint = unlockBtn.nextElementSibling;
                        unlockBtn.style.transition = 'opacity 0.3s, transform 0.3s';
                        unlockBtn.style.opacity = '0';
                        unlockBtn.style.transform = 'scale(0.9)';
                        if (hint) {
                            hint.style.transition = 'opacity 0.3s';
                            hint.style.opacity = '0';
                        }

                        setTimeout(() => {
                            // Remove old elements
                            unlockBtn.remove();
                            if (hint) hint.remove();

                            // Build and inject Next Story button
                            const label = nextStoryText + (data.nextStoryTitle ? `: ${data.nextStoryTitle}` : '');
                            const newBtn = document.createElement('button');
                            newBtn.className = 'modal-close story-complete-next';
                            newBtn.id = 'complete-next-unlocked';
                            newBtn.textContent = label;
                            newBtn.style.cssText = `
                                opacity: 0; transform: scale(0.9);
                                transition: opacity 0.35s, transform 0.35s;
                            `;

                            // Insert before main-menu button
                            const mainMenuBtn = actionsDiv.querySelector('#complete-main-menu');
                            actionsDiv.insertBefore(newBtn, mainMenuBtn);

                            // Trigger fade-in
                            requestAnimationFrame(() => {
                                requestAnimationFrame(() => {
                                    newBtn.style.opacity = '1';
                                    newBtn.style.transform = 'scale(1)';
                                });
                            });

                            newBtn.addEventListener('click', () => {
                                overlay.remove();
                                this.game.startChapter(data.nextStoryId);
                            });
                        }, 320);
                    };

                    window.addEventListener('subscriptionStatusUnlocked', onSubscribed, { once: true });
                    window.flutter_inappwebview.callHandler('showPurchaseDialog');
                }
            });
        }

        document.getElementById('complete-main-menu').addEventListener('click', () => {
            overlay.remove();
            this.game.returnToTitle();
        });
    }

    /**
     * Show story title card
     * @param {string} title - Main title
     * @param {string} subtitle - Subtitle (optional)
     * @param {number} duration - How long to stay visible before fading out in ms
     */
    showTitleCard(title, subtitle, duration = 3000) {
        const card = document.getElementById('story-title-card');
        const titleEl = document.getElementById('card-main-title');
        const subtitleEl = document.getElementById('card-sub-title');

        if (card && titleEl && subtitleEl) {
            titleEl.textContent = title;
            subtitleEl.textContent = subtitle || '';

            // Show
            card.classList.remove('hidden');

            // Hide after duration
            setTimeout(() => {
                card.classList.add('hidden');
            }, duration);
        }
    }
}
