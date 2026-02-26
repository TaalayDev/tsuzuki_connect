/**
 * TSUZUKI CONNECT - Background Renderer
 * Programmatically draws backgrounds as placeholders
 */

export class BackgroundRenderer {
    constructor(canvas, game) {
        this.canvas = canvas;
        this.ctx = canvas.getContext('2d');
        this.game = game;
        
        // Set canvas size
        this.canvas.width = 1920;
        this.canvas.height = 1080;
        
        // Current background
        this.currentBackground = null;
        this.transitioning = false;
        this.transitionAlpha = 1;
        
        // Time of day affects lighting
        this.timeOfDay = 'afternoon'; // morning, afternoon, evening, night
        
        // Season affects decorations
        this.season = 'spring'; // spring, summer, autumn, winter
    }
    
    /**
     * Set background with optional transition
     */
    setBackground(backgroundId, timeOfDay, transition = 'fade') {
        // Update time of day if provided
        if (timeOfDay) {
            this.timeOfDay = timeOfDay;
        }
        
        if (transition === 'none' || !this.currentBackground) {
            this.currentBackground = backgroundId;
            this.render();
        } else {
            this.transitioning = true;
            this.transitionTo(backgroundId, transition);
        }
    }
    
    /**
     * Transition to new background
     */
    transitionTo(newBackground, type) {
        const oldBg = this.currentBackground;
        const duration = 500;
        const startTime = Date.now();
        
        const animate = () => {
            const elapsed = Date.now() - startTime;
            const progress = Math.min(1, elapsed / duration);
            
            // Render old background
            this.currentBackground = oldBg;
            this.render();
            
            // Apply transition effect
            if (type === 'fade') {
                this.ctx.fillStyle = `rgba(0, 0, 0, ${progress})`;
                this.ctx.fillRect(0, 0, this.canvas.width, this.canvas.height);
            }
            
            if (progress < 1) {
                requestAnimationFrame(animate);
            } else {
                // Show new background
                this.currentBackground = newBackground;
                this.transitioning = false;
                this.render();
            }
        };
        
        animate();
    }
    
    /**
     * Main render function
     */
    render() {
        if (!this.currentBackground) {
            this.drawDefaultBackground();
            return;
        }
        
        switch (this.currentBackground) {
            case 'classroom':
                this.drawClassroom();
                break;
            case 'hallway':
                this.drawHallway();
                break;
            case 'cafe':
                this.drawCafe();
                break;
            case 'izakaya':
                this.drawIzakaya();
                break;
            case 'station':
                this.drawStation();
                break;
            case 'street':
                this.drawStreet();
                break;
            case 'apartment':
                this.drawApartment();
                break;
            case 'park':
                this.drawPark();
                break;
            case 'train':
                this.drawTrain();
                break;
            default:
                this.drawDefaultBackground();
        }
        
        // Apply time of day overlay
        this.applyTimeOverlay();
    }
    
    /**
     * Draw classroom background
     */
    drawClassroom() {
        const w = this.canvas.width;
        const h = this.canvas.height;
        
        // Back wall
        const gradient = this.ctx.createLinearGradient(0, 0, 0, h);
        gradient.addColorStop(0, '#f5f1e8');
        gradient.addColorStop(1, '#e8e0d0');
        this.ctx.fillStyle = gradient;
        this.ctx.fillRect(0, 0, w, h);
        
        // Floor
        this.ctx.fillStyle = '#c4a77d';
        this.ctx.fillRect(0, h * 0.65, w, h * 0.35);
        
        // Floor planks
        this.ctx.strokeStyle = '#a08060';
        this.ctx.lineWidth = 1;
        for (let i = 0; i < 10; i++) {
            const y = h * 0.65 + i * (h * 0.035);
            this.ctx.beginPath();
            this.ctx.moveTo(0, y);
            this.ctx.lineTo(w, y);
            this.ctx.stroke();
        }
        
        // Windows (left side)
        this.drawWindows(w * 0.02, h * 0.1, w * 0.25, h * 0.45);
        
        // Chalkboard
        this.drawChalkboard(w * 0.35, h * 0.08, w * 0.55, h * 0.35);
        
        // Teacher's desk
        this.drawDesk(w * 0.55, h * 0.5, w * 0.2, h * 0.12, '#6b4423');
        
        // Student desks in semi-circle
        this.drawStudentDesk(w * 0.15, h * 0.55, 0.9);
        this.drawStudentDesk(w * 0.35, h * 0.62, 0.95);
        this.drawStudentDesk(w * 0.7, h * 0.62, 0.95);
        this.drawStudentDesk(w * 0.85, h * 0.55, 0.9);
        
        // Clock on wall
        this.drawClock(w * 0.92, h * 0.12);
        
        // Bulletin board
        this.drawBulletinBoard(w * 0.02, h * 0.58, w * 0.12, h * 0.18);
        
        // Potted plant
        this.drawPlant(w * 0.28, h * 0.55);
        
        // Seasonal decorations
        if (this.season === 'spring') {
            this.drawCherryBlossomBranch(w * 0.05, h * 0.02);
        }
    }
    
    /**
     * Draw windows
     */
    drawWindows(x, y, width, height) {
        const windowCount = 3;
        const windowWidth = width / windowCount - 10;
        const frameColor = '#d4c4a8';
        
        for (let i = 0; i < windowCount; i++) {
            const wx = x + i * (windowWidth + 10);
            
            // Window frame
            this.ctx.fillStyle = frameColor;
            this.ctx.fillRect(wx, y, windowWidth, height);
            
            // Sky gradient
            const skyGradient = this.ctx.createLinearGradient(wx, y, wx, y + height);
            skyGradient.addColorStop(0, '#87ceeb');
            skyGradient.addColorStop(1, '#b0e0e6');
            this.ctx.fillStyle = skyGradient;
            this.ctx.fillRect(wx + 5, y + 5, windowWidth - 10, height - 10);
            
            // Trees outside
            this.ctx.fillStyle = '#228b22';
            this.ctx.beginPath();
            this.ctx.arc(wx + windowWidth * 0.3, y + height * 0.7, 25, 0, Math.PI * 2);
            this.ctx.arc(wx + windowWidth * 0.7, y + height * 0.8, 30, 0, Math.PI * 2);
            this.ctx.fill();
            
            // Cross dividers
            this.ctx.fillStyle = frameColor;
            this.ctx.fillRect(wx + windowWidth/2 - 3, y, 6, height);
            this.ctx.fillRect(wx, y + height/2 - 3, windowWidth, 6);
        }
        
        // Curtains
        this.ctx.fillStyle = 'rgba(255, 248, 220, 0.7)';
        this.ctx.fillRect(x - 10, y - 20, 25, height + 40);
        this.ctx.fillRect(x + width - 15, y - 20, 25, height + 40);
    }
    
    /**
     * Draw chalkboard
     */
    drawChalkboard(x, y, width, height) {
        // Frame
        this.ctx.fillStyle = '#654321';
        this.ctx.fillRect(x - 10, y - 10, width + 20, height + 20);
        
        // Board
        this.ctx.fillStyle = '#2d4739';
        this.ctx.fillRect(x, y, width, height);
        
        // Chalk tray
        this.ctx.fillStyle = '#654321';
        this.ctx.fillRect(x, y + height, width, 15);
        
        // Some chalk writing
        this.ctx.fillStyle = 'rgba(255, 255, 255, 0.8)';
        this.ctx.font = '28px "Noto Sans JP", sans-serif';
        this.ctx.fillText('ようこそ！', x + width * 0.35, y + 50);
        
        this.ctx.font = '20px "Noto Sans JP", sans-serif';
        this.ctx.fillText('Welcome to Japanese class', x + width * 0.25, y + 90);
        
        // Chalk pieces
        this.ctx.fillStyle = '#ffffff';
        this.ctx.fillRect(x + 20, y + height + 3, 30, 8);
        this.ctx.fillStyle = '#ffb6c1';
        this.ctx.fillRect(x + 60, y + height + 3, 25, 8);
        this.ctx.fillStyle = '#98fb98';
        this.ctx.fillRect(x + 95, y + height + 3, 28, 8);
    }
    
    /**
     * Draw teacher's desk
     */
    drawDesk(x, y, width, height, color) {
        // Desktop
        this.ctx.fillStyle = color;
        this.ctx.fillRect(x, y, width, height);
        
        // Desk front
        this.ctx.fillStyle = this.darkenColor(color, -20);
        this.ctx.fillRect(x, y + height, width, height * 1.5);
        
        // Items on desk
        // Coffee cup
        this.ctx.fillStyle = '#f5f5dc';
        this.ctx.beginPath();
        this.ctx.ellipse(x + 30, y - 5, 12, 8, 0, 0, Math.PI * 2);
        this.ctx.fill();
        this.ctx.fillStyle = '#8b4513';
        this.ctx.beginPath();
        this.ctx.ellipse(x + 30, y - 8, 10, 6, 0, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Books
        this.ctx.fillStyle = '#8b0000';
        this.ctx.fillRect(x + width - 60, y - 20, 50, 20);
        this.ctx.fillStyle = '#00008b';
        this.ctx.fillRect(x + width - 55, y - 35, 45, 15);
    }
    
    /**
     * Draw student desk
     */
    drawStudentDesk(x, y, scale = 1) {
        const width = 100 * scale;
        const height = 60 * scale;
        
        // Desk top
        this.ctx.fillStyle = '#deb887';
        this.ctx.fillRect(x - width/2, y, width, height * 0.3);
        
        // Desk front
        this.ctx.fillStyle = '#c4a77d';
        this.ctx.fillRect(x - width/2, y + height * 0.3, width, height * 0.7);
        
        // Chair
        this.ctx.fillStyle = '#8b4513';
        this.ctx.fillRect(x - width * 0.25, y + height * 0.5, width * 0.5, height * 0.15);
        
        // Notebook on desk
        this.ctx.fillStyle = '#f5f5f5';
        this.ctx.fillRect(x - 20, y + 5, 40, 12);
    }
    
    /**
     * Draw clock
     */
    drawClock(x, y) {
        // Clock face
        this.ctx.fillStyle = '#f5f5f5';
        this.ctx.beginPath();
        this.ctx.arc(x, y, 25, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Border
        this.ctx.strokeStyle = '#654321';
        this.ctx.lineWidth = 3;
        this.ctx.stroke();
        
        // Hour marks
        this.ctx.fillStyle = '#333';
        for (let i = 0; i < 12; i++) {
            const angle = (i * 30 - 90) * Math.PI / 180;
            const mx = x + Math.cos(angle) * 20;
            const my = y + Math.sin(angle) * 20;
            this.ctx.beginPath();
            this.ctx.arc(mx, my, 2, 0, Math.PI * 2);
            this.ctx.fill();
        }
        
        // Hands (showing ~2:30)
        this.ctx.strokeStyle = '#333';
        this.ctx.lineWidth = 2;
        this.ctx.beginPath();
        this.ctx.moveTo(x, y);
        this.ctx.lineTo(x + 12, y - 8); // Hour
        this.ctx.stroke();
        
        this.ctx.lineWidth = 1.5;
        this.ctx.beginPath();
        this.ctx.moveTo(x, y);
        this.ctx.lineTo(x, y + 15); // Minute
        this.ctx.stroke();
    }
    
    /**
     * Draw bulletin board
     */
    drawBulletinBoard(x, y, width, height) {
        // Cork background
        this.ctx.fillStyle = '#d2691e';
        this.ctx.fillRect(x, y, width, height);
        
        // Frame
        this.ctx.strokeStyle = '#654321';
        this.ctx.lineWidth = 4;
        this.ctx.strokeRect(x, y, width, height);
        
        // Papers
        const papers = [
            { x: x + 10, y: y + 10, w: 35, h: 45, color: '#fff8dc' },
            { x: x + 50, y: y + 15, w: 40, h: 50, color: '#ffe4e1' },
            { x: x + 20, y: y + 70, w: 50, h: 35, color: '#e0ffff' }
        ];
        
        papers.forEach(p => {
            this.ctx.fillStyle = p.color;
            this.ctx.fillRect(p.x, p.y, p.w, p.h);
            // Pin
            this.ctx.fillStyle = '#ff4444';
            this.ctx.beginPath();
            this.ctx.arc(p.x + p.w/2, p.y + 5, 4, 0, Math.PI * 2);
            this.ctx.fill();
        });
    }
    
    /**
     * Draw potted plant
     */
    drawPlant(x, y) {
        // Pot
        this.ctx.fillStyle = '#8b4513';
        this.ctx.beginPath();
        this.ctx.moveTo(x - 20, y + 10);
        this.ctx.lineTo(x + 20, y + 10);
        this.ctx.lineTo(x + 15, y + 40);
        this.ctx.lineTo(x - 15, y + 40);
        this.ctx.closePath();
        this.ctx.fill();
        
        // Soil
        this.ctx.fillStyle = '#3d2314';
        this.ctx.beginPath();
        this.ctx.ellipse(x, y + 12, 18, 8, 0, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Leaves
        this.ctx.fillStyle = '#228b22';
        for (let i = 0; i < 5; i++) {
            const angle = (i * 72 - 90) * Math.PI / 180;
            const lx = x + Math.cos(angle) * 5;
            const ly = y - 10 + Math.sin(angle) * 5;
            
            this.ctx.beginPath();
            this.ctx.ellipse(lx + Math.cos(angle) * 20, ly + Math.sin(angle) * 15 - 15, 15, 8, angle, 0, Math.PI * 2);
            this.ctx.fill();
        }
    }
    
    /**
     * Draw cherry blossom branch
     */
    drawCherryBlossomBranch(x, y) {
        // Branch
        this.ctx.strokeStyle = '#654321';
        this.ctx.lineWidth = 4;
        this.ctx.beginPath();
        this.ctx.moveTo(x, y);
        this.ctx.quadraticCurveTo(x + 100, y + 30, x + 180, y + 10);
        this.ctx.stroke();
        
        // Blossoms
        const blossoms = [
            { x: x + 40, y: y + 15 },
            { x: x + 80, y: y + 25 },
            { x: x + 120, y: y + 20 },
            { x: x + 160, y: y + 12 },
            { x: x + 60, y: y + 10 },
            { x: x + 140, y: y + 28 }
        ];
        
        blossoms.forEach(b => {
            // Petals
            this.ctx.fillStyle = '#ffb7c5';
            for (let i = 0; i < 5; i++) {
                const angle = (i * 72 - 90) * Math.PI / 180;
                this.ctx.beginPath();
                this.ctx.ellipse(
                    b.x + Math.cos(angle) * 8,
                    b.y + Math.sin(angle) * 8,
                    6, 4, angle, 0, Math.PI * 2
                );
                this.ctx.fill();
            }
            // Center
            this.ctx.fillStyle = '#ffeb3b';
            this.ctx.beginPath();
            this.ctx.arc(b.x, b.y, 3, 0, Math.PI * 2);
            this.ctx.fill();
        });
    }
    
    /**
     * Draw cafe background
     */
    drawCafe() {
        const w = this.canvas.width;
        const h = this.canvas.height;
        
        // Wall
        const gradient = this.ctx.createLinearGradient(0, 0, 0, h);
        gradient.addColorStop(0, '#d4a574');
        gradient.addColorStop(1, '#c49464');
        this.ctx.fillStyle = gradient;
        this.ctx.fillRect(0, 0, w, h);
        
        // Floor
        this.ctx.fillStyle = '#8b4513';
        this.ctx.fillRect(0, h * 0.7, w, h * 0.3);
        
        // Counter
        this.ctx.fillStyle = '#654321';
        this.ctx.fillRect(w * 0.6, h * 0.4, w * 0.4, h * 0.35);
        this.ctx.fillStyle = '#deb887';
        this.ctx.fillRect(w * 0.6, h * 0.38, w * 0.4, h * 0.05);
        
        // Menu board
        this.ctx.fillStyle = '#2d2d2d';
        this.ctx.fillRect(w * 0.65, h * 0.05, w * 0.3, h * 0.25);
        this.ctx.fillStyle = '#fff';
        this.ctx.font = '16px sans-serif';
        this.ctx.fillText('MENU', w * 0.77, h * 0.12);
        this.ctx.font = '12px sans-serif';
        this.ctx.fillText('Coffee ¥450', w * 0.68, h * 0.18);
        this.ctx.fillText('Latte ¥500', w * 0.68, h * 0.23);
        
        // Tables
        this.drawCafeTable(w * 0.15, h * 0.55);
        this.drawCafeTable(w * 0.4, h * 0.6);
        
        // Window
        this.ctx.fillStyle = '#87ceeb';
        this.ctx.fillRect(w * 0.02, h * 0.1, w * 0.25, h * 0.35);
        this.ctx.strokeStyle = '#654321';
        this.ctx.lineWidth = 8;
        this.ctx.strokeRect(w * 0.02, h * 0.1, w * 0.25, h * 0.35);
        
        // Plants
        this.drawPlant(w * 0.12, h * 0.48);
        this.drawPlant(w * 0.55, h * 0.65);
    }
    
    /**
     * Draw cafe table
     */
    drawCafeTable(x, y) {
        // Table top
        this.ctx.fillStyle = '#deb887';
        this.ctx.beginPath();
        this.ctx.ellipse(x, y, 50, 25, 0, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Table leg
        this.ctx.fillStyle = '#654321';
        this.ctx.fillRect(x - 8, y + 20, 16, 60);
        
        // Coffee cup
        this.ctx.fillStyle = '#fff';
        this.ctx.beginPath();
        this.ctx.ellipse(x + 10, y - 5, 10, 6, 0, 0, Math.PI * 2);
        this.ctx.fill();
    }
    
    /**
     * Draw izakaya background
     */
    drawIzakaya() {
        const w = this.canvas.width;
        const h = this.canvas.height;
        
        // Dark wood interior
        this.ctx.fillStyle = '#2d1f14';
        this.ctx.fillRect(0, 0, w, h);
        
        // Warm lighting overlay
        const lightGradient = this.ctx.createRadialGradient(w * 0.5, h * 0.3, 50, w * 0.5, h * 0.3, 400);
        lightGradient.addColorStop(0, 'rgba(255, 180, 100, 0.3)');
        lightGradient.addColorStop(1, 'rgba(0, 0, 0, 0)');
        this.ctx.fillStyle = lightGradient;
        this.ctx.fillRect(0, 0, w, h);
        
        // Counter
        this.ctx.fillStyle = '#8b4513';
        this.ctx.fillRect(0, h * 0.5, w, h * 0.12);
        
        // Bar stools
        for (let i = 0; i < 4; i++) {
            const sx = w * 0.2 + i * w * 0.2;
            this.ctx.fillStyle = '#654321';
            this.ctx.beginPath();
            this.ctx.ellipse(sx, h * 0.65, 25, 12, 0, 0, Math.PI * 2);
            this.ctx.fill();
            this.ctx.fillRect(sx - 5, h * 0.65, 10, 50);
        }
        
        // Lanterns
        this.drawLantern(w * 0.2, h * 0.15);
        this.drawLantern(w * 0.5, h * 0.12);
        this.drawLantern(w * 0.8, h * 0.15);
        
        // Bottles on shelf
        this.ctx.fillStyle = '#3d2314';
        this.ctx.fillRect(w * 0.1, h * 0.25, w * 0.8, h * 0.08);
        for (let i = 0; i < 8; i++) {
            this.ctx.fillStyle = ['#228b22', '#8b0000', '#d4a574', '#2f4f4f'][i % 4];
            this.ctx.fillRect(w * 0.12 + i * 70, h * 0.12, 20, 60);
        }
    }
    
    /**
     * Draw paper lantern
     */
    drawLantern(x, y) {
        // Lantern body
        const gradient = this.ctx.createRadialGradient(x, y + 25, 5, x, y + 25, 30);
        gradient.addColorStop(0, '#ffcc00');
        gradient.addColorStop(1, '#ff6600');
        this.ctx.fillStyle = gradient;
        this.ctx.beginPath();
        this.ctx.ellipse(x, y + 25, 25, 35, 0, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Top
        this.ctx.fillStyle = '#2d1f14';
        this.ctx.fillRect(x - 12, y - 5, 24, 10);
        
        // String
        this.ctx.strokeStyle = '#2d1f14';
        this.ctx.lineWidth = 2;
        this.ctx.beginPath();
        this.ctx.moveTo(x, y - 5);
        this.ctx.lineTo(x, y - 30);
        this.ctx.stroke();
        
        // Kanji
        this.ctx.fillStyle = '#8b0000';
        this.ctx.font = '20px "Noto Sans JP", sans-serif';
        this.ctx.textAlign = 'center';
        this.ctx.fillText('酒', x, y + 30);
    }
    
    /**
     * Draw train station background
     */
    drawStation() {
        const w = this.canvas.width;
        const h = this.canvas.height;
        
        // Platform
        this.ctx.fillStyle = '#808080';
        this.ctx.fillRect(0, h * 0.7, w, h * 0.3);
        
        // Yellow safety line
        this.ctx.fillStyle = '#ffd700';
        this.ctx.fillRect(0, h * 0.7, w, h * 0.02);
        
        // Sky/ceiling
        const skyGradient = this.ctx.createLinearGradient(0, 0, 0, h * 0.7);
        skyGradient.addColorStop(0, '#1e3a5f');
        skyGradient.addColorStop(1, '#4a6fa5');
        this.ctx.fillStyle = skyGradient;
        this.ctx.fillRect(0, 0, w, h * 0.7);
        
        // Pillars
        this.ctx.fillStyle = '#c0c0c0';
        this.ctx.fillRect(w * 0.1, h * 0.1, 30, h * 0.6);
        this.ctx.fillRect(w * 0.5, h * 0.1, 30, h * 0.6);
        this.ctx.fillRect(w * 0.9, h * 0.1, 30, h * 0.6);
        
        // Signs
        this.ctx.fillStyle = '#000080';
        this.ctx.fillRect(w * 0.3, h * 0.15, w * 0.4, h * 0.08);
        this.ctx.fillStyle = '#fff';
        this.ctx.font = '24px "Noto Sans JP", sans-serif';
        this.ctx.textAlign = 'center';
        this.ctx.fillText('渋谷 Shibuya', w * 0.5, h * 0.21);
        
        // Benches
        this.ctx.fillStyle = '#654321';
        this.ctx.fillRect(w * 0.15, h * 0.75, 80, 30);
        this.ctx.fillRect(w * 0.7, h * 0.75, 80, 30);
        
        // Vending machines
        this.ctx.fillStyle = '#ff0000';
        this.ctx.fillRect(w * 0.85, h * 0.45, 50, 100);
        this.ctx.fillStyle = '#000';
        this.ctx.fillRect(w * 0.86, h * 0.5, 48, 50);
    }
    
    /**
     * Draw street background
     */
    drawStreet() {
        const w = this.canvas.width;
        const h = this.canvas.height;
        
        // Sky
        const skyGradient = this.ctx.createLinearGradient(0, 0, 0, h * 0.5);
        skyGradient.addColorStop(0, '#87ceeb');
        skyGradient.addColorStop(1, '#e0f6ff');
        this.ctx.fillStyle = skyGradient;
        this.ctx.fillRect(0, 0, w, h * 0.5);
        
        // Buildings background
        this.ctx.fillStyle = '#a0a0a0';
        this.ctx.fillRect(0, h * 0.2, w, h * 0.3);
        
        // Street
        this.ctx.fillStyle = '#404040';
        this.ctx.fillRect(0, h * 0.5, w, h * 0.5);
        
        // Sidewalk
        this.ctx.fillStyle = '#c0c0c0';
        this.ctx.fillRect(0, h * 0.5, w, h * 0.15);
        
        // Buildings with signs
        this.drawBuilding(w * 0.05, h * 0.1, 120, h * 0.4, '#ddd', '本屋');
        this.drawBuilding(w * 0.2, h * 0.15, 100, h * 0.35, '#ffdab9', 'カフェ');
        this.drawBuilding(w * 0.4, h * 0.05, 150, h * 0.45, '#e0e0e0', 'コンビニ');
        this.drawBuilding(w * 0.65, h * 0.12, 130, h * 0.38, '#f5f5dc', '薬局');
        
        // Crosswalk
        for (let i = 0; i < 8; i++) {
            this.ctx.fillStyle = '#fff';
            this.ctx.fillRect(w * 0.35 + i * 40, h * 0.75, 30, 80);
        }
        
        // Traffic light
        this.ctx.fillStyle = '#333';
        this.ctx.fillRect(w * 0.85, h * 0.3, 15, 150);
        this.ctx.fillRect(w * 0.8, h * 0.3, 50, 60);
        this.ctx.fillStyle = '#00ff00';
        this.ctx.beginPath();
        this.ctx.arc(w * 0.805 + 25, h * 0.36, 12, 0, Math.PI * 2);
        this.ctx.fill();
    }
    
    /**
     * Draw a building
     */
    drawBuilding(x, y, width, height, color, sign) {
        this.ctx.fillStyle = color;
        this.ctx.fillRect(x, y, width, height);
        
        // Windows
        this.ctx.fillStyle = '#87ceeb';
        const rows = Math.floor(height / 50);
        const cols = Math.floor(width / 40);
        for (let r = 0; r < rows; r++) {
            for (let c = 0; c < cols; c++) {
                this.ctx.fillRect(x + 15 + c * 35, y + 15 + r * 45, 25, 30);
            }
        }
        
        // Sign
        if (sign) {
            this.ctx.fillStyle = '#ff6b6b';
            this.ctx.fillRect(x + 10, y + height - 40, width - 20, 30);
            this.ctx.fillStyle = '#fff';
            this.ctx.font = '16px "Noto Sans JP", sans-serif';
            this.ctx.textAlign = 'center';
            this.ctx.fillText(sign, x + width/2, y + height - 18);
        }
    }
    
    /**
     * Draw apartment interior
     */
    drawApartment() {
        const w = this.canvas.width;
        const h = this.canvas.height;
        
        // Wall
        this.ctx.fillStyle = '#f5f5f5';
        this.ctx.fillRect(0, 0, w, h);
        
        // Floor (tatami pattern)
        this.ctx.fillStyle = '#c4b896';
        this.ctx.fillRect(0, h * 0.65, w, h * 0.35);
        this.ctx.strokeStyle = '#a08060';
        this.ctx.lineWidth = 2;
        for (let i = 0; i < 4; i++) {
            this.ctx.strokeRect(i * w/4 + 5, h * 0.65 + 5, w/4 - 10, h * 0.35 - 10);
        }
        
        // Window
        this.ctx.fillStyle = '#87ceeb';
        this.ctx.fillRect(w * 0.6, h * 0.1, w * 0.35, h * 0.4);
        this.ctx.strokeStyle = '#fff';
        this.ctx.lineWidth = 6;
        this.ctx.strokeRect(w * 0.6, h * 0.1, w * 0.35, h * 0.4);
        
        // Low table (kotatsu)
        this.ctx.fillStyle = '#8b4513';
        this.ctx.fillRect(w * 0.3, h * 0.55, w * 0.35, h * 0.15);
        // Blanket
        this.ctx.fillStyle = '#ff6b6b';
        this.ctx.fillRect(w * 0.25, h * 0.58, w * 0.45, h * 0.12);
        
        // Cushions
        this.ctx.fillStyle = '#4169e1';
        this.ctx.beginPath();
        this.ctx.ellipse(w * 0.35, h * 0.75, 30, 15, 0, 0, Math.PI * 2);
        this.ctx.fill();
        this.ctx.beginPath();
        this.ctx.ellipse(w * 0.6, h * 0.75, 30, 15, 0, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Bookshelf
        this.ctx.fillStyle = '#deb887';
        this.ctx.fillRect(w * 0.02, h * 0.2, w * 0.15, h * 0.45);
        // Books
        for (let i = 0; i < 4; i++) {
            for (let j = 0; j < 5; j++) {
                this.ctx.fillStyle = ['#8b0000', '#00008b', '#006400', '#4b0082', '#ff8c00'][j];
                this.ctx.fillRect(w * 0.03 + j * 20, h * 0.22 + i * 55, 15, 45);
            }
        }
    }
    
    /**
     * Draw park background
     */
    drawPark() {
        const w = this.canvas.width;
        const h = this.canvas.height;
        
        // Sky
        const skyGradient = this.ctx.createLinearGradient(0, 0, 0, h * 0.6);
        skyGradient.addColorStop(0, '#87ceeb');
        skyGradient.addColorStop(1, '#b0e0e6');
        this.ctx.fillStyle = skyGradient;
        this.ctx.fillRect(0, 0, w, h * 0.6);
        
        // Grass
        this.ctx.fillStyle = '#228b22';
        this.ctx.fillRect(0, h * 0.5, w, h * 0.5);
        
        // Path
        this.ctx.fillStyle = '#c4a77d';
        this.ctx.beginPath();
        this.ctx.moveTo(w * 0.3, h);
        this.ctx.quadraticCurveTo(w * 0.5, h * 0.6, w * 0.8, h * 0.5);
        this.ctx.lineTo(w * 0.85, h * 0.5);
        this.ctx.quadraticCurveTo(w * 0.55, h * 0.65, w * 0.4, h);
        this.ctx.closePath();
        this.ctx.fill();
        
        // Trees
        this.drawTree(w * 0.15, h * 0.35, 80);
        this.drawTree(w * 0.85, h * 0.4, 70);
        this.drawTree(w * 0.6, h * 0.3, 90);
        
        // Bench
        this.ctx.fillStyle = '#8b4513';
        this.ctx.fillRect(w * 0.4, h * 0.6, 100, 15);
        this.ctx.fillRect(w * 0.42, h * 0.62, 10, 25);
        this.ctx.fillRect(w * 0.48 + 40, h * 0.62, 10, 25);
        
        // Lamp post
        this.ctx.fillStyle = '#333';
        this.ctx.fillRect(w * 0.25, h * 0.35, 8, 150);
        this.ctx.fillStyle = '#ffd700';
        this.ctx.beginPath();
        this.ctx.arc(w * 0.254, h * 0.35, 15, 0, Math.PI, true);
        this.ctx.fill();
    }
    
    /**
     * Draw a tree
     */
    drawTree(x, y, size) {
        // Trunk
        this.ctx.fillStyle = '#654321';
        this.ctx.fillRect(x - size * 0.1, y, size * 0.2, size * 0.8);
        
        // Foliage
        this.ctx.fillStyle = '#228b22';
        this.ctx.beginPath();
        this.ctx.arc(x, y - size * 0.2, size * 0.5, 0, Math.PI * 2);
        this.ctx.fill();
        this.ctx.beginPath();
        this.ctx.arc(x - size * 0.3, y, size * 0.4, 0, Math.PI * 2);
        this.ctx.fill();
        this.ctx.beginPath();
        this.ctx.arc(x + size * 0.3, y, size * 0.4, 0, Math.PI * 2);
        this.ctx.fill();
    }
    
    /**
     * Draw train interior
     */
    drawTrain() {
        const w = this.canvas.width;
        const h = this.canvas.height;
        
        // Interior
        this.ctx.fillStyle = '#e8e0d0';
        this.ctx.fillRect(0, 0, w, h);
        
        // Floor
        this.ctx.fillStyle = '#a0a0a0';
        this.ctx.fillRect(0, h * 0.75, w, h * 0.25);
        
        // Windows
        for (let i = 0; i < 4; i++) {
            this.ctx.fillStyle = '#87ceeb';
            this.ctx.fillRect(w * 0.1 + i * w * 0.22, h * 0.15, w * 0.18, h * 0.35);
            // Frame
            this.ctx.strokeStyle = '#c0c0c0';
            this.ctx.lineWidth = 8;
            this.ctx.strokeRect(w * 0.1 + i * w * 0.22, h * 0.15, w * 0.18, h * 0.35);
        }
        
        // Seats
        this.ctx.fillStyle = '#4169e1';
        this.ctx.fillRect(0, h * 0.55, w * 0.15, h * 0.2);
        this.ctx.fillRect(w * 0.85, h * 0.55, w * 0.15, h * 0.2);
        
        // Handrails
        this.ctx.strokeStyle = '#c0c0c0';
        this.ctx.lineWidth = 6;
        this.ctx.beginPath();
        this.ctx.moveTo(w * 0.2, h * 0.08);
        this.ctx.lineTo(w * 0.8, h * 0.08);
        this.ctx.stroke();
        
        // Hanging straps
        for (let i = 0; i < 6; i++) {
            this.ctx.strokeStyle = '#333';
            this.ctx.lineWidth = 2;
            this.ctx.beginPath();
            this.ctx.moveTo(w * 0.25 + i * 80, h * 0.08);
            this.ctx.lineTo(w * 0.25 + i * 80, h * 0.2);
            this.ctx.stroke();
            // Handle
            this.ctx.fillStyle = '#ff6347';
            this.ctx.beginPath();
            this.ctx.ellipse(w * 0.25 + i * 80, h * 0.22, 12, 18, 0, 0, Math.PI * 2);
            this.ctx.fill();
        }
        
        // Door
        this.ctx.fillStyle = '#c0c0c0';
        this.ctx.fillRect(w * 0.45, h * 0.1, w * 0.1, h * 0.65);
        this.ctx.fillStyle = '#87ceeb';
        this.ctx.fillRect(w * 0.46, h * 0.15, w * 0.08, h * 0.4);
    }
    
    /**
     * Draw default background
     */
    drawDefaultBackground() {
        const w = this.canvas.width;
        const h = this.canvas.height;
        
        // Simple gradient
        const gradient = this.ctx.createLinearGradient(0, 0, 0, h);
        gradient.addColorStop(0, '#f5f1e8');
        gradient.addColorStop(1, '#e8e0d0');
        this.ctx.fillStyle = gradient;
        this.ctx.fillRect(0, 0, w, h);
    }
    
    /**
     * Apply time of day lighting overlay
     */
    applyTimeOverlay() {
        const w = this.canvas.width;
        const h = this.canvas.height;
        
        let overlay = null;
        
        switch (this.timeOfDay) {
            case 'morning':
                overlay = 'rgba(255, 200, 150, 0.1)';
                break;
            case 'evening':
                overlay = 'rgba(255, 150, 100, 0.2)';
                break;
            case 'night':
                overlay = 'rgba(30, 30, 60, 0.4)';
                break;
            default: // afternoon
                overlay = null;
        }
        
        if (overlay) {
            this.ctx.fillStyle = overlay;
            this.ctx.fillRect(0, 0, w, h);
        }
    }
    
    /**
     * Set time of day
     */
    setTimeOfDay(time) {
        this.timeOfDay = time;
        this.render();
    }
    
    /**
     * Set season
     */
    setSeason(season) {
        this.season = season;
        this.render();
    }
    
    /**
     * Utility: Darken color
     */
    darkenColor(hex, amount) {
        const num = parseInt(hex.slice(1), 16);
        const r = Math.max(0, Math.min(255, (num >> 16) + amount));
        const g = Math.max(0, Math.min(255, ((num >> 8) & 0x00FF) + amount));
        const b = Math.max(0, Math.min(255, (num & 0x0000FF) + amount));
        return `#${(1 << 24 | r << 16 | g << 8 | b).toString(16).slice(1)}`;
    }
}
