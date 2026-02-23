/**
 * TSUZUKI CONNECT - Izakaya Background
 * Style: Honey and Clover - warm, nostalgic atmosphere
 */

import { BackgroundUtils } from './BackgroundUtils.js';
import { BackgroundAssets } from './BackgroundAssets.js';

export class IzakayaBackground {
    constructor(ctx, width, height) {
        this.ctx = ctx;
        this.w = width;
        this.h = height;
        this.utils = new BackgroundUtils(ctx);
    }

    draw(timeOfDay = 'evening') {
        const assetPath = BackgroundAssets.getPath('izakaya', timeOfDay);
        const imageDrawn = this.utils.drawImageBackground(assetPath, this.w, this.h);

        if (!imageDrawn) {
            this.drawInterior();
            this.drawCounter();
            this.drawBackBar();
            this.drawSeating();
            this.drawLanterns();
            this.drawDecorations();
            this.drawWarmLighting();
        }
        
        this.utils.drawWatercolorTexture(this.w, this.h, 0.02);
    }

    drawInterior() {
        // Dark wood walls with warm undertone
        const wallGradient = this.utils.createWatercolorGradient(
            0, 0, 0, this.h,
            ['#3e2723', '#4e342e', '#3e2723']
        );
        this.ctx.fillStyle = wallGradient;
        this.ctx.fillRect(0, 0, this.w, this.h);
        
        // Wood panel texture
        this.ctx.save();
        this.ctx.globalAlpha = 0.1;
        for (let i = 0; i < this.w; i += 80) {
            this.ctx.strokeStyle = '#2d1f14';
            this.ctx.lineWidth = 2;
            this.ctx.beginPath();
            this.ctx.moveTo(i, 0);
            this.ctx.lineTo(i, this.h);
            this.ctx.stroke();
        }
        this.ctx.restore();
        
        // Floor
        const floorGradient = this.utils.createWatercolorGradient(
            0, this.h * 0.7, 0, this.h,
            ['#5d4037', '#4e342e', '#3e2723']
        );
        this.ctx.fillStyle = floorGradient;
        this.ctx.fillRect(0, this.h * 0.7, this.w, this.h * 0.3);
    }

    drawCounter() {
        const counterY = this.h * 0.48;
        
        // Counter top
        const counterGradient = this.utils.createWatercolorGradient(
            0, counterY, this.w, counterY,
            ['#6d4c41', '#8d6e63', '#6d4c41']
        );
        this.ctx.fillStyle = counterGradient;
        this.ctx.fillRect(0, counterY, this.w, this.h * 0.06);
        
        // Wood grain highlights
        this.ctx.save();
        this.ctx.globalAlpha = 0.2;
        for (let i = 0; i < 8; i++) {
            this.ctx.strokeStyle = '#a1887f';
            this.ctx.lineWidth = 1;
            this.ctx.beginPath();
            this.ctx.moveTo(i * 160, counterY + 5);
            this.ctx.quadraticCurveTo(i * 160 + 80, counterY + this.h * 0.03, i * 160 + 160, counterY + 8);
            this.ctx.stroke();
        }
        this.ctx.restore();
        
        // Counter front
        this.ctx.fillStyle = '#5d4037';
        this.ctx.fillRect(0, counterY + this.h * 0.06, this.w, this.h * 0.15);
        
        // Counter edge trim
        this.ctx.fillStyle = '#4e342e';
        this.ctx.fillRect(0, counterY + this.h * 0.055, this.w, 5);
        
        // Items on counter
        this.drawCounterItems(counterY);
    }

    drawCounterItems(counterY) {
        // Sake bottles
        const bottles = [
            { x: this.w * 0.1, label: '一' },
            { x: this.w * 0.15, label: '二' },
            { x: this.w * 0.7, label: '三' },
        ];
        
        bottles.forEach(b => {
            // Bottle
            this.ctx.fillStyle = '#1b5e20';
            this.ctx.beginPath();
            this.ctx.moveTo(b.x - 10, counterY - 2);
            this.ctx.lineTo(b.x + 10, counterY - 2);
            this.ctx.lineTo(b.x + 8, counterY - 50);
            this.ctx.lineTo(b.x + 4, counterY - 55);
            this.ctx.lineTo(b.x + 4, counterY - 65);
            this.ctx.lineTo(b.x - 4, counterY - 65);
            this.ctx.lineTo(b.x - 4, counterY - 55);
            this.ctx.lineTo(b.x - 8, counterY - 50);
            this.ctx.closePath();
            this.ctx.fill();
            
            // Label
            this.ctx.fillStyle = '#fff8e1';
            this.ctx.fillRect(b.x - 6, counterY - 40, 12, 20);
            this.ctx.fillStyle = '#c62828';
            this.ctx.font = '12px "Noto Sans JP", sans-serif';
            this.ctx.textAlign = 'center';
            this.ctx.fillText(b.label, b.x, counterY - 25);
        });
        
        // Sake cups (ochoko)
        [this.w * 0.25, this.w * 0.35, this.w * 0.55].forEach(x => {
            this.ctx.fillStyle = '#f5f5f5';
            this.ctx.beginPath();
            this.ctx.moveTo(x - 8, counterY - 2);
            this.ctx.lineTo(x + 8, counterY - 2);
            this.ctx.lineTo(x + 6, counterY - 15);
            this.ctx.lineTo(x - 6, counterY - 15);
            this.ctx.closePath();
            this.ctx.fill();
        });
        
        // Plate with food
        this.ctx.fillStyle = '#fff8e1';
        this.ctx.beginPath();
        this.ctx.ellipse(this.w * 0.45, counterY - 5, 35, 10, 0, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Food items (yakitori)
        this.ctx.fillStyle = '#d7a86e';
        for (let i = 0; i < 3; i++) {
            this.ctx.fillRect(this.w * 0.42 + i * 12, counterY - 12, 8, 4);
            this.ctx.fillRect(this.w * 0.42 + i * 12, counterY - 18, 8, 4);
        }
        // Skewers
        this.ctx.fillStyle = '#a1887f';
        for (let i = 0; i < 3; i++) {
            this.ctx.fillRect(this.w * 0.425 + i * 12, counterY - 22, 2, 25);
        }
    }

    drawBackBar() {
        const shelfY = this.h * 0.12;
        const shelfHeight = this.h * 0.08;
        
        // Back wall shelving
        for (let shelf = 0; shelf < 3; shelf++) {
            const y = shelfY + shelf * (shelfHeight + this.h * 0.05);
            
            // Shelf board
            this.ctx.fillStyle = '#5d4037';
            this.ctx.fillRect(this.w * 0.1, y + shelfHeight - 5, this.w * 0.8, 8);
            
            // Bottles on shelf
            const bottleCount = 12;
            for (let i = 0; i < bottleCount; i++) {
                const x = this.w * 0.12 + i * (this.w * 0.78 / bottleCount);
                const bottleHeight = 40 + Math.random() * 20;
                
                // Different bottle colors
                const colors = ['#1b5e20', '#4a148c', '#0d47a1', '#b71c1c', '#4e342e', '#1565c0'];
                this.ctx.fillStyle = colors[i % colors.length];
                
                this.ctx.beginPath();
                this.ctx.moveTo(x - 8, y + shelfHeight - 5);
                this.ctx.lineTo(x + 8, y + shelfHeight - 5);
                this.ctx.lineTo(x + 6, y + shelfHeight - bottleHeight);
                this.ctx.lineTo(x + 3, y + shelfHeight - bottleHeight - 8);
                this.ctx.lineTo(x - 3, y + shelfHeight - bottleHeight - 8);
                this.ctx.lineTo(x - 6, y + shelfHeight - bottleHeight);
                this.ctx.closePath();
                this.ctx.fill();
                
                // Label
                if (Math.random() > 0.3) {
                    this.ctx.fillStyle = '#fff8e1';
                    this.ctx.fillRect(x - 5, y + shelfHeight - bottleHeight + 10, 10, 15);
                }
            }
        }
    }

    drawSeating() {
        // Bar stools
        const stools = [this.w * 0.2, this.w * 0.35, this.w * 0.5, this.w * 0.65, this.w * 0.8];
        
        stools.forEach(x => this.drawBarStool(x, this.h * 0.55));
    }

    drawBarStool(x, y) {
        // Seat cushion
        const seatGradient = this.ctx.createRadialGradient(x, y + 15, 5, x, y + 15, 30);
        seatGradient.addColorStop(0, '#8d6e63');
        seatGradient.addColorStop(1, '#6d4c41');
        
        this.ctx.fillStyle = seatGradient;
        this.ctx.beginPath();
        this.ctx.ellipse(x, y + 15, 28, 12, 0, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Seat sides
        this.ctx.fillStyle = '#5d4037';
        this.ctx.beginPath();
        this.ctx.ellipse(x, y + 20, 28, 12, 0, 0, Math.PI);
        this.ctx.fill();
        
        // Stool leg
        this.ctx.fillStyle = '#4e342e';
        this.ctx.fillRect(x - 5, y + 25, 10, 70);
        
        // Base
        this.ctx.fillStyle = '#3e2723';
        this.ctx.beginPath();
        this.ctx.ellipse(x, y + 95, 22, 8, 0, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Footrest ring
        this.ctx.strokeStyle = '#6d4c41';
        this.ctx.lineWidth = 4;
        this.ctx.beginPath();
        this.ctx.ellipse(x, y + 65, 20, 6, 0, 0, Math.PI * 2);
        this.ctx.stroke();
    }

    drawLanterns() {
        // Traditional paper lanterns
        const lanternPositions = [
            { x: this.w * 0.15, y: this.h * 0.08, kanji: '酒' },
            { x: this.w * 0.4, y: this.h * 0.05, kanji: '居' },
            { x: this.w * 0.65, y: this.h * 0.08, kanji: '酒' },
            { x: this.w * 0.88, y: this.h * 0.06, kanji: '屋' },
        ];
        
        lanternPositions.forEach(l => this.utils.drawLantern(l.x, l.y, l.kanji));
    }

    drawDecorations() {
        // Noren (curtain) hanging
        this.drawNoren(this.w * 0.02, this.h * 0.02);
        
        // Menu boards
        this.drawMenuBoard(this.w * 0.92, this.h * 0.2);
        
        // Decorative bamboo
        this.drawBamboo(this.w * 0.98, this.h * 0.45);
        
        // Sake barrel
        this.drawSakeBarrel(this.w * 0.05, this.h * 0.55);
    }

    drawNoren(x, y) {
        // Rod
        this.ctx.fillStyle = '#5d4037';
        this.ctx.fillRect(x, y, this.w * 0.18, 8);
        
        // Curtain panels
        const panelWidth = this.w * 0.055;
        const panelHeight = this.h * 0.12;
        
        for (let i = 0; i < 3; i++) {
            const px = x + 5 + i * (panelWidth + 5);
            
            // Panel with wave bottom
            this.ctx.fillStyle = '#1565c0';
            this.ctx.beginPath();
            this.ctx.moveTo(px, y + 8);
            this.ctx.lineTo(px + panelWidth, y + 8);
            this.ctx.lineTo(px + panelWidth, y + panelHeight);
            this.ctx.quadraticCurveTo(px + panelWidth * 0.75, y + panelHeight + 10, px + panelWidth * 0.5, y + panelHeight);
            this.ctx.quadraticCurveTo(px + panelWidth * 0.25, y + panelHeight - 10, px, y + panelHeight);
            this.ctx.closePath();
            this.ctx.fill();
            
            // White circle with kanji
            this.ctx.fillStyle = '#fff';
            this.ctx.beginPath();
            this.ctx.arc(px + panelWidth / 2, y + panelHeight * 0.5, 15, 0, Math.PI * 2);
            this.ctx.fill();
            
            this.ctx.fillStyle = '#1565c0';
            this.ctx.font = 'bold 14px "Noto Sans JP", sans-serif';
            this.ctx.textAlign = 'center';
            this.ctx.textBaseline = 'middle';
            this.ctx.fillText(['つ', 'づ', 'き'][i], px + panelWidth / 2, y + panelHeight * 0.5);
        }
    }

    drawMenuBoard(x, y) {
        // Wooden board
        this.ctx.fillStyle = '#4e342e';
        this.ctx.fillRect(x - 35, y, 70, 120);
        
        // Rope hanger
        this.ctx.strokeStyle = '#8d6e63';
        this.ctx.lineWidth = 3;
        this.ctx.beginPath();
        this.ctx.moveTo(x - 15, y - 30);
        this.ctx.lineTo(x - 25, y);
        this.ctx.moveTo(x + 15, y - 30);
        this.ctx.lineTo(x + 25, y);
        this.ctx.stroke();
        
        // Menu items
        this.ctx.fillStyle = '#fff';
        this.ctx.font = '12px "Noto Sans JP", sans-serif';
        this.ctx.textAlign = 'center';
        
        const items = ['焼き鳥', '枝豆', '刺身', '唐揚げ', '豆腐'];
        items.forEach((item, i) => {
            this.ctx.fillText(item, x, y + 20 + i * 22);
        });
    }

    drawBamboo(x, y) {
        // Bamboo stalks
        for (let i = 0; i < 3; i++) {
            const bx = x - i * 12;
            const height = 200 + i * 30;
            
            // Stalk
            const bambooGradient = this.ctx.createLinearGradient(bx - 8, y, bx + 8, y);
            bambooGradient.addColorStop(0, '#558b2f');
            bambooGradient.addColorStop(0.5, '#7cb342');
            bambooGradient.addColorStop(1, '#558b2f');
            
            this.ctx.fillStyle = bambooGradient;
            this.ctx.fillRect(bx - 8, y - height, 16, height);
            
            // Nodes
            for (let n = 0; n < 4; n++) {
                this.ctx.fillStyle = '#33691e';
                this.ctx.fillRect(bx - 10, y - height + n * 55 + 20, 20, 6);
            }
        }
        
        // Leaves
        this.ctx.fillStyle = '#689f38';
        [-15, 0, 20].forEach(offset => {
            this.ctx.beginPath();
            this.ctx.ellipse(x - 20, y - 180 + offset, 25, 8, -0.5, 0, Math.PI * 2);
            this.ctx.fill();
        });
    }

    drawSakeBarrel(x, y) {
        // Barrel body
        const barrelGradient = this.ctx.createLinearGradient(x, y, x + 60, y);
        barrelGradient.addColorStop(0, '#5d4037');
        barrelGradient.addColorStop(0.5, '#8d6e63');
        barrelGradient.addColorStop(1, '#5d4037');
        
        this.ctx.fillStyle = barrelGradient;
        this.ctx.beginPath();
        this.ctx.ellipse(x + 30, y + 25, 30, 20, 0, 0, Math.PI * 2);
        this.ctx.fill();
        this.ctx.fillRect(x, y + 25, 60, 50);
        this.ctx.beginPath();
        this.ctx.ellipse(x + 30, y + 75, 30, 20, 0, 0, Math.PI);
        this.ctx.fill();
        
        // Metal bands
        this.ctx.strokeStyle = '#37474f';
        this.ctx.lineWidth = 4;
        [y + 35, y + 55, y + 70].forEach(bandY => {
            this.ctx.beginPath();
            this.ctx.moveTo(x, bandY);
            this.ctx.lineTo(x + 60, bandY);
            this.ctx.stroke();
        });
        
        // Top
        this.ctx.fillStyle = '#4e342e';
        this.ctx.beginPath();
        this.ctx.ellipse(x + 30, y + 25, 28, 18, 0, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Label
        this.ctx.fillStyle = '#fff';
        this.ctx.beginPath();
        this.ctx.ellipse(x + 30, y + 50, 18, 12, 0, 0, Math.PI * 2);
        this.ctx.fill();
        
        this.ctx.fillStyle = '#c62828';
        this.ctx.font = 'bold 14px "Noto Sans JP", sans-serif';
        this.ctx.textAlign = 'center';
        this.ctx.textBaseline = 'middle';
        this.ctx.fillText('酒', x + 30, y + 50);
    }

    drawWarmLighting() {
        // Warm ambient light from lanterns
        this.ctx.save();
        
        // General warm overlay
        const warmGradient = this.ctx.createRadialGradient(
            this.w * 0.5, this.h * 0.3, 100,
            this.w * 0.5, this.h * 0.3, this.w * 0.8
        );
        warmGradient.addColorStop(0, 'rgba(255, 183, 77, 0.15)');
        warmGradient.addColorStop(0.5, 'rgba(255, 152, 0, 0.08)');
        warmGradient.addColorStop(1, 'rgba(0, 0, 0, 0)');
        
        this.ctx.fillStyle = warmGradient;
        this.ctx.fillRect(0, 0, this.w, this.h);
        
        // Light pools under lanterns
        [this.w * 0.15, this.w * 0.4, this.w * 0.65, this.w * 0.88].forEach(x => {
            const lightGradient = this.ctx.createRadialGradient(x, this.h * 0.15, 20, x, this.h * 0.15, 150);
            lightGradient.addColorStop(0, 'rgba(255, 235, 59, 0.2)');
            lightGradient.addColorStop(0.5, 'rgba(255, 193, 7, 0.1)');
            lightGradient.addColorStop(1, 'rgba(255, 152, 0, 0)');
            
            this.ctx.fillStyle = lightGradient;
            this.ctx.beginPath();
            this.ctx.arc(x, this.h * 0.15, 150, 0, Math.PI * 2);
            this.ctx.fill();
        });
        
        this.ctx.restore();
    }
}
