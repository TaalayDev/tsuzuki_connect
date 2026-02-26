/**
 * TSUZUKI CONNECT - Background Renderer (Modular)
 * Style: Honey and Clover - soft watercolor aesthetic
 * Main orchestrator that delegates to specialized background renderers
 */

// Import modular background renderers
import { BackgroundUtils, setImageLoadCallback } from './backgrounds/BackgroundUtils.js';
import { ClassroomBackground } from './backgrounds/ClassroomBackground.js';
import { HallwayBackground } from './backgrounds/HallwayBackground.js';
import { StreetBackground } from './backgrounds/StreetBackground.js';
import { CafeBackground } from './backgrounds/CafeBackground.js';
import { IzakayaBackground } from './backgrounds/IzakayaBackground.js';
import { StationBackground } from './backgrounds/StationBackground.js';
import { ParkBackground } from './backgrounds/ParkBackground.js';
import { ApartmentBackground } from './backgrounds/ApartmentBackground.js';
import { TrainBackground } from './backgrounds/TrainBackground.js';
import { GenericBackground } from './backgrounds/GenericBackground.js';
import { BackgroundAssets } from './backgrounds/BackgroundAssets.js';

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
        
        // Offscreen canvas for caching
        this.offscreenCanvas = document.createElement('canvas');
        this.offscreenCanvas.width = this.canvas.width;
        this.offscreenCanvas.height = this.canvas.height;
        this.offscreenCtx = this.offscreenCanvas.getContext('2d');
        
        // Cache management
        this.cachedBackground = null;
        this.cachedTimeOfDay = null;
        this.cachedSeason = null;
        
        // Initialize utility helper
        this.utils = new BackgroundUtils(this.ctx);
        
        // Set up callback for when images load to trigger re-render
        setImageLoadCallback(() => {
            this.invalidateCache();
            this.render();
        });
        
        // Initialize all background renderers
        this.initializeRenderers();
    }
    
    /**
     * Initialize all background renderer modules
     */
    initializeRenderers() {
        const w = this.canvas.width;
        const h = this.canvas.height;
        
        this.renderers = {
            classroom: new ClassroomBackground(this.ctx, w, h),
            hallway: new HallwayBackground(this.ctx, w, h),
            street: new StreetBackground(this.ctx, w, h),
            cafe: new CafeBackground(this.ctx, w, h),
            izakaya: new IzakayaBackground(this.ctx, w, h),
            station: new StationBackground(this.ctx, w, h),
            park: new ParkBackground(this.ctx, w, h),
            apartment: new ApartmentBackground(this.ctx, w, h),
            train: new TrainBackground(this.ctx, w, h),
            bathroom: new GenericBackground(this.ctx, w, h, 'bathroom'),
            bedroom: new GenericBackground(this.ctx, w, h, 'bedroom'),
            laundromat: new GenericBackground(this.ctx, w, h, 'laundromat'),
            livingroom: new GenericBackground(this.ctx, w, h, 'livingroom')
        };
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
            this.invalidateCache();
            this.render();
        } else {
            this.transitioning = true;
            this.transitionTo(backgroundId, transition);
        }
    }
    
    /**
     * Set time of day
     */
    setTimeOfDay(time) {
        if (this.timeOfDay !== time) {
            this.timeOfDay = time;
            this.invalidateCache();
        }
    }
    
    /**
     * Set season
     */
    setSeason(season) {
        if (this.season !== season) {
            this.season = season;
            this.invalidateCache();
        }
    }
    
    /**
     * Invalidate the background cache
     */
    invalidateCache() {
        this.cachedBackground = null;
    }
    
    /**
     * Check if cache is valid
     */
    isCacheValid() {
        return this.cachedBackground === this.currentBackground &&
               this.cachedTimeOfDay === this.timeOfDay &&
               this.cachedSeason === this.season;
    }
    
    /**
     * Transition to new background
     */
    transitionTo(newBackground, type) {
        const oldBg = this.currentBackground;
        const duration = 600;
        const startTime = Date.now();
        
        const animate = () => {
            const elapsed = Date.now() - startTime;
            const progress = Math.min(1, elapsed / duration);
            
            // Easing function for smoother transitions
            const eased = this.easeInOutCubic(progress);
            
            // Render old background
            this.currentBackground = oldBg;
            this.invalidateCache();
            this.render();
            
            // Apply transition effect
            if (type === 'fade') {
                this.ctx.fillStyle = `rgba(0, 0, 0, ${eased})`;
                this.ctx.fillRect(0, 0, this.canvas.width, this.canvas.height);
            } else if (type === 'dissolve') {
                this.applyDissolveTransition(eased);
            } else if (type === 'wipe') {
                this.applyWipeTransition(eased, newBackground);
            }
            
            if (progress < 1) {
                requestAnimationFrame(animate);
            } else {
                // Show new background
                this.currentBackground = newBackground;
                this.transitioning = false;
                this.invalidateCache();
                this.render();
            }
        };
        
        animate();
    }
    
    /**
     * Easing function for smooth transitions
     */
    easeInOutCubic(t) {
        return t < 0.5 
            ? 4 * t * t * t 
            : 1 - Math.pow(-2 * t + 2, 3) / 2;
    }
    
    /**
     * Apply dissolve transition effect
     */
    applyDissolveTransition(progress) {
        // Watercolor-style dissolve using noise pattern
        this.ctx.save();
        this.ctx.globalAlpha = progress;
        
        // Create soft edge dissolve
        for (let i = 0; i < 50; i++) {
            const x = Math.random() * this.canvas.width;
            const y = Math.random() * this.canvas.height;
            const radius = Math.random() * 100 + 50;
            
            const gradient = this.ctx.createRadialGradient(x, y, 0, x, y, radius);
            gradient.addColorStop(0, 'rgba(0, 0, 0, 0.8)');
            gradient.addColorStop(1, 'rgba(0, 0, 0, 0)');
            
            this.ctx.fillStyle = gradient;
            this.ctx.beginPath();
            this.ctx.arc(x, y, radius, 0, Math.PI * 2);
            this.ctx.fill();
        }
        
        this.ctx.restore();
    }
    
    /**
     * Apply wipe transition effect
     */
    applyWipeTransition(progress, newBackground) {
        const wipeX = this.canvas.width * progress;
        
        // Save current state
        this.ctx.save();
        
        // Draw new background on the revealed portion
        this.ctx.beginPath();
        this.ctx.rect(0, 0, wipeX, this.canvas.height);
        this.ctx.clip();
        
        this.currentBackground = newBackground;
        this.renderBackground();
        
        this.ctx.restore();
        
        // Soft edge on wipe line
        const edgeGradient = this.ctx.createLinearGradient(wipeX - 30, 0, wipeX + 10, 0);
        edgeGradient.addColorStop(0, 'rgba(255, 255, 255, 0)');
        edgeGradient.addColorStop(0.5, 'rgba(255, 255, 255, 0.3)');
        edgeGradient.addColorStop(1, 'rgba(255, 255, 255, 0)');
        
        this.ctx.fillStyle = edgeGradient;
        this.ctx.fillRect(wipeX - 30, 0, 40, this.canvas.height);
    }
    
    /**
     * Main render function
     */
    render() {
        if (this.isCacheValid()) {
            // Use cached background
            this.ctx.drawImage(this.offscreenCanvas, 0, 0);
        } else {
            // Render fresh background
            this.renderBackground();
            
            // Cache it
            this.offscreenCtx.clearRect(0, 0, this.offscreenCanvas.width, this.offscreenCanvas.height);
            this.offscreenCtx.drawImage(this.canvas, 0, 0);
            this.cachedBackground = this.currentBackground;
            this.cachedTimeOfDay = this.timeOfDay;
            this.cachedSeason = this.season;
        }
        
        // Apply time of day overlay (always fresh)
        this.applyTimeOverlay();
    }
    
    /**
     * Render background using modular renderers
     */
    renderBackground() {
        if (!this.currentBackground) {
            this.drawDefaultBackground();
            return;
        }
        
        const renderer = this.renderers[this.currentBackground];
        
        if (renderer) {
            renderer.draw(this.timeOfDay, this.season);
        } else {
            // If the background exists in BackgroundAssets.PATHS, render it with a generic image background.
            if (BackgroundAssets?.PATHS?.[this.currentBackground]) {
                const generic = new GenericBackground(
                    this.ctx,
                    this.canvas.width,
                    this.canvas.height,
                    this.currentBackground
                );
                // Cache instance for subsequent renders
                this.renderers[this.currentBackground] = generic;
                generic.draw(this.timeOfDay, this.season);
                return;
            }

            // Fallback for unknown backgrounds
            this.drawDefaultBackground();
        }
    }
    
    /**
     * Draw default/placeholder background
     */
    drawDefaultBackground() {
        const w = this.canvas.width;
        const h = this.canvas.height;
        
        // Soft gradient background
        const gradient = this.utils.createWatercolorGradient(0, 0, 0, h, [
            '#f8f4e8',
            '#f5ece0',
            '#f0e6d8',
            '#ebe0d0'
        ]);
        
        this.ctx.fillStyle = gradient;
        this.ctx.fillRect(0, 0, w, h);
        
        // Add subtle texture
        this.utils.drawWatercolorTexture(w, h, 0.05);
        
        // Placeholder text
        this.ctx.save();
        this.ctx.fillStyle = 'rgba(139, 119, 101, 0.3)';
        this.ctx.font = 'italic 24px "Georgia", serif';
        this.ctx.textAlign = 'center';
        this.ctx.fillText('— Scene —', w / 2, h / 2);
        this.ctx.restore();
    }
    
    /**
     * Apply time of day lighting overlay
     */
    applyTimeOverlay() {
        const w = this.canvas.width;
        const h = this.canvas.height;
        
        this.ctx.save();
        
        switch (this.timeOfDay) {
            case 'morning':
                // Warm golden morning light
                const morningGradient = this.ctx.createLinearGradient(w, 0, 0, h);
                morningGradient.addColorStop(0, 'rgba(255, 236, 179, 0.15)');
                morningGradient.addColorStop(0.5, 'rgba(255, 224, 130, 0.08)');
                morningGradient.addColorStop(1, 'rgba(255, 213, 79, 0.05)');
                this.ctx.fillStyle = morningGradient;
                this.ctx.fillRect(0, 0, w, h);
                break;
                
            case 'evening':
                // Orange/pink sunset tones
                const eveningGradient = this.ctx.createLinearGradient(0, 0, w, h);
                eveningGradient.addColorStop(0, 'rgba(255, 138, 101, 0.18)');
                eveningGradient.addColorStop(0.5, 'rgba(255, 171, 145, 0.12)');
                eveningGradient.addColorStop(1, 'rgba(255, 204, 128, 0.08)');
                this.ctx.fillStyle = eveningGradient;
                this.ctx.fillRect(0, 0, w, h);
                break;
                
            case 'night':
                // Blue/purple night overlay
                const nightGradient = this.ctx.createRadialGradient(
                    w / 2, h / 2, 0,
                    w / 2, h / 2, Math.max(w, h) * 0.7
                );
                nightGradient.addColorStop(0, 'rgba(26, 35, 126, 0.2)');
                nightGradient.addColorStop(0.5, 'rgba(40, 53, 147, 0.25)');
                nightGradient.addColorStop(1, 'rgba(13, 27, 42, 0.35)');
                this.ctx.fillStyle = nightGradient;
                this.ctx.fillRect(0, 0, w, h);
                
                // Add vignette effect
                this.applyVignette(0.3);
                break;
                
            case 'afternoon':
            default:
                // Very subtle neutral overlay
                this.ctx.fillStyle = 'rgba(255, 253, 231, 0.03)';
                this.ctx.fillRect(0, 0, w, h);
                break;
        }
        
        this.ctx.restore();
    }
    
    /**
     * Apply vignette effect
     */
    applyVignette(intensity = 0.4) {
        const w = this.canvas.width;
        const h = this.canvas.height;
        const cx = w / 2;
        const cy = h / 2;
        const radius = Math.max(w, h) * 0.7;
        
        const vignette = this.ctx.createRadialGradient(cx, cy, radius * 0.3, cx, cy, radius);
        vignette.addColorStop(0, 'rgba(0, 0, 0, 0)');
        vignette.addColorStop(0.7, `rgba(0, 0, 0, ${intensity * 0.3})`);
        vignette.addColorStop(1, `rgba(0, 0, 0, ${intensity})`);
        
        this.ctx.fillStyle = vignette;
        this.ctx.fillRect(0, 0, w, h);
    }
    
    /**
     * Get available backgrounds
     */
    getAvailableBackgrounds() {
        return Object.keys(this.renderers);
    }
    
    /**
     * Check if a background exists
     */
    hasBackground(backgroundId) {
        return this.renderers.hasOwnProperty(backgroundId);
    }
}
