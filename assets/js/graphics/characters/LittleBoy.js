/**
 * TSUZUKI CONNECT - Little Boy Character
 */

import { CharacterBase } from './CharacterBase.js';

export class LittleBoy extends CharacterBase {
    constructor(game) {
        super(game);
        this.name = 'LittleBoy';
        this.assetId = 'little_boy'; // Matches mapping key in CharacterAssets
        this.heightRatio = 0.70;
    }
}
