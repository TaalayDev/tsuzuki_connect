/**
 * TSUZUKI CONNECT - Park Background
 * Style: Honey and Clover - soft watercolor aesthetic
 */

import { BackgroundUtils } from './BackgroundUtils.js';
import { BackgroundAssets } from './BackgroundAssets.js';

export class ParkBackground {
    constructor(ctx, width, height) {
        this.ctx = ctx;
        this.w = width;
        this.h = height;
        this.utils = new BackgroundUtils(ctx);
    }

    draw(timeOfDay = 'afternoon', season = 'spring') {
        const assetPath = BackgroundAssets.getPath('park', timeOfDay);
        const imageDrawn = this.utils.drawImageBackground(assetPath, this.w, this.h);

        if (!imageDrawn) {
            this.drawSky(timeOfDay);
            this.drawDistantTrees(timeOfDay);
            this.drawGrass();
            this.drawPath();
            this.drawTrees(season);
            this.drawBench();
            this.drawLampPost(timeOfDay);
            this.drawDecorations(season);
        }
        
        this.utils.drawWatercolorTexture(this.w, this.h, 0.03);
    }

    drawSky(timeOfDay) {
        let skyColors;
        
        switch (timeOfDay) {
            case 'morning':
                skyColors = ['#fff8e1', '#ffe0b2', '#b3e5fc', '#81d4fa'];
                break;
            case 'evening':
                skyColors = ['#ff7043', '#ff8a65', '#ffab91', '#ffcc80'];
                break;
            case 'night':
                skyColors = ['#0d1b2a', '#1b263b', '#274c77', '#6096ba'];
                break;
            default:
                skyColors = ['#64b5f6', '#90caf9', '#bbdefb', '#e3f2fd'];
        }
        
        const skyGradient = this.utils.createWatercolorGradient(0, 0, 0, this.h * 0.55, skyColors);
        this.ctx.fillStyle = skyGradient;
        this.ctx.fillRect(0, 0, this.w, this.h * 0.55);
        
        // Clouds
        if (timeOfDay !== 'night') {
            this.utils.drawCloud(this.w * 0.1, this.h * 0.08, 0.9);
            this.utils.drawCloud(this.w * 0.4, this.h * 0.12, 1.1);
            this.utils.drawCloud(this.w * 0.75, this.h * 0.06, 0.7);
        } else {
            // Stars and moon
            this.drawNightSky();
        }
    }

    drawNightSky() {
        // Stars
        this.ctx.save();
        for (let i = 0; i < 80; i++) {
            const x = Math.random() * this.w;
            const y = Math.random() * this.h * 0.45;
            const size = Math.random() * 2 + 0.5;
            const alpha = Math.random() * 0.6 + 0.2;
            
            this.ctx.fillStyle = `rgba(255, 255, 255, ${alpha})`;
            this.ctx.beginPath();
            this.ctx.arc(x, y, size, 0, Math.PI * 2);
            this.ctx.fill();
        }
        
        // Moon
        const moonGradient = this.ctx.createRadialGradient(
            this.w * 0.85, this.h * 0.12, 0,
            this.w * 0.85, this.h * 0.12, 40
        );
        moonGradient.addColorStop(0, '#fffde7');
        moonGradient.addColorStop(0.8, '#fff9c4');
        moonGradient.addColorStop(1, 'rgba(255, 249, 196, 0)');
        
        this.ctx.fillStyle = moonGradient;
        this.ctx.beginPath();
        this.ctx.arc(this.w * 0.85, this.h * 0.12, 40, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Moon glow
        const glowGradient = this.ctx.createRadialGradient(
            this.w * 0.85, this.h * 0.12, 30,
            this.w * 0.85, this.h * 0.12, 100
        );
        glowGradient.addColorStop(0, 'rgba(255, 249, 196, 0.3)');
        glowGradient.addColorStop(1, 'rgba(255, 249, 196, 0)');
        
        this.ctx.fillStyle = glowGradient;
        this.ctx.beginPath();
        this.ctx.arc(this.w * 0.85, this.h * 0.12, 100, 0, Math.PI * 2);
        this.ctx.fill();
        
        this.ctx.restore();
    }

    drawDistantTrees(timeOfDay) {
        const treeColor = timeOfDay === 'night' ? '#1b3a26' : '#66bb6a';
        const y = this.h * 0.4;
        
        // Distant treeline
        this.ctx.fillStyle = treeColor;
        
        for (let i = 0; i < 20; i++) {
            const x = i * (this.w / 18) - 20;
            const height = 60 + Math.random() * 40;
            const width = 50 + Math.random() * 30;
            
            this.ctx.beginPath();
            this.ctx.arc(x + width / 2, y, width / 2, Math.PI, 0);
            this.ctx.fill();
        }
    }

    drawGrass() {
        // Main grass area
        const grassGradient = this.utils.createWatercolorGradient(
            0, this.h * 0.45, 0, this.h,
            ['#81c784', '#66bb6a', '#4caf50', '#43a047']
        );
        this.ctx.fillStyle = grassGradient;
        this.ctx.fillRect(0, this.h * 0.45, this.w, this.h * 0.55);
        
        // Grass texture (soft spots)
        this.ctx.save();
        this.ctx.globalAlpha = 0.15;
        
        for (let i = 0; i < 100; i++) {
            const x = Math.random() * this.w;
            const y = this.h * 0.45 + Math.random() * this.h * 0.55;
            const radius = Math.random() * 40 + 20;
            
            const spotGradient = this.ctx.createRadialGradient(x, y, 0, x, y, radius);
            spotGradient.addColorStop(0, Math.random() > 0.5 ? '#a5d6a7' : '#388e3c');
            spotGradient.addColorStop(1, 'rgba(76, 175, 80, 0)');
            
            this.ctx.fillStyle = spotGradient;
            this.ctx.beginPath();
            this.ctx.arc(x, y, radius, 0, Math.PI * 2);
            this.ctx.fill();
        }
        
        this.ctx.restore();
    }

    drawPath() {
        // Winding path
        const pathGradient = this.utils.createWatercolorGradient(
            0, this.h * 0.6, 0, this.h,
            ['#d7ccc8', '#bcaaa4', '#a1887f']
        );
        
        this.ctx.fillStyle = pathGradient;
        
        // Main path shape
        this.ctx.beginPath();
        this.ctx.moveTo(this.w * 0.25, this.h);
        this.ctx.quadraticCurveTo(this.w * 0.35, this.h * 0.75, this.w * 0.5, this.h * 0.55);
        this.ctx.quadraticCurveTo(this.w * 0.65, this.h * 0.45, this.w * 0.85, this.h * 0.42);
        this.ctx.lineTo(this.w * 0.9, this.h * 0.42);
        this.ctx.quadraticCurveTo(this.w * 0.68, this.h * 0.48, this.w * 0.55, this.h * 0.58);
        this.ctx.quadraticCurveTo(this.w * 0.42, this.h * 0.78, this.w * 0.35, this.h);
        this.ctx.closePath();
        this.ctx.fill();
        
        // Path edge highlight
        this.ctx.strokeStyle = 'rgba(161, 136, 127, 0.5)';
        this.ctx.lineWidth = 3;
        this.ctx.beginPath();
        this.ctx.moveTo(this.w * 0.25, this.h);
        this.ctx.quadraticCurveTo(this.w * 0.35, this.h * 0.75, this.w * 0.5, this.h * 0.55);
        this.ctx.quadraticCurveTo(this.w * 0.65, this.h * 0.45, this.w * 0.85, this.h * 0.42);
        this.ctx.stroke();
    }

    drawTrees(season) {
        if (season === 'spring') {
            // Cherry blossom trees
            this.utils.drawCherryBlossomTree(this.w * 0.1, this.h * 0.38, 120);
            this.utils.drawCherryBlossomTree(this.w * 0.75, this.h * 0.35, 140);
            this.utils.drawCherryBlossomTree(this.w * 0.92, this.h * 0.4, 100);
            
            // Regular tree for variety
            this.utils.drawTree(this.w * 0.55, this.h * 0.32, 90, '#66bb6a');
        } else {
            // Regular trees for other seasons
            this.utils.drawTree(this.w * 0.1, this.h * 0.38, 110, '#4caf50');
            this.utils.drawTree(this.w * 0.55, this.h * 0.32, 95, '#66bb6a');
            this.utils.drawTree(this.w * 0.75, this.h * 0.35, 130, '#43a047');
            this.utils.drawTree(this.w * 0.92, this.h * 0.4, 85, '#81c784');
        }
    }

    drawBench() {
        const x = this.w * 0.38;
        const y = this.h * 0.58;
        
        // Bench shadow
        this.ctx.save();
        this.ctx.globalAlpha = 0.2;
        this.ctx.fillStyle = '#1b5e20';
        this.ctx.beginPath();
        this.ctx.ellipse(x + 60, y + 55, 70, 15, 0, 0, Math.PI * 2);
        this.ctx.fill();
        this.ctx.restore();
        
        // Back support
        const backGradient = this.ctx.createLinearGradient(x, y - 40, x, y);
        backGradient.addColorStop(0, '#8d6e63');
        backGradient.addColorStop(1, '#6d4c41');
        
        this.ctx.fillStyle = backGradient;
        
        // Back slats
        for (let i = 0; i < 4; i++) {
            this.ctx.fillRect(x + 5, y - 35 + i * 10, 110, 7);
        }
        
        // Seat
        const seatGradient = this.ctx.createLinearGradient(x, y, x, y + 15);
        seatGradient.addColorStop(0, '#a1887f');
        seatGradient.addColorStop(1, '#8d6e63');
        
        this.ctx.fillStyle = seatGradient;
        this.ctx.fillRect(x, y, 120, 15);
        
        // Seat slats
        this.ctx.strokeStyle = '#6d4c41';
        this.ctx.lineWidth = 1;
        for (let i = 0; i < 5; i++) {
            this.ctx.beginPath();
            this.ctx.moveTo(x, y + i * 3 + 2);
            this.ctx.lineTo(x + 120, y + i * 3 + 2);
            this.ctx.stroke();
        }
        
        // Legs
        this.ctx.fillStyle = '#5d4037';
        
        // Left leg assembly
        this.ctx.fillRect(x + 5, y + 15, 8, 35);
        this.ctx.fillRect(x + 5, y - 40, 8, 40);
        
        // Right leg assembly
        this.ctx.fillRect(x + 107, y + 15, 8, 35);
        this.ctx.fillRect(x + 107, y - 40, 8, 40);
        
        // Armrests
        this.ctx.fillStyle = '#6d4c41';
        this.ctx.fillRect(x - 5, y - 8, 15, 8);
        this.ctx.fillRect(x + 110, y - 8, 15, 8);
    }

    drawLampPost(timeOfDay) {
        const x = this.w * 0.22;
        const y = this.h * 0.3;
        
        // Pole
        const poleGradient = this.ctx.createLinearGradient(x - 6, y, x + 6, y);
        poleGradient.addColorStop(0, '#455a64');
        poleGradient.addColorStop(0.5, '#607d8b');
        poleGradient.addColorStop(1, '#455a64');
        
        this.ctx.fillStyle = poleGradient;
        this.ctx.fillRect(x - 6, y, 12, this.h * 0.35);
        
        // Decorative rings
        this.ctx.fillStyle = '#37474f';
        this.ctx.fillRect(x - 8, y + 10, 16, 5);
        this.ctx.fillRect(x - 8, y + this.h * 0.33, 16, 5);
        
        // Lamp head arm
        this.ctx.fillStyle = '#455a64';
        this.ctx.beginPath();
        this.ctx.moveTo(x, y);
        this.ctx.quadraticCurveTo(x + 20, y - 20, x + 40, y - 15);
        this.ctx.lineTo(x + 40, y - 10);
        this.ctx.quadraticCurveTo(x + 15, y - 15, x, y + 5);
        this.ctx.closePath();
        this.ctx.fill();
        
        // Lamp shade
        this.ctx.fillStyle = '#37474f';
        this.ctx.beginPath();
        this.ctx.moveTo(x + 25, y - 15);
        this.ctx.lineTo(x + 55, y - 15);
        this.ctx.lineTo(x + 50, y + 10);
        this.ctx.lineTo(x + 30, y + 10);
        this.ctx.closePath();
        this.ctx.fill();
        
        // Light (glowing at night/evening)
        if (timeOfDay === 'evening' || timeOfDay === 'night') {
            // Light bulb glow
            const glowGradient = this.ctx.createRadialGradient(
                x + 40, y, 5, x + 40, y, 80
            );
            glowGradient.addColorStop(0, 'rgba(255, 249, 196, 0.8)');
            glowGradient.addColorStop(0.3, 'rgba(255, 241, 118, 0.3)');
            glowGradient.addColorStop(1, 'rgba(255, 235, 59, 0)');
            
            this.ctx.fillStyle = glowGradient;
            this.ctx.beginPath();
            this.ctx.arc(x + 40, y, 80, 0, Math.PI * 2);
            this.ctx.fill();
            
            // Light on ground
            const groundGlow = this.ctx.createRadialGradient(
                x + 40, this.h * 0.65, 10, x + 40, this.h * 0.65, 120
            );
            groundGlow.addColorStop(0, 'rgba(255, 249, 196, 0.25)');
            groundGlow.addColorStop(1, 'rgba(255, 249, 196, 0)');
            
            this.ctx.fillStyle = groundGlow;
            this.ctx.beginPath();
            this.ctx.ellipse(x + 40, this.h * 0.65, 120, 50, 0, 0, Math.PI * 2);
            this.ctx.fill();
        }
        
        // Light glass
        this.ctx.fillStyle = timeOfDay === 'night' || timeOfDay === 'evening' ? '#fff9c4' : '#e0e0e0';
        this.ctx.beginPath();
        this.ctx.moveTo(x + 30, y - 12);
        this.ctx.lineTo(x + 50, y - 12);
        this.ctx.lineTo(x + 48, y + 5);
        this.ctx.lineTo(x + 32, y + 5);
        this.ctx.closePath();
        this.ctx.fill();
    }

    drawDecorations(season) {
        // Flowers in grass
        this.drawFlowers();
        
        // Small pond
        this.drawPond();
        
        // Distant fountain
        this.drawFountain();
        
        if (season === 'spring') {
            // Falling petals
            this.drawFallingPetals();
        }
    }

    drawFlowers() {
        const flowerPositions = [
            { x: this.w * 0.05, y: this.h * 0.7 },
            { x: this.w * 0.15, y: this.h * 0.85 },
            { x: this.w * 0.65, y: this.h * 0.75 },
            { x: this.w * 0.8, y: this.h * 0.9 },
            { x: this.w * 0.95, y: this.h * 0.8 },
        ];
        
        flowerPositions.forEach(pos => {
            // Flower cluster
            for (let i = 0; i < 5; i++) {
                const fx = pos.x + (Math.random() - 0.5) * 30;
                const fy = pos.y + (Math.random() - 0.5) * 20;
                const colors = ['#ffeb3b', '#ff9800', '#e91e63', '#9c27b0', '#fff'];
                
                // Petals
                this.ctx.fillStyle = colors[Math.floor(Math.random() * colors.length)];
                this.ctx.beginPath();
                this.ctx.arc(fx, fy, 4, 0, Math.PI * 2);
                this.ctx.fill();
                
                // Center
                this.ctx.fillStyle = '#ffeb3b';
                this.ctx.beginPath();
                this.ctx.arc(fx, fy, 2, 0, Math.PI * 2);
                this.ctx.fill();
            }
        });
    }

    drawPond() {
        const x = this.w * 0.7;
        const y = this.h * 0.65;
        
        // Water
        const waterGradient = this.ctx.createRadialGradient(x, y, 10, x, y, 60);
        waterGradient.addColorStop(0, '#4fc3f7');
        waterGradient.addColorStop(0.7, '#29b6f6');
        waterGradient.addColorStop(1, '#0288d1');
        
        this.ctx.fillStyle = waterGradient;
        this.ctx.beginPath();
        this.ctx.ellipse(x, y, 65, 30, -0.2, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Water shine
        this.ctx.save();
        this.ctx.globalAlpha = 0.3;
        this.ctx.fillStyle = '#fff';
        this.ctx.beginPath();
        this.ctx.ellipse(x - 15, y - 8, 20, 8, -0.3, 0, Math.PI * 2);
        this.ctx.fill();
        this.ctx.restore();
        
        // Lily pads
        this.ctx.fillStyle = '#2e7d32';
        this.ctx.beginPath();
        this.ctx.ellipse(x + 25, y + 5, 12, 8, 0.2, 0, Math.PI * 2);
        this.ctx.fill();
        this.ctx.beginPath();
        this.ctx.ellipse(x - 20, y + 10, 10, 6, -0.3, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Lotus flower
        this.ctx.fillStyle = '#f8bbd9';
        for (let i = 0; i < 5; i++) {
            const angle = (i * 72 - 90) * Math.PI / 180;
            this.ctx.beginPath();
            this.ctx.ellipse(
                x + 25 + Math.cos(angle) * 6,
                y + 2 + Math.sin(angle) * 4,
                5, 3, angle, 0, Math.PI * 2
            );
            this.ctx.fill();
        }
    }

    drawFountain() {
        const x = this.w * 0.48;
        const y = this.h * 0.48;
        
        // Base pool
        this.ctx.fillStyle = '#78909c';
        this.ctx.beginPath();
        this.ctx.ellipse(x, y + 15, 35, 12, 0, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Water in pool
        this.ctx.fillStyle = '#4fc3f7';
        this.ctx.beginPath();
        this.ctx.ellipse(x, y + 13, 30, 10, 0, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Center pillar
        this.ctx.fillStyle = '#90a4ae';
        this.ctx.fillRect(x - 6, y - 20, 12, 35);
        
        // Water spray
        this.ctx.save();
        this.ctx.globalAlpha = 0.5;
        
        for (let i = 0; i < 8; i++) {
            const angle = (i * 45) * Math.PI / 180;
            const dropGradient = this.ctx.createLinearGradient(
                x, y - 20, x + Math.cos(angle) * 20, y - 35
            );
            dropGradient.addColorStop(0, '#81d4fa');
            dropGradient.addColorStop(1, 'rgba(129, 212, 250, 0)');
            
            this.ctx.strokeStyle = dropGradient;
            this.ctx.lineWidth = 2;
            this.ctx.beginPath();
            this.ctx.moveTo(x, y - 20);
            this.ctx.quadraticCurveTo(
                x + Math.cos(angle) * 15, y - 40,
                x + Math.cos(angle) * 25, y - 10
            );
            this.ctx.stroke();
        }
        
        this.ctx.restore();
    }

    drawFallingPetals() {
        this.ctx.save();
        
        for (let i = 0; i < 20; i++) {
            const x = Math.random() * this.w;
            const y = Math.random() * this.h * 0.7;
            const size = Math.random() * 6 + 4;
            const rotation = Math.random() * Math.PI;
            const alpha = Math.random() * 0.4 + 0.4;
            
            this.ctx.save();
            this.ctx.translate(x, y);
            this.ctx.rotate(rotation);
            this.ctx.globalAlpha = alpha;
            
            // Petal shape
            const petalGradient = this.ctx.createRadialGradient(0, 0, 0, 0, 0, size);
            petalGradient.addColorStop(0, '#fff0f5');
            petalGradient.addColorStop(1, '#ffb7c5');
            
            this.ctx.fillStyle = petalGradient;
            this.ctx.beginPath();
            this.ctx.ellipse(0, 0, size, size / 2, 0, 0, Math.PI * 2);
            this.ctx.fill();
            
            this.ctx.restore();
        }
        
        this.ctx.restore();
    }
}
