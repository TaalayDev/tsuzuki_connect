/**
 * TSUZUKI CONNECT - Player Character
 * The player's avatar/protagonist
 */

import { CharacterBase } from './CharacterBase.js';

export class Player extends CharacterBase {
    constructor(game) {
        super(game);
        this.name = 'Player';
        this.heightRatio = 0.85;
    }
}
