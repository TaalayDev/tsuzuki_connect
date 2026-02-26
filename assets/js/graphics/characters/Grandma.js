/**
 * TSUZUKI CONNECT - Grandma Character
 */

import { CharacterBase } from './CharacterBase.js';

export class Grandma extends CharacterBase {
    constructor(game) {
        super(game);
        this.name = 'Grandma';
        this.heightRatio = 0.85;
    }
}
