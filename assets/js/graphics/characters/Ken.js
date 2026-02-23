/**
 * TSUZUKI CONNECT - Ken Character
 * The friendly, casual male protagonist friend
 */

import { CharacterBase } from './CharacterBase.js';

export class Ken extends CharacterBase {
    constructor(game) {
        super(game);
        this.name = 'Ken';
        this.heightRatio = 0.95;
    }
}
