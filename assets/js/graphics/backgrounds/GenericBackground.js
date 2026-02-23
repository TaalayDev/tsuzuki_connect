/**
 * TSUZUKI CONNECT - Generic Background
 * Simple renderer for image-only backgrounds
 */

import { BackgroundUtils } from './BackgroundUtils.js';
import { BackgroundAssets } from './BackgroundAssets.js';

export class GenericBackground {
    constructor(ctx, width, height, assetId) {
        this.ctx = ctx;
        this.w = width;
        this.h = height;
        this.assetId = assetId;
        this.utils = new BackgroundUtils(ctx);
    }

    draw(timeOfDay = 'afternoon', season = 'spring') {
        const assetPath = BackgroundAssets.getPath(this.assetId, timeOfDay);
        const imageDrawn = this.utils.drawImageBackground(assetPath, this.w, this.h);

        if (!imageDrawn) {
            // Draw a simple fallback if image is loading
            this.ctx.fillStyle = '#333';
            this.ctx.fillRect(0, 0, this.w, this.h);
        }
        
        this.utils.drawWatercolorTexture(this.w, this.h, 0.03);
    }
}
