/**
 * TSUZUKI CONNECT - Cafe Background
 * Style: Honey and Clover - soft watercolor aesthetic
 */

import { BackgroundUtils } from './BackgroundUtils.js';
import { BackgroundAssets } from './BackgroundAssets.js';

export class CafeBackground {
    constructor(ctx, width, height) {
        this.ctx = ctx;
        this.w = width;
        this.h = height;
        this.utils = new BackgroundUtils(ctx);
    }

    draw(timeOfDay = 'afternoon') {
        const assetPath = BackgroundAssets.getPath('cafe', timeOfDay);
        const imageDrawn = this.utils.drawImageBackground(assetPath, this.w, this.h);

        if (!imageDrawn) {
            this.drawWalls();
            this.drawFloor();
            this.drawWindow(timeOfDay);
            this.drawCounter();
            this.drawMenuBoard();
            this.drawTables();
            this.drawDecorations();
        }
        
        this.utils.drawWatercolorTexture(this.w, this.h, 0.03);
    }

    drawWalls() {
        // Main wall with warm gradient
        const wallGradient = this.utils.createWatercolorGradient(
            0, 0, 0, this.h * 0.7,
            ['#efebe9', '#d7ccc8', '#bcaaa4']
        );
        this.ctx.fillStyle = wallGradient;
        this.ctx.fillRect(0, 0, this.w, this.h * 0.7);
        
        // Accent wall stripe
        this.ctx.fillStyle = 'rgba(121, 85, 72, 0.1)';
        this.ctx.fillRect(0, this.h * 0.12, this.w, this.h * 0.03);
        
        // Wainscoting on lower wall
        this.ctx.fillStyle = '#8d6e63';
        this.ctx.fillRect(0, this.h * 0.5, this.w, this.h * 0.02);
        
        const woodGradient = this.utils.createWatercolorGradient(
            0, this.h * 0.52, 0, this.h * 0.7,
            ['#a1887f', '#8d6e63', '#795548']
        );
        this.ctx.fillStyle = woodGradient;
        this.ctx.fillRect(0, this.h * 0.52, this.w, this.h * 0.18);
    }

    drawFloor() {
        // Wooden floor
        const floorGradient = this.utils.createWatercolorGradient(
            0, this.h * 0.7, 0, this.h,
            ['#8d6e63', '#6d4c41', '#5d4037']
        );
        this.ctx.fillStyle = floorGradient;
        this.ctx.fillRect(0, this.h * 0.7, this.w, this.h * 0.3);
        
        // Floor planks
        this.ctx.strokeStyle = 'rgba(93, 64, 55, 0.3)';
        this.ctx.lineWidth = 1;
        
        for (let i = 0; i < 10; i++) {
            const y = this.h * 0.7 + i * (this.h * 0.032);
            this.ctx.beginPath();
            this.ctx.moveTo(0, y);
            this.ctx.lineTo(this.w, y);
            this.ctx.stroke();
        }
    }

    drawWindow(timeOfDay) {
        const x = this.w * 0.02;
        const y = this.h * 0.08;
        const width = this.w * 0.28;
        const height = this.h * 0.4;
        
        // Window frame
        this.ctx.fillStyle = '#d7ccc8';
        this.ctx.fillRect(x - 10, y - 10, width + 20, height + 20);
        
        // Sky outside
        let skyColors;
        switch (timeOfDay) {
            case 'morning':
                skyColors = ['#fff8e1', '#ffecb3', '#81d4fa'];
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
        
        // Trees/buildings outside
        this.ctx.fillStyle = timeOfDay === 'night' ? '#1a237e' : '#81c784';
        this.ctx.beginPath();
        this.ctx.arc(x + width * 0.25, y + height * 0.75, 40, 0, Math.PI * 2);
        this.ctx.arc(x + width * 0.7, y + height * 0.8, 35, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Window dividers
        this.ctx.fillStyle = '#bcaaa4';
        this.ctx.fillRect(x + width / 2 - 4, y, 8, height);
        this.ctx.fillRect(x, y + height / 2 - 4, width, 8);
        
        // Curtains
        this.drawCurtain(x - 20, y - 20, 40, height + 50, '#fff8e1');
        this.drawCurtain(x + width - 20, y - 20, 40, height + 50, '#fff8e1');
        
        // Window sill with plant
        this.ctx.fillStyle = '#8d6e63';
        this.ctx.fillRect(x - 10, y + height + 5, width + 20, 15);
        this.utils.drawPlant(x + width * 0.8, y + height - 5, 0.6);
    }

    drawCurtain(x, y, width, height, color) {
        this.ctx.fillStyle = this.utils.hexToRgba(color.replace('#', ''), 0.7);
        
        this.ctx.beginPath();
        this.ctx.moveTo(x, y);
        
        // Wavy curtain edge
        for (let i = 0; i <= 8; i++) {
            const yPos = y + (height / 8) * i;
            const xOffset = (i % 2 === 0) ? 8 : -5;
            this.ctx.lineTo(x + width / 2 + xOffset, yPos);
        }
        
        this.ctx.lineTo(x + width, y + height);
        this.ctx.lineTo(x, y + height);
        this.ctx.closePath();
        this.ctx.fill();
    }

    drawCounter() {
        const x = this.w * 0.58;
        const y = this.h * 0.38;
        const width = this.w * 0.42;
        const height = this.h * 0.35;
        
        // Counter back wall / shelves
        this.ctx.fillStyle = '#5d4037';
        this.ctx.fillRect(x, y - this.h * 0.25, width, this.h * 0.25);
        
        // Shelves with bottles/jars
        for (let shelf = 0; shelf < 3; shelf++) {
            const shelfY = y - this.h * 0.22 + shelf * this.h * 0.07;
            
            // Shelf board
            this.ctx.fillStyle = '#8d6e63';
            this.ctx.fillRect(x + 10, shelfY + this.h * 0.05, width - 20, 6);
            
            // Items on shelf
            const items = 8;
            for (let i = 0; i < items; i++) {
                const itemX = x + 20 + i * (width - 40) / items;
                const itemColors = ['#4caf50', '#2196f3', '#ff9800', '#9c27b0', '#795548', '#f44336', '#3f51b5', '#009688'];
                
                // Jar/bottle
                this.ctx.fillStyle = itemColors[i % itemColors.length];
                this.ctx.fillRect(itemX, shelfY, 18, this.h * 0.045);
                
                // Cap
                this.ctx.fillStyle = '#5d4037';
                this.ctx.fillRect(itemX + 2, shelfY - 5, 14, 6);
            }
        }
        
        // Counter top
        const counterTopGradient = this.utils.createWatercolorGradient(
            x, y, x + width, y,
            ['#a1887f', '#8d6e63', '#795548']
        );
        this.ctx.fillStyle = counterTopGradient;
        this.ctx.fillRect(x, y, width, this.h * 0.04);
        
        // Counter front
        const counterGradient = this.utils.createWatercolorGradient(
            x, y + this.h * 0.04, x, y + height,
            ['#6d4c41', '#5d4037', '#4e342e']
        );
        this.ctx.fillStyle = counterGradient;
        this.ctx.fillRect(x, y + this.h * 0.04, width, height - this.h * 0.04);
        
        // Display case glass
        this.ctx.fillStyle = 'rgba(255, 255, 255, 0.3)';
        this.ctx.fillRect(x + 20, y + this.h * 0.08, width * 0.4, this.h * 0.18);
        
        // Pastries in display
        const pastryColors = ['#d7a86e', '#ffcc80', '#bcaaa4', '#ffb74d'];
        for (let i = 0; i < 4; i++) {
            this.ctx.fillStyle = pastryColors[i];
            this.ctx.beginPath();
            this.ctx.ellipse(x + 40 + i * 40, y + this.h * 0.2, 15, 10, 0, 0, Math.PI * 2);
            this.ctx.fill();
        }
        
        // Coffee machine
        this.drawCoffeeMachine(x + width - 80, y - 60);
        
        // Cash register
        this.ctx.fillStyle = '#37474f';
        this.ctx.fillRect(x + width - 150, y - 40, 50, 40);
        this.ctx.fillStyle = '#78909c';
        this.ctx.fillRect(x + width - 145, y - 35, 40, 20);
    }

    drawCoffeeMachine(x, y) {
        // Machine body
        this.ctx.fillStyle = '#455a64';
        this.ctx.fillRect(x, y, 60, 80);
        
        // Chrome top
        const chromeGradient = this.ctx.createLinearGradient(x, y, x + 60, y);
        chromeGradient.addColorStop(0, '#90a4ae');
        chromeGradient.addColorStop(0.5, '#cfd8dc');
        chromeGradient.addColorStop(1, '#90a4ae');
        
        this.ctx.fillStyle = chromeGradient;
        this.ctx.fillRect(x - 5, y - 10, 70, 15);
        
        // Pressure gauge
        this.ctx.fillStyle = '#263238';
        this.ctx.beginPath();
        this.ctx.arc(x + 30, y + 25, 15, 0, Math.PI * 2);
        this.ctx.fill();
        this.ctx.fillStyle = '#fff';
        this.ctx.beginPath();
        this.ctx.arc(x + 30, y + 25, 12, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Drip tray
        this.ctx.fillStyle = '#37474f';
        this.ctx.fillRect(x + 5, y + 55, 50, 20);
        
        // Cup
        this.ctx.fillStyle = '#fff';
        this.ctx.beginPath();
        this.ctx.moveTo(x + 20, y + 50);
        this.ctx.lineTo(x + 40, y + 50);
        this.ctx.lineTo(x + 38, y + 70);
        this.ctx.lineTo(x + 22, y + 70);
        this.ctx.closePath();
        this.ctx.fill();
    }

    drawMenuBoard() {
        const x = this.w * 0.62;
        const y = this.h * 0.03;
        const width = this.w * 0.32;
        const height = this.h * 0.18;
        
        // Board
        this.ctx.fillStyle = '#263238';
        this.ctx.fillRect(x, y, width, height);
        
        // Frame
        this.ctx.strokeStyle = '#5d4037';
        this.ctx.lineWidth = 6;
        this.ctx.strokeRect(x, y, width, height);
        
        // Menu text
        this.ctx.fillStyle = '#fff';
        this.ctx.font = 'bold 18px "Nunito", sans-serif';
        this.ctx.textAlign = 'center';
        this.ctx.fillText('☕ MENU', x + width / 2, y + 25);
        
        this.ctx.font = '14px "Noto Sans JP", sans-serif';
        this.ctx.textAlign = 'left';
        
        const menuItems = [
            { name: 'コーヒー Coffee', price: '¥450' },
            { name: 'ラテ Latte', price: '¥520' },
            { name: '抹茶 Matcha', price: '¥550' },
            { name: 'ケーキ Cake', price: '¥480' },
        ];
        
        menuItems.forEach((item, i) => {
            this.ctx.fillStyle = '#fff';
            this.ctx.fillText(item.name, x + 15, y + 50 + i * 22);
            this.ctx.textAlign = 'right';
            this.ctx.fillText(item.price, x + width - 15, y + 50 + i * 22);
            this.ctx.textAlign = 'left';
        });
    }

    drawTables() {
        // Table positions
        const tables = [
            { x: this.w * 0.12, y: this.h * 0.58 },
            { x: this.w * 0.35, y: this.h * 0.62 },
        ];
        
        tables.forEach((t, i) => this.drawCafeTable(t.x, t.y, i === 0));
    }

    drawCafeTable(x, y, hasItems = true) {
        // Table leg
        this.ctx.fillStyle = '#5d4037';
        this.ctx.fillRect(x - 8, y + 25, 16, 80);
        
        // Table base
        this.ctx.fillStyle = '#6d4c41';
        this.ctx.beginPath();
        this.ctx.ellipse(x, y + 100, 35, 12, 0, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Table top
        const tableGradient = this.ctx.createRadialGradient(x, y, 0, x, y, 60);
        tableGradient.addColorStop(0, '#efebe9');
        tableGradient.addColorStop(1, '#d7ccc8');
        
        this.ctx.fillStyle = tableGradient;
        this.ctx.beginPath();
        this.ctx.ellipse(x, y, 60, 28, 0, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Table edge
        this.ctx.strokeStyle = '#bcaaa4';
        this.ctx.lineWidth = 3;
        this.ctx.stroke();
        
        if (hasItems) {
            // Coffee cup
            this.ctx.fillStyle = '#fff';
            this.ctx.beginPath();
            this.ctx.ellipse(x + 15, y - 3, 14, 8, 0, 0, Math.PI * 2);
            this.ctx.fill();
            
            // Coffee inside
            this.ctx.fillStyle = '#5d4037';
            this.ctx.beginPath();
            this.ctx.ellipse(x + 15, y - 5, 11, 6, 0, 0, Math.PI * 2);
            this.ctx.fill();
            
            // Cup handle
            this.ctx.strokeStyle = '#fff';
            this.ctx.lineWidth = 3;
            this.ctx.beginPath();
            this.ctx.arc(x + 30, y - 3, 6, -0.5, 2, false);
            this.ctx.stroke();
            
            // Saucer
            this.ctx.fillStyle = '#f5f5f5';
            this.ctx.beginPath();
            this.ctx.ellipse(x + 15, y + 3, 18, 5, 0, 0, Math.PI * 2);
            this.ctx.fill();
            
            // Book
            this.ctx.fillStyle = '#c62828';
            this.ctx.save();
            this.ctx.translate(x - 25, y - 5);
            this.ctx.rotate(-0.2);
            this.ctx.fillRect(0, 0, 30, 22);
            this.ctx.restore();
        }
        
        // Chair
        this.drawChair(x - 50, y + 30);
        this.drawChair(x + 50, y + 30, true);
    }

    drawChair(x, y, flipped = false) {
        this.ctx.save();
        if (flipped) {
            this.ctx.translate(x, y);
            this.ctx.scale(-1, 1);
            this.ctx.translate(-x, -y);
        }
        
        // Seat
        this.ctx.fillStyle = '#8d6e63';
        this.ctx.beginPath();
        this.ctx.ellipse(x, y, 25, 12, 0, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Back
        this.ctx.fillStyle = '#6d4c41';
        this.ctx.beginPath();
        this.ctx.ellipse(x - 15, y - 30, 8, 25, 0.3, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Legs
        this.ctx.fillStyle = '#5d4037';
        this.ctx.fillRect(x - 18, y + 8, 5, 40);
        this.ctx.fillRect(x + 13, y + 8, 5, 40);
        
        this.ctx.restore();
    }

    drawDecorations() {
        // Hanging lights
        this.drawHangingLight(this.w * 0.2, this.h * 0.05);
        this.drawHangingLight(this.w * 0.45, this.h * 0.03);
        
        // Wall art
        this.drawWallArt(this.w * 0.35, this.h * 0.18);
        
        // Plants
        this.utils.drawPlant(this.w * 0.52, this.h * 0.65, 1.1);
    }

    drawHangingLight(x, y) {
        // Wire
        this.ctx.strokeStyle = '#5d4037';
        this.ctx.lineWidth = 2;
        this.ctx.beginPath();
        this.ctx.moveTo(x, 0);
        this.ctx.lineTo(x, y + 20);
        this.ctx.stroke();
        
        // Shade
        const shadeGradient = this.ctx.createRadialGradient(x, y + 40, 5, x, y + 40, 35);
        shadeGradient.addColorStop(0, '#fff9c4');
        shadeGradient.addColorStop(0.5, '#ffcc80');
        shadeGradient.addColorStop(1, '#ffb74d');
        
        this.ctx.fillStyle = shadeGradient;
        this.ctx.beginPath();
        this.ctx.moveTo(x - 10, y + 20);
        this.ctx.lineTo(x + 10, y + 20);
        this.ctx.lineTo(x + 25, y + 55);
        this.ctx.lineTo(x - 25, y + 55);
        this.ctx.closePath();
        this.ctx.fill();
        
        // Light glow
        this.ctx.save();
        this.ctx.globalAlpha = 0.15;
        const glowGradient = this.ctx.createRadialGradient(x, y + 55, 10, x, y + 55, 100);
        glowGradient.addColorStop(0, '#fff9c4');
        glowGradient.addColorStop(1, 'rgba(255, 249, 196, 0)');
        
        this.ctx.fillStyle = glowGradient;
        this.ctx.beginPath();
        this.ctx.arc(x, y + 55, 100, 0, Math.PI * 2);
        this.ctx.fill();
        this.ctx.restore();
    }

    drawWallArt(x, y) {
        // Frame
        this.ctx.fillStyle = '#6d4c41';
        this.ctx.fillRect(x - 5, y - 5, 90, 70);
        
        // Canvas
        const artGradient = this.ctx.createLinearGradient(x, y, x + 80, y + 60);
        artGradient.addColorStop(0, '#fff8e1');
        artGradient.addColorStop(0.5, '#ffecb3');
        artGradient.addColorStop(1, '#ffe082');
        
        this.ctx.fillStyle = artGradient;
        this.ctx.fillRect(x, y, 80, 60);
        
        // Simple abstract art (coffee cup shape)
        this.ctx.fillStyle = '#8d6e63';
        this.ctx.beginPath();
        this.ctx.ellipse(x + 40, y + 35, 20, 15, 0, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Steam swirls
        this.ctx.strokeStyle = '#bcaaa4';
        this.ctx.lineWidth = 2;
        this.ctx.beginPath();
        this.ctx.moveTo(x + 35, y + 18);
        this.ctx.quadraticCurveTo(x + 30, y + 12, x + 35, y + 8);
        this.ctx.moveTo(x + 45, y + 18);
        this.ctx.quadraticCurveTo(x + 50, y + 10, x + 45, y + 5);
        this.ctx.stroke();
    }
}
