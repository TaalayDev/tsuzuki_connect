/**
 * TSUZUKI CONNECT - Apartment Background
 * Style: Honey and Clover - soft watercolor aesthetic
 * Cozy Japanese apartment interior
 */

import { BackgroundUtils } from './BackgroundUtils.js';
import { BackgroundAssets } from './BackgroundAssets.js';

export class ApartmentBackground {
    constructor(ctx, width, height) {
        this.ctx = ctx;
        this.w = width;
        this.h = height;
        this.utils = new BackgroundUtils(ctx);
    }

    draw(timeOfDay = 'afternoon', season = 'spring') {
        const assetPath = BackgroundAssets.getPath('apartment', timeOfDay);
        const imageDrawn = this.utils.drawImageBackground(assetPath, this.w, this.h);

        if (!imageDrawn) {
            this.drawWalls(timeOfDay);
            this.drawFloor();
            this.drawWindow(timeOfDay, season);
            this.drawFurniture();
            this.drawKitchenArea();
            this.drawDecorations();
            this.drawLighting(timeOfDay);
        }
        
        this.utils.drawWatercolorTexture(this.w, this.h, 0.03);
    }

    drawWalls(timeOfDay) {
        let wallColors;
        
        if (timeOfDay === 'night') {
            wallColors = ['#4a4458', '#3d3652', '#35304a'];
        } else if (timeOfDay === 'evening') {
            wallColors = ['#d7ccc8', '#c9b8b0', '#bcaaa4'];
        } else {
            wallColors = ['#fff8e1', '#ffecb3', '#ffe0b2'];
        }
        
        const wallGradient = this.utils.createWatercolorGradient(0, 0, 0, this.h * 0.65, wallColors);
        this.ctx.fillStyle = wallGradient;
        this.ctx.fillRect(0, 0, this.w, this.h * 0.65);
        
        // Wall texture (subtle pattern)
        this.ctx.save();
        this.ctx.globalAlpha = 0.05;
        for (let y = 0; y < this.h * 0.65; y += 20) {
            this.ctx.strokeStyle = '#8d6e63';
            this.ctx.lineWidth = 0.5;
            this.ctx.beginPath();
            this.ctx.moveTo(0, y);
            this.ctx.lineTo(this.w, y);
            this.ctx.stroke();
        }
        this.ctx.restore();
    }

    drawFloor() {
        // Tatami or wood floor
        const floorGradient = this.utils.createWatercolorGradient(
            0, this.h * 0.65, 0, this.h,
            ['#bcaaa4', '#a1887f', '#8d6e63']
        );
        this.ctx.fillStyle = floorGradient;
        this.ctx.fillRect(0, this.h * 0.65, this.w, this.h * 0.35);
        
        // Wood plank lines
        this.ctx.strokeStyle = 'rgba(93, 64, 55, 0.3)';
        this.ctx.lineWidth = 1;
        
        for (let x = 0; x < this.w; x += 60) {
            this.ctx.beginPath();
            this.ctx.moveTo(x, this.h * 0.65);
            this.ctx.lineTo(x - 30, this.h);
            this.ctx.stroke();
        }
    }

    drawWindow(timeOfDay, season) {
        const x = this.w * 0.6;
        const y = this.h * 0.08;
        const width = this.w * 0.35;
        const height = this.h * 0.45;
        
        // Window frame
        this.ctx.fillStyle = '#8d6e63';
        this.ctx.fillRect(x - 8, y - 8, width + 16, height + 16);
        
        // Inner frame
        this.ctx.fillStyle = '#a1887f';
        this.ctx.fillRect(x - 4, y - 4, width + 8, height + 8);
        
        // Sky through window
        let skyColors;
        switch (timeOfDay) {
            case 'morning':
                skyColors = ['#ffecb3', '#fff8e1', '#b3e5fc'];
                break;
            case 'evening':
                skyColors = ['#ff8a65', '#ffab91', '#ffcc80'];
                break;
            case 'night':
                skyColors = ['#1a237e', '#283593', '#3949ab'];
                break;
            default:
                skyColors = ['#81d4fa', '#b3e5fc', '#e1f5fe'];
        }
        
        const skyGradient = this.utils.createWatercolorGradient(x, y, x, y + height, skyColors);
        this.ctx.fillStyle = skyGradient;
        this.ctx.fillRect(x, y, width, height);
        
        // Clouds or stars
        if (timeOfDay === 'night') {
            this.ctx.save();
            for (let i = 0; i < 15; i++) {
                const sx = x + Math.random() * width;
                const sy = y + Math.random() * height * 0.6;
                this.ctx.fillStyle = `rgba(255, 255, 255, ${Math.random() * 0.6 + 0.2})`;
                this.ctx.beginPath();
                this.ctx.arc(sx, sy, Math.random() * 1.5 + 0.5, 0, Math.PI * 2);
                this.ctx.fill();
            }
            this.ctx.restore();
        } else {
            // Distant buildings
            this.ctx.fillStyle = timeOfDay === 'evening' ? '#bf9b8c' : '#b0bec5';
            for (let i = 0; i < 5; i++) {
                const bx = x + i * 40 + 10;
                const bHeight = 30 + Math.random() * 50;
                this.ctx.fillRect(bx, y + height - bHeight, 30, bHeight);
            }
        }
        
        // Cherry blossom branch visible through window in spring
        if (season === 'spring' && timeOfDay !== 'night') {
            this.ctx.save();
            this.ctx.beginPath();
            this.ctx.rect(x, y, width, height);
            this.ctx.clip();
            
            // Branch
            this.ctx.strokeStyle = '#5d4037';
            this.ctx.lineWidth = 4;
            this.ctx.beginPath();
            this.ctx.moveTo(x + width + 20, y + 30);
            this.ctx.quadraticCurveTo(x + width * 0.7, y + 50, x + width * 0.4, y + 80);
            this.ctx.stroke();
            
            // Blossoms
            const blossomPositions = [
                { x: x + width * 0.8, y: y + 40 },
                { x: x + width * 0.6, y: y + 55 },
                { x: x + width * 0.45, y: y + 75 },
            ];
            
            blossomPositions.forEach(pos => {
                for (let i = 0; i < 5; i++) {
                    const bx = pos.x + (Math.random() - 0.5) * 25;
                    const by = pos.y + (Math.random() - 0.5) * 25;
                    this.ctx.fillStyle = `rgba(255, 183, 197, ${Math.random() * 0.3 + 0.5})`;
                    this.ctx.beginPath();
                    this.ctx.arc(bx, by, Math.random() * 4 + 3, 0, Math.PI * 2);
                    this.ctx.fill();
                }
            });
            
            this.ctx.restore();
        }
        
        // Window dividers
        this.ctx.strokeStyle = '#6d4c41';
        this.ctx.lineWidth = 4;
        
        // Vertical divider
        this.ctx.beginPath();
        this.ctx.moveTo(x + width / 2, y);
        this.ctx.lineTo(x + width / 2, y + height);
        this.ctx.stroke();
        
        // Horizontal divider
        this.ctx.beginPath();
        this.ctx.moveTo(x, y + height / 2);
        this.ctx.lineTo(x + width, y + height / 2);
        this.ctx.stroke();
        
        // Curtains
        this.drawCurtains(x, y, width, height);
        
        // Light rays during day
        if (timeOfDay === 'morning' || timeOfDay === 'afternoon') {
            this.ctx.save();
            this.ctx.globalAlpha = 0.08;
            
            const rayGradient = this.ctx.createLinearGradient(x + width, y, x - 100, this.h);
            rayGradient.addColorStop(0, '#fff9c4');
            rayGradient.addColorStop(1, 'rgba(255, 249, 196, 0)');
            
            this.ctx.fillStyle = rayGradient;
            this.ctx.beginPath();
            this.ctx.moveTo(x, y);
            this.ctx.lineTo(x + width, y);
            this.ctx.lineTo(x + width, y + height);
            this.ctx.lineTo(0, this.h);
            this.ctx.lineTo(0, this.h * 0.6);
            this.ctx.closePath();
            this.ctx.fill();
            
            this.ctx.restore();
        }
    }

    drawCurtains(wx, wy, ww, wh) {
        // Left curtain
        const leftCurtain = this.ctx.createLinearGradient(wx - 30, wy, wx + 30, wy);
        leftCurtain.addColorStop(0, '#ffccbc');
        leftCurtain.addColorStop(0.5, '#ffab91');
        leftCurtain.addColorStop(1, '#ff8a65');
        
        this.ctx.fillStyle = leftCurtain;
        this.ctx.beginPath();
        this.ctx.moveTo(wx - 30, wy - 15);
        this.ctx.lineTo(wx + 25, wy - 15);
        this.ctx.quadraticCurveTo(wx + 20, wy + wh * 0.3, wx + 30, wy + wh + 30);
        this.ctx.lineTo(wx - 30, wy + wh + 30);
        this.ctx.closePath();
        this.ctx.fill();
        
        // Right curtain
        const rightCurtain = this.ctx.createLinearGradient(wx + ww - 30, wy, wx + ww + 30, wy);
        rightCurtain.addColorStop(0, '#ff8a65');
        rightCurtain.addColorStop(0.5, '#ffab91');
        rightCurtain.addColorStop(1, '#ffccbc');
        
        this.ctx.fillStyle = rightCurtain;
        this.ctx.beginPath();
        this.ctx.moveTo(wx + ww - 25, wy - 15);
        this.ctx.lineTo(wx + ww + 30, wy - 15);
        this.ctx.lineTo(wx + ww + 30, wy + wh + 30);
        this.ctx.quadraticCurveTo(wx + ww - 20, wy + wh * 0.3, wx + ww - 30, wy + wh + 30);
        this.ctx.closePath();
        this.ctx.fill();
        
        // Curtain rod
        this.ctx.fillStyle = '#5d4037';
        this.ctx.fillRect(wx - 40, wy - 25, ww + 80, 10);
        
        // Rod ends
        this.ctx.fillStyle = '#4e342e';
        this.ctx.beginPath();
        this.ctx.arc(wx - 40, wy - 20, 8, 0, Math.PI * 2);
        this.ctx.fill();
        this.ctx.beginPath();
        this.ctx.arc(wx + ww + 40, wy - 20, 8, 0, Math.PI * 2);
        this.ctx.fill();
    }

    drawFurniture() {
        // Low table (kotatsu style)
        this.drawKotatsu();
        
        // Cushion
        this.drawCushion();
        
        // Small bookshelf
        this.drawBookshelf();
        
        // Bed/futon area
        this.drawBedArea();
    }

    drawKotatsu() {
        const x = this.w * 0.15;
        const y = this.h * 0.6;
        
        // Table shadow
        this.ctx.save();
        this.ctx.globalAlpha = 0.15;
        this.ctx.fillStyle = '#3e2723';
        this.ctx.beginPath();
        this.ctx.ellipse(x + 80, y + 50, 100, 25, 0, 0, Math.PI * 2);
        this.ctx.fill();
        this.ctx.restore();
        
        // Table blanket
        const blanketGradient = this.ctx.createLinearGradient(x, y, x + 160, y + 40);
        blanketGradient.addColorStop(0, '#c62828');
        blanketGradient.addColorStop(0.5, '#d32f2f');
        blanketGradient.addColorStop(1, '#b71c1c');
        
        this.ctx.fillStyle = blanketGradient;
        this.ctx.beginPath();
        this.ctx.moveTo(x - 10, y + 5);
        this.ctx.lineTo(x + 170, y + 5);
        this.ctx.lineTo(x + 180, y + 45);
        this.ctx.lineTo(x - 20, y + 45);
        this.ctx.closePath();
        this.ctx.fill();
        
        // Pattern on blanket
        this.ctx.save();
        this.ctx.globalAlpha = 0.2;
        this.ctx.strokeStyle = '#ffeb3b';
        this.ctx.lineWidth = 1;
        
        for (let i = 0; i < 6; i++) {
            this.ctx.beginPath();
            this.ctx.arc(x + 30 + i * 25, y + 25, 8, 0, Math.PI * 2);
            this.ctx.stroke();
        }
        this.ctx.restore();
        
        // Table top
        const tableGradient = this.ctx.createLinearGradient(x, y - 10, x, y + 5);
        tableGradient.addColorStop(0, '#8d6e63');
        tableGradient.addColorStop(1, '#6d4c41');
        
        this.ctx.fillStyle = tableGradient;
        this.ctx.fillRect(x, y - 10, 160, 18);
        
        // Items on table
        // Tea cup
        this.ctx.fillStyle = '#fff';
        this.ctx.beginPath();
        this.ctx.ellipse(x + 40, y - 8, 12, 8, 0, 0, Math.PI * 2);
        this.ctx.fill();
        this.ctx.fillStyle = '#81c784';
        this.ctx.beginPath();
        this.ctx.ellipse(x + 40, y - 8, 8, 5, 0, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Book
        this.ctx.fillStyle = '#5c6bc0';
        this.ctx.save();
        this.ctx.translate(x + 100, y - 10);
        this.ctx.rotate(-0.1);
        this.ctx.fillRect(0, 0, 40, 6);
        this.ctx.restore();
    }

    drawCushion() {
        const x = this.w * 0.25;
        const y = this.h * 0.75;
        
        // Cushion
        const cushionGradient = this.ctx.createRadialGradient(x, y, 10, x, y, 45);
        cushionGradient.addColorStop(0, '#e8b4b8');
        cushionGradient.addColorStop(1, '#d4919a');
        
        this.ctx.fillStyle = cushionGradient;
        this.ctx.beginPath();
        this.ctx.ellipse(x, y, 45, 20, 0, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Cushion detail
        this.ctx.strokeStyle = 'rgba(255, 255, 255, 0.3)';
        this.ctx.lineWidth = 2;
        this.ctx.beginPath();
        this.ctx.ellipse(x, y - 3, 30, 12, 0, 0, Math.PI * 2);
        this.ctx.stroke();
    }

    drawBookshelf() {
        const x = this.w * 0.02;
        const y = this.h * 0.2;
        
        // Shelf frame
        const shelfGradient = this.ctx.createLinearGradient(x, y, x + 100, y);
        shelfGradient.addColorStop(0, '#6d4c41');
        shelfGradient.addColorStop(0.5, '#8d6e63');
        shelfGradient.addColorStop(1, '#6d4c41');
        
        this.ctx.fillStyle = shelfGradient;
        
        // Back panel
        this.ctx.fillRect(x, y, 100, 180);
        
        // Shelves
        this.ctx.fillStyle = '#5d4037';
        for (let i = 0; i < 4; i++) {
            this.ctx.fillRect(x - 5, y + i * 45 + 40, 110, 8);
        }
        
        // Books on shelves
        const bookColors = ['#e57373', '#64b5f6', '#81c784', '#ffb74d', '#ba68c8', '#4db6ac'];
        
        for (let shelf = 0; shelf < 3; shelf++) {
            let bookX = x + 8;
            const shelfY = y + shelf * 45 + 8;
            
            for (let i = 0; i < 6; i++) {
                if (Math.random() > 0.2) {
                    const bookWidth = 8 + Math.random() * 6;
                    const bookHeight = 30 + Math.random() * 10;
                    
                    this.ctx.fillStyle = bookColors[Math.floor(Math.random() * bookColors.length)];
                    this.ctx.fillRect(bookX, shelfY + (40 - bookHeight), bookWidth, bookHeight);
                    
                    // Book spine detail
                    this.ctx.strokeStyle = 'rgba(0, 0, 0, 0.1)';
                    this.ctx.lineWidth = 1;
                    this.ctx.strokeRect(bookX, shelfY + (40 - bookHeight), bookWidth, bookHeight);
                    
                    bookX += bookWidth + 2;
                } else {
                    bookX += 10;
                }
            }
        }
        
        // Small plant on top shelf
        this.utils.drawPlant(x + 80, y + 160, 25);
    }

    drawBedArea() {
        // Suggestion of bed/futon at edge
        const x = this.w * 0.0;
        const y = this.h * 0.55;
        
        // Pillow
        const pillowGradient = this.ctx.createLinearGradient(x, y, x + 60, y + 30);
        pillowGradient.addColorStop(0, '#fff8e1');
        pillowGradient.addColorStop(1, '#ffecb3');
        
        this.ctx.fillStyle = pillowGradient;
        this.ctx.beginPath();
        this.ctx.ellipse(x + 30, y + 15, 35, 18, -0.2, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Blanket edge
        const blanketGradient = this.ctx.createLinearGradient(x, y + 20, x, y + 100);
        blanketGradient.addColorStop(0, '#90caf9');
        blanketGradient.addColorStop(1, '#64b5f6');
        
        this.ctx.fillStyle = blanketGradient;
        this.ctx.beginPath();
        this.ctx.moveTo(x, y + 25);
        this.ctx.quadraticCurveTo(x + 40, y + 20, x + 80, y + 35);
        this.ctx.lineTo(x + 60, y + 100);
        this.ctx.lineTo(x, y + 100);
        this.ctx.closePath();
        this.ctx.fill();
    }

    drawKitchenArea() {
        const x = this.w * 0.0;
        const y = this.h * 0.0;
        
        // Mini kitchen counter (visible at edge)
        const counterGradient = this.ctx.createLinearGradient(x, y + 180, x, y + 260);
        counterGradient.addColorStop(0, '#e0e0e0');
        counterGradient.addColorStop(1, '#bdbdbd');
        
        this.ctx.fillStyle = counterGradient;
        this.ctx.fillRect(x, y + 180, 120, 80);
        
        // Sink
        this.ctx.fillStyle = '#9e9e9e';
        this.ctx.fillRect(x + 20, y + 195, 50, 35);
        this.ctx.fillStyle = '#78909c';
        this.ctx.fillRect(x + 25, y + 200, 40, 25);
        
        // Faucet
        this.ctx.fillStyle = '#b0bec5';
        this.ctx.fillRect(x + 55, y + 185, 8, 20);
        this.ctx.beginPath();
        this.ctx.arc(x + 47, y + 188, 12, Math.PI, 0);
        this.ctx.lineWidth = 4;
        this.ctx.strokeStyle = '#b0bec5';
        this.ctx.stroke();
        
        // Small items
        // Dish soap
        this.ctx.fillStyle = '#81c784';
        this.ctx.fillRect(x + 80, y + 200, 15, 30);
        this.ctx.fillStyle = '#fff';
        this.ctx.fillRect(x + 82, y + 195, 11, 8);
    }

    drawDecorations() {
        // Wall poster/art
        this.drawWallArt();
        
        // Clock
        this.utils.drawClock(this.w * 0.45, this.h * 0.12, 25);
        
        // String lights
        this.drawStringLights();
        
        // Small rug
        this.drawRug();
    }

    drawWallArt() {
        const x = this.w * 0.25;
        const y = this.h * 0.08;
        
        // Frame
        this.ctx.fillStyle = '#5d4037';
        this.ctx.fillRect(x - 5, y - 5, 90, 75);
        
        // Art background
        const artGradient = this.ctx.createLinearGradient(x, y, x, y + 65);
        artGradient.addColorStop(0, '#e8f5e9');
        artGradient.addColorStop(1, '#c8e6c9');
        
        this.ctx.fillStyle = artGradient;
        this.ctx.fillRect(x, y, 80, 65);
        
        // Simple watercolor-style art (abstract flowers)
        this.ctx.save();
        this.ctx.globalAlpha = 0.6;
        
        // Pink blob
        this.ctx.fillStyle = '#f8bbd9';
        this.ctx.beginPath();
        this.ctx.arc(x + 25, y + 35, 15, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Yellow blob
        this.ctx.fillStyle = '#fff9c4';
        this.ctx.beginPath();
        this.ctx.arc(x + 50, y + 30, 12, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Stems
        this.ctx.strokeStyle = '#81c784';
        this.ctx.lineWidth = 2;
        this.ctx.beginPath();
        this.ctx.moveTo(x + 25, y + 45);
        this.ctx.lineTo(x + 30, y + 60);
        this.ctx.moveTo(x + 50, y + 40);
        this.ctx.lineTo(x + 48, y + 60);
        this.ctx.stroke();
        
        this.ctx.restore();
    }

    drawStringLights() {
        const startX = this.w * 0.55;
        const endX = this.w * 0.98;
        const y = this.h * 0.05;
        
        // String
        this.ctx.strokeStyle = '#5d4037';
        this.ctx.lineWidth = 2;
        this.ctx.beginPath();
        this.ctx.moveTo(startX, y);
        
        for (let x = startX; x < endX; x += 30) {
            const sagY = y + Math.sin((x - startX) / 50) * 10 + 5;
            this.ctx.lineTo(x, sagY);
        }
        this.ctx.lineTo(endX, y);
        this.ctx.stroke();
        
        // Bulbs
        for (let x = startX + 20; x < endX - 10; x += 35) {
            const sagY = y + Math.sin((x - startX) / 50) * 10 + 8;
            
            // Bulb glow
            this.ctx.save();
            this.ctx.globalAlpha = 0.3;
            const glowGradient = this.ctx.createRadialGradient(x, sagY + 8, 2, x, sagY + 8, 15);
            glowGradient.addColorStop(0, '#fff9c4');
            glowGradient.addColorStop(1, 'rgba(255, 249, 196, 0)');
            this.ctx.fillStyle = glowGradient;
            this.ctx.beginPath();
            this.ctx.arc(x, sagY + 8, 15, 0, Math.PI * 2);
            this.ctx.fill();
            this.ctx.restore();
            
            // Bulb
            const colors = ['#ffeb3b', '#ff9800', '#e91e63', '#4caf50', '#2196f3'];
            this.ctx.fillStyle = colors[Math.floor(Math.random() * 10000) % colors.length];
            this.ctx.beginPath();
            this.ctx.ellipse(x, sagY + 8, 5, 7, 0, 0, Math.PI * 2);
            this.ctx.fill();
        }
    }

    drawRug() {
        const x = this.w * 0.1;
        const y = this.h * 0.82;
        
        // Rug shape
        const rugGradient = this.ctx.createLinearGradient(x, y, x + 180, y);
        rugGradient.addColorStop(0, '#8e24aa');
        rugGradient.addColorStop(0.5, '#ab47bc');
        rugGradient.addColorStop(1, '#8e24aa');
        
        this.ctx.fillStyle = rugGradient;
        this.ctx.beginPath();
        this.ctx.ellipse(x + 90, y + 20, 95, 35, 0, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Pattern
        this.ctx.save();
        this.ctx.globalAlpha = 0.3;
        this.ctx.strokeStyle = '#e1bee7';
        this.ctx.lineWidth = 2;
        this.ctx.beginPath();
        this.ctx.ellipse(x + 90, y + 20, 70, 25, 0, 0, Math.PI * 2);
        this.ctx.stroke();
        this.ctx.beginPath();
        this.ctx.ellipse(x + 90, y + 20, 45, 15, 0, 0, Math.PI * 2);
        this.ctx.stroke();
        this.ctx.restore();
    }

    drawLighting(timeOfDay) {
        if (timeOfDay === 'evening' || timeOfDay === 'night') {
            // Warm room lighting
            this.ctx.save();
            this.ctx.globalAlpha = 0.12;
            
            const warmGradient = this.ctx.createRadialGradient(
                this.w * 0.4, this.h * 0.3, 50,
                this.w * 0.4, this.h * 0.3, this.w * 0.6
            );
            warmGradient.addColorStop(0, '#fff9c4');
            warmGradient.addColorStop(0.5, '#ffe082');
            warmGradient.addColorStop(1, 'rgba(255, 224, 130, 0)');
            
            this.ctx.fillStyle = warmGradient;
            this.ctx.fillRect(0, 0, this.w, this.h);
            
            this.ctx.restore();
        }
    }
}
