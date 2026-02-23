/**
 * TSUZUKI CONNECT - Street Background
 * Style: Honey and Clover - soft watercolor aesthetic
 */

import { BackgroundUtils } from './BackgroundUtils.js';
import { BackgroundAssets } from './BackgroundAssets.js';

export class StreetBackground {
    constructor(ctx, width, height) {
        this.ctx = ctx;
        this.w = width;
        this.h = height;
        this.utils = new BackgroundUtils(ctx);
    }

    draw(timeOfDay = 'morning', season = 'spring') {
        const assetPath = BackgroundAssets.getPath('street', timeOfDay);
        const imageDrawn = this.utils.drawImageBackground(assetPath, this.w, this.h);

        if (!imageDrawn) {
            // Procedural fallback
            this.drawSky(timeOfDay);
            this.drawDistantBuildings(timeOfDay);
            this.drawStreet();
            this.drawSidewalk();
            this.drawBuildings(timeOfDay);
            this.drawTrees(season);
            this.drawStreetElements();
            
            if (season === 'spring') {
                this.drawFallingPetals();
            }
        }
        
        this.utils.drawWatercolorTexture(this.w, this.h, 0.03);
    }

    drawSky(timeOfDay) {
        let skyColors;
        
        switch (timeOfDay) {
            case 'morning':
                skyColors = ['#fff8e1', '#ffe0b2', '#ffccbc', '#b3e5fc'];
                break;
            case 'evening':
                skyColors = ['#ff8a65', '#ffab91', '#ffcc80', '#fff8e1'];
                break;
            case 'night':
                skyColors = ['#0d1b2a', '#1b263b', '#274c77', '#3a5a8c'];
                break;
            default: // afternoon
                skyColors = ['#81d4fa', '#b3e5fc', '#e1f5fe', '#fff8e1'];
        }
        
        const skyGradient = this.utils.createWatercolorGradient(0, 0, 0, this.h * 0.55, skyColors);
        this.ctx.fillStyle = skyGradient;
        this.ctx.fillRect(0, 0, this.w, this.h * 0.55);
        
        // Clouds
        if (timeOfDay !== 'night') {
            this.utils.drawCloud(this.w * 0.15, this.h * 0.12, 0.8);
            this.utils.drawCloud(this.w * 0.5, this.h * 0.08, 1.0);
            this.utils.drawCloud(this.w * 0.85, this.h * 0.15, 0.7);
        } else {
            // Stars at night
            this.drawStars();
        }
    }

    drawStars() {
        this.ctx.save();
        for (let i = 0; i < 50; i++) {
            const x = Math.random() * this.w;
            const y = Math.random() * this.h * 0.4;
            const size = Math.random() * 2 + 0.5;
            const alpha = Math.random() * 0.5 + 0.3;
            
            this.ctx.fillStyle = `rgba(255, 255, 255, ${alpha})`;
            this.ctx.beginPath();
            this.ctx.arc(x, y, size, 0, Math.PI * 2);
            this.ctx.fill();
        }
        this.ctx.restore();
    }

    drawDistantBuildings(timeOfDay) {
        const baseColor = timeOfDay === 'night' ? '#1a237e' : '#b0bec5';
        
        // Distant city silhouette
        this.ctx.fillStyle = baseColor;
        
        const buildings = [
            { x: 0, w: 80, h: 120 },
            { x: 70, w: 60, h: 150 },
            { x: 120, w: 100, h: 100 },
            { x: 200, w: 70, h: 180 },
            { x: 260, w: 90, h: 130 },
            { x: 340, w: 80, h: 160 },
            { x: 400, w: 120, h: 90 },
            { x: 500, w: 60, h: 140 },
            { x: 550, w: 100, h: 170 },
            { x: 640, w: 80, h: 110 },
            { x: 700, w: 90, h: 150 },
            { x: 780, w: 70, h: 130 },
            { x: 840, w: 110, h: 100 },
            { x: 940, w: 80, h: 160 },
            { x: 1000, w: 100, h: 120 },
            { x: 1080, w: 90, h: 145 },
            { x: 1160, w: 80, h: 110 },
            { x: 1220, w: 70, h: 130 },
        ];
        
        const horizonY = this.h * 0.35;
        
        buildings.forEach(b => {
            const gradient = this.ctx.createLinearGradient(b.x, horizonY - b.h, b.x, horizonY);
            
            if (timeOfDay === 'night') {
                gradient.addColorStop(0, '#1a237e');
                gradient.addColorStop(1, '#283593');
            } else {
                gradient.addColorStop(0, '#b0bec5');
                gradient.addColorStop(1, '#90a4ae');
            }
            
            this.ctx.fillStyle = gradient;
            this.ctx.fillRect(b.x, horizonY - b.h, b.w, b.h);
        });
    }

    drawStreet() {
        // Main road
        const roadGradient = this.ctx.createLinearGradient(0, this.h * 0.55, 0, this.h);
        roadGradient.addColorStop(0, '#546e7a');
        roadGradient.addColorStop(0.5, '#455a64');
        roadGradient.addColorStop(1, '#37474f');
        
        this.ctx.fillStyle = roadGradient;
        this.ctx.fillRect(0, this.h * 0.55, this.w, this.h * 0.45);
        
        // Road texture
        this.ctx.save();
        this.ctx.globalAlpha = 0.05;
        for (let i = 0; i < 100; i++) {
            this.ctx.fillStyle = Math.random() > 0.5 ? '#263238' : '#78909c';
            this.ctx.beginPath();
            this.ctx.arc(
                Math.random() * this.w,
                this.h * 0.55 + Math.random() * this.h * 0.45,
                Math.random() * 5 + 2,
                0, Math.PI * 2
            );
            this.ctx.fill();
        }
        this.ctx.restore();
        
        // Center line (dashed)
        this.ctx.strokeStyle = '#fff176';
        this.ctx.lineWidth = 4;
        this.ctx.setLineDash([30, 20]);
        this.ctx.beginPath();
        this.ctx.moveTo(0, this.h * 0.75);
        this.ctx.lineTo(this.w, this.h * 0.75);
        this.ctx.stroke();
        this.ctx.setLineDash([]);
    }

    drawSidewalk() {
        // Left sidewalk
        const sidewalkGradient = this.ctx.createLinearGradient(0, this.h * 0.48, 0, this.h * 0.58);
        sidewalkGradient.addColorStop(0, '#eceff1');
        sidewalkGradient.addColorStop(1, '#cfd8dc');
        
        this.ctx.fillStyle = sidewalkGradient;
        this.ctx.fillRect(0, this.h * 0.48, this.w, this.h * 0.1);
        
        // Sidewalk tiles
        this.ctx.strokeStyle = 'rgba(0, 0, 0, 0.08)';
        this.ctx.lineWidth = 1;
        
        for (let i = 0; i < 20; i++) {
            const x = i * (this.w / 18);
            this.ctx.beginPath();
            this.ctx.moveTo(x, this.h * 0.48);
            this.ctx.lineTo(x, this.h * 0.58);
            this.ctx.stroke();
        }
        
        // Curb
        this.ctx.fillStyle = '#90a4ae';
        this.ctx.fillRect(0, this.h * 0.55, this.w, this.h * 0.015);
    }

    drawBuildings(timeOfDay) {
        const buildings = [
            { x: this.w * 0.02, y: this.h * 0.12, w: 140, h: this.h * 0.38, color: '#fff8e1', name: '本屋', nameEn: 'Bookstore' },
            { x: this.w * 0.15, y: this.h * 0.08, w: 160, h: this.h * 0.42, color: '#ffebee', name: 'カフェ', nameEn: 'Cafe' },
            { x: this.w * 0.32, y: this.h * 0.05, w: 180, h: this.h * 0.45, color: '#e8f5e9', name: 'コンビニ', nameEn: 'Convenience Store' },
            { x: this.w * 0.52, y: this.h * 0.1, w: 150, h: this.h * 0.4, color: '#e3f2fd', name: '薬局', nameEn: 'Pharmacy' },
            { x: this.w * 0.68, y: this.h * 0.06, w: 170, h: this.h * 0.44, color: '#fce4ec', name: '花屋', nameEn: 'Flower Shop' },
            { x: this.w * 0.85, y: this.h * 0.12, w: 200, h: this.h * 0.38, color: '#f3e5f5', name: 'レストラン', nameEn: 'Restaurant' },
        ];
        
        buildings.forEach(b => this.drawBuilding(b, timeOfDay));
    }

    drawBuilding(b, timeOfDay) {
        // Building body with gradient
        const buildingGradient = this.ctx.createLinearGradient(b.x, b.y, b.x + b.w, b.y + b.h);
        buildingGradient.addColorStop(0, b.color);
        buildingGradient.addColorStop(1, this.utils.darkenColor(b.color, 15));
        
        this.ctx.fillStyle = buildingGradient;
        this.ctx.fillRect(b.x, b.y, b.w, b.h);
        
        // Building outline
        this.ctx.strokeStyle = 'rgba(0, 0, 0, 0.1)';
        this.ctx.lineWidth = 2;
        this.ctx.strokeRect(b.x, b.y, b.w, b.h);
        
        // Windows
        const windowRows = Math.floor(b.h / 60);
        const windowCols = Math.floor(b.w / 45);
        const windowW = 28;
        const windowH = 35;
        
        for (let r = 0; r < windowRows - 1; r++) {
            for (let c = 0; c < windowCols; c++) {
                const wx = b.x + 15 + c * 40;
                const wy = b.y + 20 + r * 55;
                
                // Window glass
                if (timeOfDay === 'night') {
                    // Some windows lit up at night
                    const isLit = Math.random() > 0.4;
                    if (isLit) {
                        this.ctx.fillStyle = '#fff9c4';
                        this.ctx.shadowColor = '#fff59d';
                        this.ctx.shadowBlur = 10;
                    } else {
                        this.ctx.fillStyle = '#37474f';
                        this.ctx.shadowBlur = 0;
                    }
                } else {
                    this.ctx.fillStyle = '#81d4fa';
                    this.ctx.shadowBlur = 0;
                }
                
                this.ctx.fillRect(wx, wy, windowW, windowH);
                this.ctx.shadowBlur = 0;
                
                // Window frame
                this.ctx.strokeStyle = 'rgba(255, 255, 255, 0.8)';
                this.ctx.lineWidth = 2;
                this.ctx.strokeRect(wx, wy, windowW, windowH);
            }
        }
        
        // Shop awning
        const awningGradient = this.ctx.createLinearGradient(b.x, b.y + b.h - 55, b.x, b.y + b.h - 35);
        awningGradient.addColorStop(0, '#ff8a65');
        awningGradient.addColorStop(1, '#ff7043');
        
        this.ctx.fillStyle = awningGradient;
        this.ctx.beginPath();
        this.ctx.moveTo(b.x - 5, b.y + b.h - 55);
        this.ctx.lineTo(b.x + b.w + 5, b.y + b.h - 55);
        this.ctx.lineTo(b.x + b.w + 15, b.y + b.h - 35);
        this.ctx.lineTo(b.x - 15, b.y + b.h - 35);
        this.ctx.closePath();
        this.ctx.fill();
        
        // Stripes on awning
        this.ctx.fillStyle = 'rgba(255, 255, 255, 0.3)';
        for (let i = 0; i < 6; i++) {
            this.ctx.beginPath();
            this.ctx.moveTo(b.x + i * 25, b.y + b.h - 55);
            this.ctx.lineTo(b.x + i * 25 + 3, b.y + b.h - 35);
            this.ctx.lineTo(b.x + i * 25 + 15, b.y + b.h - 35);
            this.ctx.lineTo(b.x + i * 25 + 12, b.y + b.h - 55);
            this.ctx.closePath();
            this.ctx.fill();
        }
        
        // Shop sign
        this.ctx.fillStyle = '#5d4037';
        this.ctx.fillRect(b.x + 10, b.y + b.h - 48, b.w - 20, 28);
        
        this.ctx.fillStyle = '#fff8e1';
        this.ctx.font = 'bold 14px "Noto Sans JP", sans-serif';
        this.ctx.textAlign = 'center';
        this.ctx.fillText(b.name, b.x + b.w / 2, b.y + b.h - 28);
        
        // Door
        this.ctx.fillStyle = '#8d6e63';
        this.ctx.fillRect(b.x + b.w / 2 - 20, b.y + b.h - 70, 40, 70);
        this.ctx.fillStyle = '#a1887f';
        this.ctx.fillRect(b.x + b.w / 2 - 15, b.y + b.h - 65, 30, 50);
    }

    drawTrees(season) {
        if (season === 'spring') {
            this.utils.drawCherryBlossomTree(this.w * 0.08, this.h * 0.42, 90);
            this.utils.drawCherryBlossomTree(this.w * 0.45, this.h * 0.44, 80);
            this.utils.drawCherryBlossomTree(this.w * 0.78, this.h * 0.42, 95);
        } else {
            this.utils.drawTree(this.w * 0.08, this.h * 0.42, 70);
            this.utils.drawTree(this.w * 0.45, this.h * 0.44, 65);
            this.utils.drawTree(this.w * 0.78, this.h * 0.42, 75);
        }
    }

    drawStreetElements() {
        // Crosswalk
        this.ctx.fillStyle = '#ffffff';
        for (let i = 0; i < 8; i++) {
            this.ctx.fillRect(this.w * 0.35 + i * 45, this.h * 0.78, 32, 80);
        }
        
        // Traffic light
        this.drawTrafficLight(this.w * 0.92, this.h * 0.28);
        
        // Street lamp
        this.drawStreetLamp(this.w * 0.22, this.h * 0.25);
        this.drawStreetLamp(this.w * 0.62, this.h * 0.25);
        
        // Vending machine
        this.drawVendingMachine(this.w * 0.95, this.h * 0.35);
    }

    drawTrafficLight(x, y) {
        // Pole
        this.ctx.fillStyle = '#37474f';
        this.ctx.fillRect(x, y, 12, this.h * 0.35);
        
        // Light box
        this.ctx.fillStyle = '#263238';
        this.ctx.fillRect(x - 25, y, 55, 85);
        
        // Lights
        const lights = [
            { dy: 10, color: '#c62828', glow: false },
            { dy: 35, color: '#f9a825', glow: false },
            { dy: 60, color: '#2e7d32', glow: true },
        ];
        
        lights.forEach(light => {
            this.ctx.fillStyle = light.glow ? light.color : this.utils.darkenColor(light.color, 50);
            
            if (light.glow) {
                this.ctx.shadowColor = light.color;
                this.ctx.shadowBlur = 15;
            }
            
            this.ctx.beginPath();
            this.ctx.arc(x + 2, y + light.dy + 10, 12, 0, Math.PI * 2);
            this.ctx.fill();
            this.ctx.shadowBlur = 0;
        });
    }

    drawStreetLamp(x, y) {
        // Pole
        const poleGradient = this.ctx.createLinearGradient(x, y, x + 10, y);
        poleGradient.addColorStop(0, '#78909c');
        poleGradient.addColorStop(1, '#546e7a');
        
        this.ctx.fillStyle = poleGradient;
        this.ctx.fillRect(x, y, 10, this.h * 0.3);
        
        // Lamp head
        this.ctx.fillStyle = '#455a64';
        this.ctx.beginPath();
        this.ctx.moveTo(x - 20, y + 5);
        this.ctx.lineTo(x + 30, y + 5);
        this.ctx.lineTo(x + 25, y + 25);
        this.ctx.lineTo(x - 15, y + 25);
        this.ctx.closePath();
        this.ctx.fill();
        
        // Light glow
        const glowGradient = this.ctx.createRadialGradient(x + 5, y + 30, 5, x + 5, y + 30, 50);
        glowGradient.addColorStop(0, 'rgba(255, 249, 196, 0.4)');
        glowGradient.addColorStop(1, 'rgba(255, 249, 196, 0)');
        
        this.ctx.fillStyle = glowGradient;
        this.ctx.beginPath();
        this.ctx.arc(x + 5, y + 30, 50, 0, Math.PI * 2);
        this.ctx.fill();
    }

    drawVendingMachine(x, y) {
        // Body
        const machineGradient = this.ctx.createLinearGradient(x - 40, y, x + 10, y);
        machineGradient.addColorStop(0, '#e53935');
        machineGradient.addColorStop(1, '#c62828');
        
        this.ctx.fillStyle = machineGradient;
        this.ctx.fillRect(x - 40, y, 50, 110);
        
        // Display window
        this.ctx.fillStyle = '#1a237e';
        this.ctx.fillRect(x - 35, y + 10, 40, 55);
        
        // Drink rows
        for (let r = 0; r < 3; r++) {
            for (let c = 0; c < 4; c++) {
                const drinkColors = ['#4caf50', '#2196f3', '#ff9800', '#e91e63'];
                this.ctx.fillStyle = drinkColors[c];
                this.ctx.fillRect(x - 33 + c * 10, y + 15 + r * 17, 8, 14);
            }
        }
        
        // Slot
        this.ctx.fillStyle = '#263238';
        this.ctx.fillRect(x - 30, y + 75, 25, 25);
    }

    drawFallingPetals() {
        this.ctx.save();
        
        for (let i = 0; i < 15; i++) {
            const x = Math.random() * this.w;
            const y = Math.random() * this.h * 0.6;
            const size = Math.random() * 6 + 4;
            const rotation = Math.random() * Math.PI;
            
            this.ctx.save();
            this.ctx.translate(x, y);
            this.ctx.rotate(rotation);
            this.ctx.globalAlpha = 0.7;
            
            this.ctx.fillStyle = '#ffb7c5';
            this.ctx.beginPath();
            this.ctx.ellipse(0, 0, size, size / 2, 0, 0, Math.PI * 2);
            this.ctx.fill();
            
            this.ctx.restore();
        }
        
        this.ctx.restore();
    }
}
