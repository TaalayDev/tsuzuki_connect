/**
 * TSUZUKI CONNECT - Yuki Character
 * The cheerful, energetic friend
 */

import { CharacterBase } from './CharacterBase.js';

export class Yuki extends CharacterBase {
    constructor(game) {
        super(game);
        this.name = 'Yuki';
        this.heightRatio = 0.82;
    }
}
