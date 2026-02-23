/**
 * TSUZUKI CONNECT - Effects Renderer
 * Handles particles, transitions, and visual effects
 * Implements Cherry Blossom theme mechanics
 * OPTIMIZED: Uses offscreen canvas caching and pre-rendering
 */

export class EffectsRenderer {
    constructor(canvas, game) {
        this.canvas = canvas;
        this.ctx = canvas.getContext('2d', { alpha: true }); // optimize
        this.game = game;

        // Set canvas size
        this.canvas.width = 1920;
        this.canvas.height = 1080;

        // Particles system
        this.particles = [];
        this.isRunning = false;

        // Menu particles canvas reference
        this.menuCanvas = null;
        this.menuCtx = null;

        // Theme Colors & Constants
        this.theme = {
            primary: { r: 255, g: 183, b: 197 }, // #FFB7C5
            accent: { r: 152, g: 216, b: 200 },  // #98D8C8
            skyTopBase: { r: 239, g: 247, b: 255 }, // #EFF7FF
            skyBottomBase: { r: 255, g: 241, b: 246 }, // #FFF1F6
            petalBase: { r: 255, g: 193, b: 217 }, // #FFC1D9 (approx lerp 0.6)
            petalDeepBase: { r: 238, g: 106, b: 158 }, // #EE6A9E (approx lerp 0.5)
        };

        // Pre-calculated colors
        this.colors = this.calculateThemeColors(this.theme);

        // Animation Loop Bind
        this.loop = this.animateMenuParticles.bind(this);

        // Initialize Cache
        this.initCache();
    }

    calculateThemeColors(theme) {
        // Helper to lerp colors
        const lerp = (c1, c2, t) => ({
            r: Math.round(c1.r + (c2.r - c1.r) * t),
            g: Math.round(c1.g + (c2.g - c1.g) * t),
            b: Math.round(c1.b + (c2.b - c1.b) * t)
        });

        // Derive palette
        const petal = lerp(theme.primary, { r: 255, g: 193, b: 217 }, 0.6);
        const petalDeep = lerp(theme.accent, { r: 238, g: 106, b: 158 }, 0.5);

        const skyTop = lerp(theme.skyTopBase, petal, 0.18);
        const skyBottom = lerp(theme.skyBottomBase, petal, 0.35);

        const toRgb = (c) => `rgb(${c.r}, ${c.g}, ${c.b})`;

        return {
            petal: toRgb(petal),
            petalRaw: petal,
            petalDeep: toRgb(petalDeep),
            petalDeepRaw: petalDeep,
            skyTop: toRgb(skyTop),
            skyBottom: toRgb(skyBottom),
            skyTopRaw: skyTop,
            skyBottomRaw: skyBottom
        };
    }

    initCache() {
        this.cache = {};

        // 1. Pre-render VIGNETTE
        const vCanvas = document.createElement('canvas');
        vCanvas.width = 1920;
        vCanvas.height = 1080;
        const vCtx = vCanvas.getContext('2d');
        const centerX = 960;
        const centerY = 1080 * 0.55;
        const radius = Math.max(1920, 1080) * 0.85;
        const grad = vCtx.createRadialGradient(centerX, centerY, 0, centerX, centerY, radius);
        grad.addColorStop(0.82, 'rgba(0,0,0,0)');
        grad.addColorStop(1.0, 'rgba(0,0,0,0.16)');
        vCtx.fillStyle = grad;
        vCtx.fillRect(0, 0, 1920, 1080);
        this.cache.vignette = vCanvas;

        // 2. Pre-render BOKEH (Blurred Circle)
        // We use a larger canvas to accommodate the blur spread
        const bCanvas = document.createElement('canvas');
        bCanvas.width = 128;
        bCanvas.height = 128;
        const bCtx = bCanvas.getContext('2d');
        bCtx.filter = 'blur(16px)';
        bCtx.fillStyle = '#FFFFFF';
        bCtx.beginPath();
        bCtx.arc(64, 64, 32, 0, Math.PI * 2); // Draw circle
        bCtx.fill();
        this.cache.bokeh = bCanvas;

        // 3. Pre-render PETALS
        // We create a few variations:
        // - Standard Pink
        // - Lighter Pink (Mixed with white)
        // - Blurred Pink (For background)
        this.cache.petals = {};

        const lerpColor = (c1, c2, t) => ({
            r: Math.round(c1.r + (c2.r - c1.r) * t),
            g: Math.round(c1.g + (c2.g - c1.g) * t),
            b: Math.round(c1.b + (c2.b - c1.b) * t)
        });

        // Base Color
        this.cache.petals.base = this.createCachedPetal(this.theme.petalBase, 0);

        // Light Mix (approx 50% white mix)
        const lightCol = lerpColor(this.theme.petalBase, { r: 255, g: 255, b: 255 }, 0.5);
        this.cache.petals.light = this.createCachedPetal(lightCol, 0);

        // Blurred (Background)
        this.cache.petals.blurred = this.createCachedPetal(this.theme.petalBase, 4);

        // 4. Pre-render SKY Gradient
        // Since it's a vertical gradient that doesn't change, we can cache it
        const sCanvas = document.createElement('canvas');
        sCanvas.width = 1; // 1px width stretched
        sCanvas.height = 1080;
        const sCtx = sCanvas.getContext('2d');
        const skyGrad = sCtx.createLinearGradient(0, 0, 0, 1080);
        skyGrad.addColorStop(0, this.colors.skyTop);
        skyGrad.addColorStop(1, this.colors.skyBottom);
        sCtx.fillStyle = skyGrad;
        sCtx.fillRect(0, 0, 1, 1080);
        this.cache.sky = sCanvas;
    }

    createCachedPetal(color, blur) {
        const size = 64; // High res container
        const c = document.createElement('canvas');
        c.width = size;
        c.height = size;
        const ctx = c.getContext('2d');

        // Center drawing
        const cx = size / 2;
        const cy = size / 2;

        // Shape Dimensions (Base)
        const w = 12; // Base width scalar
        const h = 16; // Base height scalar

        ctx.translate(cx, cy);

        if (blur > 0) {
            ctx.filter = `blur(${blur}px)`;
        }

        // Draw Logic (Same as before)
        const notch = 0.16;
        ctx.beginPath();
        ctx.moveTo(0, 0);
        ctx.bezierCurveTo(-w * 0.65, h * 0.15, -w * 0.75, h * 0.65, -w * 0.15, h * 0.90);
        ctx.quadraticCurveTo(-w * notch, h * 0.98, 0, h);
        ctx.quadraticCurveTo(w * notch, h * 0.98, w * 0.15, h * 0.90);
        ctx.bezierCurveTo(w * 0.75, h * 0.65, w * 0.65, h * 0.15, 0, 0);
        ctx.closePath();

        // Fill
        ctx.fillStyle = `rgb(${color.r},${color.g},${color.b})`;
        ctx.fill();

        // Stroke
        if (blur === 0) {
            const strokeCol = this.theme.petalDeepBase;
            ctx.strokeStyle = `rgba(${strokeCol.r}, ${strokeCol.g}, ${strokeCol.b}, 0.2)`;
            ctx.lineWidth = 1;
            ctx.stroke();

            // Highlight
            ctx.filter = 'blur(2px)';
            ctx.fillStyle = 'rgba(255, 255, 255, 0.2)';
            ctx.beginPath();
            ctx.ellipse(0, h * 0.25, w * 0.4, h * 0.225, 0, 0, Math.PI * 2);
            ctx.fill();
        }

        return c;
    }

    /**
     * Start menu cherry blossom particles
     */
    startMenuParticles(canvas) {
        this.menuCanvas = canvas;
        this.menuCanvas.width = 1920;
        this.menuCanvas.height = 1080;
        this.menuCtx = this.menuCanvas.getContext('2d', { alpha: false }); // Background is opaque

        this.isRunning = true;
        this.animationStartTime = performance.now();

        // Initialize layers

        this.menuParticles = {
            back: this.createLayer(24, 6, 10), // Increased count for larger res
            mid: this.createLayer(36, 8, 14),
            fore: this.createLayer(14, 12, 20),
            blossoms: this.createBlossoms(5),
        };

        // Start Loop
        requestAnimationFrame(this.loop);
    }

    createLayer(count, sizeMin, sizeMax) {
        const particles = [];
        for (let i = 0; i < count; i++) {
            particles.push({
                baseX: Math.random() * 1920,
                speed: 0.25 + Math.random() * 0.35,
                amp: 14.0 + Math.random() * 10.0,
                flipSpd: 0.9 + Math.random() * 1.4,
                rotSpd: 0.3 + Math.random() * 0.6,
                off: i * 0.113 + Math.random() * 2.0,
                sizeMin,
                sizeMax,
                // Per-particle randomness
                rndSize: Math.random(),
                rndW: Math.random(),
                rndH: Math.random(),
                rndCol: Math.random(),
            });
        }
        return particles;
    }

    createBlossoms(count) {
        const blossoms = [];
        for (let i = 0; i < count; i++) {
            blossoms.push({
                i,
                side: (i % 2 === 0) ? -1.0 : 1.0,
                rndR: Math.random(),
            });
        }
        return blossoms;
    }

    /**
     * Helpers
     */
    getPhase(t) { return 2 * Math.PI * t; }
    wave(t, speed, off = 0) { return Math.sin(this.getPhase(t) * speed + off); }
    smoothstep(a, b, x) {
        if (x < a) return 0;
        if (x > b) return 1;
        const t = (x - a) / (b - a);
        return t * t * (3 - 2 * t);
    }

    /**
     * Animate menu particles (FULL SCENE RENDER) - OPTIMIZED
     */
    animateMenuParticles() {
        if (!this.isRunning || !this.menuCtx) return;

        const now = performance.now();
        const duration = 15000; // 15 seconds loop
        const t = ((now - this.animationStartTime) % duration) / duration;

        const ctx = this.menuCtx;
        const width = 1920;
        const height = 1080;

        // 1. Paint Sky (drawImage instead of fillRect with gradient)
        ctx.drawImage(this.cache.sky, 0, 0, width, height);

        // 2. Paint Bokeh
        this.paintBokeh(ctx, width, height, t);

        // 3. Paint Blossoms (stationary)
        this.paintBlossoms(ctx, width, height, t);

        // 4. Paint Falling Petals
        this.paintFallingPetals(ctx, width, height, t);

        // 5. Paint Vignette
        ctx.drawImage(this.cache.vignette, 0, 0);

        requestAnimationFrame(this.loop);
    }

    paintBokeh(ctx, width, height, t) {
        // Draw cached bokeh circles
        const img = this.cache.bokeh;
        // The cached image is 128x128, circle at 64,64 radius 32.

        // Optim: Pre-calculate alpha
        ctx.globalAlpha = 0.05;

        for (let i = 0; i < 6; i++) {
            const cx = width * (0.1 + 0.16 * i);
            const cy = height * (0.18 + 0.08 * this.wave(t, 0.15, i));
            const targetRadius = 24 + 6.0 * i;
            // Scale: targetRadius / 32 (base radius)
            const scale = targetRadius / 32;
            const size = 128 * scale;

            ctx.drawImage(img, cx - size / 2, cy - size / 2, size, size);
        }
        ctx.globalAlpha = 1.0;
    }

    paintBlossoms(ctx, width, height, t) {
        const intensity = 1.0;
        const blossoms = this.menuParticles.blossoms;

        blossoms.forEach(b => {
            const x = b.side < 0
                ? width * (0.08 + 0.06 * b.i) + 8 * this.wave(t, 0.12, b.i)
                : width * (0.92 - 0.06 * b.i) + 8 * this.wave(t, 0.12, b.i);
            const y = height * (0.18 + 0.15 * (b.i / blossoms.length)) + 6 * this.wave(t, 0.18, b.i * 0.7);
            const r = (16.0 + b.rndR * 12.0) * (0.9 + 0.3 * intensity);
            const rot = this.wave(t, 0.06, b.i) * 0.4;

            this.drawBlossom(ctx, x, y, r, rot, 0.9);
        });
    }

    paintFallingPetals(ctx, width, height, t) {
        const intensity = 1.0;
        const wind = 16.0 * intensity * this.wave(t, 0.05);
        const fallMargin = 80.0;
        const travel = height + 2 * fallMargin;
        const phase = this.getPhase(t);

        // Optimization: Lift Math functions
        const sin = Math.sin;
        const PI = Math.PI;

        const drawLayer = (particles, alphaMul, isBlurred) => {
            // Select cached texture
            let texture;
            if (isBlurred) {
                texture = this.cache.petals.blurred;
            } else {
                texture = this.cache.petals.base;
                // We mix later
            }

            particles.forEach(p => {
                // Life progress
                const s = (t * p.speed + p.off) % 1.0;
                const y = -fallMargin + s * travel;

                // Horizontal path
                const x = p.baseX + wind + sin(phase * 0.7 + p.off) * 4.0 + sin(s * 2 * PI * 1.2 + p.off) * p.amp;

                // Fade
                let edgeFade = 1.0;
                if (y < 0) edgeFade = this.smoothstep(-fallMargin, 0.0, y);
                else if (y > height) edgeFade = 1.0 - this.smoothstep(height, height + fallMargin, y);

                const opacity = (0.65 * edgeFade) * alphaMul;
                if (opacity <= 0.01) return;

                // Scale factor from randomness
                const sz = p.sizeMin + p.rndSize * (p.sizeMax - p.sizeMin);
                // In cache, petal is drawn approx 20x24 inside 64x64.
                // We need to scale the drawing to match desired `sz`.
                // Base cache petal "visual" height is ~16 (h in createCachedPetal).
                const scale = sz / 16;

                // Aspect ratio variation
                const scaleX = scale * (0.9 + 0.2 * p.rndW);
                const scaleY = scale * (1.2 + 0.25 * p.rndH);

                const rotation = phase * p.rotSpd + p.off;
                const flip = 0.75 + 0.25 * sin(phase * p.flipSpd + p.off);

                // Texture Selection for diversity
                let currentTexture = texture;
                if (!isBlurred && p.rndCol > 0.5) {
                    currentTexture = this.cache.petals.light;
                }

                ctx.globalAlpha = opacity;

                ctx.setTransform(
                    Math.cos(rotation) * flip * scaleX,
                    Math.sin(rotation) * flip * scaleX,
                    -Math.sin(rotation) * scaleY,
                    Math.cos(rotation) * scaleY,
                    x, y
                );

                // Draw centered (cache is 64x64, center at 32,32)
                ctx.drawImage(currentTexture, -32, -32);
            });
        };

        // Reset Transform before returning? setTransform overwrites, so it's fine.
        // But need to reset for next layer if loop relies on it?
        // Actually best to use save/restore or setTransform(1,0,0,1,0,0) at end.

        ctx.save();
        drawLayer(this.menuParticles.back, 0.55, true);
        drawLayer(this.menuParticles.mid, 0.75, false);
        drawLayer(this.menuParticles.fore, 0.9, false);
        ctx.restore();
    }

    // --- Drawing Helpers ---

    drawBlossom(ctx, x, y, r, rot, opacity) {
        // For blossoms, we use the cached petals too, but arranged
        const texture = this.cache.petals.light; // Use lighter for blossom

        ctx.save();
        ctx.translate(x, y);
        ctx.rotate(rot);

        // 5 petals
        const scale = r / 16; // Approx

        for (let i = 0; i < 5; i++) {
            ctx.save();
            ctx.rotate(i * (2 * Math.PI / 5));
            // Shift out
            ctx.translate(0, r * 0.4);
            ctx.rotate(-Math.PI / 2);

            ctx.scale(scale * 0.85, scale * 1.2);

            // Draw cached
            ctx.globalAlpha = 0.92 * opacity;
            ctx.drawImage(texture, -32, -32);
            ctx.restore();
        }

        // Center core & Stamens - Draw manually (cheap)
        ctx.fillStyle = `rgba(255,255,255, ${0.85 * opacity})`;
        ctx.beginPath();
        ctx.arc(0, 0, r * 0.4, 0, Math.PI * 2);
        ctx.fill();

        ctx.fillStyle = `rgba(255, 226, 122, ${0.9 * opacity})`;
        for (let i = 0; i < 10; i++) {
            const a = i * (2 * Math.PI / 10);
            const rr = r * 0.6;
            ctx.beginPath();
            ctx.arc(Math.cos(a) * rr, Math.sin(a) * rr, r * 0.07, 0, Math.PI * 2);
            ctx.fill();
        }

        ctx.restore();
    }

    /**
     * Stop particles
     */
    stopParticles() {
        this.isRunning = false;
        if (this.menuCtx) {
            this.menuCtx.clearRect(0, 0, 1920, 1080);
        }
    }

    // --- Legacy / In-Game Effects Support ---

    startEffect(effectType, duration = null) {
        // Clear any existing effect timeout
        if (this.effectTimeout) {
            clearTimeout(this.effectTimeout);
            this.effectTimeout = null;
        }

        // Simplified mapping for existing game logic
        switch (effectType) {
            case 'cherry-blossoms': this.startCherryBlossoms(); break;
            case 'rain': this.startRain(); break;
            case 'snow': this.startSnow(); break;
            case 'sparkle': this.startSparkle(); break;
            case 'fade-in': this.fadeIn(duration || 1000); break;
            case 'fade-out': this.fadeOut(duration || 1000); break;
            case 'fade-in-white': this.fadeInWhite(duration || 900); break;
            case 'fade-out-white': this.fadeOutWhite(duration || 900); break;
            case 'shake': this.screenShake(5, duration || 500); break;
        }

        // Handle auto-stop if duration is provided (and it's not a fade/shake which handle duration internally)
        const ONE_SHOT_EFFECTS = ['fade-in', 'fade-out', 'fade-in-white', 'fade-out-white', 'shake'];
        if (duration && !ONE_SHOT_EFFECTS.includes(effectType)) {
            this.effectTimeout = setTimeout(() => {
                this.stopEffect();
            }, duration);
        }
    }

    stopEffect() {
        if (this.effectTimeout) {
            clearTimeout(this.effectTimeout);
            this.effectTimeout = null;
        }
        this.isRunning = false;
        this.particles = [];
        this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
    }

    startCherryBlossoms() {
        // In-game simple effect
        this.particles = [];
        for (let i = 0; i < 30; i++) { // Increased particle count
            this.particles.push({
                x: Math.random() * 1920,
                y: Math.random() * -100 - 50,
                size: Math.random() * 8 + 4,
                speedY: Math.random() * 1 + 0.5,
                speedX: Math.random() * 0.5 - 0.25,
                rotation: Math.random() * Math.PI * 2,
                rotationSpeed: (Math.random() - 0.5) * 0.05,
                wobble: Math.random() * Math.PI * 2,
                wobbleSpeed: Math.random() * 0.02 + 0.01,
                alpha: Math.random() * 0.5 + 0.5,
            });
        }
        this.isRunning = true;
        this.animateGameParticles('petal');
    }

    createPetal() {
        return {
            x: Math.random() * 1920,
            y: Math.random() * -100 - 50,
            size: Math.random() * 8 + 4,
            speedY: Math.random() * 1 + 0.5,
            speedX: Math.random() * 0.5 - 0.25,
            rotation: Math.random() * Math.PI * 2,
            rotationSpeed: (Math.random() - 0.5) * 0.05,
            wobble: Math.random() * Math.PI * 2,
            wobbleSpeed: Math.random() * 0.02 + 0.01,
            alpha: Math.random() * 0.5 + 0.5,
        };
    }

    animateGameParticles(type) {
        if (!this.isRunning) return;
        this.ctx.clearRect(0, 0, 1920, 1080);

        // For game particles, we use simple drawing or reused simple methods
        this.ctx.save();
        this.particles.forEach((p, index) => {
            switch (type) {
                case 'petal':
                    p.wobble += p.wobbleSpeed;
                    p.x += p.speedX + Math.sin(p.wobble) * 0.5;
                    p.y += p.speedY;
                    p.rotation += p.rotationSpeed;

                    if (p.y > 1110) this.particles[index] = this.createPetal();

                    // Use cached drawing for speed here too!
                    const scale = p.size / 16;
                    this.ctx.setTransform(scale, 0, 0, scale, p.x, p.y);
                    this.ctx.rotate(p.rotation);
                    this.ctx.globalAlpha = p.alpha;
                    this.ctx.drawImage(this.cache.petals.base, -32, -32);
                    break;

                // ... rain/snow/sparkle implementation (kept simple) ...
                case 'rain':
                    p.y += p.speed;
                    if (p.y > 1080) { p.y = -p.length; p.x = Math.random() * 1920; }
                    this.ctx.strokeStyle = `rgba(150, 200, 255, ${p.alpha})`;
                    this.ctx.lineWidth = 1;
                    this.ctx.beginPath();
                    this.ctx.moveTo(p.x, p.y);
                    this.ctx.lineTo(p.x - 2, p.y + p.length);
                    this.ctx.stroke();
                    break;
                case 'snow':
                    p.wobble += p.wobbleSpeed;
                    p.x += p.speedX + Math.sin(p.wobble) * 0.3;
                    p.y += p.speedY;
                    if (p.y > 1080) { p.y = -10; p.x = Math.random() * 1920; }
                    this.ctx.fillStyle = `rgba(255, 255, 255, ${p.alpha})`;
                    this.ctx.beginPath();
                    this.ctx.arc(p.x, p.y, p.size, 0, Math.PI * 2);
                    this.ctx.fill();
                    break;
            }
        });
        this.ctx.restore(); // Restore from transforms

        requestAnimationFrame(() => this.animateGameParticles(type));
    }

    startRain() {
        this.particles = [];
        for (let i = 0; i < 150; i++) this.particles.push({ x: Math.random() * 1920, y: Math.random() * 1080, length: 15, speed: 10, alpha: 0.5 });
        this.isRunning = true;
        this.animateGameParticles('rain');
    }
    startSnow() {
        this.particles = [];
        for (let i = 0; i < 80; i++) this.particles.push({ x: Math.random() * 1920, y: Math.random() * 1080, size: 3, speedX: 0, speedY: 2, wobble: 0, wobbleSpeed: 0.02, alpha: 0.8 });
        this.isRunning = true;
        this.animateGameParticles('snow');
    }
    startSparkle() {
        this.particles = [];
        for (let i = 0; i < 40; i++) {
            this.particles.push({
                x: Math.random() * 1920,
                y: Math.random() * 1080,
                size: Math.random() * 4 + 1,
                speedX: 0,
                speedY: 0,
                alpha: 0,
                phase: Math.random() * Math.PI * 2,
                speed: Math.random() * 0.1 + 0.05
            });
        }
        this.isRunning = true;

        const animateSparkle = () => {
            if (!this.isRunning) return;
            this.ctx.clearRect(0, 0, 1280, 720);

            this.ctx.save();
            this.particles.forEach(p => {
                p.phase += p.speed;
                p.alpha = (Math.sin(p.phase) + 1) / 2; // 0 to 1 oscillation

                this.ctx.fillStyle = `rgba(255, 255, 255, ${p.alpha})`;
                this.ctx.beginPath();
                this.ctx.arc(p.x, p.y, p.size, 0, Math.PI * 2);
                this.ctx.fill();

                // Cross shape for extra sparkle
                this.ctx.globalAlpha = p.alpha;
                this.ctx.fillRect(p.x - p.size * 2, p.y - 0.5, p.size * 4, 1);
                this.ctx.fillRect(p.x - 0.5, p.y - p.size * 2, 1, p.size * 4);
            });
            this.ctx.restore();

            requestAnimationFrame(animateSparkle);
        };

        animateSparkle();
    }

    /**
     * Transition with fade effect
     * @param {Function} callback Function to call when screen is fully obscured
     */
    fadeTransition(callback) {
        // Stop any active particle effects to prevent flickering
        this.isRunning = false;

        const duration = 500;
        let start = null;

        // Define color based on theme or default to black
        const fadeColor = '#000000';

        const animateFade = (timestamp) => {
            if (!start) start = timestamp;
            const progress = timestamp - start;

            // Phase 1: Fade In (0 to 1)
            if (progress < duration) {
                const alpha = progress / duration;

                // Clear and draw
                this.ctx.clearRect(0, 0, 1280, 720);
                this.ctx.globalAlpha = alpha;
                this.ctx.fillStyle = fadeColor;
                this.ctx.fillRect(0, 0, 1280, 720);
                this.ctx.globalAlpha = 1.0;

                requestAnimationFrame(animateFade);
            }
            // Phase 2: Execute Callback & Switch to Fade Out
            else if (progress >= duration && progress < duration + 50) {
                // Ensure full coverage
                this.ctx.globalAlpha = 1.0;
                this.ctx.fillStyle = fadeColor;
                this.ctx.fillRect(0, 0, 1280, 720);

                if (callback) {
                    callback();
                    callback = null; // Ensure only called once
                }
                requestAnimationFrame(animateFade);
            }
            // Phase 3: Fade Out (1 to 0)
            else if (progress < duration * 2 + 50) {
                const fadeOutProgress = progress - (duration + 50);
                const alpha = 1.0 - (fadeOutProgress / duration);

                this.ctx.clearRect(0, 0, 1280, 720);
                this.ctx.globalAlpha = alpha;
                this.ctx.fillStyle = fadeColor;
                this.ctx.fillRect(0, 0, 1280, 720);
                this.ctx.globalAlpha = 1.0;

                requestAnimationFrame(animateFade);
            }
            // Done
            else {
                this.ctx.clearRect(0, 0, 1280, 720);
            }
        };

        requestAnimationFrame(animateFade);
    }

    fadeIn(duration = 1000) {
        // Simple fade from black
        this.fadeOverlay('#000000', 'in', duration);
    }

    fadeOut(duration = 1000, callback) {
        // Simple fade to black
        this.fadeOverlay('#000000', 'out', duration, callback);
    }

    fadeInWhite(duration = 900) {
        this.fadeOverlay('#FFFFFF', 'in', duration);
    }

    fadeOutWhite(duration = 900, callback) {
        this.fadeOverlay('#FFFFFF', 'out', duration, callback);
    }

    fadeOverlay(color, direction = 'out', duration = 1000, callback) {
        let start = null;
        const width = this.canvas.width;
        const height = this.canvas.height;

        const animate = (timestamp) => {
            if (!start) start = timestamp;
            const p = (timestamp - start) / duration;
            if (p < 1) {
                this.ctx.clearRect(0, 0, width, height);
                this.ctx.globalAlpha = direction === 'in' ? 1 - p : p;
                this.ctx.fillStyle = color;
                this.ctx.fillRect(0, 0, width, height);
                this.ctx.globalAlpha = 1;
                requestAnimationFrame(animate);
            } else {
                if (direction === 'in') {
                    this.ctx.clearRect(0, 0, width, height);
                } else {
                    this.ctx.globalAlpha = 1;
                    this.ctx.fillStyle = color;
                    this.ctx.fillRect(0, 0, width, height);
                }
                if (callback) callback();
            }
        };
        requestAnimationFrame(animate);
    }

    screenShake(intensity = 5, duration = 500) {
        const gameContainer = document.querySelector('.game-container') || document.body;
        const start = Date.now();
        const originalTransform = gameContainer.style.transform;

        const shake = () => {
            const elapsed = Date.now() - start;
            if (elapsed < duration) {
                const dx = (Math.random() - 0.5) * intensity;
                const dy = (Math.random() - 0.5) * intensity;
                gameContainer.style.transform = `translate(${dx}px, ${dy}px)`;
                requestAnimationFrame(shake);
            } else {
                gameContainer.style.transform = originalTransform;
            }
        };
        shake();
    }

    clear() { this.ctx.clearRect(0, 0, 1280, 720); }
}
