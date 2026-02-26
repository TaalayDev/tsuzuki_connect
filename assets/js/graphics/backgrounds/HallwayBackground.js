/**
 * TSUZUKI CONNECT - Hallway Background
 * Style: Honey and Clover - soft watercolor aesthetic
 * School/building hallway
 */

import { BackgroundUtils } from './BackgroundUtils.js';
import { BackgroundAssets } from './BackgroundAssets.js';

export class HallwayBackground {
    constructor(ctx, width, height) {
        this.ctx = ctx;
        this.w = width;
        this.h = height;
        this.utils = new BackgroundUtils(ctx);
    }

    draw(timeOfDay = 'afternoon', season = 'spring') {
        const assetPath = BackgroundAssets.getPath('hallway', timeOfDay);
        const imageDrawn = this.utils.drawImageBackground(assetPath, this.w, this.h);

        if (!imageDrawn) {
            this.drawWalls(timeOfDay);
            this.drawFloor();
            this.drawCeiling();
            this.drawWindows(timeOfDay);
            this.drawDoors();
            this.drawLockers();
            this.drawDecorations(season);
            this.drawLighting(timeOfDay);
        }
        
        this.utils.drawWatercolorTexture(this.w, this.h, 0.03);
    }

    drawWalls(timeOfDay) {
        let wallColors;
        
        if (timeOfDay === 'night') {
            wallColors = ['#4a4458', '#3d3652', '#35304a'];
        } else if (timeOfDay === 'evening') {
            wallColors = ['#ffe0b2', '#ffcc80', '#ffb74d'];
        } else {
            wallColors = ['#fff8e1', '#fffde7', '#fff9c4'];
        }
        
        // Left wall with perspective
        const leftWallGradient = this.utils.createWatercolorGradient(0, 0, this.w * 0.35, this.h, wallColors);
        this.ctx.fillStyle = leftWallGradient;
        this.ctx.beginPath();
        this.ctx.moveTo(0, 0);
        this.ctx.lineTo(this.w * 0.25, this.h * 0.15);
        this.ctx.lineTo(this.w * 0.25, this.h * 0.85);
        this.ctx.lineTo(0, this.h);
        this.ctx.closePath();
        this.ctx.fill();
        
        // Right wall with perspective
        const rightWallGradient = this.utils.createWatercolorGradient(this.w * 0.65, 0, this.w, this.h, wallColors);
        this.ctx.fillStyle = rightWallGradient;
        this.ctx.beginPath();
        this.ctx.moveTo(this.w, 0);
        this.ctx.lineTo(this.w * 0.75, this.h * 0.15);
        this.ctx.lineTo(this.w * 0.75, this.h * 0.85);
        this.ctx.lineTo(this.w, this.h);
        this.ctx.closePath();
        this.ctx.fill();
        
        // Back wall (vanishing point)
        const backWallGradient = this.utils.createWatercolorGradient(this.w * 0.25, this.h * 0.15, this.w * 0.75, this.h * 0.85, [
            '#f5f5f5', '#eeeeee', '#e0e0e0'
        ]);
        this.ctx.fillStyle = backWallGradient;
        this.ctx.fillRect(this.w * 0.25, this.h * 0.15, this.w * 0.5, this.h * 0.7);
        
        // Wainscoting on walls
        this.drawWainscoting();
    }

    drawWainscoting() {
        // Left wall wainscoting
        this.ctx.fillStyle = '#bcaaa4';
        this.ctx.beginPath();
        this.ctx.moveTo(0, this.h * 0.6);
        this.ctx.lineTo(this.w * 0.25, this.h * 0.55);
        this.ctx.lineTo(this.w * 0.25, this.h * 0.85);
        this.ctx.lineTo(0, this.h);
        this.ctx.closePath();
        this.ctx.fill();
        
        // Right wall wainscoting
        this.ctx.beginPath();
        this.ctx.moveTo(this.w, this.h * 0.6);
        this.ctx.lineTo(this.w * 0.75, this.h * 0.55);
        this.ctx.lineTo(this.w * 0.75, this.h * 0.85);
        this.ctx.lineTo(this.w, this.h);
        this.ctx.closePath();
        this.ctx.fill();
        
        // Trim line
        this.ctx.strokeStyle = '#8d6e63';
        this.ctx.lineWidth = 3;
        this.ctx.beginPath();
        this.ctx.moveTo(0, this.h * 0.6);
        this.ctx.lineTo(this.w * 0.25, this.h * 0.55);
        this.ctx.stroke();
        this.ctx.beginPath();
        this.ctx.moveTo(this.w, this.h * 0.6);
        this.ctx.lineTo(this.w * 0.75, this.h * 0.55);
        this.ctx.stroke();
    }

    drawFloor() {
        // Perspective floor
        const floorGradient = this.utils.createWatercolorGradient(0, this.h * 0.75, 0, this.h, [
            '#a1887f', '#8d6e63', '#6d4c41'
        ]);
        
        this.ctx.fillStyle = floorGradient;
        this.ctx.beginPath();
        this.ctx.moveTo(0, this.h);
        this.ctx.lineTo(this.w * 0.25, this.h * 0.85);
        this.ctx.lineTo(this.w * 0.75, this.h * 0.85);
        this.ctx.lineTo(this.w, this.h);
        this.ctx.closePath();
        this.ctx.fill();
        
        // Floor tiles/pattern
        this.ctx.strokeStyle = 'rgba(93, 64, 55, 0.2)';
        this.ctx.lineWidth = 1;
        
        // Horizontal perspective lines
        for (let i = 0; i < 8; i++) {
            const t = i / 8;
            const leftY = this.h * 0.85 + t * (this.h - this.h * 0.85);
            const rightY = leftY;
            const leftX = this.w * 0.25 - t * this.w * 0.25;
            const rightX = this.w * 0.75 + t * this.w * 0.25;
            
            this.ctx.beginPath();
            this.ctx.moveTo(leftX, leftY);
            this.ctx.lineTo(rightX, rightY);
            this.ctx.stroke();
        }
    }

    drawCeiling() {
        // Perspective ceiling
        const ceilingGradient = this.utils.createWatercolorGradient(0, 0, 0, this.h * 0.2, [
            '#e0e0e0', '#eeeeee', '#f5f5f5'
        ]);
        
        this.ctx.fillStyle = ceilingGradient;
        this.ctx.beginPath();
        this.ctx.moveTo(0, 0);
        this.ctx.lineTo(this.w * 0.25, this.h * 0.15);
        this.ctx.lineTo(this.w * 0.75, this.h * 0.15);
        this.ctx.lineTo(this.w, 0);
        this.ctx.closePath();
        this.ctx.fill();
        
        // Ceiling lights
        this.drawCeilingLights();
    }

    drawCeilingLights() {
        const lightPositions = [0.35, 0.5, 0.65];
        
        lightPositions.forEach(pos => {
            const x = this.w * pos;
            const y = this.h * 0.12;
            const scale = 1 - Math.abs(pos - 0.5) * 0.5;
            
            // Light fixture
            this.ctx.fillStyle = '#bdbdbd';
            this.ctx.fillRect(x - 30 * scale, y - 5, 60 * scale, 10);
            
            // Light panel
            this.ctx.fillStyle = '#fffde7';
            this.ctx.fillRect(x - 25 * scale, y - 3, 50 * scale, 6);
        });
    }

    drawWindows(timeOfDay) {
        // Left side windows
        this.drawWindow(this.w * 0.03, this.h * 0.18, 0.12, timeOfDay, 0.8);
        this.drawWindow(this.w * 0.12, this.h * 0.22, 0.15, timeOfDay, 0.9);
        this.drawWindow(this.w * 0.18, this.h * 0.25, 0.12, timeOfDay, 0.95);
        
        // Add light rays from windows
        if (timeOfDay === 'morning' || timeOfDay === 'afternoon') {
            this.drawLightRays();
        }
    }

    drawWindow(x, y, heightRatio, timeOfDay, scale) {
        const windowWidth = 80 * scale;
        const windowHeight = this.h * heightRatio * scale;
        
        // Frame
        this.ctx.fillStyle = '#8d6e63';
        this.ctx.fillRect(x - 4, y - 4, windowWidth + 8, windowHeight + 8);
        
        // Inner frame
        this.ctx.fillStyle = '#a1887f';
        this.ctx.fillRect(x - 2, y - 2, windowWidth + 4, windowHeight + 4);
        
        // Sky through window
        let skyColors;
        switch (timeOfDay) {
            case 'morning':
                skyColors = ['#ffecb3', '#b3e5fc', '#81d4fa'];
                break;
            case 'evening':
                skyColors = ['#ff8a65', '#ffab91', '#ffcc80'];
                break;
            case 'night':
                skyColors = ['#1a237e', '#283593', '#303f9f'];
                break;
            default:
                skyColors = ['#64b5f6', '#90caf9', '#bbdefb'];
        }
        
        const skyGradient = this.utils.createWatercolorGradient(x, y, x, y + windowHeight, skyColors);
        this.ctx.fillStyle = skyGradient;
        this.ctx.fillRect(x, y, windowWidth, windowHeight);
        
        // Window cross bars
        this.ctx.strokeStyle = '#6d4c41';
        this.ctx.lineWidth = 3;
        
        this.ctx.beginPath();
        this.ctx.moveTo(x + windowWidth / 2, y);
        this.ctx.lineTo(x + windowWidth / 2, y + windowHeight);
        this.ctx.stroke();
        
        this.ctx.beginPath();
        this.ctx.moveTo(x, y + windowHeight / 2);
        this.ctx.lineTo(x + windowWidth, y + windowHeight / 2);
        this.ctx.stroke();
    }

    drawLightRays() {
        this.ctx.save();
        this.ctx.globalAlpha = 0.08;
        
        const rayGradient = this.ctx.createLinearGradient(0, this.h * 0.2, this.w * 0.5, this.h);
        rayGradient.addColorStop(0, '#fff9c4');
        rayGradient.addColorStop(1, 'rgba(255, 249, 196, 0)');
        
        this.ctx.fillStyle = rayGradient;
        this.ctx.beginPath();
        this.ctx.moveTo(this.w * 0.05, this.h * 0.2);
        this.ctx.lineTo(this.w * 0.25, this.h * 0.25);
        this.ctx.lineTo(this.w * 0.5, this.h);
        this.ctx.lineTo(this.w * 0.2, this.h);
        this.ctx.closePath();
        this.ctx.fill();
        
        this.ctx.restore();
    }

    drawDoors() {
        // Doors along the hallway - decreasing in size with perspective
        
        // Left side doors
        this.drawDoor(this.w * 0.02, this.h * 0.25, 0.7, 'left');
        
        // Right side doors
        this.drawDoor(this.w * 0.88, this.h * 0.25, 0.7, 'right');
        
        // Back wall door (end of hallway)
        this.drawBackDoor();
    }

    drawDoor(x, y, scale, side) {
        const doorWidth = 70 * scale;
        const doorHeight = this.h * 0.35 * scale;
        
        // Door frame
        this.ctx.fillStyle = '#6d4c41';
        this.ctx.fillRect(x - 5, y - 5, doorWidth + 10, doorHeight + 10);
        
        // Door
        const doorGradient = this.ctx.createLinearGradient(x, y, x + doorWidth, y);
        doorGradient.addColorStop(0, '#8d6e63');
        doorGradient.addColorStop(0.5, '#a1887f');
        doorGradient.addColorStop(1, '#8d6e63');
        
        this.ctx.fillStyle = doorGradient;
        this.ctx.fillRect(x, y, doorWidth, doorHeight);
        
        // Door panels
        this.ctx.strokeStyle = '#5d4037';
        this.ctx.lineWidth = 2;
        this.ctx.strokeRect(x + 8, y + 10, doorWidth - 16, doorHeight * 0.35);
        this.ctx.strokeRect(x + 8, y + doorHeight * 0.45, doorWidth - 16, doorHeight * 0.45);
        
        // Door handle
        this.ctx.fillStyle = '#ffd54f';
        const handleX = side === 'left' ? x + doorWidth - 15 : x + 10;
        this.ctx.beginPath();
        this.ctx.arc(handleX, y + doorHeight * 0.5, 5, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Class number sign
        this.drawClassSign(x + doorWidth / 2, y - 15, '1-A', scale);
    }

    drawClassSign(x, y, text, scale) {
        const signWidth = 50 * scale;
        const signHeight = 20 * scale;
        
        // Sign background
        this.ctx.fillStyle = '#3f51b5';
        this.ctx.beginPath();
        this.ctx.roundRect(x - signWidth / 2, y - signHeight / 2, signWidth, signHeight, 3);
        this.ctx.fill();
        
        // Text
        this.ctx.fillStyle = '#fff';
        this.ctx.font = `bold ${12 * scale}px sans-serif`;
        this.ctx.textAlign = 'center';
        this.ctx.textBaseline = 'middle';
        this.ctx.fillText(text, x, y);
    }

    drawBackDoor() {
        const x = this.w * 0.42;
        const y = this.h * 0.35;
        const doorWidth = this.w * 0.16;
        const doorHeight = this.h * 0.4;
        
        // Frame
        this.ctx.fillStyle = '#5d4037';
        this.ctx.fillRect(x - 5, y - 5, doorWidth + 10, doorHeight + 10);
        
        // Double doors
        const doorGradient = this.ctx.createLinearGradient(x, y, x + doorWidth, y);
        doorGradient.addColorStop(0, '#8d6e63');
        doorGradient.addColorStop(0.5, '#bcaaa4');
        doorGradient.addColorStop(1, '#8d6e63');
        
        this.ctx.fillStyle = doorGradient;
        this.ctx.fillRect(x, y, doorWidth, doorHeight);
        
        // Door gap
        this.ctx.strokeStyle = '#4e342e';
        this.ctx.lineWidth = 3;
        this.ctx.beginPath();
        this.ctx.moveTo(x + doorWidth / 2, y);
        this.ctx.lineTo(x + doorWidth / 2, y + doorHeight);
        this.ctx.stroke();
        
        // Exit sign above
        this.ctx.fillStyle = '#4caf50';
        this.ctx.fillRect(x + doorWidth / 2 - 25, y - 25, 50, 18);
        this.ctx.fillStyle = '#fff';
        this.ctx.font = 'bold 10px sans-serif';
        this.ctx.textAlign = 'center';
        this.ctx.fillText('EXIT', x + doorWidth / 2, y - 13);
    }

    drawLockers() {
        // Lockers on right wall (perspective view)
        const lockerStart = this.w * 0.78;
        const lockerEnd = this.w * 0.95;
        const y = this.h * 0.32;
        const lockerHeight = this.h * 0.25;
        
        // Locker bank
        const lockerGradient = this.ctx.createLinearGradient(lockerStart, y, lockerEnd, y);
        lockerGradient.addColorStop(0, '#78909c');
        lockerGradient.addColorStop(0.5, '#90a4ae');
        lockerGradient.addColorStop(1, '#78909c');
        
        this.ctx.fillStyle = lockerGradient;
        this.ctx.fillRect(lockerStart, y, lockerEnd - lockerStart, lockerHeight);
        
        // Individual locker lines
        this.ctx.strokeStyle = '#546e7a';
        this.ctx.lineWidth = 1;
        
        const lockerWidth = (lockerEnd - lockerStart) / 5;
        for (let i = 0; i <= 5; i++) {
            const lx = lockerStart + i * lockerWidth;
            this.ctx.beginPath();
            this.ctx.moveTo(lx, y);
            this.ctx.lineTo(lx, y + lockerHeight);
            this.ctx.stroke();
        }
        
        // Horizontal divider
        this.ctx.beginPath();
        this.ctx.moveTo(lockerStart, y + lockerHeight / 2);
        this.ctx.lineTo(lockerEnd, y + lockerHeight / 2);
        this.ctx.stroke();
        
        // Locker vents and handles
        for (let i = 0; i < 5; i++) {
            const lx = lockerStart + i * lockerWidth + lockerWidth / 2;
            
            // Vents (top lockers)
            this.ctx.fillStyle = '#455a64';
            this.ctx.fillRect(lx - 10, y + 8, 20, 5);
            
            // Vents (bottom lockers)
            this.ctx.fillRect(lx - 10, y + lockerHeight / 2 + 8, 20, 5);
        }
    }

    drawDecorations(season) {
        // Bulletin board on left wall
        this.drawBulletinBoard();
        
        // Fire extinguisher
        this.drawFireExtinguisher();
        
        // Potted plant
        this.utils.drawPlant(this.w * 0.22, this.h * 0.72, 30);
        
        // Seasonal decorations
        if (season === 'spring') {
            this.drawSpringDecorations();
        }
    }

    drawBulletinBoard() {
        const x = this.w * 0.06;
        const y = this.h * 0.2;
        const width = 80;
        const height = 60;
        
        // Cork board
        this.ctx.fillStyle = '#d4a574';
        this.ctx.fillRect(x, y, width, height);
        
        // Frame
        this.ctx.strokeStyle = '#6d4c41';
        this.ctx.lineWidth = 4;
        this.ctx.strokeRect(x, y, width, height);
        
        // Papers pinned
        const papers = [
            { x: x + 10, y: y + 8, color: '#fff9c4', rotation: -0.1 },
            { x: x + 40, y: y + 5, color: '#e3f2fd', rotation: 0.05 },
            { x: x + 25, y: y + 30, color: '#f8bbd9', rotation: 0.1 },
            { x: x + 55, y: y + 25, color: '#c8e6c9', rotation: -0.05 }
        ];
        
        papers.forEach(paper => {
            this.ctx.save();
            this.ctx.translate(paper.x + 15, paper.y + 12);
            this.ctx.rotate(paper.rotation);
            this.ctx.fillStyle = paper.color;
            this.ctx.fillRect(-15, -12, 30, 24);
            
            // Pin
            this.ctx.fillStyle = '#f44336';
            this.ctx.beginPath();
            this.ctx.arc(0, -8, 3, 0, Math.PI * 2);
            this.ctx.fill();
            
            this.ctx.restore();
        });
    }

    drawFireExtinguisher() {
        const x = this.w * 0.72;
        const y = this.h * 0.4;
        
        // Case
        this.ctx.fillStyle = '#d32f2f';
        this.ctx.beginPath();
        this.ctx.roundRect(x, y, 20, 40, 3);
        this.ctx.fill();
        
        // Handle
        this.ctx.fillStyle = '#424242';
        this.ctx.fillRect(x + 6, y - 10, 8, 12);
        
        // Nozzle
        this.ctx.fillRect(x + 12, y - 6, 15, 4);
    }

    drawSpringDecorations() {
        // Cherry blossom petals scattered
        this.ctx.save();
        
        for (let i = 0; i < 12; i++) {
            const x = Math.random() * this.w;
            const y = Math.random() * this.h * 0.7;
            const size = Math.random() * 5 + 3;
            const rotation = Math.random() * Math.PI;
            const alpha = Math.random() * 0.4 + 0.3;
            
            this.ctx.save();
            this.ctx.translate(x, y);
            this.ctx.rotate(rotation);
            this.ctx.globalAlpha = alpha;
            
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

    drawLighting(timeOfDay) {
        if (timeOfDay === 'evening' || timeOfDay === 'night') {
            // Pool of light from ceiling fixtures
            this.ctx.save();
            this.ctx.globalAlpha = 0.15;
            
            const lightPositions = [0.35, 0.5, 0.65];
            lightPositions.forEach(pos => {
                const lightGradient = this.ctx.createRadialGradient(
                    this.w * pos, this.h * 0.3, 20,
                    this.w * pos, this.h * 0.6, 200
                );
                lightGradient.addColorStop(0, '#fff9c4');
                lightGradient.addColorStop(1, 'rgba(255, 249, 196, 0)');
                
                this.ctx.fillStyle = lightGradient;
                this.ctx.beginPath();
                this.ctx.arc(this.w * pos, this.h * 0.5, 200, 0, Math.PI * 2);
                this.ctx.fill();
            });
            
            this.ctx.restore();
        }
    }
}
