/**
 * TSUZUKI CONNECT - Mother Character
 */

import { CharacterBase } from './CharacterBase.js';

export class Mother extends CharacterBase {
    constructor(game) {
        super(game);
        this.name = 'Mother';
        this.heightRatio = 0.90;
    }
}
