/**
 * TSUZUKI CONNECT - Station Background
 * Style: Honey and Clover - soft watercolor aesthetic
 */

import { BackgroundUtils } from './BackgroundUtils.js';
import { BackgroundAssets } from './BackgroundAssets.js';

export class StationBackground {
    constructor(ctx, width, height) {
        this.ctx = ctx;
        this.w = width;
        this.h = height;
        this.utils = new BackgroundUtils(ctx);
    }

    draw(timeOfDay = 'afternoon') {
        const assetPath = BackgroundAssets.getPath('station', timeOfDay);
        const imageDrawn = this.utils.drawImageBackground(assetPath, this.w, this.h);

        if (!imageDrawn) {
            this.drawSky(timeOfDay);
            this.drawPlatformRoof();
            this.drawPlatform();
            this.drawTracks();
            this.drawSignage();
            this.drawPillars();
            this.drawBenches();
            this.drawVendingMachines();
            this.drawDetails(timeOfDay);
        }
        
        this.utils.drawWatercolorTexture(this.w, this.h, 0.025);
    }

    drawSky(timeOfDay) {
        let skyColors;
        
        switch (timeOfDay) {
            case 'morning':
                skyColors = ['#fff8e1', '#ffecb3', '#81d4fa'];
                break;
            case 'evening':
                skyColors = ['#ff7043', '#ffab91', '#ffcc80'];
                break;
            case 'night':
                skyColors = ['#1a237e', '#283593', '#3949ab'];
                break;
            default:
                skyColors = ['#64b5f6', '#90caf9', '#bbdefb'];
        }
        
        const skyGradient = this.utils.createWatercolorGradient(0, 0, 0, this.h * 0.5, skyColors);
        this.ctx.fillStyle = skyGradient;
        this.ctx.fillRect(0, 0, this.w, this.h * 0.5);
        
        // Clouds (daytime only)
        if (timeOfDay !== 'night') {
            this.utils.drawCloud(this.w * 0.2, this.h * 0.1, 0.6);
            this.utils.drawCloud(this.w * 0.7, this.h * 0.15, 0.8);
        }
    }

    drawPlatformRoof() {
        // Main roof structure
        const roofGradient = this.utils.createWatercolorGradient(
            0, 0, 0, this.h * 0.15,
            ['#455a64', '#37474f', '#263238']
        );
        this.ctx.fillStyle = roofGradient;
        
        // Angled roof
        this.ctx.beginPath();
        this.ctx.moveTo(0, 0);
        this.ctx.lineTo(this.w, 0);
        this.ctx.lineTo(this.w, this.h * 0.08);
        this.ctx.lineTo(0, this.h * 0.12);
        this.ctx.closePath();
        this.ctx.fill();
        
        // Roof underside with beams
        this.ctx.fillStyle = '#546e7a';
        this.ctx.fillRect(0, this.h * 0.08, this.w, this.h * 0.02);
        
        // Support beams
        for (let i = 0; i < 6; i++) {
            const x = this.w * 0.1 + i * (this.w * 0.16);
            this.ctx.fillStyle = '#455a64';
            this.ctx.fillRect(x, this.h * 0.1, 15, this.h * 0.05);
        }
    }

    drawPlatform() {
        // Platform surface
        const platformGradient = this.utils.createWatercolorGradient(
            0, this.h * 0.68, 0, this.h * 0.72,
            ['#90a4ae', '#78909c', '#607d8b']
        );
        this.ctx.fillStyle = platformGradient;
        this.ctx.fillRect(0, this.h * 0.68, this.w, this.h * 0.04);
        
        // Yellow safety line
        const safetyGradient = this.ctx.createLinearGradient(0, this.h * 0.68, this.w, this.h * 0.68);
        safetyGradient.addColorStop(0, '#ffd600');
        safetyGradient.addColorStop(0.5, '#ffea00');
        safetyGradient.addColorStop(1, '#ffd600');
        
        this.ctx.fillStyle = safetyGradient;
        this.ctx.fillRect(0, this.h * 0.68, this.w, this.h * 0.015);
        
        // Warning bumps on safety line
        this.ctx.fillStyle = '#ffab00';
        for (let i = 0; i < 40; i++) {
            this.ctx.beginPath();
            this.ctx.arc(i * 35 + 15, this.h * 0.685, 4, 0, Math.PI * 2);
            this.ctx.fill();
        }
        
        // Platform floor (concrete texture)
        const floorGradient = this.utils.createWatercolorGradient(
            0, this.h * 0.72, 0, this.h,
            ['#78909c', '#607d8b', '#546e7a']
        );
        this.ctx.fillStyle = floorGradient;
        this.ctx.fillRect(0, this.h * 0.72, this.w, this.h * 0.28);
        
        // Floor tiles
        this.ctx.strokeStyle = 'rgba(69, 90, 100, 0.3)';
        this.ctx.lineWidth = 1;
        
        for (let i = 0; i < 20; i++) {
            this.ctx.beginPath();
            this.ctx.moveTo(i * 70, this.h * 0.72);
            this.ctx.lineTo(i * 70, this.h);
            this.ctx.stroke();
        }
        
        for (let i = 0; i < 5; i++) {
            this.ctx.beginPath();
            this.ctx.moveTo(0, this.h * 0.72 + i * 60);
            this.ctx.lineTo(this.w, this.h * 0.72 + i * 60);
            this.ctx.stroke();
        }
    }

    drawTracks() {
        const trackY = this.h * 0.5;
        
        // Track bed (gravel)
        this.ctx.fillStyle = '#5d4037';
        this.ctx.fillRect(0, trackY, this.w, this.h * 0.18);
        
        // Gravel texture
        this.ctx.save();
        this.ctx.globalAlpha = 0.3;
        for (let i = 0; i < 200; i++) {
            this.ctx.fillStyle = ['#4e342e', '#6d4c41', '#795548'][Math.floor(Math.random() * 3)];
            this.ctx.beginPath();
            this.ctx.arc(
                Math.random() * this.w,
                trackY + Math.random() * this.h * 0.18,
                Math.random() * 4 + 2,
                0, Math.PI * 2
            );
            this.ctx.fill();
        }
        this.ctx.restore();
        
        // Rails
        const railY1 = trackY + this.h * 0.06;
        const railY2 = trackY + this.h * 0.12;
        
        this.ctx.fillStyle = '#37474f';
        this.ctx.fillRect(0, railY1, this.w, 6);
        this.ctx.fillRect(0, railY2, this.w, 6);
        
        // Rail shine
        this.ctx.fillStyle = 'rgba(255, 255, 255, 0.3)';
        this.ctx.fillRect(0, railY1, this.w, 2);
        this.ctx.fillRect(0, railY2, this.w, 2);
        
        // Ties (sleepers)
        this.ctx.fillStyle = '#5d4037';
        for (let i = 0; i < 25; i++) {
            this.ctx.fillRect(i * 55 + 10, trackY + this.h * 0.04, 35, this.h * 0.1);
        }
    }

    drawSignage() {
        // Main station sign
        const signX = this.w * 0.3;
        const signY = this.h * 0.13;
        const signW = this.w * 0.4;
        const signH = this.h * 0.08;
        
        // Sign background
        this.ctx.fillStyle = '#0d47a1';
        this.ctx.fillRect(signX, signY, signW, signH);
        
        // White border
        this.ctx.strokeStyle = '#fff';
        this.ctx.lineWidth = 3;
        this.ctx.strokeRect(signX + 5, signY + 5, signW - 10, signH - 10);
        
        // Station name
        this.ctx.fillStyle = '#fff';
        this.ctx.font = 'bold 28px "Noto Sans JP", sans-serif';
        this.ctx.textAlign = 'center';
        this.ctx.textBaseline = 'middle';
        this.ctx.fillText('渋谷', signX + signW / 2 - 60, signY + signH / 2);
        
        this.ctx.font = 'bold 20px "Nunito", sans-serif';
        this.ctx.fillText('Shibuya', signX + signW / 2 + 50, signY + signH / 2);
        
        // Direction arrows
        this.drawDirectionSign(this.w * 0.08, signY + 5, '← 原宿', 'Harajuku');
        this.drawDirectionSign(this.w * 0.75, signY + 5, '恵比寿 →', 'Ebisu');
        
        // Platform number
        this.drawPlatformNumber(this.w * 0.9, this.h * 0.25);
    }

    drawDirectionSign(x, y, textJa, textEn) {
        this.ctx.fillStyle = '#1565c0';
        this.ctx.fillRect(x, y, 140, 50);
        
        this.ctx.fillStyle = '#fff';
        this.ctx.font = '16px "Noto Sans JP", sans-serif';
        this.ctx.textAlign = 'center';
        this.ctx.fillText(textJa, x + 70, y + 22);
        
        this.ctx.font = '12px "Nunito", sans-serif';
        this.ctx.fillText(textEn, x + 70, y + 40);
    }

    drawPlatformNumber(x, y) {
        // Platform indicator
        this.ctx.fillStyle = '#0d47a1';
        this.ctx.beginPath();
        this.ctx.arc(x, y, 35, 0, Math.PI * 2);
        this.ctx.fill();
        
        this.ctx.fillStyle = '#fff';
        this.ctx.font = 'bold 32px "Nunito", sans-serif';
        this.ctx.textAlign = 'center';
        this.ctx.textBaseline = 'middle';
        this.ctx.fillText('3', x, y);
        
        this.ctx.font = '12px "Nunito", sans-serif';
        this.ctx.fillText('Platform', x, y + 50);
    }

    drawPillars() {
        const pillarPositions = [this.w * 0.15, this.w * 0.45, this.w * 0.75];
        
        pillarPositions.forEach(x => {
            // Pillar body
            const pillarGradient = this.ctx.createLinearGradient(x - 20, 0, x + 20, 0);
            pillarGradient.addColorStop(0, '#78909c');
            pillarGradient.addColorStop(0.5, '#b0bec5');
            pillarGradient.addColorStop(1, '#78909c');
            
            this.ctx.fillStyle = pillarGradient;
            this.ctx.fillRect(x - 20, this.h * 0.1, 40, this.h * 0.58);
            
            // Pillar base
            this.ctx.fillStyle = '#546e7a';
            this.ctx.fillRect(x - 25, this.h * 0.65, 50, this.h * 0.03);
        });
    }

    drawBenches() {
        this.drawBench(this.w * 0.25, this.h * 0.78);
        this.drawBench(this.w * 0.6, this.h * 0.78);
    }

    drawBench(x, y) {
        // Seat
        const seatGradient = this.ctx.createLinearGradient(x, y, x, y + 20);
        seatGradient.addColorStop(0, '#90a4ae');
        seatGradient.addColorStop(1, '#78909c');
        
        this.ctx.fillStyle = seatGradient;
        this.ctx.fillRect(x, y, 120, 18);
        
        // Dividers
        this.ctx.fillStyle = '#607d8b';
        this.ctx.fillRect(x + 40, y, 4, 18);
        this.ctx.fillRect(x + 80, y, 4, 18);
        
        // Legs
        this.ctx.fillStyle = '#546e7a';
        this.ctx.fillRect(x + 5, y + 18, 10, 30);
        this.ctx.fillRect(x + 105, y + 18, 10, 30);
        
        // Armrests
        this.ctx.fillStyle = '#78909c';
        this.ctx.fillRect(x - 5, y - 25, 8, 25);
        this.ctx.fillRect(x + 117, y - 25, 8, 25);
    }

    drawVendingMachines() {
        this.drawVendingMachine(this.w * 0.88, this.h * 0.4, '#e53935');
        this.drawVendingMachine(this.w * 0.93, this.h * 0.4, '#1565c0');
    }

    drawVendingMachine(x, y, color) {
        // Body
        const machineGradient = this.ctx.createLinearGradient(x, y, x + 55, y);
        machineGradient.addColorStop(0, this.utils.darkenColor(color, 20));
        machineGradient.addColorStop(0.5, color);
        machineGradient.addColorStop(1, this.utils.darkenColor(color, 20));
        
        this.ctx.fillStyle = machineGradient;
        this.ctx.fillRect(x, y, 55, 120);
        
        // Display window
        this.ctx.fillStyle = '#1a237e';
        this.ctx.fillRect(x + 5, y + 10, 45, 60);
        
        // Drink rows
        for (let r = 0; r < 3; r++) {
            for (let c = 0; c < 4; c++) {
                const drinkColors = ['#4caf50', '#2196f3', '#ff9800', '#e91e63'];
                this.ctx.fillStyle = drinkColors[c];
                this.ctx.fillRect(x + 8 + c * 11, y + 15 + r * 18, 9, 15);
            }
        }
        
        // Price display
        this.ctx.fillStyle = '#000';
        this.ctx.fillRect(x + 5, y + 75, 45, 15);
        this.ctx.fillStyle = '#4caf50';
        this.ctx.font = '10px "Nunito", sans-serif';
        this.ctx.textAlign = 'center';
        this.ctx.fillText('¥150', x + 27, y + 86);
        
        // Slot
        this.ctx.fillStyle = '#263238';
        this.ctx.fillRect(x + 10, y + 95, 35, 20);
    }

    drawDetails(timeOfDay) {
        // Clock
        this.utils.drawClock(this.w * 0.5, this.h * 0.25, 30);
        
        // Timetable display
        this.drawTimetable(this.w * 0.55, this.h * 0.32);
        
        // Lighting (for evening/night)
        if (timeOfDay === 'evening' || timeOfDay === 'night') {
            this.drawStationLights();
        }
        
        // Trash bins
        this.drawTrashBin(this.w * 0.35, this.h * 0.82);
    }

    drawTimetable(x, y) {
        // Board
        this.ctx.fillStyle = '#263238';
        this.ctx.fillRect(x, y, 100, 80);
        
        // Header
        this.ctx.fillStyle = '#ff9800';
        this.ctx.fillRect(x, y, 100, 18);
        
        this.ctx.fillStyle = '#000';
        this.ctx.font = 'bold 11px "Noto Sans JP", sans-serif';
        this.ctx.textAlign = 'center';
        this.ctx.fillText('次の電車', x + 50, y + 13);
        
        // Times
        this.ctx.fillStyle = '#ffc107';
        this.ctx.font = '14px "Nunito", sans-serif';
        
        const times = ['14:32', '14:38', '14:45'];
        times.forEach((time, i) => {
            this.ctx.fillText(time, x + 30, y + 38 + i * 18);
            this.ctx.fillStyle = '#fff';
            this.ctx.fillText('各停', x + 70, y + 38 + i * 18);
            this.ctx.fillStyle = '#ffc107';
        });
    }

    drawTrashBin(x, y) {
        // Bin body
        this.ctx.fillStyle = '#37474f';
        this.ctx.fillRect(x, y, 30, 45);
        
        // Opening
        this.ctx.fillStyle = '#263238';
        this.ctx.beginPath();
        this.ctx.ellipse(x + 15, y + 5, 12, 5, 0, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Labels
        this.ctx.fillStyle = '#4caf50';
        this.ctx.font = '8px "Noto Sans JP", sans-serif';
        this.ctx.textAlign = 'center';
        this.ctx.fillText('燃える', x + 15, y + 30);
        this.ctx.fillText('ごみ', x + 15, y + 40);
    }

    drawStationLights() {
        // Overhead lights glow
        this.ctx.save();
        
        for (let i = 0; i < 5; i++) {
            const lightX = this.w * 0.15 + i * (this.w * 0.18);
            
            const lightGradient = this.ctx.createRadialGradient(
                lightX, this.h * 0.12, 10,
                lightX, this.h * 0.12, 150
            );
            lightGradient.addColorStop(0, 'rgba(255, 249, 196, 0.4)');
            lightGradient.addColorStop(0.3, 'rgba(255, 245, 157, 0.2)');
            lightGradient.addColorStop(1, 'rgba(255, 241, 118, 0)');
            
            this.ctx.fillStyle = lightGradient;
            this.ctx.beginPath();
            this.ctx.arc(lightX, this.h * 0.12, 150, 0, Math.PI * 2);
            this.ctx.fill();
            
            // Light fixture
            this.ctx.fillStyle = '#fff9c4';
            this.ctx.fillRect(lightX - 20, this.h * 0.1, 40, 10);
        }
        
        this.ctx.restore();
    }
}
