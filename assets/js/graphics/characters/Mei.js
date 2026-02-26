/**
 * TSUZUKI CONNECT - Mei Character
 * The elegant, studious class representative
 */

import { CharacterBase } from './CharacterBase.js';

export class Mei extends CharacterBase {
    constructor(game) {
        super(game);
        this.name = 'Mei';
        this.heightRatio = 0.88;
    }
}
