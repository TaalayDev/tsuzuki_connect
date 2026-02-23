/**
 * TSUZUKI CONNECT - Train Interior Background
 * Style: Honey and Clover - soft watercolor aesthetic
 * Japanese train car interior
 */

import { BackgroundUtils } from './BackgroundUtils.js';
import { BackgroundAssets } from './BackgroundAssets.js';

export class TrainBackground {
    constructor(ctx, width, height) {
        this.ctx = ctx;
        this.w = width;
        this.h = height;
        this.utils = new BackgroundUtils(ctx);
    }

    draw(timeOfDay = 'afternoon', season = 'spring') {
        const assetPath = BackgroundAssets.getPath('train', timeOfDay);
        const imageDrawn = this.utils.drawImageBackground(assetPath, this.w, this.h);

        if (!imageDrawn) {
            this.drawInterior(timeOfDay);
            this.drawFloor();
            this.drawWindows(timeOfDay, season);
            this.drawSeats();
            this.drawHandrails();
            this.drawDetails();
            this.drawPassengers();
        }
        
        this.utils.drawWatercolorTexture(this.w, this.h, 0.025);
    }

    drawInterior(timeOfDay) {
        // Ceiling
        let ceilingColors;
        if (timeOfDay === 'night') {
            ceilingColors = ['#455a64', '#546e7a', '#607d8b'];
        } else {
            ceilingColors = ['#eceff1', '#cfd8dc', '#b0bec5'];
        }
        
        const ceilingGradient = this.utils.createWatercolorGradient(0, 0, 0, this.h * 0.15, ceilingColors);
        this.ctx.fillStyle = ceilingGradient;
        this.ctx.fillRect(0, 0, this.w, this.h * 0.15);
        
        // Walls
        let wallColors;
        if (timeOfDay === 'night') {
            wallColors = ['#37474f', '#455a64', '#546e7a'];
        } else {
            wallColors = ['#e0e0e0', '#eeeeee', '#f5f5f5'];
        }
        
        const wallGradient = this.utils.createWatercolorGradient(0, this.h * 0.15, 0, this.h * 0.65, wallColors);
        this.ctx.fillStyle = wallGradient;
        this.ctx.fillRect(0, this.h * 0.15, this.w, this.h * 0.5);
        
        // Metal trim
        this.ctx.fillStyle = '#9e9e9e';
        this.ctx.fillRect(0, this.h * 0.14, this.w, 5);
        this.ctx.fillRect(0, this.h * 0.64, this.w, 3);
        
        // Ceiling lights
        this.drawCeilingLights(timeOfDay);
    }

    drawCeilingLights(timeOfDay) {
        const lightY = this.h * 0.08;
        
        for (let i = 0; i < 5; i++) {
            const x = this.w * 0.1 + i * (this.w * 0.2);
            
            // Light fixture
            this.ctx.fillStyle = '#bdbdbd';
            this.ctx.fillRect(x - 40, lightY - 8, 80, 16);
            
            if (timeOfDay === 'evening' || timeOfDay === 'night') {
                // Light glow
                const glowGradient = this.ctx.createRadialGradient(x, lightY + 10, 10, x, lightY + 50, 100);
                glowGradient.addColorStop(0, 'rgba(255, 249, 196, 0.3)');
                glowGradient.addColorStop(1, 'rgba(255, 249, 196, 0)');
                
                this.ctx.fillStyle = glowGradient;
                this.ctx.beginPath();
                this.ctx.arc(x, lightY + 50, 100, 0, Math.PI * 2);
                this.ctx.fill();
            }
            
            // Light panel
            this.ctx.fillStyle = timeOfDay === 'night' || timeOfDay === 'evening' ? '#fffde7' : '#fff9c4';
            this.ctx.fillRect(x - 35, lightY - 5, 70, 10);
        }
    }

    drawFloor() {
        const floorGradient = this.utils.createWatercolorGradient(
            0, this.h * 0.65, 0, this.h,
            ['#757575', '#616161', '#424242']
        );
        this.ctx.fillStyle = floorGradient;
        this.ctx.fillRect(0, this.h * 0.65, this.w, this.h * 0.35);
        
        // Floor pattern (speckled anti-slip)
        this.ctx.save();
        this.ctx.globalAlpha = 0.1;
        for (let i = 0; i < 200; i++) {
            const x = Math.random() * this.w;
            const y = this.h * 0.65 + Math.random() * this.h * 0.35;
            this.ctx.fillStyle = Math.random() > 0.5 ? '#9e9e9e' : '#424242';
            this.ctx.beginPath();
            this.ctx.arc(x, y, Math.random() * 2 + 1, 0, Math.PI * 2);
            this.ctx.fill();
        }
        this.ctx.restore();
        
        // Yellow safety line at door area
        this.ctx.fillStyle = '#fdd835';
        this.ctx.fillRect(this.w * 0.42, this.h * 0.66, this.w * 0.16, 6);
    }

    drawWindows(timeOfDay, season) {
        // Windows on both sides
        const windowPositions = [
            { x: this.w * 0.03, width: this.w * 0.18 },
            { x: this.w * 0.24, width: this.w * 0.15 },
            { x: this.w * 0.62, width: this.w * 0.15 },
            { x: this.w * 0.8, width: this.w * 0.18 }
        ];
        
        windowPositions.forEach(win => {
            this.drawWindow(win.x, this.h * 0.18, win.width, this.h * 0.35, timeOfDay, season);
        });
        
        // Door in center
        this.drawDoor(this.w * 0.4, this.h * 0.16, this.w * 0.2, this.h * 0.5, timeOfDay);
    }

    drawWindow(x, y, width, height, timeOfDay, season) {
        // Window frame
        this.ctx.fillStyle = '#78909c';
        this.ctx.fillRect(x - 4, y - 4, width + 8, height + 8);
        
        // View through window
        let viewColors;
        switch (timeOfDay) {
            case 'morning':
                viewColors = ['#fff8e1', '#bbdefb', '#90caf9'];
                break;
            case 'evening':
                viewColors = ['#ff8a65', '#ffab91', '#ffcc80'];
                break;
            case 'night':
                viewColors = ['#1a237e', '#283593', '#303f9f'];
                break;
            default:
                viewColors = ['#64b5f6', '#90caf9', '#bbdefb'];
        }
        
        const viewGradient = this.utils.createWatercolorGradient(x, y, x, y + height, viewColors);
        this.ctx.fillStyle = viewGradient;
        this.ctx.fillRect(x, y, width, height);
        
        // Scenery through window (blurred cityscape)
        this.ctx.save();
        this.ctx.globalAlpha = 0.4;
        
        // Distant buildings
        const buildingColor = timeOfDay === 'night' ? '#1a1a2e' : 
                             timeOfDay === 'evening' ? '#bf9b8c' : '#78909c';
        this.ctx.fillStyle = buildingColor;
        
        for (let i = 0; i < 6; i++) {
            const bx = x + i * (width / 5) - 10;
            const bHeight = 40 + Math.random() * 80;
            this.ctx.fillRect(bx, y + height - bHeight, width / 6, bHeight);
        }
        
        // Cherry blossoms outside in spring
        if (season === 'spring' && timeOfDay !== 'night') {
            this.ctx.fillStyle = '#ffb7c5';
            for (let i = 0; i < 8; i++) {
                const px = x + Math.random() * width;
                const py = y + Math.random() * height;
                this.ctx.beginPath();
                this.ctx.arc(px, py, Math.random() * 5 + 3, 0, Math.PI * 2);
                this.ctx.fill();
            }
        }
        
        // Night lights
        if (timeOfDay === 'night') {
            for (let i = 0; i < 15; i++) {
                const lx = x + Math.random() * width;
                const ly = y + height * 0.3 + Math.random() * height * 0.5;
                const colors = ['#ffeb3b', '#ff9800', '#4fc3f7', '#fff'];
                this.ctx.fillStyle = colors[Math.floor(Math.random() * colors.length)];
                this.ctx.beginPath();
                this.ctx.arc(lx, ly, Math.random() * 2 + 1, 0, Math.PI * 2);
                this.ctx.fill();
            }
        }
        
        this.ctx.restore();
        
        // Window shine
        this.ctx.save();
        this.ctx.globalAlpha = 0.15;
        this.ctx.fillStyle = '#fff';
        this.ctx.beginPath();
        this.ctx.moveTo(x + 5, y + 5);
        this.ctx.lineTo(x + 30, y + 5);
        this.ctx.lineTo(x + 5, y + 50);
        this.ctx.closePath();
        this.ctx.fill();
        this.ctx.restore();
    }

    drawDoor(x, y, width, height, timeOfDay) {
        // Door frame
        this.ctx.fillStyle = '#607d8b';
        this.ctx.fillRect(x - 6, y - 4, width + 12, height + 8);
        
        // Door panels (glass)
        const doorColor = timeOfDay === 'night' ? '#37474f' : '#90a4ae';
        this.ctx.fillStyle = doorColor;
        this.ctx.fillRect(x, y, width * 0.48, height);
        this.ctx.fillRect(x + width * 0.52, y, width * 0.48, height);
        
        // Door gap
        this.ctx.fillStyle = '#455a64';
        this.ctx.fillRect(x + width * 0.48, y, width * 0.04, height);
        
        // Door windows
        const windowGradient = this.ctx.createLinearGradient(x, y, x, y + height * 0.6);
        windowGradient.addColorStop(0, timeOfDay === 'night' ? '#1a237e' : '#b3e5fc');
        windowGradient.addColorStop(1, timeOfDay === 'night' ? '#303f9f' : '#81d4fa');
        
        this.ctx.fillStyle = windowGradient;
        this.ctx.fillRect(x + 10, y + 10, width * 0.48 - 20, height * 0.5);
        this.ctx.fillRect(x + width * 0.52 + 10, y + 10, width * 0.48 - 20, height * 0.5);
        
        // Door handles
        this.ctx.fillStyle = '#9e9e9e';
        this.ctx.fillRect(x + width * 0.42, y + height * 0.4, 8, 30);
        this.ctx.fillRect(x + width * 0.52, y + height * 0.4, 8, 30);
        
        // "Caution" sign above door
        this.ctx.fillStyle = '#f44336';
        this.ctx.fillRect(x + width * 0.3, y - 25, width * 0.4, 18);
        this.ctx.fillStyle = '#fff';
        this.ctx.font = '10px sans-serif';
        this.ctx.textAlign = 'center';
        this.ctx.fillText('ドアに注意', x + width * 0.5, y - 12);
    }

    drawSeats() {
        // Left side seats
        this.drawSeatRow(this.w * 0.02, this.h * 0.48, 3, 'left');
        
        // Right side seats  
        this.drawSeatRow(this.w * 0.68, this.h * 0.48, 3, 'right');
        
        // Priority seat indicator
        this.drawPrioritySeat(this.w * 0.02, this.h * 0.48);
    }

    drawSeatRow(startX, y, count, side) {
        const seatWidth = 50;
        const seatGap = 5;
        
        for (let i = 0; i < count; i++) {
            const x = startX + i * (seatWidth + seatGap);
            this.drawSeat(x, y, seatWidth, side);
        }
    }

    drawSeat(x, y, width, side) {
        // Seat cushion
        const cushionGradient = this.ctx.createLinearGradient(x, y, x, y + 35);
        cushionGradient.addColorStop(0, '#5c6bc0');
        cushionGradient.addColorStop(0.5, '#7986cb');
        cushionGradient.addColorStop(1, '#5c6bc0');
        
        this.ctx.fillStyle = cushionGradient;
        
        // Seat base
        this.ctx.beginPath();
        this.ctx.roundRect(x, y + 25, width, 35, 5);
        this.ctx.fill();
        
        // Seat back
        const backGradient = this.ctx.createLinearGradient(x, y, x, y + 30);
        backGradient.addColorStop(0, '#5c6bc0');
        backGradient.addColorStop(1, '#3f51b5');
        
        this.ctx.fillStyle = backGradient;
        this.ctx.beginPath();
        this.ctx.roundRect(x + 2, y, width - 4, 28, [5, 5, 0, 0]);
        this.ctx.fill();
        
        // Metal frame
        this.ctx.fillStyle = '#9e9e9e';
        this.ctx.fillRect(x + 5, y + 58, 8, 12);
        this.ctx.fillRect(x + width - 13, y + 58, 8, 12);
        
        // Armrest
        this.ctx.fillStyle = '#78909c';
        if (side === 'left') {
            this.ctx.fillRect(x + width - 2, y + 20, 6, 40);
        } else {
            this.ctx.fillRect(x - 4, y + 20, 6, 40);
        }
    }

    drawPrioritySeat(x, y) {
        // Priority seat sign
        this.ctx.save();
        
        // Sign background
        this.ctx.fillStyle = '#ff8f00';
        this.ctx.beginPath();
        this.ctx.roundRect(x, y - 35, 80, 25, 5);
        this.ctx.fill();
        
        // Text
        this.ctx.fillStyle = '#fff';
        this.ctx.font = 'bold 11px sans-serif';
        this.ctx.textAlign = 'center';
        this.ctx.fillText('優先席', x + 40, y - 18);
        
        this.ctx.restore();
    }

    drawHandrails() {
        // Overhead handrails
        this.ctx.strokeStyle = '#9e9e9e';
        this.ctx.lineWidth = 6;
        
        // Left rail
        this.ctx.beginPath();
        this.ctx.moveTo(this.w * 0.05, this.h * 0.12);
        this.ctx.lineTo(this.w * 0.38, this.h * 0.12);
        this.ctx.stroke();
        
        // Right rail
        this.ctx.beginPath();
        this.ctx.moveTo(this.w * 0.62, this.h * 0.12);
        this.ctx.lineTo(this.w * 0.95, this.h * 0.12);
        this.ctx.stroke();
        
        // Vertical poles
        this.ctx.lineWidth = 5;
        const polePositions = [0.05, 0.2, 0.38, 0.62, 0.8, 0.95];
        
        polePositions.forEach(pos => {
            const x = this.w * pos;
            
            // Pole gradient
            const poleGradient = this.ctx.createLinearGradient(x - 3, 0, x + 3, 0);
            poleGradient.addColorStop(0, '#9e9e9e');
            poleGradient.addColorStop(0.5, '#bdbdbd');
            poleGradient.addColorStop(1, '#9e9e9e');
            
            this.ctx.strokeStyle = poleGradient;
            this.ctx.beginPath();
            this.ctx.moveTo(x, this.h * 0.12);
            this.ctx.lineTo(x, this.h * 0.65);
            this.ctx.stroke();
        });
        
        // Hanging straps
        this.drawHangingStraps();
    }

    drawHangingStraps() {
        const strapPositions = [
            this.w * 0.1, this.w * 0.18, this.w * 0.26, this.w * 0.34,
            this.w * 0.66, this.w * 0.74, this.w * 0.82, this.w * 0.9
        ];
        
        strapPositions.forEach(x => {
            const swayOffset = Math.sin(x * 0.01) * 5;
            
            // Strap
            this.ctx.strokeStyle = '#e0e0e0';
            this.ctx.lineWidth = 3;
            this.ctx.beginPath();
            this.ctx.moveTo(x, this.h * 0.12);
            this.ctx.lineTo(x + swayOffset, this.h * 0.25);
            this.ctx.stroke();
            
            // Handle (ring)
            this.ctx.strokeStyle = '#9e9e9e';
            this.ctx.lineWidth = 4;
            this.ctx.beginPath();
            this.ctx.arc(x + swayOffset, this.h * 0.28, 12, 0, Math.PI * 2);
            this.ctx.stroke();
            
            // Handle fill
            this.ctx.fillStyle = '#f5f5f5';
            this.ctx.beginPath();
            this.ctx.arc(x + swayOffset, this.h * 0.28, 10, 0, Math.PI * 2);
            this.ctx.fill();
        });
    }

    drawDetails() {
        // Route map display
        this.drawRouteMap();
        
        // Advertisement panels
        this.drawAdPanels();
        
        // Emergency equipment
        this.drawEmergencyEquipment();
    }

    drawRouteMap() {
        const x = this.w * 0.78;
        const y = this.h * 0.18;
        
        // Frame
        this.ctx.fillStyle = '#455a64';
        this.ctx.fillRect(x - 4, y - 4, 130, 65);
        
        // Map background
        this.ctx.fillStyle = '#e3f2fd';
        this.ctx.fillRect(x, y, 122, 57);
        
        // Route line
        this.ctx.strokeStyle = '#1e88e5';
        this.ctx.lineWidth = 4;
        this.ctx.beginPath();
        this.ctx.moveTo(x + 10, y + 30);
        this.ctx.lineTo(x + 112, y + 30);
        this.ctx.stroke();
        
        // Station dots
        const stations = [15, 35, 55, 75, 95, 112];
        stations.forEach((sx, i) => {
            this.ctx.fillStyle = i === 2 ? '#f44336' : '#1e88e5';
            this.ctx.beginPath();
            this.ctx.arc(x + sx, y + 30, i === 2 ? 6 : 4, 0, Math.PI * 2);
            this.ctx.fill();
        });
        
        // "You are here" indicator
        this.ctx.fillStyle = '#f44336';
        this.ctx.beginPath();
        this.ctx.moveTo(x + 55, y + 15);
        this.ctx.lineTo(x + 50, y + 22);
        this.ctx.lineTo(x + 60, y + 22);
        this.ctx.closePath();
        this.ctx.fill();
    }

    drawAdPanels() {
        // Ad panel above left seats
        this.drawAdPanel(this.w * 0.05, this.h * 0.18, 'コーヒー', '#795548');
        
        // Ad panel above right seats  
        this.drawAdPanel(this.w * 0.88, this.h * 0.18, '新刊発売', '#e91e63');
    }

    drawAdPanel(x, y, text, color) {
        // Panel
        this.ctx.fillStyle = color;
        this.ctx.fillRect(x, y, 70, 45);
        
        // Design element
        this.ctx.save();
        this.ctx.globalAlpha = 0.3;
        this.ctx.fillStyle = '#fff';
        this.ctx.beginPath();
        this.ctx.arc(x + 50, y + 25, 20, 0, Math.PI * 2);
        this.ctx.fill();
        this.ctx.restore();
        
        // Text
        this.ctx.fillStyle = '#fff';
        this.ctx.font = 'bold 10px sans-serif';
        this.ctx.textAlign = 'center';
        this.ctx.fillText(text, x + 35, y + 30);
    }

    drawEmergencyEquipment() {
        const x = this.w * 0.58;
        const y = this.h * 0.55;
        
        // Fire extinguisher
        this.ctx.fillStyle = '#d32f2f';
        this.ctx.beginPath();
        this.ctx.roundRect(x, y, 15, 30, 3);
        this.ctx.fill();
        
        // Nozzle
        this.ctx.fillStyle = '#424242';
        this.ctx.fillRect(x + 4, y - 8, 7, 10);
        this.ctx.fillRect(x + 8, y - 6, 12, 4);
    }

    drawPassengers() {
        // Silhouette suggestions of passengers (watercolor style)
        this.ctx.save();
        this.ctx.globalAlpha = 0.15;
        
        // Standing passenger 1
        const p1Gradient = this.ctx.createRadialGradient(
            this.w * 0.12, this.h * 0.4, 10,
            this.w * 0.12, this.h * 0.5, 80
        );
        p1Gradient.addColorStop(0, '#5d4037');
        p1Gradient.addColorStop(1, 'rgba(93, 64, 55, 0)');
        
        this.ctx.fillStyle = p1Gradient;
        this.ctx.beginPath();
        this.ctx.ellipse(this.w * 0.12, this.h * 0.45, 25, 60, 0, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Standing passenger 2
        const p2Gradient = this.ctx.createRadialGradient(
            this.w * 0.88, this.h * 0.42, 10,
            this.w * 0.88, this.h * 0.5, 70
        );
        p2Gradient.addColorStop(0, '#455a64');
        p2Gradient.addColorStop(1, 'rgba(69, 90, 100, 0)');
        
        this.ctx.fillStyle = p2Gradient;
        this.ctx.beginPath();
        this.ctx.ellipse(this.w * 0.88, this.h * 0.47, 22, 55, 0, 0, Math.PI * 2);
        this.ctx.fill();
        
        this.ctx.restore();
    }
}
