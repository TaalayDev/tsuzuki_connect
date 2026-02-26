/**
 * TSUZUKI CONNECT - Little Girl Character
 */

import { CharacterBase } from './CharacterBase.js';

export class LittleGirl extends CharacterBase {
    constructor(game) {
        super(game);
        this.name = 'LittleGirl';
        this.assetId = 'little_girl'; // Matches mapping key in CharacterAssets
        this.heightRatio = 0.70;
    }
}
