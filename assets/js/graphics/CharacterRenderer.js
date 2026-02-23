/**
 * TSUZUKI CONNECT - Character Renderer
 * Manages and renders characters using individual character specialized classes
 * Features smooth animations, transitions, and visual effects
 */

import { Ken } from './characters/Ken.js';
import { Mei } from './characters/Mei.js';
import { Yuki } from './characters/Yuki.js';
import { Tanaka } from './characters/Tanaka.js';
import { Player } from './characters/Player.js';
import { Father } from './characters/Father.js';
import { Mother } from './characters/Mother.js';
import { Grandpa } from './characters/Grandpa.js';
import { Grandma } from './characters/Grandma.js';
import { LittleBoy } from './characters/LittleBoy.js';
import { LittleGirl } from './characters/LittleGirl.js';
import { CharacterAssets } from './characters/CharacterAssets.js';

export class CharacterRenderer {
    constructor(canvas, game) {
        this.canvas = canvas;
        this.ctx = canvas.getContext('2d');
        this.game = game;

        // Register callback for character image loading (force redraw)
        CharacterAssets.setLoadCallback(() => {
            // Can trigger a redraw here if needed, animation loop will likely handle it
        });

        // Set canvas size
        this.canvas.width = 1920;
        this.canvas.height = 1080;

        // Active characters on screen
        this.characters = [];
        this.highlightedCharacter = null;

        // Initialize character renderers
        this.renderers = {
            'ken': new Ken(game),
            'mei': new Mei(game),
            'yuki': new Yuki(game),
            'tanaka': new Tanaka(game),
            'player': new Player(game),
            'father': new Father(game),
            'mother': new Mother(game),
            'grandpa': new Grandpa(game),
            'grandma': new Grandma(game),
            'little_boy': new LittleBoy(game),
            'little_girl': new LittleGirl(game)
        };

        // Character aliases for anthology stories (maps alias to renderer key)
        this.aliases = {
            'sora': 'ken',      // Story 1: Exchange Partner (uses Ken's appearance)
            'rina': 'mei',      // Story 1: Potential side character
            'hana': 'yuki',     // Story 2: Gardener's Daughter
            'kana': 'yuki',     // Story 3: The Video Call (Partner)
            'grandfather': 'grandpa',
            'grandmother': 'grandma',
            'mom': 'mother',
            'server': 'mei',    // Generic server/NPC
            'daichi': 'ken',    // Story 2 support cast
            'obaachan': 'grandma',
            'mika': 'mei',
            // Story 4 support cast
            'junko': 'tanaka',
            'tetsu': 'grandpa',
            'mimi': 'mei',
            'yamada': 'father',
            'junko_young': 'yuki',
            'saito': 'grandpa',
            // Story 5 support cast
            'yamamoto': 'grandma',
            'pharmacist': 'mei',
            'david': 'father',
            'yuko': 'mother',
            'kenta': 'little_boy',
            'dr_ito': 'tanaka',
            'nurse_akemi': 'mei',
            'fujita': 'ken',
            'obaa': 'grandma',
            'tanaka_toru': 'grandpa',
            'class_members': 'ken',
            // Story 6 support cast
            'ueda': 'ken',
            'nakamura_child': 'little_girl',
            'ishii': 'tanaka',
            'rachel': 'yuki',
            // Story 7 support cast
            'sota': 'ken',
            'cafe_owner': 'mother',
            'nishimura': 'tanaka',
            'bartender_yuna': 'yuki',
            'reading_woman': 'mei',
            'yamamoto_curry': 'grandpa'
        };

        // Display names for canonical characters and aliases
        this.displayNames = {
            ken: 'Ken',
            mei: 'Mei',
            yuki: 'Yuki',
            tanaka: 'Tanaka-sensei',
            player: 'You',
            father: 'Father',
            mother: 'Mother',
            grandpa: 'Grandpa',
            grandma: 'Grandma',
            little_boy: 'Boy',
            little_girl: 'Girl',
            sora: 'Sora',
            rina: 'Rina',
            hana: 'Hana',
            kana: 'Kana',
            grandfather: 'Grandfather',
            grandmother: 'Grandmother',
            mom: 'Mom',
            server: 'Server',
            daichi: 'Daichi',
            obaachan: 'Obaachan',
            mika: 'Mika',
            junko: 'Junko',
            tetsu: 'Tetsu',
            mimi: 'Mimi',
            yamada: 'Yamada',
            junko_young: 'Junko (Young)',
            saito: 'Saito',
            yamamoto: 'Yamamoto',
            pharmacist: 'Pharmacist',
            david: 'David',
            yuko: 'Yuko',
            kenta: 'Kenta',
            dr_ito: 'Dr. Ito',
            nurse_akemi: 'Nurse Akemi',
            fujita: 'Fujita',
            obaa: 'Obaa',
            tanaka_toru: 'Tanaka Toru',
            class_members: 'Class Members',
            ueda: 'Ueda',
            nakamura_child: 'Nakamura Child',
            ishii: 'Ishii',
            rachel: 'Rachel',
            sota: 'Sota',
            cafe_owner: 'Cafe Owner',
            nishimura: 'Nishimura',
            bartender_yuna: 'Bartender Yuna',
            reading_woman: 'Reading Woman',
            yamamoto_curry: 'Mr. Yamamoto'
        };

        // Screen positions (horizontal ratio)
        this.positions = {
            'left': 0.25,
            'center': 0.5,
            'right': 0.75,
            'far-left': 0.15,
            'far-right': 0.85
        };

        // Animation state
        this.animationFrame = 0;
        this.breathingOffset = 0;
        this.lastFrameTime = 0;

        // Visual effects settings
        this.settings = {
            fadeInSpeed: 0.04,      // Alpha increase per frame
            fadeOutSpeed: 0.06,     // Alpha decrease per frame
            breathingSpeed: 0.025,  // Breathing animation speed
            breathingAmount: 2.5,   // Breathing amplitude in pixels
            dimAmount: 0.65,        // Non-highlighted character opacity
            slideSpeed: 0.08        // Position slide speed (for future animations)
        };

        // Start animation loop
        this.animate();
    }

    /**
     * Set characters on screen (batch operation)
     */
    setCharacters(characters) {
        this.characters = characters
            .filter(char => char.id !== 'player') // Explicitly exclude player character from scene
            .map(char => ({
                id: char.id,
                position: char.position || 'center',
                expression: char.expression || 'neutral',
                entering: true,
                exiting: false,
                alpha: 0,
                targetX: this.positions[char.position || 'center'],
                currentX: this.positions[char.position || 'center']
            }));
        this.render();
    }

    /**
     * Add a character to the screen
     */
    addCharacter(characterId, position = 'center', expression = 'neutral') {
        // Resolve alias to check if it's a valid character
        const resolvedId = this.resolveCharacterId(characterId);

        // Explicitly exclude player character from scene
        if (resolvedId === 'player') return;

        // Check if renderer exists for this character
        if (!this.renderers[resolvedId]) {
            console.warn(`No renderer for character: ${characterId} (resolved: ${resolvedId})`);
            return;
        }

        const existing = this.characters.find(c => c.id === characterId);

        if (existing) {
            // Update existing character
            existing.position = position;
            existing.expression = expression;
            existing.exiting = false;
            existing.targetX = this.positions[position];

            // If fully visible, just update position
            if (existing.alpha >= 1) {
                existing.alpha = 1;
                existing.entering = false;
            }
        } else {
            // Add new character (keep original ID for tracking, renderer uses alias)
            this.characters.push({
                id: characterId,
                position: position,
                expression: expression,
                entering: true,
                exiting: false,
                alpha: 0,
                targetX: this.positions[position],
                currentX: this.positions[position]
            });
        }

        this.render();
    }

    /**
     * Remove a character from screen (with fade out)
     */
    removeCharacter(characterId) {
        const char = this.characters.find(c => c.id === characterId);
        if (char) {
            char.exiting = true;
            char.entering = false;
        }
    }

    /**
     * Alias for removeCharacter
     */
    hideCharacter(characterId) {
        this.removeCharacter(characterId);
    }

    /**
     * Hide all characters (with fade out)
     */
    hideAllCharacters() {
        this.characters.forEach(char => {
            char.exiting = true;
            char.entering = false;
        });
    }

    /**
     * Move a character to a new position
     */
    moveCharacter(characterId, newPosition) {
        const char = this.characters.find(c => c.id === characterId);
        if (char) {
            char.position = newPosition;
            char.targetX = this.positions[newPosition];
            this.render();
        }
    }

    /**
     * Set character expression
     */
    setExpression(characterId, expression) {
        const char = this.characters.find(c => c.id === characterId);
        if (char) {
            char.expression = expression;
            this.render();
        }
    }

    /**
     * Highlight speaking character (dims others)
     */
    highlightCharacter(characterId) {
        this.highlightedCharacter = characterId;
        this.render();
    }

    /**
     * Clear highlight (all characters at full brightness)
     */
    clearHighlight() {
        this.highlightedCharacter = null;
        this.render();
    }

    /**
     * Main animation loop
     */
    animate(currentTime = 0) {
        // Calculate delta time for smooth animations
        const deltaTime = currentTime - this.lastFrameTime;
        this.lastFrameTime = currentTime;

        this.animationFrame++;

        // Smooth breathing animation
        this.breathingOffset = Math.sin(this.animationFrame * this.settings.breathingSpeed) *
            this.settings.breathingAmount;

        let needsRender = false;

        // Update character states
        this.characters.forEach(char => {
            // Fade in animation
            if (char.entering && char.alpha < 1) {
                char.alpha = Math.min(1, char.alpha + this.settings.fadeInSpeed);
                needsRender = true;
                if (char.alpha >= 1) {
                    char.entering = false;
                }
            }

            // Fade out animation
            if (char.exiting) {
                char.alpha = Math.max(0, char.alpha - this.settings.fadeOutSpeed);
                needsRender = true;
            }

            // Position slide animation (smooth movement)
            if (char.currentX !== char.targetX) {
                const diff = char.targetX - char.currentX;
                if (Math.abs(diff) < 0.01) {
                    char.currentX = char.targetX;
                } else {
                    char.currentX += diff * this.settings.slideSpeed;
                    needsRender = true;
                }
            }
        });

        // Remove fully faded out characters
        const previousCount = this.characters.length;
        this.characters = this.characters.filter(c => !c.exiting || c.alpha > 0);

        if (this.characters.length !== previousCount) {
            needsRender = true;
        }

        // Render if needed or on breathing frame update
        if (needsRender || this.animationFrame % 2 === 0) {
            this.render();
        }

        requestAnimationFrame((time) => this.animate(time));
    }

    /**
     * Render all characters to canvas
     */
    render() {
        // Clear canvas
        this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);

        // Sort characters for proper layering (center characters render last/on top)
        const sorted = [...this.characters].sort((a, b) => {
            const posA = this.positions[a.position] || 0.5;
            const posB = this.positions[b.position] || 0.5;

            // Characters closer to center render later (on top)
            const distA = Math.abs(posA - 0.5);
            const distB = Math.abs(posB - 0.5);
            return distB - distA;
        });

        // Render each character
        sorted.forEach(charState => {
            this.renderCharacter(charState);
        });
    }

    /**
     * Resolve character ID through aliases
     */
    resolveCharacterId(characterId) {
        const id = characterId.toLowerCase();
        return this.aliases[id] || id;
    }

    getDisplayName(characterId) {
        if (!characterId) return '';

        const id = String(characterId).toLowerCase();
        if (this.displayNames[id]) return this.displayNames[id];

        const resolvedId = this.resolveCharacterId(id);
        const renderer = this.renderers[resolvedId];
        if (renderer?.name) return renderer.name;

        return String(characterId)
            .replace(/[_-]+/g, ' ')
            .replace(/\b\w/g, (ch) => ch.toUpperCase());
    }

    /**
     * Render a single character
     */
    renderCharacter(charState) {
        // Resolve through aliases first
        const resolvedId = this.resolveCharacterId(charState.id);

        // Get the character renderer
        let renderer = this.renderers[resolvedId];

        // Try lowercase lookup if not found
        if (!renderer) {
            const key = resolvedId.toLowerCase();
            renderer = this.renderers[key];
        }

        if (!renderer) {
            console.warn(`No renderer for character: ${charState.id} (resolved: ${resolvedId})`);
            return;
        }

        // Calculate position
        const x = this.canvas.width * (charState.currentX || this.positions[charState.position] || 0.5);
        const height = this.canvas.height * renderer.heightRatio;
        const y = this.canvas.height; // Bottom of screen

        // Calculate dimming for non-highlighted characters
        let dimAmount = 1;
        if (this.highlightedCharacter && this.highlightedCharacter !== charState.id) {
            dimAmount = this.settings.dimAmount;
        }

        // Apply alpha (combines fade transition and dim effect)
        this.ctx.save();
        this.ctx.globalAlpha = charState.alpha * dimAmount;

        // Draw the character
        renderer.draw(
            this.ctx,
            x,
            y,
            height,
            charState.expression,
            this.breathingOffset
        );

        // Draw name tag for highlighted character
        if (this.highlightedCharacter === charState.id && charState.alpha > 0.8) {
            this.drawNameTag(this.getDisplayName(charState.id), x, y - height - 15);
        }

        this.ctx.restore();
    }

    /**
     * Draw character name tag above their head
     */
    drawNameTag(name, x, y) {
        this.ctx.save();

        // Text settings
        this.ctx.font = 'bold 22px "Segoe UI", "Noto Sans JP", sans-serif';
        this.ctx.textAlign = 'center';
        this.ctx.textBaseline = 'bottom';

        // Measure text for background
        const metrics = this.ctx.measureText(name);
        const padding = 10;
        const bgWidth = metrics.width + padding * 2;
        const bgHeight = 30;

        // Background with rounded corners
        this.ctx.fillStyle = 'rgba(0, 0, 0, 0.6)';
        this.roundRect(this.ctx, x - bgWidth / 2, y - bgHeight, bgWidth, bgHeight, 8);
        this.ctx.fill();

        // Text outline
        this.ctx.strokeStyle = 'rgba(0, 0, 0, 0.8)';
        this.ctx.lineWidth = 4;
        this.ctx.lineJoin = 'round';
        this.ctx.strokeText(name, x, y - 5);

        // Text fill
        this.ctx.fillStyle = '#FFFFFF';
        this.ctx.fillText(name, x, y - 5);

        this.ctx.restore();
    }

    /**
     * Helper: Draw rounded rectangle
     */
    roundRect(ctx, x, y, w, h, r) {
        if (w < 2 * r) r = w / 2;
        if (h < 2 * r) r = h / 2;
        ctx.beginPath();
        ctx.moveTo(x + r, y);
        ctx.arcTo(x + w, y, x + w, y + h, r);
        ctx.arcTo(x + w, y + h, x, y + h, r);
        ctx.arcTo(x, y + h, x, y, r);
        ctx.arcTo(x, y, x + w, y, r);
        ctx.closePath();
    }

    /**
     * Get list of available character IDs
     */
    getAvailableCharacters() {
        return Object.keys(this.renderers);
    }

    /**
     * Check if a character exists
     */
    hasCharacter(characterId) {
        const key = this.resolveCharacterId(characterId);
        return Object.prototype.hasOwnProperty.call(this.renderers, key);
    }

    /**
     * Get current characters on screen
     */
    getActiveCharacters() {
        return this.characters.map(c => ({
            id: c.id,
            position: c.position,
            expression: c.expression,
            isVisible: c.alpha > 0 && !c.exiting
        }));
    }
}
