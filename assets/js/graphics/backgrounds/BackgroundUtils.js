/**
 * TSUZUKI CONNECT - Background Utilities
 * Shared drawing utilities for all backgrounds
 * Style: Honey and Clover - soft watercolor aesthetic
 */

// Global image cache shared across all BackgroundUtils instances
const globalImageCache = new Map();
const globalImagePromises = new Map();

// Global callback for when images load (set by BackgroundRenderer)
let onImageLoadCallback = null;

export function setImageLoadCallback(callback) {
    onImageLoadCallback = callback;
}

/**
 * Preload a background image into the shared cache.
 * Resolves true on load, false on error.
 */
export function preloadBackgroundImage(path) {
    if (!path) return Promise.resolve(false);

    const cached = globalImageCache.get(path);
    if (cached && cached.complete && cached.naturalWidth !== 0) {
        return Promise.resolve(true);
    }

    const existingPromise = globalImagePromises.get(path);
    if (existingPromise) return existingPromise;

    let img = cached;
    if (!img) {
        img = new Image();
        img.src = path;
        img.onload = () => {
            // Trigger re-render when image is ready
            if (onImageLoadCallback) onImageLoadCallback();
        };
        img.onerror = () => {
            console.warn(`[BackgroundUtils] Failed to load image: ${path}`);
        };
        globalImageCache.set(path, img);
    }

    const promise = new Promise((resolve) => {
        const cleanup = () => {
            img.removeEventListener('load', onLoad);
            img.removeEventListener('error', onError);
            globalImagePromises.delete(path);
        };

        const onLoad = async () => {
            try {
                if (typeof img.decode === 'function') {
                    await img.decode();
                }
            } catch {
                // decode() can fail even if the image is usable; ignore
            } finally {
                cleanup();
                resolve(true);
            }
        };

        const onError = () => {
            cleanup();
            resolve(false);
        };

        img.addEventListener('load', onLoad, { once: true });
        img.addEventListener('error', onError, { once: true });

        // In case it finished between checks
        if (img.complete) {
            if (img.naturalWidth !== 0) onLoad();
            else onError();
        }
    });

    globalImagePromises.set(path, promise);
    return promise;
}

export class BackgroundUtils {
    constructor(ctx) {
        this.ctx = ctx;
    }

    /**
     * Draw an image background that fills the canvas
     * @param {string} path - Path to image
     * @param {number} w - Canvas width
     * @param {number} h - Canvas height
     * @returns {boolean} - True if image was drawn, false if still loading
     */
    drawImageBackground(path, w, h) {
        if (!path) return false;

        let img = globalImageCache.get(path);
        
        if (!img) {
            img = new Image();
            img.src = path;
            img.onload = () => {
                console.log(`[BackgroundUtils] Image loaded: ${path}`);
                // Trigger re-render when image is ready
                if (onImageLoadCallback) {
                    onImageLoadCallback();
                }
            };
            img.onerror = () => {
                console.warn(`[BackgroundUtils] Failed to load image: ${path}`);
            };
            globalImageCache.set(path, img);
        }

        if (img.complete && img.naturalWidth !== 0) {
            // Calculate scale to cover (similar to background-size: cover)
            const scale = Math.max(w / img.width, h / img.height);
            const newWidth = img.width * scale;
            const newHeight = img.height * scale;
            const x = (w - newWidth) / 2;
            const y = (h - newHeight) / 2;

            this.ctx.drawImage(img, x, y, newWidth, newHeight);
            return true;
        }

        return false; // Still loading or failed
    }

    /**
     * Create a soft watercolor gradient
     */
    createWatercolorGradient(x1, y1, x2, y2, colors) {
        const gradient = this.ctx.createLinearGradient(x1, y1, x2, y2);
        colors.forEach((color, i) => {
            gradient.addColorStop(i / (colors.length - 1), color);
        });
        return gradient;
    }

    /**
     * Draw soft watercolor texture overlay
     */
    drawWatercolorTexture(w, h, opacity = 0.05) {
        this.ctx.save();
        this.ctx.globalAlpha = opacity;
        
        // Create organic noise pattern
        for (let i = 0; i < 50; i++) {
            const x = Math.random() * w;
            const y = Math.random() * h;
            const radius = Math.random() * 100 + 50;
            
            const gradient = this.ctx.createRadialGradient(x, y, 0, x, y, radius);
            gradient.addColorStop(0, 'rgba(255, 255, 255, 0.3)');
            gradient.addColorStop(0.5, 'rgba(255, 245, 238, 0.1)');
            gradient.addColorStop(1, 'rgba(255, 255, 255, 0)');
            
            this.ctx.fillStyle = gradient;
            this.ctx.beginPath();
            this.ctx.arc(x, y, radius, 0, Math.PI * 2);
            this.ctx.fill();
        }
        
        this.ctx.restore();
    }

    /**
     * Draw soft paper texture
     */
    drawPaperTexture(w, h) {
        this.ctx.save();
        this.ctx.globalAlpha = 0.03;
        
        for (let i = 0; i < 200; i++) {
            const x = Math.random() * w;
            const y = Math.random() * h;
            const size = Math.random() * 3 + 1;
            
            this.ctx.fillStyle = Math.random() > 0.5 ? '#000' : '#fff';
            this.ctx.beginPath();
            this.ctx.arc(x, y, size, 0, Math.PI * 2);
            this.ctx.fill();
        }
        
        this.ctx.restore();
    }

    /**
     * Draw a soft watercolor tree
     */
    drawTree(x, y, size, foliageColor = '#7cb342') {
        // Trunk with soft edges
        const trunkGradient = this.ctx.createLinearGradient(
            x - size * 0.1, y, x + size * 0.1, y
        );
        trunkGradient.addColorStop(0, '#8d6e63');
        trunkGradient.addColorStop(0.5, '#6d4c41');
        trunkGradient.addColorStop(1, '#5d4037');
        
        this.ctx.fillStyle = trunkGradient;
        this.ctx.beginPath();
        this.ctx.moveTo(x - size * 0.08, y + size * 0.6);
        this.ctx.quadraticCurveTo(x - size * 0.1, y, x - size * 0.05, y - size * 0.1);
        this.ctx.lineTo(x + size * 0.05, y - size * 0.1);
        this.ctx.quadraticCurveTo(x + size * 0.1, y, x + size * 0.08, y + size * 0.6);
        this.ctx.closePath();
        this.ctx.fill();
        
        // Foliage layers (soft, overlapping circles)
        const foliagePositions = [
            { dx: 0, dy: -size * 0.4, r: size * 0.45 },
            { dx: -size * 0.25, dy: -size * 0.2, r: size * 0.35 },
            { dx: size * 0.25, dy: -size * 0.2, r: size * 0.35 },
            { dx: -size * 0.15, dy: -size * 0.55, r: size * 0.3 },
            { dx: size * 0.15, dy: -size * 0.55, r: size * 0.3 },
        ];
        
        foliagePositions.forEach(pos => {
            const gradient = this.ctx.createRadialGradient(
                x + pos.dx, y + pos.dy, pos.r * 0.2,
                x + pos.dx, y + pos.dy, pos.r
            );
            gradient.addColorStop(0, this.lightenColor(foliageColor, 30));
            gradient.addColorStop(0.6, foliageColor);
            gradient.addColorStop(1, this.darkenColor(foliageColor, 20));
            
            this.ctx.fillStyle = gradient;
            this.ctx.beginPath();
            this.ctx.arc(x + pos.dx, y + pos.dy, pos.r, 0, Math.PI * 2);
            this.ctx.fill();
        });
    }

    /**
     * Draw a cherry blossom tree
     */
    drawCherryBlossomTree(x, y, size) {
        // Trunk
        const trunkGradient = this.ctx.createLinearGradient(
            x - size * 0.1, y, x + size * 0.1, y
        );
        trunkGradient.addColorStop(0, '#a1887f');
        trunkGradient.addColorStop(0.5, '#8d6e63');
        trunkGradient.addColorStop(1, '#795548');
        
        this.ctx.fillStyle = trunkGradient;
        this.ctx.beginPath();
        this.ctx.moveTo(x - size * 0.06, y + size * 0.5);
        this.ctx.quadraticCurveTo(x - size * 0.08, y, x, y - size * 0.1);
        this.ctx.quadraticCurveTo(x + size * 0.08, y, x + size * 0.06, y + size * 0.5);
        this.ctx.closePath();
        this.ctx.fill();
        
        // Branches
        this.ctx.strokeStyle = '#8d6e63';
        this.ctx.lineWidth = 3;
        this.ctx.beginPath();
        this.ctx.moveTo(x, y - size * 0.1);
        this.ctx.quadraticCurveTo(x - size * 0.3, y - size * 0.3, x - size * 0.4, y - size * 0.25);
        this.ctx.moveTo(x, y - size * 0.1);
        this.ctx.quadraticCurveTo(x + size * 0.3, y - size * 0.35, x + size * 0.45, y - size * 0.3);
        this.ctx.stroke();
        
        // Blossom clusters (soft pink clouds)
        const blossomPositions = [
            { dx: -size * 0.35, dy: -size * 0.3, r: size * 0.25 },
            { dx: size * 0.4, dy: -size * 0.35, r: size * 0.28 },
            { dx: 0, dy: -size * 0.45, r: size * 0.35 },
            { dx: -size * 0.15, dy: -size * 0.55, r: size * 0.25 },
            { dx: size * 0.2, dy: -size * 0.5, r: size * 0.22 },
        ];
        
        blossomPositions.forEach(pos => {
            const gradient = this.ctx.createRadialGradient(
                x + pos.dx, y + pos.dy, 0,
                x + pos.dx, y + pos.dy, pos.r
            );
            gradient.addColorStop(0, '#fff0f5');
            gradient.addColorStop(0.4, '#ffb7c5');
            gradient.addColorStop(0.7, '#ff91a4');
            gradient.addColorStop(1, 'rgba(255, 183, 197, 0.3)');
            
            this.ctx.fillStyle = gradient;
            this.ctx.beginPath();
            this.ctx.arc(x + pos.dx, y + pos.dy, pos.r, 0, Math.PI * 2);
            this.ctx.fill();
        });
    }

    /**
     * Draw a potted plant with soft style
     */
    drawPlant(x, y, scale = 1) {
        const s = scale;
        
        // Pot with gradient
        const potGradient = this.ctx.createLinearGradient(x - 20 * s, y, x + 20 * s, y);
        potGradient.addColorStop(0, '#a1887f');
        potGradient.addColorStop(0.5, '#8d6e63');
        potGradient.addColorStop(1, '#795548');
        
        this.ctx.fillStyle = potGradient;
        this.ctx.beginPath();
        this.ctx.moveTo(x - 22 * s, y + 10 * s);
        this.ctx.lineTo(x + 22 * s, y + 10 * s);
        this.ctx.lineTo(x + 16 * s, y + 45 * s);
        this.ctx.lineTo(x - 16 * s, y + 45 * s);
        this.ctx.closePath();
        this.ctx.fill();
        
        // Rim
        this.ctx.fillStyle = '#6d4c41';
        this.ctx.beginPath();
        this.ctx.ellipse(x, y + 10 * s, 24 * s, 6 * s, 0, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Soil
        this.ctx.fillStyle = '#4e342e';
        this.ctx.beginPath();
        this.ctx.ellipse(x, y + 12 * s, 20 * s, 5 * s, 0, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Leaves with soft gradients
        const leafPositions = [
            { angle: -70, length: 35 * s },
            { angle: -40, length: 40 * s },
            { angle: -10, length: 38 * s },
            { angle: 20, length: 42 * s },
            { angle: 50, length: 36 * s },
        ];
        
        leafPositions.forEach(leaf => {
            const rad = (leaf.angle * Math.PI) / 180;
            const endX = x + Math.cos(rad) * leaf.length;
            const endY = y - Math.sin(rad) * leaf.length;
            
            const leafGradient = this.ctx.createLinearGradient(x, y, endX, endY);
            leafGradient.addColorStop(0, '#81c784');
            leafGradient.addColorStop(1, '#4caf50');
            
            this.ctx.fillStyle = leafGradient;
            this.ctx.beginPath();
            this.ctx.moveTo(x, y);
            this.ctx.quadraticCurveTo(
                x + Math.cos(rad - 0.3) * leaf.length * 0.6,
                y - Math.sin(rad - 0.3) * leaf.length * 0.6,
                endX, endY
            );
            this.ctx.quadraticCurveTo(
                x + Math.cos(rad + 0.3) * leaf.length * 0.6,
                y - Math.sin(rad + 0.3) * leaf.length * 0.6,
                x, y
            );
            this.ctx.fill();
        });
    }

    /**
     * Draw soft clouds
     */
    drawCloud(x, y, scale = 1) {
        const s = scale;
        
        this.ctx.save();
        this.ctx.globalAlpha = 0.8;
        
        const gradient = this.ctx.createRadialGradient(x, y, 0, x, y, 80 * s);
        gradient.addColorStop(0, '#ffffff');
        gradient.addColorStop(0.7, 'rgba(255, 255, 255, 0.8)');
        gradient.addColorStop(1, 'rgba(255, 255, 255, 0)');
        
        this.ctx.fillStyle = gradient;
        
        // Cloud puffs
        const puffs = [
            { dx: 0, dy: 0, r: 40 * s },
            { dx: -35 * s, dy: 10 * s, r: 30 * s },
            { dx: 35 * s, dy: 5 * s, r: 35 * s },
            { dx: -50 * s, dy: 15 * s, r: 25 * s },
            { dx: 50 * s, dy: 12 * s, r: 28 * s },
        ];
        
        puffs.forEach(puff => {
            this.ctx.beginPath();
            this.ctx.arc(x + puff.dx, y + puff.dy, puff.r, 0, Math.PI * 2);
            this.ctx.fill();
        });
        
        this.ctx.restore();
    }

    /**
     * Draw a window with soft lighting
     */
    drawWindow(x, y, width, height, timeOfDay = 'afternoon') {
        // Frame
        this.ctx.fillStyle = '#d7ccc8';
        this.ctx.fillRect(x - 6, y - 6, width + 12, height + 12);
        
        // Glass with sky gradient
        let skyColors;
        switch (timeOfDay) {
            case 'morning':
                skyColors = ['#ffe4b5', '#ffd1dc', '#b0e0e6'];
                break;
            case 'evening':
                skyColors = ['#ff7e67', '#ffc107', '#ffab91'];
                break;
            case 'night':
                skyColors = ['#1a237e', '#303f9f', '#3f51b5'];
                break;
            default:
                skyColors = ['#81d4fa', '#b3e5fc', '#e1f5fe'];
        }
        
        const skyGradient = this.createWatercolorGradient(x, y, x, y + height, skyColors);
        this.ctx.fillStyle = skyGradient;
        this.ctx.fillRect(x, y, width, height);
        
        // Cross dividers
        this.ctx.fillStyle = '#bcaaa4';
        this.ctx.fillRect(x + width / 2 - 3, y, 6, height);
        this.ctx.fillRect(x, y + height / 2 - 3, width, 6);
        
        // Light glow from window
        const glowGradient = this.ctx.createRadialGradient(
            x + width / 2, y + height / 2, 0,
            x + width / 2, y + height / 2, Math.max(width, height)
        );
        glowGradient.addColorStop(0, 'rgba(255, 255, 255, 0.2)');
        glowGradient.addColorStop(1, 'rgba(255, 255, 255, 0)');
        
        this.ctx.fillStyle = glowGradient;
        this.ctx.fillRect(x - 50, y - 50, width + 100, height + 100);
    }

    /**
     * Draw paper lantern (izakaya style)
     */
    drawLantern(x, y, kanji = '酒') {
        // String
        this.ctx.strokeStyle = '#5d4037';
        this.ctx.lineWidth = 2;
        this.ctx.beginPath();
        this.ctx.moveTo(x, y - 40);
        this.ctx.lineTo(x, y - 10);
        this.ctx.stroke();
        
        // Top cap
        this.ctx.fillStyle = '#5d4037';
        this.ctx.beginPath();
        this.ctx.ellipse(x, y - 8, 15, 5, 0, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Lantern body with warm glow
        const lanternGradient = this.ctx.createRadialGradient(x, y + 25, 5, x, y + 25, 35);
        lanternGradient.addColorStop(0, '#fff9c4');
        lanternGradient.addColorStop(0.5, '#ffcc80');
        lanternGradient.addColorStop(1, '#ff8a65');
        
        this.ctx.fillStyle = lanternGradient;
        this.ctx.beginPath();
        this.ctx.ellipse(x, y + 25, 28, 38, 0, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Decorative lines
        this.ctx.strokeStyle = 'rgba(139, 69, 19, 0.3)';
        this.ctx.lineWidth = 1;
        for (let i = 0; i < 5; i++) {
            this.ctx.beginPath();
            this.ctx.ellipse(x, y + 10 + i * 12, 25 - i * 2, 3, 0, 0, Math.PI * 2);
            this.ctx.stroke();
        }
        
        // Kanji
        this.ctx.fillStyle = '#c62828';
        this.ctx.font = 'bold 22px "Noto Sans JP", sans-serif';
        this.ctx.textAlign = 'center';
        this.ctx.textBaseline = 'middle';
        this.ctx.fillText(kanji, x, y + 28);
        
        // Bottom
        this.ctx.fillStyle = '#5d4037';
        this.ctx.beginPath();
        this.ctx.ellipse(x, y + 60, 12, 4, 0, 0, Math.PI * 2);
        this.ctx.fill();
    }

    /**
     * Draw clock
     */
    drawClock(x, y, radius = 25) {
        // Face
        const faceGradient = this.ctx.createRadialGradient(x, y, 0, x, y, radius);
        faceGradient.addColorStop(0, '#ffffff');
        faceGradient.addColorStop(1, '#f5f5f5');
        
        this.ctx.fillStyle = faceGradient;
        this.ctx.beginPath();
        this.ctx.arc(x, y, radius, 0, Math.PI * 2);
        this.ctx.fill();
        
        // Border
        this.ctx.strokeStyle = '#8d6e63';
        this.ctx.lineWidth = 3;
        this.ctx.stroke();
        
        // Hour marks
        this.ctx.fillStyle = '#5d4037';
        for (let i = 0; i < 12; i++) {
            const angle = ((i * 30) - 90) * Math.PI / 180;
            const mx = x + Math.cos(angle) * (radius - 6);
            const my = y + Math.sin(angle) * (radius - 6);
            this.ctx.beginPath();
            this.ctx.arc(mx, my, 2, 0, Math.PI * 2);
            this.ctx.fill();
        }
        
        // Hands
        this.ctx.strokeStyle = '#5d4037';
        this.ctx.lineCap = 'round';
        
        // Hour hand
        this.ctx.lineWidth = 3;
        this.ctx.beginPath();
        this.ctx.moveTo(x, y);
        this.ctx.lineTo(x + radius * 0.45, y - radius * 0.25);
        this.ctx.stroke();
        
        // Minute hand
        this.ctx.lineWidth = 2;
        this.ctx.beginPath();
        this.ctx.moveTo(x, y);
        this.ctx.lineTo(x, y - radius * 0.65);
        this.ctx.stroke();
        
        // Center dot
        this.ctx.fillStyle = '#8d6e63';
        this.ctx.beginPath();
        this.ctx.arc(x, y, 3, 0, Math.PI * 2);
        this.ctx.fill();
    }

    /**
     * Darken a hex color
     */
    darkenColor(hex, amount) {
        const num = parseInt(hex.replace('#', ''), 16);
        const r = Math.max(0, (num >> 16) - amount);
        const g = Math.max(0, ((num >> 8) & 0x00FF) - amount);
        const b = Math.max(0, (num & 0x0000FF) - amount);
        return `#${((1 << 24) | (r << 16) | (g << 8) | b).toString(16).slice(1)}`;
    }

    /**
     * Lighten a hex color
     */
    lightenColor(hex, amount) {
        const num = parseInt(hex.replace('#', ''), 16);
        const r = Math.min(255, (num >> 16) + amount);
        const g = Math.min(255, ((num >> 8) & 0x00FF) + amount);
        const b = Math.min(255, (num & 0x0000FF) + amount);
        return `#${((1 << 24) | (r << 16) | (g << 8) | b).toString(16).slice(1)}`;
    }

    /**
     * Convert hex to rgba
     */
    hexToRgba(hex, alpha) {
        const num = parseInt(hex.replace('#', ''), 16);
        const r = (num >> 16) & 255;
        const g = (num >> 8) & 255;
        const b = num & 255;
        return `rgba(${r}, ${g}, ${b}, ${alpha})`;
    }
}
