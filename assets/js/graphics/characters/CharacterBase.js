/**
 * TSUZUKI CONNECT - Character Base Class
 * Asset-only character rendering
 */

import { CharacterAssets } from './CharacterAssets.js';

export class CharacterBase {
    constructor(game) {
        this.game = game;
        this.name = 'Character';
        this.assetId = null; // Override for asset lookup (defaults to name)
        this.heightRatio = 0.9;
    }

    /**
     * Main draw function - renders character using image assets
     */
    draw(ctx, x, y, height, expression, breathing) {
        this.drawImageAsset(ctx, x, y, height, expression, breathing);
    }

    /**
     * Draw character using image asset
     */
    drawImageAsset(ctx, x, y, height, expression, breathing) {
        // Use assetId if set, otherwise fallback to name
        const lookupId = this.assetId || this.name;
        
        const path = CharacterAssets.getPath(lookupId, expression);
        if (!path) return false;

        const img = CharacterAssets.getImage(path);
        if (!img) return false; // Not loaded yet or doesn't exist

        // Clip bottom 45% of the sprite for a closer shot (VN style hip-up)
        const clipRatio = 0.45; 
        const sourceHeight = img.height * (1 - clipRatio);
        
        // Calculate dimensions maintaining aspect ratio of the CLIPPED portion
        const aspect = img.width / sourceHeight;
        
        // Use the requested height for the visible portion
        const drawHeight = height * 1.05; 
        const drawWidth = drawHeight * aspect;
        
        // Calculate position
        const drawX = x - (drawWidth / 2);
        const drawY = y - drawHeight + (breathing * 2);

        // Draw character (cropping the source image)
        ctx.drawImage(
            img, 
            0, 0, img.width, sourceHeight,
            drawX, drawY, drawWidth, drawHeight
        );
        
        return true;
    }
}
