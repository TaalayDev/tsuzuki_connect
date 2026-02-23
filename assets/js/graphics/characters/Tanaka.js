/**
 * TSUZUKI CONNECT - Tanaka-sensei Character
 * The warm, motherly Japanese teacher
 */

import { CharacterBase } from './CharacterBase.js';

export class Tanaka extends CharacterBase {
    constructor(game) {
        super(game);
        this.name = 'Tanaka-sensei';
        this.assetId = 'tanaka'; // Explicitly set asset ID for lookup
        this.heightRatio = 0.85;
    }
}

