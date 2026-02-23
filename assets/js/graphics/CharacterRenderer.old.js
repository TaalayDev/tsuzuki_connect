/**
 * TSUZUKI CONNECT - Character Renderer
 * Programmatically draws characters as placeholders
 */

export class CharacterRenderer {
    constructor(canvas, game) {
        this.canvas = canvas;
        this.ctx = canvas.getContext('2d');
        this.game = game;
        
        // Set canvas size
        this.canvas.width = 1920;
        this.canvas.height = 1080;
        
        // Active characters on screen
        this.characters = [];
        this.highlightedCharacter = null;
        
        // Character definitions
        this.characterData = {
            'tanaka': {
                name: 'Tanaka Haruka',
                nameJp: '田中晴香',
                hairColor: '#3d2314',
                hairStyle: 'bun',
                skinTone: '#f5d0c5',
                eyeColor: '#5c4033',
                clothingColor: '#8fbc8f', // Soft cardigan green
                clothingType: 'cardigan',
                accessories: ['glasses'],
                height: 0.85
            },
            'ken': {
                name: 'Kenneth Brooks',
                nameJp: 'ケン・ブルックス',
                hairColor: '#8b7355',
                hairStyle: 'short',
                skinTone: '#fbe4d5',
                eyeColor: '#5f9ea0',
                clothingColor: '#4682b4', // Hoodie blue
                clothingType: 'hoodie',
                accessories: [],
                height: 0.95
            },
            'mei': {
                name: 'Kim Mei-hwa',
                nameJp: 'キム・メイファ',
                hairColor: '#1a1a2e',
                hairStyle: 'ponytail',
                skinTone: '#f5deb3',
                eyeColor: '#2c1810',
                clothingColor: '#483d8b', // Blazer purple
                clothingType: 'blazer',
                accessories: [],
                height: 0.88
            },
            'yuki': {
                name: 'Yukimura Yuki',
                nameJp: '雪村ユキ',
                hairColor: '#2c1810',
                hairStyle: 'medium',
                skinTone: '#fbe4d5',
                eyeColor: '#4a3728',
                clothingColor: '#d4a574', // Oversized sweater
                clothingType: 'sweater',
                accessories: [],
                height: 0.82
            },
            'player': {
                name: 'Player',
                hairColor: '#4a3728',
                hairStyle: 'medium',
                skinTone: '#f5d0c5',
                eyeColor: '#5c4033',
                clothingColor: '#e8a87c',
                clothingType: 'casual',
                accessories: [],
                height: 0.85
            }
        };
        
        // Expression data
        this.expressions = {
            'neutral': { eyebrows: 'normal', eyes: 'normal', mouth: 'neutral' },
            'happy': { eyebrows: 'up', eyes: 'happy', mouth: 'smile' },
            'sad': { eyebrows: 'down', eyes: 'sad', mouth: 'frown' },
            'surprised': { eyebrows: 'high', eyes: 'wide', mouth: 'open' },
            'angry': { eyebrows: 'angry', eyes: 'narrow', mouth: 'frown' },
            'embarrassed': { eyebrows: 'worried', eyes: 'side', mouth: 'small' },
            'thinking': { eyebrows: 'up', eyes: 'up', mouth: 'hmm' },
            'serious': { eyebrows: 'down', eyes: 'narrow', mouth: 'flat' }
        };
        
        // Positions
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
        
        // Start animation loop
        this.animate();
    }
    
    /**
     * Set characters on screen
     */
    setCharacters(characters) {
        this.characters = characters.map(char => ({
            id: char.id,
            position: char.position || 'center',
            expression: char.expression || 'neutral',
            entering: true,
            alpha: 0
        }));
        this.render();
    }
    
    /**
     * Add a character to the screen
     */
    addCharacter(characterId, position = 'center', expression = 'neutral') {
        // Check if already on screen
        const existing = this.characters.find(c => c.id === characterId);
        if (existing) {
            existing.position = position;
            existing.expression = expression;
        } else {
            this.characters.push({
                id: characterId,
                position: position,
                expression: expression,
                entering: true,
                alpha: 0
            });
        }
        this.render();
    }
    
    /**
     * Remove a character from screen
     */
    removeCharacter(characterId) {
        const char = this.characters.find(c => c.id === characterId);
        if (char) {
            char.exiting = true;
        }
    }
    
    /**
     * Alias for removeCharacter (used by DialogueBuilder)
     */
    hideCharacter(characterId) {
        this.removeCharacter(characterId);
    }
    
    /**
     * Hide all characters from screen
     */
    hideAllCharacters() {
        this.characters.forEach(char => {
            char.exiting = true;
        });
    }
    
    /**
     * Move a character to new position
     */
    moveCharacter(characterId, newPosition) {
        const char = this.characters.find(c => c.id === characterId);
        if (char) {
            char.targetPosition = newPosition;
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
     * Highlight speaking character
     */
    highlightCharacter(characterId) {
        this.highlightedCharacter = characterId;
        this.render();
    }
    
    /**
     * Animation loop
     */
    animate() {
        this.animationFrame++;
        this.breathingOffset = Math.sin(this.animationFrame * 0.03) * 2;
        
        // Update character states
        let needsRender = false;
        
        this.characters.forEach(char => {
            // Fade in
            if (char.entering && char.alpha < 1) {
                char.alpha = Math.min(1, char.alpha + 0.05);
                needsRender = true;
                if (char.alpha >= 1) char.entering = false;
            }
            
            // Fade out
            if (char.exiting) {
                char.alpha = Math.max(0, char.alpha - 0.08);
                needsRender = true;
            }
        });
        
        // Remove fully faded characters
        this.characters = this.characters.filter(c => !c.exiting || c.alpha > 0);
        
        if (needsRender || this.animationFrame % 3 === 0) {
            this.render();
        }
        
        requestAnimationFrame(() => this.animate());
    }
    
    /**
     * Render all characters
     */
    render() {
        this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
        
        // Sort by position for proper layering
        const sorted = [...this.characters].sort((a, b) => {
            const posA = this.positions[a.position] || 0.5;
            const posB = this.positions[b.position] || 0.5;
            return posA - posB;
        });
        
        sorted.forEach(char => {
            this.drawCharacter(char);
        });
    }
    
    /**
     * Draw a single character
     */
    drawCharacter(charState) {
        const data = this.characterData[charState.id];
        if (!data) return;
        
        const posX = this.positions[charState.position] || 0.5;
        const x = this.canvas.width * posX;
        const baseY = this.canvas.height;
        const charHeight = this.canvas.height * data.height;
        
        // Determine if highlighted
        const isHighlighted = this.highlightedCharacter === charState.id;
        const dimAmount = this.highlightedCharacter && !isHighlighted ? 0.6 : 1;
        
        this.ctx.save();
        this.ctx.globalAlpha = charState.alpha * dimAmount;
        
        // Apply breathing animation
        const breathOffset = this.breathingOffset;
        
        // Draw character
        this.drawBody(x, baseY, charHeight, data, breathOffset);
        this.drawHead(x, baseY - charHeight * 0.55, charHeight, data, charState.expression, breathOffset);
        
        // Draw name tag if highlighted
        if (isHighlighted) {
            this.drawNameTag(x, baseY - charHeight - 20, data.name);
        }
        
        this.ctx.restore();
    }
    
    /**
     * Draw character body
     */
    drawBody(x, baseY, height, data, breathOffset) {
        const bodyHeight = height * 0.6;
        const bodyWidth = height * 0.35;
        const shoulderY = baseY - bodyHeight;
        
        // Shadow
        this.ctx.fillStyle = 'rgba(0,0,0,0.1)';
        this.ctx.beginPath();
        this.ctx.ellipse(x, baseY - 10, bodyWidth * 0.8, 15, 0, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Body shape based on clothing type
        this.ctx.fillStyle = data.clothingColor;
        
        switch (data.clothingType) {
            case 'cardigan':
                this.drawCardigan(x, shoulderY + breathOffset, bodyWidth, bodyHeight);
                break;
            case 'hoodie':
                this.drawHoodie(x, shoulderY + breathOffset, bodyWidth, bodyHeight);
                break;
            case 'blazer':
                this.drawBlazer(x, shoulderY + breathOffset, bodyWidth, bodyHeight);
                break;
            case 'sweater':
                this.drawSweater(x, shoulderY + breathOffset, bodyWidth, bodyHeight);
                break;
            default:
                this.drawCasualTop(x, shoulderY + breathOffset, bodyWidth, bodyHeight);
        }
    }
    
    /**
     * Draw cardigan style (Tanaka-sensei)
     */
    drawCardigan(x, y, width, height) {
        // Inner shirt
        this.ctx.fillStyle = '#f5f5dc';
        this.ctx.beginPath();
        this.ctx.moveTo(x - width * 0.3, y);
        this.ctx.lineTo(x + width * 0.3, y);
        this.ctx.lineTo(x + width * 0.4, y + height);
        this.ctx.lineTo(x - width * 0.4, y + height);
        this.ctx.closePath();
        this.ctx.fill();
        
        // Cardigan
        this.ctx.fillStyle = '#8fbc8f';
        // Left side
        this.ctx.beginPath();
        this.ctx.moveTo(x - width * 0.5, y - 10);
        this.ctx.lineTo(x - width * 0.15, y);
        this.ctx.lineTo(x - width * 0.2, y + height);
        this.ctx.lineTo(x - width * 0.6, y + height);
        this.ctx.closePath();
        this.ctx.fill();
        
        // Right side
        this.ctx.beginPath();
        this.ctx.moveTo(x + width * 0.5, y - 10);
        this.ctx.lineTo(x + width * 0.15, y);
        this.ctx.lineTo(x + width * 0.2, y + height);
        this.ctx.lineTo(x + width * 0.6, y + height);
        this.ctx.closePath();
        this.ctx.fill();
        
        // Collar
        this.ctx.strokeStyle = '#6b8e6b';
        this.ctx.lineWidth = 3;
        this.ctx.beginPath();
        this.ctx.moveTo(x - width * 0.15, y);
        this.ctx.lineTo(x, y + 20);
        this.ctx.lineTo(x + width * 0.15, y);
        this.ctx.stroke();
    }
    
    /**
     * Draw hoodie style (Ken)
     */
    drawHoodie(x, y, width, height) {
        // Main body
        this.ctx.fillStyle = '#4682b4';
        this.ctx.beginPath();
        this.ctx.moveTo(x - width * 0.5, y - 5);
        this.ctx.quadraticCurveTo(x - width * 0.6, y + height * 0.3, x - width * 0.55, y + height);
        this.ctx.lineTo(x + width * 0.55, y + height);
        this.ctx.quadraticCurveTo(x + width * 0.6, y + height * 0.3, x + width * 0.5, y - 5);
        this.ctx.closePath();
        this.ctx.fill();
        
        // Hood
        this.ctx.fillStyle = '#3a6f9a';
        this.ctx.beginPath();
        this.ctx.ellipse(x, y - 20, width * 0.35, 25, 0, Math.PI, Math.PI * 2);
        this.ctx.fill();
        
        // Pocket
        this.ctx.fillStyle = '#3a6f9a';
        this.ctx.fillRect(x - width * 0.35, y + height * 0.5, width * 0.7, height * 0.2);
        
        // Strings
        this.ctx.strokeStyle = '#f5f5f5';
        this.ctx.lineWidth = 2;
        this.ctx.beginPath();
        this.ctx.moveTo(x - 10, y);
        this.ctx.lineTo(x - 10, y + 40);
        this.ctx.moveTo(x + 10, y);
        this.ctx.lineTo(x + 10, y + 40);
        this.ctx.stroke();
    }
    
    /**
     * Draw blazer style (Mei)
     */
    drawBlazer(x, y, width, height) {
        // Inner shirt
        this.ctx.fillStyle = '#ffffff';
        this.ctx.beginPath();
        this.ctx.moveTo(x - width * 0.25, y);
        this.ctx.lineTo(x + width * 0.25, y);
        this.ctx.lineTo(x + width * 0.3, y + height);
        this.ctx.lineTo(x - width * 0.3, y + height);
        this.ctx.closePath();
        this.ctx.fill();
        
        // Blazer
        this.ctx.fillStyle = '#483d8b';
        this.ctx.beginPath();
        this.ctx.moveTo(x - width * 0.55, y - 10);
        this.ctx.lineTo(x - width * 0.1, y + 10);
        this.ctx.lineTo(x - width * 0.15, y + height);
        this.ctx.lineTo(x - width * 0.6, y + height);
        this.ctx.closePath();
        this.ctx.fill();
        
        this.ctx.beginPath();
        this.ctx.moveTo(x + width * 0.55, y - 10);
        this.ctx.lineTo(x + width * 0.1, y + 10);
        this.ctx.lineTo(x + width * 0.15, y + height);
        this.ctx.lineTo(x + width * 0.6, y + height);
        this.ctx.closePath();
        this.ctx.fill();
        
        // Lapels
        this.ctx.fillStyle = '#3d3270';
        this.ctx.beginPath();
        this.ctx.moveTo(x - width * 0.1, y + 10);
        this.ctx.lineTo(x - width * 0.3, y - 5);
        this.ctx.lineTo(x - width * 0.15, y + 50);
        this.ctx.closePath();
        this.ctx.fill();
        
        this.ctx.beginPath();
        this.ctx.moveTo(x + width * 0.1, y + 10);
        this.ctx.lineTo(x + width * 0.3, y - 5);
        this.ctx.lineTo(x + width * 0.15, y + 50);
        this.ctx.closePath();
        this.ctx.fill();
    }
    
    /**
     * Draw sweater style (Yuki)
     */
    drawSweater(x, y, width, height) {
        // Oversized sweater
        this.ctx.fillStyle = '#d4a574';
        this.ctx.beginPath();
        this.ctx.moveTo(x - width * 0.6, y);
        this.ctx.quadraticCurveTo(x - width * 0.7, y + height * 0.5, x - width * 0.55, y + height);
        this.ctx.lineTo(x + width * 0.55, y + height);
        this.ctx.quadraticCurveTo(x + width * 0.7, y + height * 0.5, x + width * 0.6, y);
        this.ctx.closePath();
        this.ctx.fill();
        
        // Neckline
        this.ctx.fillStyle = '#c49464';
        this.ctx.beginPath();
        this.ctx.ellipse(x, y + 5, width * 0.25, 15, 0, 0, Math.PI);
        this.ctx.fill();
        
        // Cable knit pattern (simplified)
        this.ctx.strokeStyle = '#c49464';
        this.ctx.lineWidth = 2;
        for (let i = 0; i < 5; i++) {
            this.ctx.beginPath();
            this.ctx.moveTo(x - width * 0.3 + i * 20, y + 30);
            this.ctx.lineTo(x - width * 0.3 + i * 20, y + height - 20);
            this.ctx.stroke();
        }
    }
    
    /**
     * Draw casual top (default/player)
     */
    drawCasualTop(x, y, width, height) {
        this.ctx.fillStyle = '#e8a87c';
        this.ctx.beginPath();
        this.ctx.moveTo(x - width * 0.5, y);
        this.ctx.lineTo(x + width * 0.5, y);
        this.ctx.lineTo(x + width * 0.55, y + height);
        this.ctx.lineTo(x - width * 0.55, y + height);
        this.ctx.closePath();
        this.ctx.fill();
        
        // Collar
        this.ctx.fillStyle = '#d4956b';
        this.ctx.beginPath();
        this.ctx.ellipse(x, y + 5, width * 0.2, 12, 0, 0, Math.PI);
        this.ctx.fill();
    }
    
    /**
     * Draw character head
     */
    drawHead(x, y, totalHeight, data, expression, breathOffset) {
        const headSize = totalHeight * 0.25;
        const expr = this.expressions[expression] || this.expressions.neutral;
        
        y += breathOffset * 0.5;
        
        // Neck
        this.ctx.fillStyle = data.skinTone;
        this.ctx.fillRect(x - headSize * 0.15, y + headSize * 0.4, headSize * 0.3, headSize * 0.3);
        
        // Face shape
        this.ctx.fillStyle = data.skinTone;
        this.ctx.beginPath();
        this.ctx.ellipse(x, y, headSize * 0.45, headSize * 0.5, 0, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Hair (back)
        this.drawHair(x, y, headSize, data, 'back');
        
        // Ears
        this.ctx.fillStyle = data.skinTone;
        this.ctx.beginPath();
        this.ctx.ellipse(x - headSize * 0.45, y, headSize * 0.08, headSize * 0.12, 0, 0, Math.PI * 2);
        this.ctx.ellipse(x + headSize * 0.45, y, headSize * 0.08, headSize * 0.12, 0, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Eyes
        this.drawEyes(x, y - headSize * 0.05, headSize, data, expr);
        
        // Eyebrows
        this.drawEyebrows(x, y - headSize * 0.2, headSize, data, expr);
        
        // Nose
        this.ctx.strokeStyle = this.darkenColor(data.skinTone, 20);
        this.ctx.lineWidth = 2;
        this.ctx.beginPath();
        this.ctx.moveTo(x, y);
        this.ctx.lineTo(x - 3, y + headSize * 0.12);
        this.ctx.stroke();
        
        // Mouth
        this.drawMouth(x, y + headSize * 0.2, headSize, expr);
        
        // Hair (front)
        this.drawHair(x, y, headSize, data, 'front');
        
        // Accessories
        if (data.accessories.includes('glasses')) {
            this.drawGlasses(x, y - headSize * 0.05, headSize);
        }
    }
    
    /**
     * Draw hair based on style
     */
    drawHair(x, y, headSize, data, layer) {
        this.ctx.fillStyle = data.hairColor;
        
        switch (data.hairStyle) {
            case 'bun':
                if (layer === 'back') {
                    // Back hair
                    this.ctx.beginPath();
                    this.ctx.ellipse(x, y - headSize * 0.3, headSize * 0.5, headSize * 0.35, 0, Math.PI, Math.PI * 2);
                    this.ctx.fill();
                    // Bun
                    this.ctx.beginPath();
                    this.ctx.ellipse(x, y - headSize * 0.55, headSize * 0.2, headSize * 0.18, 0, 0, Math.PI * 2);
                    this.ctx.fill();
                }
                if (layer === 'front') {
                    // Bangs
                    this.ctx.beginPath();
                    this.ctx.moveTo(x - headSize * 0.35, y - headSize * 0.15);
                    this.ctx.quadraticCurveTo(x - headSize * 0.2, y - headSize * 0.05, x - headSize * 0.1, y - headSize * 0.2);
                    this.ctx.quadraticCurveTo(x, y - headSize * 0.1, x + headSize * 0.1, y - headSize * 0.2);
                    this.ctx.quadraticCurveTo(x + headSize * 0.2, y - headSize * 0.05, x + headSize * 0.35, y - headSize * 0.15);
                    this.ctx.lineTo(x + headSize * 0.4, y - headSize * 0.35);
                    this.ctx.lineTo(x - headSize * 0.4, y - headSize * 0.35);
                    this.ctx.closePath();
                    this.ctx.fill();
                }
                break;
                
            case 'short':
                if (layer === 'back') {
                    this.ctx.beginPath();
                    this.ctx.ellipse(x, y - headSize * 0.25, headSize * 0.5, headSize * 0.35, 0, Math.PI, Math.PI * 2);
                    this.ctx.fill();
                }
                if (layer === 'front') {
                    // Messy bangs
                    this.ctx.beginPath();
                    this.ctx.moveTo(x - headSize * 0.4, y - headSize * 0.1);
                    for (let i = 0; i < 6; i++) {
                        const px = x - headSize * 0.35 + i * headSize * 0.14;
                        const py = y - headSize * 0.15 + (i % 2) * headSize * 0.1;
                        this.ctx.lineTo(px, py);
                    }
                    this.ctx.lineTo(x + headSize * 0.45, y - headSize * 0.35);
                    this.ctx.lineTo(x - headSize * 0.45, y - headSize * 0.35);
                    this.ctx.closePath();
                    this.ctx.fill();
                }
                break;
                
            case 'ponytail':
                if (layer === 'back') {
                    this.ctx.beginPath();
                    this.ctx.ellipse(x, y - headSize * 0.25, headSize * 0.5, headSize * 0.35, 0, Math.PI, Math.PI * 2);
                    this.ctx.fill();
                    // Ponytail
                    this.ctx.beginPath();
                    this.ctx.moveTo(x + headSize * 0.3, y - headSize * 0.2);
                    this.ctx.quadraticCurveTo(x + headSize * 0.6, y, x + headSize * 0.5, y + headSize * 0.4);
                    this.ctx.quadraticCurveTo(x + headSize * 0.4, y + headSize * 0.2, x + headSize * 0.35, y - headSize * 0.1);
                    this.ctx.closePath();
                    this.ctx.fill();
                }
                if (layer === 'front') {
                    // Neat bangs
                    this.ctx.beginPath();
                    this.ctx.moveTo(x - headSize * 0.4, y - headSize * 0.15);
                    this.ctx.lineTo(x - headSize * 0.35, y - headSize * 0.1);
                    this.ctx.lineTo(x, y - headSize * 0.15);
                    this.ctx.lineTo(x + headSize * 0.35, y - headSize * 0.1);
                    this.ctx.lineTo(x + headSize * 0.4, y - headSize * 0.15);
                    this.ctx.lineTo(x + headSize * 0.45, y - headSize * 0.35);
                    this.ctx.lineTo(x - headSize * 0.45, y - headSize * 0.35);
                    this.ctx.closePath();
                    this.ctx.fill();
                }
                break;
                
            case 'medium':
            default:
                if (layer === 'back') {
                    this.ctx.beginPath();
                    this.ctx.ellipse(x, y - headSize * 0.2, headSize * 0.52, headSize * 0.4, 0, Math.PI, Math.PI * 2);
                    this.ctx.fill();
                    // Side hair
                    this.ctx.fillRect(x - headSize * 0.5, y - headSize * 0.1, headSize * 0.15, headSize * 0.5);
                    this.ctx.fillRect(x + headSize * 0.35, y - headSize * 0.1, headSize * 0.15, headSize * 0.5);
                }
                if (layer === 'front') {
                    // Soft bangs
                    this.ctx.beginPath();
                    this.ctx.moveTo(x - headSize * 0.45, y - headSize * 0.1);
                    this.ctx.quadraticCurveTo(x - headSize * 0.2, y, x, y - headSize * 0.1);
                    this.ctx.quadraticCurveTo(x + headSize * 0.2, y, x + headSize * 0.45, y - headSize * 0.1);
                    this.ctx.lineTo(x + headSize * 0.48, y - headSize * 0.35);
                    this.ctx.lineTo(x - headSize * 0.48, y - headSize * 0.35);
                    this.ctx.closePath();
                    this.ctx.fill();
                }
                break;
        }
    }
    
    /**
     * Draw eyes
     */
    drawEyes(x, y, headSize, data, expr) {
        const eyeSpacing = headSize * 0.18;
        const eyeSize = headSize * 0.1;
        
        // Eye whites
        this.ctx.fillStyle = '#ffffff';
        this.ctx.beginPath();
        this.ctx.ellipse(x - eyeSpacing, y, eyeSize, eyeSize * 0.7, 0, 0, Math.PI * 2);
        this.ctx.ellipse(x + eyeSpacing, y, eyeSize, eyeSize * 0.7, 0, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Pupils based on expression
        this.ctx.fillStyle = data.eyeColor;
        let pupilOffsetX = 0;
        let pupilOffsetY = 0;
        let pupilScale = 1;
        
        switch (expr.eyes) {
            case 'happy':
                pupilOffsetY = 2;
                break;
            case 'sad':
                pupilOffsetY = 3;
                break;
            case 'wide':
                pupilScale = 1.2;
                break;
            case 'narrow':
                pupilScale = 0.8;
                break;
            case 'side':
                pupilOffsetX = 3;
                break;
            case 'up':
                pupilOffsetY = -3;
                break;
        }
        
        this.ctx.beginPath();
        this.ctx.ellipse(x - eyeSpacing + pupilOffsetX, y + pupilOffsetY, eyeSize * 0.6 * pupilScale, eyeSize * 0.5 * pupilScale, 0, 0, Math.PI * 2);
        this.ctx.ellipse(x + eyeSpacing + pupilOffsetX, y + pupilOffsetY, eyeSize * 0.6 * pupilScale, eyeSize * 0.5 * pupilScale, 0, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Highlights
        this.ctx.fillStyle = '#ffffff';
        this.ctx.beginPath();
        this.ctx.arc(x - eyeSpacing + 2, y - 2, eyeSize * 0.2, 0, Math.PI * 2);
        this.ctx.arc(x + eyeSpacing + 2, y - 2, eyeSize * 0.2, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Happy eyes - add curved lines
        if (expr.eyes === 'happy') {
            this.ctx.strokeStyle = data.eyeColor;
            this.ctx.lineWidth = 2;
            this.ctx.beginPath();
            this.ctx.arc(x - eyeSpacing, y + 2, eyeSize * 0.5, 0.2 * Math.PI, 0.8 * Math.PI);
            this.ctx.stroke();
            this.ctx.beginPath();
            this.ctx.arc(x + eyeSpacing, y + 2, eyeSize * 0.5, 0.2 * Math.PI, 0.8 * Math.PI);
            this.ctx.stroke();
        }
    }
    
    /**
     * Draw eyebrows
     */
    drawEyebrows(x, y, headSize, data, expr) {
        const browSpacing = headSize * 0.18;
        const browWidth = headSize * 0.12;
        
        this.ctx.strokeStyle = this.darkenColor(data.hairColor, -20);
        this.ctx.lineWidth = 3;
        this.ctx.lineCap = 'round';
        
        let leftAngle = 0;
        let rightAngle = 0;
        let yOffset = 0;
        
        switch (expr.eyebrows) {
            case 'up':
                yOffset = -3;
                break;
            case 'down':
                yOffset = 3;
                break;
            case 'high':
                yOffset = -5;
                leftAngle = -0.1;
                rightAngle = 0.1;
                break;
            case 'angry':
                leftAngle = 0.3;
                rightAngle = -0.3;
                break;
            case 'worried':
                leftAngle = -0.2;
                rightAngle = 0.2;
                break;
        }
        
        // Left eyebrow
        this.ctx.save();
        this.ctx.translate(x - browSpacing, y + yOffset);
        this.ctx.rotate(leftAngle);
        this.ctx.beginPath();
        this.ctx.moveTo(-browWidth, 0);
        this.ctx.lineTo(browWidth, 0);
        this.ctx.stroke();
        this.ctx.restore();
        
        // Right eyebrow
        this.ctx.save();
        this.ctx.translate(x + browSpacing, y + yOffset);
        this.ctx.rotate(rightAngle);
        this.ctx.beginPath();
        this.ctx.moveTo(-browWidth, 0);
        this.ctx.lineTo(browWidth, 0);
        this.ctx.stroke();
        this.ctx.restore();
    }
    
    /**
     * Draw mouth
     */
    drawMouth(x, y, headSize, expr) {
        this.ctx.strokeStyle = '#a67c52';
        this.ctx.fillStyle = '#c4756e';
        this.ctx.lineWidth = 2;
        
        const mouthWidth = headSize * 0.15;
        
        switch (expr.mouth) {
            case 'smile':
                this.ctx.beginPath();
                this.ctx.arc(x, y - 5, mouthWidth, 0.15 * Math.PI, 0.85 * Math.PI);
                this.ctx.stroke();
                break;
            case 'frown':
                this.ctx.beginPath();
                this.ctx.arc(x, y + 10, mouthWidth, 1.15 * Math.PI, 1.85 * Math.PI);
                this.ctx.stroke();
                break;
            case 'open':
                this.ctx.beginPath();
                this.ctx.ellipse(x, y, mouthWidth * 0.7, mouthWidth * 0.5, 0, 0, Math.PI * 2);
                this.ctx.fill();
                break;
            case 'small':
                this.ctx.beginPath();
                this.ctx.arc(x, y, mouthWidth * 0.4, 0, Math.PI * 2);
                this.ctx.stroke();
                break;
            case 'hmm':
                this.ctx.beginPath();
                this.ctx.moveTo(x - mouthWidth * 0.5, y);
                this.ctx.lineTo(x + mouthWidth * 0.5, y - 3);
                this.ctx.stroke();
                break;
            case 'flat':
                this.ctx.beginPath();
                this.ctx.moveTo(x - mouthWidth * 0.6, y);
                this.ctx.lineTo(x + mouthWidth * 0.6, y);
                this.ctx.stroke();
                break;
            default: // neutral
                this.ctx.beginPath();
                this.ctx.arc(x, y - 2, mouthWidth * 0.8, 0.1 * Math.PI, 0.9 * Math.PI);
                this.ctx.stroke();
        }
    }
    
    /**
     * Draw glasses
     */
    drawGlasses(x, y, headSize) {
        const glassSize = headSize * 0.15;
        const spacing = headSize * 0.18;
        
        this.ctx.strokeStyle = '#4a3728';
        this.ctx.lineWidth = 2;
        
        // Frames
        this.ctx.beginPath();
        this.ctx.roundRect(x - spacing - glassSize, y - glassSize * 0.6, glassSize * 2, glassSize * 1.2, 3);
        this.ctx.roundRect(x + spacing - glassSize, y - glassSize * 0.6, glassSize * 2, glassSize * 1.2, 3);
        this.ctx.stroke();
        
        // Bridge
        this.ctx.beginPath();
        this.ctx.moveTo(x - spacing + glassSize, y);
        this.ctx.lineTo(x + spacing - glassSize, y);
        this.ctx.stroke();
        
        // Temples
        this.ctx.beginPath();
        this.ctx.moveTo(x - spacing - glassSize, y);
        this.ctx.lineTo(x - headSize * 0.45, y);
        this.ctx.moveTo(x + spacing + glassSize, y);
        this.ctx.lineTo(x + headSize * 0.45, y);
        this.ctx.stroke();
    }
    
    /**
     * Draw name tag
     */
    drawNameTag(x, y, name) {
        this.ctx.font = '16px Nunito, sans-serif';
        const metrics = this.ctx.measureText(name);
        const padding = 10;
        
        // Background
        this.ctx.fillStyle = 'rgba(44, 36, 22, 0.8)';
        this.ctx.roundRect(
            x - metrics.width / 2 - padding,
            y - 10,
            metrics.width + padding * 2,
            28,
            5
        );
        this.ctx.fill();
        
        // Text
        this.ctx.fillStyle = '#f5f1e8';
        this.ctx.textAlign = 'center';
        this.ctx.fillText(name, x, y + 10);
    }
    
    /**
     * Utility: Darken/lighten a color
     */
    darkenColor(hex, amount) {
        const num = parseInt(hex.slice(1), 16);
        const r = Math.max(0, Math.min(255, (num >> 16) + amount));
        const g = Math.max(0, Math.min(255, ((num >> 8) & 0x00FF) + amount));
        const b = Math.max(0, Math.min(255, (num & 0x0000FF) + amount));
        return `#${(1 << 24 | r << 16 | g << 8 | b).toString(16).slice(1)}`;
    }
}
