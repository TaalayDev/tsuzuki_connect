/**
 * TSUZUKI CONNECT - Character Assets
 * Static fields for character image paths and mapping logic
 */

export class CharacterAssets {
    static BASE_PATH = 'assets/characters/';

    // Image Cache
    static imageCache = new Map();
    static imagePromises = new Map();
    static onImageLoadCallback = null;

    static setLoadCallback(callback) {
        this.onImageLoadCallback = callback;
    }

    // Static Asset Paths
    // Ken
    static get KEN_NEUTRAL() { return `${this.BASE_PATH}ken_neutral.png`; }
    static get KEN_SMILE() { return `${this.BASE_PATH}ken_smile.png`; }
    static get KEN_LAUGH() { return `${this.BASE_PATH}ken_laugh.png`; }
    static get KEN_SURPRISED() { return `${this.BASE_PATH}ken_surprised.png`; }
    static get KEN_ANNOYED() { return `${this.BASE_PATH}ken_annoyed.png`; }
    static get KEN_CONCERNED() { return `${this.BASE_PATH}ken_concerned.png`; }
    static get KEN_SERIOUS() { return `${this.BASE_PATH}ken_serious.png`; }
    static get KEN_SPEAKING() { return `${this.BASE_PATH}ken_speaking.png`; }
    static get KEN_SILHOUETTE() { return `${this.BASE_PATH}ken_silhouette.png`; }

    // Mei
    static get MEI_NEUTRAL() { return `${this.BASE_PATH}mei_neutral.png`; }
    static get MEI_SMILE() { return `${this.BASE_PATH}mei_smile.png`; }
    static get MEI_LAUGH() { return `${this.BASE_PATH}mei_laugh.png`; }
    static get MEI_SURPRISED() { return `${this.BASE_PATH}mei_surprised.png`; }
    static get MEI_ANNOYED() { return `${this.BASE_PATH}mei_annoyed.png`; }
    static get MEI_CONCERNED() { return `${this.BASE_PATH}mei_concerned.png`; }
    static get MEI_SERIOUS() { return `${this.BASE_PATH}mei_serious.png`; }
    static get MEI_SPEAKING() { return `${this.BASE_PATH}mei_speaking.png`; }
    static get MEI_SILHOUETTE() { return `${this.BASE_PATH}mei_silhouette.png`; }

    // Tanaka
    static get TANAKA_NEUTRAL() { return `${this.BASE_PATH}tanaka_neutral.png`; }
    static get TANAKA_SMILE() { return `${this.BASE_PATH}tanaka_smile.png`; }
    static get TANAKA_LAUGH() { return `${this.BASE_PATH}tanaka_laugh.png`; }
    static get TANAKA_SURPRISED() { return `${this.BASE_PATH}tanaka_surprised.png`; }
    static get TANAKA_ANNOYED() { return `${this.BASE_PATH}tanaka_annoyed.png`; }
    static get TANAKA_CONCERNED() { return `${this.BASE_PATH}tanaka_concerned.png`; }
    static get TANAKA_SERIOUS() { return `${this.BASE_PATH}tanaka_serious.png`; }
    static get TANAKA_SPEAKING() { return `${this.BASE_PATH}tanaka_speaking.png`; }
    static get TANAKA_SILHOUETTE() { return `${this.BASE_PATH}tanaka_silhouette.png`; }

    // Yuki
    static get YUKI_NEUTRAL() { return `${this.BASE_PATH}yuki_neutral.png`; }
    static get YUKI_HAPPY() { return `${this.BASE_PATH}yuki_happy.png`; }
    static get YUKI_PLAYFUL() { return `${this.BASE_PATH}yuki_playful_smile.png`; }
    static get YUKI_LAUGH() { return `${this.BASE_PATH}yuki_cheerful_laugh.png`; }
    static get YUKI_SURPRISED() { return `${this.BASE_PATH}yuki_surprised.png`; }
    static get YUKI_SHOCKED() { return `${this.BASE_PATH}yuki_shocked.png`; }
    static get YUKI_SUBTLE_SURPRISE() { return `${this.BASE_PATH}yuki_subtle_surprise.png`; }
    static get YUKI_WORRIED() { return `${this.BASE_PATH}yuki_worried.png`; }
    static get YUKI_CONFUSED() { return `${this.BASE_PATH}yuki_confused.png`; }
    static get YUKI_SERIOUS() { return `${this.BASE_PATH}yuki_serious.png`; }
    static get YUKI_GENTLE() { return `${this.BASE_PATH}yuki_gentle_content.png`; }
    static get YUKI_SPEAKING() { return `${this.BASE_PATH}yuki_speaking.png`; }
    static get YUKI_SILHOUETTE() { return `${this.BASE_PATH}yuki_silhouette.png`; }

    // Family / Misc
    static get FATHER_NEUTRAL() { return `${this.BASE_PATH}father_neutral.png`; }
    static get MOTHER_NEUTRAL() { return `${this.BASE_PATH}mother_neutral.png`; }
    static get GRANDPA_NEUTRAL() { return `${this.BASE_PATH}grandpa_neutral.png`; }
    static get GRANDMA_NEUTRAL() { return `${this.BASE_PATH}grandma_neutral.png`; }
    static get LITTLE_BOY_NEUTRAL() { return `${this.BASE_PATH}little_boy_neutral.png`; }
    static get LITTLE_GIRL_NEUTRAL() { return `${this.BASE_PATH}little_girl_neutral.png`; }


    // Mapping tables
    static MAPPINGS = {
        'ken': {
            'neutral': this.KEN_NEUTRAL,
            'happy': this.KEN_SMILE,
            'laugh': this.KEN_LAUGH,
            'surprised': this.KEN_SURPRISED,
            'angry': this.KEN_ANNOYED,
            'annoyed': this.KEN_ANNOYED,
            'sad': this.KEN_CONCERNED,
            'concerned': this.KEN_CONCERNED,
            'serious': this.KEN_SERIOUS,
            'speaking': this.KEN_SPEAKING,
            'silhouette': this.KEN_SILHOUETTE
        },
        'mei': {
            'neutral': this.MEI_NEUTRAL,
            'happy': this.MEI_SMILE,
            'laugh': this.MEI_LAUGH,
            'surprised': this.MEI_SURPRISED,
            'angry': this.MEI_ANNOYED,
            'annoyed': this.MEI_ANNOYED,
            'sad': this.MEI_CONCERNED,
            'concerned': this.MEI_CONCERNED,
            'serious': this.MEI_SERIOUS,
            'speaking': this.MEI_SPEAKING,
            'silhouette': this.MEI_SILHOUETTE
        },
        'tanaka': {
            'neutral': this.TANAKA_NEUTRAL,
            'happy': this.TANAKA_SMILE,
            'laugh': this.TANAKA_LAUGH,
            'surprised': this.TANAKA_SURPRISED,
            'angry': this.TANAKA_ANNOYED,
            'annoyed': this.TANAKA_ANNOYED,
            'sad': this.TANAKA_CONCERNED,
            'concerned': this.TANAKA_CONCERNED,
            'serious': this.TANAKA_SERIOUS,
            'speaking': this.TANAKA_SPEAKING,
            'silhouette': this.TANAKA_SILHOUETTE
        },
        'yuki': {
            'neutral': this.YUKI_NEUTRAL,
            'happy': this.YUKI_HAPPY,
            'playful': this.YUKI_PLAYFUL,
            'laugh': this.YUKI_LAUGH,
            'surprised': this.YUKI_SURPRISED,
            'shocked': this.YUKI_SHOCKED,
            'subtle_surprise': this.YUKI_SUBTLE_SURPRISE,
            'sad': this.YUKI_WORRIED,
            'worried': this.YUKI_WORRIED,
            'confused': this.YUKI_CONFUSED,
            'serious': this.YUKI_SERIOUS,
            'gentle': this.YUKI_GENTLE,
            'speaking': this.YUKI_SPEAKING,
            'silhouette': this.YUKI_SILHOUETTE
        },
        'father': {
            'neutral': this.FATHER_NEUTRAL
        },
        'mother': {
            'neutral': this.MOTHER_NEUTRAL
        },
        'grandpa': {
            'neutral': this.GRANDPA_NEUTRAL
        },
        'grandma': {
            'neutral': this.GRANDMA_NEUTRAL
        },
        'little_boy': {
            'neutral': this.LITTLE_BOY_NEUTRAL
        },
        'little_girl': {
            'neutral': this.LITTLE_GIRL_NEUTRAL
        }
    };

    /**
     * Get image path for character and expression
     */
    static getPath(characterId, expression) {
        const charMap = this.MAPPINGS[characterId.toLowerCase()];
        if (!charMap) return null;

        // Try direct match
        let path = charMap[expression.toLowerCase()];

        // Try fallback if not found
        if (!path) {
            // Expression fallbacks
            if (expression.includes('smile')) path = charMap['happy'];
            else if (expression.includes('laugh')) path = charMap['laugh'] || charMap['happy'];
            else if (expression.includes('cry')) path = charMap['sad'];
            else if (expression.includes('angry')) path = charMap['annoyed'];
            else if (expression.includes('think')) path = charMap['serious'];
            else if (expression.includes('blush')) path = charMap['happy']; // or embarrassed if we had it
            else path = charMap['neutral']; // Ultimate fallback
        }

        return path;
    }

    /**
     * Get image object, start loading if not cached
     */
    static getImage(path) {
        if (!path) return null;

        let img = this.imageCache.get(path);

        if (!img) {
            img = new Image();
            img.src = path;
            img.onload = () => {
                if (this.onImageLoadCallback) {
                    this.onImageLoadCallback();
                }
            };
            this.imageCache.set(path, img);
        }

        return img.complete && img.naturalWidth !== 0 ? img : null;
    }

    /**
     * Preload a single character image into the cache.
     * Resolves true on load, false on error.
     */
    static preload(path) {
        if (!path) return Promise.resolve(false);

        const cached = this.imageCache.get(path);
        if (cached && cached.complete && cached.naturalWidth !== 0) {
            return Promise.resolve(true);
        }

        const existingPromise = this.imagePromises.get(path);
        if (existingPromise) return existingPromise;

        let img = cached;
        if (!img) {
            img = new Image();
            img.src = path;

            if (!img.onload) {
                img.onload = () => {
                    if (this.onImageLoadCallback) this.onImageLoadCallback();
                };
            }

            this.imageCache.set(path, img);
        }

        const promise = new Promise((resolve) => {
            const cleanup = () => {
                img.removeEventListener('load', onLoad);
                img.removeEventListener('error', onError);
                this.imagePromises.delete(path);
            };

            const onLoad = async () => {
                try {
                    if (typeof img.decode === 'function') {
                        await img.decode();
                    }
                } catch {
                    // decode() can fail even if the image is usable; ignore
                } finally {
                    cleanup();
                    resolve(true);
                }
            };

            const onError = () => {
                cleanup();
                resolve(false);
            };

            img.addEventListener('load', onLoad, { once: true });
            img.addEventListener('error', onError, { once: true });

            // In case it finished between checks
            if (img.complete) {
                if (img.naturalWidth !== 0) onLoad();
                else onError();
            }
        });

        this.imagePromises.set(path, promise);
        return promise;
    }

    /**
     * Preload all known character sprites (all expressions for all characters).
     */
    static preloadAll() {
        const paths = new Set();
        for (const expressions of Object.values(this.MAPPINGS)) {
            for (const value of Object.values(expressions)) {
                if (value) paths.add(value);
            }
        }
        return Promise.allSettled([...paths].map((p) => this.preload(p)));
    }
}
