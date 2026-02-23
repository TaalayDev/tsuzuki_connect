/**
 * TSUZUKI CONNECT - Father Character
 */

import { CharacterBase } from './CharacterBase.js';

export class Father extends CharacterBase {
    constructor(game) {
        super(game);
        this.name = 'Father';
        this.heightRatio = 0.95;
    }
}
