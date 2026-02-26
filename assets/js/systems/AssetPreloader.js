/**
 * TSUZUKI CONNECT - Asset Preloader
 * Warms image caches so background/character transitions stay smooth.
 */

import { CharacterAssets } from '../graphics/characters/CharacterAssets.js';
import { BackgroundAssets } from '../graphics/backgrounds/BackgroundAssets.js';
import { preloadBackgroundImage } from '../graphics/backgrounds/BackgroundUtils.js';

export class AssetPreloader {
    static getCoreAssetPaths() {
        const characterPaths = new Set();
        for (const expressions of Object.values(CharacterAssets.MAPPINGS)) {
            for (const path of Object.values(expressions)) {
                if (path) characterPaths.add(path);
            }
        }

        const backgroundPaths = new Set();
        for (const times of Object.values(BackgroundAssets.PATHS)) {
            for (const file of Object.values(times)) {
                if (file) backgroundPaths.add(`${BackgroundAssets.BASE_PATH}${file}`);
            }
        }

        return {
            characterPaths: [...characterPaths],
            backgroundPaths: [...backgroundPaths]
        };
    }

    static async preloadCoreAssets({ concurrency = 6, onProgress = null } = {}) {
        const { characterPaths, backgroundPaths } = this.getCoreAssetPaths();
        const tasks = [
            ...characterPaths.map((path) => () => CharacterAssets.preload(path)),
            ...backgroundPaths.map((path) => () => preloadBackgroundImage(path))
        ];

        return this._runTasks(tasks, {
            concurrency,
            onProgress
        });
    }

    static async _runTasks(tasks, { concurrency, onProgress }) {
        const total = tasks.length;
        let completed = 0;

        const report = () => {
            if (typeof onProgress === 'function') {
                onProgress({ completed, total });
            }
        };

        const queue = tasks.slice();
        const workerCount = Math.max(1, Math.min(concurrency || 1, queue.length || 1));

        const workers = Array.from({ length: workerCount }, async () => {
            while (queue.length) {
                const task = queue.shift();
                try {
                    await task();
                } catch {
                    // Ignore individual failures; game will fall back procedurally/placeholder.
                } finally {
                    completed++;
                    report();
                }
            }
        });

        report();
        await Promise.all(workers);

        return { completed, total };
    }
}

