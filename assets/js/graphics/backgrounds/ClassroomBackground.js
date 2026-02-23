/**
 * TSUZUKI CONNECT - Classroom Background
 * Style: Honey and Clover - soft watercolor aesthetic
 */

import { BackgroundUtils } from './BackgroundUtils.js';
import { BackgroundAssets } from './BackgroundAssets.js';

export class ClassroomBackground {
    constructor(ctx, width, height) {
        this.ctx = ctx;
        this.w = width;
        this.h = height;
        this.utils = new BackgroundUtils(ctx);
    }

    draw(timeOfDay = 'morning', season = 'spring') {
        const assetPath = BackgroundAssets.getPath('classroom', timeOfDay);
        const imageDrawn = this.utils.drawImageBackground(assetPath, this.w, this.h);

        if (!imageDrawn) {
            this.drawWall();
            this.drawFloor();
            this.drawWindows(timeOfDay, season);
            this.drawChalkboard();
            this.drawTeacherDesk();
            this.drawStudentDesks();
            this.drawDecorations(season);
        }
        
        this.utils.drawWatercolorTexture(this.w, this.h, 0.03);
    }

    drawWall() {
        // Soft cream wall with subtle gradient
        const gradient = this.ctx.createLinearGradient(0, 0, 0, this.h * 0.65);
        gradient.addColorStop(0, '#faf8f5');
        gradient.addColorStop(0.5, '#f5f1eb');
        gradient.addColorStop(1, '#efe9e0');
        
        this.ctx.fillStyle = gradient;
        this.ctx.fillRect(0, 0, this.w, this.h * 0.65);
        
        // Subtle wall texture
        this.ctx.save();
        this.ctx.globalAlpha = 0.02;
        for (let i = 0; i < 30; i++) {
            this.ctx.fillStyle = '#d7ccc8';
            this.ctx.beginPath();
            this.ctx.arc(
                Math.random() * this.w,
                Math.random() * this.h * 0.65,
                Math.random() * 80 + 20,
                0, Math.PI * 2
            );
            this.ctx.fill();
        }
        this.ctx.restore();
    }

    drawFloor() {
        // Warm wooden floor gradient
        const floorGradient = this.ctx.createLinearGradient(0, this.h * 0.65, 0, this.h);
        floorGradient.addColorStop(0, '#d7b98e');
        floorGradient.addColorStop(1, '#c4a574');
        
        this.ctx.fillStyle = floorGradient;
        this.ctx.fillRect(0, this.h * 0.65, this.w, this.h * 0.35);
        
        // Wood plank lines with soft appearance
        this.ctx.strokeStyle = 'rgba(139, 90, 43, 0.15)';
        this.ctx.lineWidth = 1;
        
        for (let i = 0; i < 12; i++) {
            const y = this.h * 0.65 + i * (this.h * 0.03);
            this.ctx.beginPath();
            this.ctx.moveTo(0, y);
            this.ctx.lineTo(this.w, y);
            this.ctx.stroke();
        }
        
        // Vertical plank divisions (perspective)
        for (let i = 0; i < 8; i++) {
            const x = i * (this.w / 7);
            this.ctx.beginPath();
            this.ctx.moveTo(x, this.h * 0.65);
            this.ctx.lineTo(x + (i - 3.5) * 20, this.h);
            this.ctx.stroke();
        }
    }

    drawWindows(timeOfDay, season) {
        const windowX = this.w * 0.02;
        const windowY = this.h * 0.08;
        const windowWidth = this.w * 0.28;
        const windowHeight = this.h * 0.48;
        
        // Window frame
        this.ctx.fillStyle = '#e8e0d5';
        this.ctx.fillRect(windowX - 8, windowY - 8, windowWidth + 16, windowHeight + 16);
        
        // Sky gradient based on time
        let skyColors;
        switch (timeOfDay) {
            case 'morning':
                skyColors = ['#fff8e1', '#ffecb3', '#b3e5fc'];
                break;
            case 'evening':
                skyColors = ['#ffccbc', '#ffab91', '#ff8a65'];
                break;
            case 'night':
                skyColors = ['#1a237e', '#283593', '#3949ab'];
                break;
            default:
                skyColors = ['#81d4fa', '#b3e5fc', '#e1f5fe'];
        }
        
        const skyGradient = this.utils.createWatercolorGradient(
            windowX, windowY, windowX, windowY + windowHeight, skyColors
        );
        this.ctx.fillStyle = skyGradient;
        this.ctx.fillRect(windowX, windowY, windowWidth, windowHeight);
        
        // Cherry blossom trees outside (spring)
        if (season === 'spring') {
            this.utils.drawCherryBlossomTree(windowX + windowWidth * 0.3, windowY + windowHeight * 0.6, 100);
            this.utils.drawCherryBlossomTree(windowX + windowWidth * 0.7, windowY + windowHeight * 0.7, 80);
        } else {
            this.utils.drawTree(windowX + windowWidth * 0.3, windowY + windowHeight * 0.6, 80);
            this.utils.drawTree(windowX + windowWidth * 0.75, windowY + windowHeight * 0.65, 70);
        }
        
        // Window cross dividers
        this.ctx.fillStyle = '#d7ccc8';
        this.ctx.fillRect(windowX + windowWidth / 2 - 4, windowY, 8, windowHeight);
        this.ctx.fillRect(windowX, windowY + windowHeight / 2 - 4, windowWidth, 8);
        
        // Soft curtains
        this.drawCurtain(windowX - 15, windowY - 20, 35, windowHeight + 50, 'left');
        this.drawCurtain(windowX + windowWidth - 20, windowY - 20, 35, windowHeight + 50, 'right');
        
        // Light rays from window
        this.ctx.save();
        this.ctx.globalAlpha = 0.08;
        const rayGradient = this.ctx.createLinearGradient(windowX, windowY, windowX + 400, windowY + 400);
        rayGradient.addColorStop(0, '#fff9c4');
        rayGradient.addColorStop(1, 'rgba(255, 249, 196, 0)');
        
        this.ctx.fillStyle = rayGradient;
        this.ctx.beginPath();
        this.ctx.moveTo(windowX, windowY);
        this.ctx.lineTo(windowX + windowWidth, windowY);
        this.ctx.lineTo(windowX + windowWidth + 300, this.h);
        this.ctx.lineTo(windowX + 100, this.h);
        this.ctx.closePath();
        this.ctx.fill();
        this.ctx.restore();
    }

    drawCurtain(x, y, width, height, side) {
        const curtainGradient = this.ctx.createLinearGradient(x, y, x + width, y);
        
        if (side === 'left') {
            curtainGradient.addColorStop(0, 'rgba(255, 248, 225, 0.9)');
            curtainGradient.addColorStop(1, 'rgba(255, 248, 225, 0.6)');
        } else {
            curtainGradient.addColorStop(0, 'rgba(255, 248, 225, 0.6)');
            curtainGradient.addColorStop(1, 'rgba(255, 248, 225, 0.9)');
        }
        
        this.ctx.fillStyle = curtainGradient;
        
        // Curtain folds
        this.ctx.beginPath();
        this.ctx.moveTo(x, y);
        
        for (let i = 0; i <= 5; i++) {
            const fold = i % 2 === 0 ? 5 : -5;
            this.ctx.lineTo(x + width / 2 + fold, y + (height / 5) * i);
        }
        
        this.ctx.lineTo(x + width, y + height);
        this.ctx.lineTo(x, y + height);
        this.ctx.closePath();
        this.ctx.fill();
        
        // Curtain rod
        this.ctx.fillStyle = '#8d6e63';
        this.ctx.fillRect(x - 5, y - 10, width + 10, 8);
    }

    drawChalkboard() {
        const x = this.w * 0.35;
        const y = this.h * 0.06;
        const width = this.w * 0.55;
        const height = this.h * 0.35;
        
        // Wooden frame with gradient
        const frameGradient = this.ctx.createLinearGradient(x - 12, y - 12, x + width + 12, y + height + 12);
        frameGradient.addColorStop(0, '#8d6e63');
        frameGradient.addColorStop(0.5, '#6d4c41');
        frameGradient.addColorStop(1, '#5d4037');
        
        this.ctx.fillStyle = frameGradient;
        this.ctx.fillRect(x - 12, y - 12, width + 24, height + 24);
        
        // Board surface with subtle texture
        const boardGradient = this.ctx.createLinearGradient(x, y, x, y + height);
        boardGradient.addColorStop(0, '#2e5339');
        boardGradient.addColorStop(0.5, '#3d6647');
        boardGradient.addColorStop(1, '#2e5339');
        
        this.ctx.fillStyle = boardGradient;
        this.ctx.fillRect(x, y, width, height);
        
        // Chalk dust texture
        this.ctx.save();
        this.ctx.globalAlpha = 0.1;
        for (let i = 0; i < 100; i++) {
            this.ctx.fillStyle = '#fff';
            this.ctx.beginPath();
            this.ctx.arc(
                x + Math.random() * width,
                y + Math.random() * height,
                Math.random() * 2,
                0, Math.PI * 2
            );
            this.ctx.fill();
        }
        this.ctx.restore();
        
        // Chalk writing
        this.ctx.fillStyle = 'rgba(255, 255, 255, 0.9)';
        this.ctx.font = '32px "Noto Sans JP", sans-serif';
        this.ctx.textAlign = 'center';
        this.ctx.fillText('ようこそ！', x + width / 2, y + 55);
        
        this.ctx.font = '20px "Nunito", sans-serif';
        this.ctx.fillStyle = 'rgba(255, 255, 255, 0.8)';
        this.ctx.fillText('Welcome to Japanese Class', x + width / 2, y + 95);
        
        // Date in corner
        this.ctx.font = '14px "Noto Sans JP", sans-serif';
        this.ctx.textAlign = 'right';
        this.ctx.fillText('4月15日', x + width - 15, y + 25);
        
        // Chalk tray
        this.ctx.fillStyle = '#6d4c41';
        this.ctx.fillRect(x, y + height, width, 18);
        this.ctx.fillStyle = '#5d4037';
        this.ctx.fillRect(x, y + height, width, 6);
        
        // Chalk pieces
        const chalks = [
            { x: x + 25, color: '#ffffff' },
            { x: x + 65, color: '#ffb7c5' },
            { x: x + 100, color: '#98d8c8' },
            { x: x + 135, color: '#fff59d' },
        ];
        
        chalks.forEach(chalk => {
            this.ctx.fillStyle = chalk.color;
            this.ctx.beginPath();
            this.ctx.roundRect(chalk.x, y + height + 6, 28, 7, 2);
            this.ctx.fill();
        });
    }

    drawTeacherDesk() {
        const x = this.w * 0.52;
        const y = this.h * 0.48;
        const width = this.w * 0.22;
        const height = this.h * 0.08;
        
        // Desk top with wood grain
        const topGradient = this.ctx.createLinearGradient(x, y, x + width, y);
        topGradient.addColorStop(0, '#a1887f');
        topGradient.addColorStop(0.5, '#8d6e63');
        topGradient.addColorStop(1, '#795548');
        
        this.ctx.fillStyle = topGradient;
        this.ctx.fillRect(x, y, width, height);
        
        // Desk front panel
        const frontGradient = this.ctx.createLinearGradient(x, y + height, x, y + height * 2.5);
        frontGradient.addColorStop(0, '#6d4c41');
        frontGradient.addColorStop(1, '#5d4037');
        
        this.ctx.fillStyle = frontGradient;
        this.ctx.fillRect(x, y + height, width, height * 1.8);
        
        // Items on desk
        // Coffee mug
        this.ctx.fillStyle = '#fff8e1';
        this.ctx.beginPath();
        this.ctx.ellipse(x + 35, y - 3, 14, 8, 0, 0, Math.PI * 2);
        this.ctx.fill();
        this.ctx.fillStyle = '#6d4c41';
        this.ctx.beginPath();
        this.ctx.ellipse(x + 35, y - 5, 11, 6, 0, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Steam
        this.ctx.save();
        this.ctx.globalAlpha = 0.3;
        this.ctx.strokeStyle = '#fff';
        this.ctx.lineWidth = 2;
        this.ctx.beginPath();
        this.ctx.moveTo(x + 32, y - 15);
        this.ctx.quadraticCurveTo(x + 28, y - 25, x + 32, y - 35);
        this.ctx.moveTo(x + 38, y - 15);
        this.ctx.quadraticCurveTo(x + 42, y - 28, x + 38, y - 38);
        this.ctx.stroke();
        this.ctx.restore();
        
        // Books stack
        const bookColors = ['#c62828', '#1565c0', '#2e7d32'];
        bookColors.forEach((color, i) => {
            this.ctx.fillStyle = color;
            this.ctx.fillRect(x + width - 70 + i * 3, y - 35 + i * 12, 55, 12);
        });
        
        // Papers
        this.ctx.fillStyle = '#fafafa';
        this.ctx.fillRect(x + width - 120, y - 8, 40, 30);
        this.ctx.fillStyle = 'rgba(0,0,0,0.1)';
        for (let i = 0; i < 4; i++) {
            this.ctx.fillRect(x + width - 115, y - 3 + i * 6, 30, 1);
        }
    }

    drawStudentDesks() {
        const desks = [
            { x: this.w * 0.12, y: this.h * 0.58, scale: 0.85 },
            { x: this.w * 0.32, y: this.h * 0.64, scale: 0.95 },
            { x: this.w * 0.72, y: this.h * 0.64, scale: 0.95 },
            { x: this.w * 0.88, y: this.h * 0.58, scale: 0.85 },
        ];
        
        desks.forEach(desk => this.drawStudentDesk(desk.x, desk.y, desk.scale));
    }

    drawStudentDesk(x, y, scale) {
        const width = 100 * scale;
        const height = 55 * scale;
        
        // Desk top
        const topGradient = this.ctx.createLinearGradient(x - width / 2, y, x + width / 2, y);
        topGradient.addColorStop(0, '#efebe9');
        topGradient.addColorStop(0.5, '#d7ccc8');
        topGradient.addColorStop(1, '#bcaaa4');
        
        this.ctx.fillStyle = topGradient;
        this.ctx.fillRect(x - width / 2, y, width, height * 0.25);
        
        // Desk front
        this.ctx.fillStyle = '#a1887f';
        this.ctx.fillRect(x - width / 2, y + height * 0.25, width, height * 0.6);
        
        // Storage opening
        this.ctx.fillStyle = '#5d4037';
        this.ctx.fillRect(x - width / 2 + 10, y + height * 0.35, width - 20, height * 0.4);
        
        // Chair
        this.ctx.fillStyle = '#8d6e63';
        this.ctx.fillRect(x - width * 0.22, y + height * 0.55, width * 0.44, height * 0.15);
        
        // Notebook on desk
        this.ctx.fillStyle = '#fff8e1';
        this.ctx.fillRect(x - 18 * scale, y + 4, 36 * scale, 10 * scale);
        
        // Pencil
        this.ctx.fillStyle = '#ffcc80';
        this.ctx.fillRect(x + 22 * scale, y + 6, 20 * scale, 3 * scale);
        this.ctx.fillStyle = '#ffb74d';
        this.ctx.fillRect(x + 22 * scale, y + 6, 4 * scale, 3 * scale);
    }

    drawDecorations(season) {
        // Clock
        this.utils.drawClock(this.w * 0.93, this.h * 0.12, 28);
        
        // Bulletin board
        this.drawBulletinBoard(this.w * 0.02, this.h * 0.56);
        
        // Potted plant
        this.utils.drawPlant(this.w * 0.31, this.h * 0.54, 0.9);
        
        // Seasonal decoration
        if (season === 'spring') {
            this.drawCherryBlossomDecor();
        }
    }

    drawBulletinBoard(x, y) {
        const width = this.w * 0.12;
        const height = this.h * 0.2;
        
        // Cork background
        const corkGradient = this.ctx.createLinearGradient(x, y, x + width, y + height);
        corkGradient.addColorStop(0, '#d7a86e');
        corkGradient.addColorStop(1, '#c49a6c');
        
        this.ctx.fillStyle = corkGradient;
        this.ctx.fillRect(x, y, width, height);
        
        // Frame
        this.ctx.strokeStyle = '#6d4c41';
        this.ctx.lineWidth = 5;
        this.ctx.strokeRect(x, y, width, height);
        
        // Papers with different colors
        const papers = [
            { dx: 8, dy: 10, w: 40, h: 50, color: '#fff8e1', rot: -0.05 },
            { dx: 55, dy: 15, w: 45, h: 55, color: '#ffebee', rot: 0.08 },
            { dx: 15, dy: 75, w: 55, h: 40, color: '#e8f5e9', rot: -0.03 },
            { dx: 75, dy: 80, w: 35, h: 45, color: '#e3f2fd', rot: 0.05 },
        ];
        
        papers.forEach(p => {
            this.ctx.save();
            this.ctx.translate(x + p.dx + p.w / 2, y + p.dy + p.h / 2);
            this.ctx.rotate(p.rot);
            
            this.ctx.fillStyle = p.color;
            this.ctx.fillRect(-p.w / 2, -p.h / 2, p.w, p.h);
            
            // Lines on paper
            this.ctx.fillStyle = 'rgba(0,0,0,0.1)';
            for (let i = 1; i < 4; i++) {
                this.ctx.fillRect(-p.w / 2 + 5, -p.h / 2 + i * 10 + 5, p.w - 10, 1);
            }
            
            this.ctx.restore();
            
            // Pushpin
            this.ctx.fillStyle = ['#f44336', '#2196f3', '#4caf50', '#ff9800'][papers.indexOf(p)];
            this.ctx.beginPath();
            this.ctx.arc(x + p.dx + p.w / 2, y + p.dy + 6, 5, 0, Math.PI * 2);
            this.ctx.fill();
        });
    }

    drawCherryBlossomDecor() {
        // Small branch decoration at top corner
        this.ctx.strokeStyle = '#8d6e63';
        this.ctx.lineWidth = 3;
        this.ctx.beginPath();
        this.ctx.moveTo(0, this.h * 0.02);
        this.ctx.quadraticCurveTo(this.w * 0.08, this.h * 0.04, this.w * 0.15, this.h * 0.02);
        this.ctx.stroke();
        
        // Blossoms
        const blossomPositions = [
            { x: this.w * 0.03, y: this.h * 0.025 },
            { x: this.w * 0.07, y: this.h * 0.035 },
            { x: this.w * 0.11, y: this.h * 0.025 },
        ];
        
        blossomPositions.forEach(pos => {
            // Petals
            this.ctx.fillStyle = '#ffb7c5';
            for (let i = 0; i < 5; i++) {
                const angle = ((i * 72) - 90) * Math.PI / 180;
                this.ctx.beginPath();
                this.ctx.ellipse(
                    pos.x + Math.cos(angle) * 8,
                    pos.y + Math.sin(angle) * 8,
                    6, 4, angle, 0, Math.PI * 2
                );
                this.ctx.fill();
            }
            // Center
            this.ctx.fillStyle = '#fff59d';
            this.ctx.beginPath();
            this.ctx.arc(pos.x, pos.y, 3, 0, Math.PI * 2);
            this.ctx.fill();
        });
    }
}
