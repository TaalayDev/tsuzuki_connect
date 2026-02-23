export class AudioManager {
    constructor() {
        this.initialized = false;
        // Defaults match in-game slider defaults (0-1 range)
        this.masterVolume = 0.8;
        this.musicVolume = 0.7;
        this.sfxVolume = 0.6;
        this.voiceVolume = 0.9;

        // VN Mode: Cleaner audio without lo-fi artifacts
        this.vnMode = true;  // Set false for lo-fi beats style

        // Tone.js components
        this.synths = {};
        this.effects = {};
        this.sequences = {};
        this.loops = {};
        this.noiseGenerators = {};
        this.currentMusic = null;
        this.isPlaying = false;

        // SFX synth pool for performance
        this.sfxPool = [];
        this.maxSfxSynths = 8;

        // Vinyl crackle state
        this.vinylState = {
            isPlaying: false,
            filter: null,
            gain: null,
            lfo: null
        };

        // Transport state tracking
        this.transportStarted = false;

        // File-based BGM playback (assets/audio/*)
        this.currentBgmAudio = null;
        this.bgmFadeInterval = null;
        this.bgmManifest = {
            menu: 'lunar lounging_mp3.mp3',
            classroom: 'flight home_mp3.mp3',
            cafe: 'mpk plaza_mp3.mp3',
            emotional: 'rain on mars_mp3.mp3',
            night: 'spaceship earth_mp3.mp3',
            tense: 'paradise wasteland_mp3.mp3',
            upbeat: 'sol beach (day) mp3.mp3',
            chill: 'lunar lounging_mp3.mp3'
        };
    }

    /**
     * Initialize Tone.js audio context
     */
    async init() {
        if (this.initialized) return;

        try {
            await Tone.start();
            console.log('🎵 Audio context started');

            // Scheduler stability (helps prevent long-run timing glitches on some devices)
            try {
                const ctx = (typeof Tone.getContext === 'function') ? Tone.getContext() : Tone.context;
                if (ctx) {
                    // More lookahead = fewer dropouts (fine for BGM), slightly more latency for real-time input.
                    ctx.lookAhead = Math.max(ctx.lookAhead || 0, 0.2);
                    // Keep scheduler cadence reasonable; too low can increase CPU.
                    ctx.updateInterval = 0.05;
                }
            } catch (e) {
                // Non-fatal; Tone versions differ
            }

            // Master bus (all audio passes through here)
            this.masterGain = new Tone.Gain(this.masterVolume).toDestination();

            // Sub-buses (music/SFX/voice)
            this.musicGain = new Tone.Gain(this.musicVolume).connect(this.masterGain);
            this.sfxGain = new Tone.Gain(this.sfxVolume).connect(this.masterGain);
            this.voiceGain = new Tone.Gain(this.voiceVolume).connect(this.masterGain);

            // Create lo-fi effects chain
            await this.createLofiEffects();

            // Create synths
            this.createSynths();

            // Create drum kit
            this.createDrumKit();

            // Initialize vinyl crackle (don't start yet)
            this.initVinylCrackle();

            // Initialize SFX pool
            this.initSFXPool();

            this.initialized = true;

            // Auto-resume audio context when browser/WebView suspends it
            this._attachResumeListeners();

            // Periodic watchdog: detect silently-stopped BGM and restart it.
            // Catches any edge cases that event listeners miss.
            this._bgmWatchdog = setInterval(() => {
                if (this.isPlaying && this.currentBgmAudio
                    && this.currentBgmAudio.paused
                    && !this.currentBgmAudio._intentionallyStopped) {
                    console.log('[BGM Watchdog] Audio paused unexpectedly, restarting…');
                    // Reset to beginning — critical when audio.ended is true
                    if (this.currentBgmAudio.ended || this.currentBgmAudio.currentTime >= this.currentBgmAudio.duration - 0.5) {
                        this.currentBgmAudio.currentTime = 0;
                    }
                    this.currentBgmAudio.play().catch(() => { });
                }
            }, 3000);
        } catch (error) {
            console.error('Failed to initialize audio:', error);
        }
    }

    // ─── Auto-resume helpers ───────────────────────────────────────────────

    /**
     * Resume Tone.js AudioContext + HTMLAudio if they were suspended.
     * Called automatically on visibilitychange, focus, and AudioContext statechange.
     */
    _resumeAudio() {
        // 1. Resume Tone.js AudioContext (Web Audio API)
        try {
            const ctx = (typeof Tone.getContext === 'function') ? Tone.getContext() : Tone.context;
            const rawCtx = ctx && (ctx.rawContext || ctx);
            if (rawCtx && rawCtx.state === 'suspended') {
                rawCtx.resume().then(() => {
                    console.log('🎵 AudioContext resumed');
                    // Restart Tone.Transport if it was running before
                    if (this.transportStarted && Tone.Transport.state !== 'started') {
                        Tone.Transport.start();
                    }
                }).catch(() => { });
            }
        } catch (e) { /* ignore */ }

        // 2. Resume HTMLAudio BGM if it got paused unexpectedly
        if (this.isPlaying && this.currentBgmAudio && this.currentBgmAudio.paused) {
            this.currentBgmAudio.play().catch(() => { });
        }
    }

    /**
     * Attach document / AudioContext listeners that auto-resume audio.
     * Safe to call multiple times (idempotent via flag).
     */
    _attachResumeListeners() {
        if (this._resumeListenersAttached) return;
        this._resumeListenersAttached = true;

        // Resume when tab/WebView becomes visible again
        document.addEventListener('visibilitychange', () => {
            if (!document.hidden) this._resumeAudio();
        });

        // Resume when window regains focus (Flutter sheet dismissed)
        window.addEventListener('focus', () => this._resumeAudio());
        document.addEventListener('focus', () => this._resumeAudio(), true);

        // Resume when the AudioContext itself signals a state change to 'running'
        try {
            const ctx = (typeof Tone.getContext === 'function') ? Tone.getContext() : Tone.context;
            const rawCtx = ctx && (ctx.rawContext || ctx);
            if (rawCtx) {
                rawCtx.addEventListener('statechange', () => {
                    if (rawCtx.state === 'running') {
                        // Re-kickstart transport if loops were scheduled
                        if (this.transportStarted && Tone.Transport.state !== 'started') {
                            Tone.Transport.start();
                        }
                        // Resume HTMLAudio BGM if paused
                        if (this.isPlaying && this.currentBgmAudio && this.currentBgmAudio.paused) {
                            this.currentBgmAudio.play().catch(() => { });
                        }
                    }
                });
            }
        } catch (e) { /* ignore – Tone version differences */ }
    }

    // ── End auto-resume helpers ───────────────────────────────────────────────

    /**
     * Create lo-fi effect chain with tape saturation and filtering
     */
    async createLofiEffects() {
        // Tape wobble - subtle pitch modulation
        this.effects.vibrato = new Tone.Vibrato({
            frequency: 0.5,
            depth: 0.03,
            type: 'sine'
        });

        // Gentle chorus to add width and richness (helps synths feel less "dry")
        this.effects.chorus = new Tone.Chorus({
            frequency: 0.8,
            delayTime: 3.2,
            depth: 0.3,
            wet: 0.14
        }).start();

        // Lo-fi filter - roll off highs like old equipment
        this.effects.lofiFilter = new Tone.Filter({
            frequency: 3800,
            type: 'lowpass',
            rolloff: -24
        });

        // Subtle high-pass to remove rumble
        this.effects.highpass = new Tone.Filter({
            frequency: 60,
            type: 'highpass',
            rolloff: -12
        });

        // Warm reverb - like a small room
        this.effects.reverb = new Tone.Reverb({
            decay: 2.8,
            wet: 0.32,
            preDelay: 0.02
        });
        await this.effects.reverb.generate();

        // Tape-style delay
        this.effects.delay = new Tone.FeedbackDelay({
            delayTime: '8n.',
            feedback: 0.18,
            wet: 0.12
        });

        // Soft saturation/warmth
        this.effects.distortion = new Tone.Chebyshev({
            order: 2,
            wet: 0.08
        });

        // Compressor for that pumping lo-fi feel
        this.effects.compressor = new Tone.Compressor({
            threshold: -18,
            ratio: 4,
            attack: 0.003,
            release: 0.25
        });

        // Stereo widener
        this.effects.widener = new Tone.StereoWidener({
            width: 0.65
        });

        // Gentle EQ before limiting (keeps BGM clear and prevents mud buildup)
        this.effects.eq = new Tone.EQ3({
            low: 0,
            mid: 0,
            high: 0,
            lowFrequency: 120,
            highFrequency: 2600
        });

        // Limiter to prevent clipping
        this.effects.limiter = new Tone.Limiter(-1);

        // Connect effects chain
        this.effects.vibrato.connect(this.effects.chorus);
        this.effects.chorus.connect(this.effects.lofiFilter);
        this.effects.lofiFilter.connect(this.effects.highpass);
        this.effects.highpass.connect(this.effects.distortion);
        this.effects.distortion.connect(this.effects.delay);
        this.effects.delay.connect(this.effects.reverb);
        this.effects.reverb.connect(this.effects.compressor);
        this.effects.compressor.connect(this.effects.widener);
        this.effects.widener.connect(this.effects.eq);
        this.effects.eq.connect(this.effects.limiter);
        this.effects.limiter.connect(this.musicGain || this.masterGain);

        // Separate dry path for drums (less processing)
        this.effects.drumBus = new Tone.Gain(0.8);
        this.effects.drumReverb = new Tone.Reverb({ decay: 0.8, wet: 0.15 });
        await this.effects.drumReverb.generate();
        this.effects.drumCompressor = new Tone.Compressor({
            threshold: -15,
            ratio: 3,
            attack: 0.005,
            release: 0.1
        });
        this.effects.drumBus.connect(this.effects.drumReverb);
        this.effects.drumReverb.connect(this.effects.drumCompressor);
        this.effects.drumCompressor.connect(this.effects.limiter);

        // Store snare merge gain for proper cleanup
        this.effects.snareMerge = new Tone.Gain(0.8);

        // Dedicated bass bus (keeps low-end clean + prevents bypass clipping)
        this.effects.bassHighpass = new Tone.Filter({
            frequency: 30,
            type: 'highpass',
            rolloff: -12
        });
        this.effects.bassLowpass = new Tone.Filter({
            frequency: 230,
            type: 'lowpass',
            rolloff: -12
        });
        this.effects.bassHighpass.connect(this.effects.bassLowpass);
        this.effects.bassLowpass.connect(this.effects.limiter);

        // Apply VN vs Lo-fi tuning (frequency roll-off, saturation, etc.)
        this.applySoundProfile();
    }

    /**
     * Tune the FX chain for VN (clean) vs Lo-fi (colored) playback.
     */
    applySoundProfile() {
        const vn = !!this.vnMode;

        if (this.effects.vibrato?.frequency) {
            this.effects.vibrato.frequency.value = vn ? 0.25 : 0.5;
        }
        if (this.effects.vibrato?.depth) {
            this.effects.vibrato.depth.value = vn ? 0.012 : 0.03;
        }

        if (this.effects.chorus?.frequency) {
            this.effects.chorus.frequency.value = vn ? 0.9 : 0.8;
        }
        if (this.effects.chorus?.wet) {
            this.effects.chorus.wet.value = vn ? 0.12 : 0.16;
        }
        if (typeof this.effects.chorus?.depth === 'number') {
            this.effects.chorus.depth = vn ? 0.25 : 0.32;
        }

        if (this.effects.lofiFilter?.frequency) {
            // VN mode should sound full-range; lo-fi mode rolls off highs heavily
            this.effects.lofiFilter.frequency.value = vn ? 16000 : 4200;
        }
        if (typeof this.effects.lofiFilter?.rolloff === 'number') {
            this.effects.lofiFilter.rolloff = vn ? -12 : -24;
        }

        if (this.effects.distortion?.wet) {
            this.effects.distortion.wet.value = vn ? 0.008 : 0.08;
        }
        if (this.effects.delay?.wet) {
            this.effects.delay.wet.value = vn ? 0.06 : 0.12;
        }
        if (this.effects.delay?.feedback) {
            this.effects.delay.feedback.value = vn ? 0.14 : 0.18;
        }
        if (this.effects.reverb?.wet) {
            this.effects.reverb.wet.value = vn ? 0.22 : 0.32;
        }
        if (typeof this.effects.reverb?.decay === 'number') {
            this.effects.reverb.decay = vn ? 2.2 : 2.8;
        }
        if (this.effects.compressor?.threshold) {
            this.effects.compressor.threshold.value = vn ? -22 : -18;
        }
        if (this.effects.compressor?.ratio) {
            this.effects.compressor.ratio.value = vn ? 2.4 : 4;
        }
        if (this.effects.widener?.width) {
            this.effects.widener.width.value = vn ? 0.48 : 0.65;
        }
        if (this.effects.eq) {
            // Keep VN mode clear/airy; keep lo-fi mode slightly darker/warmer.
            this.effects.eq.low.value = vn ? -1.5 : -2.0;
            this.effects.eq.mid.value = vn ? -0.5 : -1.0;
            this.effects.eq.high.value = vn ? 1.2 : 0.6;
        }
        if (this.effects.drumReverb?.wet) {
            this.effects.drumReverb.wet.value = vn ? 0.1 : 0.15;
        }
        if (this.effects.bassLowpass?.frequency) {
            this.effects.bassLowpass.frequency.value = vn ? 240 : 200;
        }
    }

    /**
     * Create synthesizers for music generation
     */
    createSynths() {
        // Rhodes-style Electric Piano - warm and mellow
        this.synths.rhodes = new Tone.PolySynth(Tone.FMSynth, {
            harmonicity: 2,
            modulationIndex: 1.5,
            oscillator: { type: 'sine' },
            envelope: {
                attack: 0.01,
                decay: 0.9,
                sustain: 0.35,
                release: 1.4
            },
            modulation: { type: 'sine' },
            modulationEnvelope: {
                attack: 0.01,
                decay: 0.5,
                sustain: 0.2,
                release: 0.5
            }
        });
        this.synths.rhodes.maxPolyphony = 12;
        this.synths.rhodes.volume.value = -12;  // Warm rhodes
        this.synths.rhodes.connect(this.effects.vibrato);

        // Warm Pad - Lo-fi strings/synth pad
        this.synths.pad = new Tone.PolySynth(Tone.Synth, {
            oscillator: {
                type: 'sine',
                partialCount: 4
            },
            envelope: {
                attack: 1.8,
                decay: 1.0,
                sustain: 0.55,
                release: 3.0
            }
        });
        this.synths.pad.maxPolyphony = 6;
        this.synths.pad.volume.value = -18;  // Gentle atmosphere
        this.synths.pad.connect(this.effects.reverb);

        // Soft Piano - Muted upright piano tone
        this.synths.piano = new Tone.PolySynth(Tone.Synth, {
            oscillator: { type: 'triangle8' },
            envelope: {
                attack: 0.005,
                decay: 1.2,
                sustain: 0.1,
                release: 2.0
            }
        });
        this.synths.piano.maxPolyphony = 12;
        this.synths.piano.volume.value = -14;  // Clear piano
        this.synths.piano.connect(this.effects.vibrato);

        // Koto / Shamisen - Japanese plucked string
        this.synths.koto = new Tone.PluckSynth({
            attackNoise: 2,
            dampening: 3200,
            resonance: 0.96,
            release: 1.8
        });
        this.synths.koto.volume.value = -10;  // Present koto
        this.synths.koto.connect(this.effects.delay);

        // Sub Bass - Deep and warm 808-style
        this.synths.bass = new Tone.MonoSynth({
            oscillator: { type: 'sine' },
            envelope: {
                attack: 0.02,
                decay: 0.3,
                sustain: 0.7,
                release: 0.8
            },
            filterEnvelope: {
                attack: 0.01,
                decay: 0.2,
                sustain: 0.5,
                release: 0.5,
                baseFrequency: 200,
                octaves: 2
            }
        });
        this.synths.bass.volume.value = -16;  // Warm bass (slightly lower to avoid clipping)
        if (this.effects.bassHighpass) {
            this.synths.bass.connect(this.effects.bassHighpass);
        } else {
            // Fallback (shouldn't happen unless FX init failed)
            this.synths.bass.connect(this.musicGain || this.masterGain);
        }

        // Chime / Bell - Soft wind chime
        this.synths.chime = new Tone.PolySynth(Tone.Synth, {
            oscillator: { type: 'sine' },
            envelope: {
                attack: 0.001,
                decay: 3.5,
                sustain: 0,
                release: 3.5
            }
        });
        this.synths.chime.maxPolyphony = 10;
        this.synths.chime.volume.value = -24;
        this.synths.chime.connect(this.effects.reverb);

        // Soft Lead - For melodies
        this.synths.lead = new Tone.Synth({
            oscillator: { type: 'triangle' },
            envelope: {
                attack: 0.05,
                decay: 0.4,
                sustain: 0.35,
                release: 1.2
            }
        });
        this.synths.lead.volume.value = -14;
        this.synths.lead.connect(this.effects.vibrato);

        // Celesta - Sparkly high notes
        this.synths.celesta = new Tone.PolySynth(Tone.Synth, {
            oscillator: { type: 'sine' },
            envelope: {
                attack: 0.002,
                decay: 1.5,
                sustain: 0,
                release: 1.5
            }
        });
        this.synths.celesta.maxPolyphony = 10;
        this.synths.celesta.volume.value = -22;
        this.synths.celesta.connect(this.effects.reverb);
    }

    /**
     * Create lo-fi drum kit
     */
    createDrumKit() {
        // Muted kick drum
        this.synths.kick = new Tone.MembraneSynth({
            pitchDecay: 0.05,
            octaves: 6,
            oscillator: { type: 'sine' },
            envelope: {
                attack: 0.001,
                decay: 0.25,
                sustain: 0,
                release: 0.4
            }
        });
        this.synths.kick.volume.value = -12;  // Soft kick
        this.synths.kick.connect(this.effects.drumBus);

        // Lo-fi snare - more like a rim shot
        this.synths.snare = new Tone.NoiseSynth({
            noise: { type: 'white' },
            envelope: {
                attack: 0.001,
                decay: 0.15,
                sustain: 0,
                release: 0.1
            }
        });
        this.synths.snare.volume.value = -20;  // Soft snare

        // Snare body
        this.synths.snareBody = new Tone.Synth({
            oscillator: { type: 'triangle' },
            envelope: {
                attack: 0.001,
                decay: 0.1,
                sustain: 0,
                release: 0.1
            }
        });
        this.synths.snareBody.volume.value = -18;  // Soft snare body

        // Connect snare through stored merge gain
        this.synths.snare.connect(this.effects.snareMerge);
        this.synths.snareBody.connect(this.effects.snareMerge);
        this.effects.snareMerge.connect(this.effects.drumBus);

        // Closed hi-hat
        this.synths.hihat = new Tone.MetalSynth({
            frequency: 250,
            envelope: {
                attack: 0.001,
                decay: 0.06,
                release: 0.01
            },
            harmonicity: 5.1,
            modulationIndex: 32,
            resonance: 3000,
            octaves: 1.5
        });
        this.synths.hihat.volume.value = -24;  // Subtle hi-hat
        this.synths.hihat.connect(this.effects.drumBus);

        // Open hi-hat
        this.synths.openHat = new Tone.MetalSynth({
            frequency: 250,
            envelope: {
                attack: 0.001,
                decay: 0.3,
                release: 0.1
            },
            harmonicity: 5.1,
            modulationIndex: 32,
            resonance: 3000,
            octaves: 1.5
        });
        this.synths.openHat.volume.value = -26;  // Subtle open hat
        this.synths.openHat.connect(this.effects.drumBus);

        // Shaker
        this.synths.shaker = new Tone.NoiseSynth({
            noise: { type: 'pink' },
            envelope: {
                attack: 0.001,
                decay: 0.05,
                sustain: 0,
                release: 0.03
            }
        });
        this.synths.shaker.volume.value = -28;  // Light shaker
        this.synths.shaker.connect(this.effects.drumBus);
    }

    /**
     * Initialize vinyl crackle system (doesn't start automatically)
     */
    initVinylCrackle() {
        // Create all vinyl components
        this.recreateVinylCrackle();
    }

    /**
     * Recreate vinyl crackle components (called before each music start)
     */
    recreateVinylCrackle() {
        // Dispose existing if any
        this.disposeVinylCrackle();

        // Create fresh noise generator
        this.noiseGenerators.vinyl = new Tone.Noise('brown');

        // Create filter to shape the crackle
        this.vinylState.filter = new Tone.Filter({
            frequency: 1200,
            type: 'bandpass',
            Q: 0.6
        });

        // Very subtle volume - almost inaudible in VN mode
        this.vinylState.gain = new Tone.Gain(this.vnMode ? 0.003 : 0.015);

        // Random amplitude modulation for crackle effect
        this.vinylState.lfo = new Tone.LFO({
            frequency: '8n',
            min: 0,
            max: this.vnMode ? 0.01 : 0.04,
            type: 'sine'  // Smoother modulation
        });

        // Secondary crackle layer (higher frequency pops) - disabled in VN mode
        if (!this.vnMode) {
            this.noiseGenerators.vinylHigh = new Tone.Noise('white');
            this.vinylState.highFilter = new Tone.Filter({
                frequency: 4000,
                type: 'highpass'
            });
            this.vinylState.highGain = new Tone.Gain(0.004);
        } else {
            this.noiseGenerators.vinylHigh = null;
            this.vinylState.highFilter = null;
            this.vinylState.highGain = null;
        }

        // Connect main crackle chain
        this.noiseGenerators.vinyl.connect(this.vinylState.filter);
        this.vinylState.filter.connect(this.vinylState.gain);
        this.vinylState.gain.connect(this.musicGain || this.masterGain);

        // Connect high crackle chain (only if not in VN mode)
        if (this.noiseGenerators.vinylHigh && this.vinylState.highFilter && this.vinylState.highGain) {
            this.noiseGenerators.vinylHigh.connect(this.vinylState.highFilter);
            this.vinylState.highFilter.connect(this.vinylState.highGain);
            this.vinylState.highGain.connect(this.musicGain || this.masterGain);
        }

        this.vinylState.isPlaying = false;
    }

    /**
     * Dispose vinyl crackle components safely
     */
    disposeVinylCrackle() {
        // Stop and dispose main vinyl noise
        if (this.noiseGenerators.vinyl) {
            try {
                if (this.vinylState.isPlaying) {
                    this.noiseGenerators.vinyl.stop();
                }
                this.noiseGenerators.vinyl.dispose();
            } catch (e) { /* ignore */ }
            this.noiseGenerators.vinyl = null;
        }

        // Stop and dispose high vinyl noise
        if (this.noiseGenerators.vinylHigh) {
            try {
                if (this.vinylState.isPlaying) {
                    this.noiseGenerators.vinylHigh.stop();
                }
                this.noiseGenerators.vinylHigh.dispose();
            } catch (e) { /* ignore */ }
            this.noiseGenerators.vinylHigh = null;
        }

        // Dispose filter and gain nodes
        if (this.vinylState.filter) {
            try { this.vinylState.filter.dispose(); } catch (e) { /* ignore */ }
            this.vinylState.filter = null;
        }
        if (this.vinylState.gain) {
            try { this.vinylState.gain.dispose(); } catch (e) { /* ignore */ }
            this.vinylState.gain = null;
        }
        if (this.vinylState.lfo) {
            try { this.vinylState.lfo.dispose(); } catch (e) { /* ignore */ }
            this.vinylState.lfo = null;
        }
        if (this.vinylState.highFilter) {
            try { this.vinylState.highFilter.dispose(); } catch (e) { /* ignore */ }
            this.vinylState.highFilter = null;
        }
        if (this.vinylState.highGain) {
            try { this.vinylState.highGain.dispose(); } catch (e) { /* ignore */ }
            this.vinylState.highGain = null;
        }

        this.vinylState.isPlaying = false;
    }

    /**
     * Start vinyl crackle (only if not in VN mode, or very subtle)
     */
    startVinylCrackle() {
        // Skip vinyl crackle entirely in VN mode for cleaner audio
        if (this.vnMode) return;

        if (!this.noiseGenerators.vinyl || this.vinylState.isPlaying) return;

        try {
            this.noiseGenerators.vinyl.start();
            if (this.noiseGenerators.vinylHigh) {
                this.noiseGenerators.vinylHigh.start();
            }
            this.vinylState.isPlaying = true;
        } catch (e) {
            // If start fails, recreate and try again
            this.recreateVinylCrackle();
            try {
                this.noiseGenerators.vinyl.start();
                if (this.noiseGenerators.vinylHigh) {
                    this.noiseGenerators.vinylHigh.start();
                }
                this.vinylState.isPlaying = true;
            } catch (e2) {
                console.warn('Could not start vinyl crackle:', e2);
            }
        }
    }

    /**
     * Stop vinyl crackle
     */
    stopVinylCrackle() {
        if (!this.vinylState.isPlaying) return;

        try {
            if (this.noiseGenerators.vinyl) {
                this.noiseGenerators.vinyl.stop();
            }
            if (this.noiseGenerators.vinylHigh) {
                this.noiseGenerators.vinylHigh.stop();
            }
        } catch (e) {
            // Ignore stop errors
        }
        this.vinylState.isPlaying = false;
    }

    /**
     * Initialize SFX synth pool
     */
    initSFXPool() {
        for (let i = 0; i < this.maxSfxSynths; i++) {
            const synth = new Tone.Synth({
                oscillator: { type: 'sine' },
                envelope: { attack: 0.005, decay: 0.1, sustain: 0, release: 0.1 }
            }).connect(this.sfxGain || Tone.Destination);
            synth.volume.value = -8;
            this.sfxPool.push({ synth, inUse: false, releaseTime: 0 });
        }
    }

    /**
     * Get an available SFX synth from the pool
     */
    getSFXSynth() {
        const now = Tone.now();

        // Find an available synth
        let sfx = this.sfxPool.find(s => !s.inUse || now > s.releaseTime);

        if (sfx) {
            sfx.inUse = true;
            sfx.releaseTime = now + 2; // Reserve for 2 seconds
            sfx.synth.volume.value = -8;
            return sfx.synth;
        }

        // All synths in use, return the oldest one
        sfx = this.sfxPool.reduce((oldest, current) =>
            current.releaseTime < oldest.releaseTime ? current : oldest
        );
        sfx.releaseTime = now + 2;
        sfx.synth.volume.value = -8;
        return sfx.synth;
    }

    /**
     * Safely stop all sequences and loops
     */
    stopAllSequences() {
        // Stop all sequences
        for (const key of Object.keys(this.sequences)) {
            if (this.sequences[key]) {
                try {
                    this.sequences[key].stop();
                    this.sequences[key].dispose();
                } catch (e) {
                    // Ignore disposal errors
                }
            }
        }
        this.sequences = {};

        // Stop all loops
        for (const key of Object.keys(this.loops)) {
            if (this.loops[key]) {
                try {
                    this.loops[key].stop();
                    this.loops[key].dispose();
                } catch (e) {
                    // Ignore disposal errors
                }
            }
        }
        this.loops = {};
    }

    /**
     * Reset transport state
     */
    resetTransport() {
        try {
            Tone.Transport.stop();
            Tone.Transport.cancel(0);
            Tone.Transport.position = '0:0:0';
        } catch (e) {
            console.warn('Transport reset error:', e);
        }
        this.transportStarted = false;
    }

    /**
     * Start transport safely
     */
    startTransport() {
        if (!this.transportStarted) {
            Tone.Transport.start();
            this.transportStarted = true;
        }
    }

    /**
     * Get swing time offset for groove
     */
    getSwingOffset(sixteenthIndex, swingAmount = 0.15) {
        return (sixteenthIndex % 2 === 1) ? swingAmount : 0;
    }

    _pick(list) {
        if (!list || list.length === 0) return null;
        return list[Math.floor(Math.random() * list.length)];
    }

    _transpose(note, semitones) {
        try {
            return Tone.Frequency(note).transpose(semitones).toNote();
        } catch (e) {
            return note;
        }
    }

    _strum(synth, notes, duration, time, velocity = 0.4, spread = 0.014) {
        if (!synth || !notes || notes.length === 0) return;

        const v = Math.max(0, Math.min(1, velocity));
        const jitter = spread * 0.3;

        notes.forEach((note, i) => {
            const t = time + (i * spread) + (Math.random() - 0.5) * jitter;
            synth.triggerAttackRelease(note, duration, t, v * (0.9 + Math.random() * 0.2));
        });
    }

    _clearBgmFade() {
        if (this.bgmFadeInterval) {
            clearInterval(this.bgmFadeInterval);
            this.bgmFadeInterval = null;
        }
    }

    _getBgmSrc(trackKey) {
        const fileName = this.bgmManifest[trackKey];
        if (!fileName) return null;
        return encodeURI(`assets/audio/${fileName}`);
    }

    _playAssetBgm(trackKey, fadeInSeconds = 0) {
        if (!this.initialized) return;

        const src = this._getBgmSrc(trackKey);
        if (!src) {
            console.warn(`Unknown BGM track key: ${trackKey}`);
            return;
        }

        this.stopAllMusic();

        const audio = new Audio(src);
        audio.loop = true;
        audio.preload = 'auto';
        audio.volume = fadeInSeconds > 0 ? 0 : this.musicVolume;

        this.currentBgmAudio = audio;
        this.currentMusic = trackKey;
        this.isPlaying = true;

        const playPromise = audio.play();
        if (playPromise && typeof playPromise.catch === 'function') {
            playPromise.catch((error) => {
                console.warn(`Failed to play BGM "${trackKey}":`, error);
            });
        }

        // Guard: if the element gets paused by the browser (e.g. native overlay
        // from Flutter covers the WebView), resume it when still supposed to play.
        audio.addEventListener('pause', () => {
            if (this.isPlaying && this.currentBgmAudio === audio && !audio._intentionallyStopped) {
                setTimeout(() => {
                    if (this.isPlaying && this.currentBgmAudio === audio && audio.paused && !audio._intentionallyStopped) {
                        console.log('[BGM] Auto-resuming paused audio');
                        // If audio reached the end, rewind first
                        if (audio.ended || audio.currentTime >= audio.duration - 0.5) {
                            audio.currentTime = 0;
                        }
                        audio.play().catch(() => { });
                    }
                }, 300);
            }
        });

        // Guard: WebKit sometimes silently stops looped audio (the 'ended' event
        // fires even though loop=true). Catch it and restart.
        audio.addEventListener('ended', () => {
            if (this.isPlaying && this.currentBgmAudio === audio && !audio._intentionallyStopped) {
                console.log('[BGM] Loop ended unexpectedly, restarting…');
                audio.currentTime = 0;
                audio.play().catch(() => { });
            }
        });

        // Proactive loop: when nearing the end, seek back to 0.
        // This bypasses WebKit's broken loop entirely.
        audio.addEventListener('timeupdate', () => {
            if (!this.isPlaying || this.currentBgmAudio !== audio || audio._intentionallyStopped) return;
            if (audio.duration > 0 && audio.currentTime >= audio.duration - 0.3) {
                audio.currentTime = 0;
            }
        });

        // Guard: if the audio source errors out, try to recover once.
        audio.addEventListener('error', (e) => {
            console.warn('[BGM] Audio error:', e);
            if (this.isPlaying && this.currentBgmAudio === audio && !audio._intentionallyStopped) {
                setTimeout(() => {
                    if (this.isPlaying && this.currentBgmAudio === audio) {
                        console.log('[BGM] Attempting error recovery…');
                        audio.load();
                        audio.play().catch(() => { });
                    }
                }, 1000);
            }
        });

        if (fadeInSeconds > 0) {
            const durationMs = Math.max(100, Math.floor(fadeInSeconds * 1000));
            const stepMs = 50;
            const steps = Math.max(1, Math.floor(durationMs / stepMs));
            const delta = this.musicVolume / steps;
            let current = 0;

            this._clearBgmFade();
            this.bgmFadeInterval = setInterval(() => {
                if (!this.currentBgmAudio || this.currentBgmAudio !== audio) {
                    this._clearBgmFade();
                    return;
                }

                current = Math.min(this.musicVolume, current + delta);
                this.currentBgmAudio.volume = current;

                if (current >= this.musicVolume) {
                    this._clearBgmFade();
                }
            }, stepMs);
        }
    }

    /**
     * Play main menu music - Peaceful Lo-fi Cherry Blossom Theme
     */
    playMenuMusic() {
        if (!this.initialized) return;
        this.stopAllMusic();

        // Recreate vinyl for fresh start
        this.recreateVinylCrackle();

        Tone.Transport.bpm.value = 76;
        Tone.Transport.swing = 0.08;
        Tone.Transport.swingSubdivision = '16n';

        this.startVinylCrackle();

        // Warm I–iii–vi–V progression (8-bar loop), voiced to stay airy and non-distracting.
        const chordProgression = [
            { bass: 'F2', chord: ['A3', 'C4', 'E4', 'G4'], pad: ['F3', 'C4'] }, // Fmaj9 (no root)
            { bass: 'A2', chord: ['C4', 'E4', 'G4', 'B4'], pad: ['A3', 'E4'] }, // Am9 (no root)
            { bass: 'D2', chord: ['F3', 'A3', 'C4', 'E4'], pad: ['D3', 'A3'] }, // Dm9 (no root)
            { bass: 'C2', chord: ['G3', 'B3', 'D4', 'E4'], pad: ['C3', 'G3'] }  // Cmaj9 (no root)
        ];

        const half = Tone.Time('2n').toSeconds();
        const quarter = Tone.Time('4n').toSeconds();

        // Rhodes comping (more intentional rhythm, less random "wrong note" risk)
        let bar = 0;
        this.loops.rhodes = new Tone.Loop((time) => {
            const chord = chordProgression[Math.floor(bar / 2) % chordProgression.length];
            const isDownbeatBar = bar % 2 === 0;

            this._strum(this.synths.rhodes, chord.chord, '8n', time, isDownbeatBar ? 0.5 : 0.35, 0.013);

            if (isDownbeatBar && Math.random() > 0.12) {
                this._strum(this.synths.rhodes, chord.chord.slice(1), '8n', time + half, 0.26, 0.011);
            } else if (!isDownbeatBar && Math.random() > 0.7) {
                this._strum(this.synths.rhodes, chord.chord.slice(0, 3), '8n', time + quarter, 0.22, 0.01);
            }

            bar++;
        }, '1m');
        this.loops.rhodes.start(0);

        // Soft pad bed
        let padIndex = 0;
        this.loops.pad = new Tone.Loop((time) => {
            const chord = chordProgression[padIndex % chordProgression.length];
            this.synths.pad.triggerAttackRelease(chord.pad, '2m', time, 0.26);
            padIndex++;
        }, '2m');
        this.loops.pad.start(0);

        // Bassline with gentle approach tones (stays out of the way)
        let bassStep = 0;
        this.loops.bass = new Tone.Loop((time) => {
            const chordIndex = Math.floor(bassStep / 8) % chordProgression.length; // 2 bars per chord @ 4n
            const stepInChord = bassStep % 8;
            const chord = chordProgression[chordIndex];
            const nextChord = chordProgression[(chordIndex + 1) % chordProgression.length];

            const shouldPlay = stepInChord % 2 === 0; // leave space
            if (shouldPlay) {
                let note = chord.bass;
                if (stepInChord === 2) note = this._transpose(chord.bass, 7); // fifth
                if (stepInChord === 6) note = this._transpose(nextChord.bass, -1); // approach
                if (stepInChord === 4 && Math.random() > 0.7) note = this._transpose(chord.bass, 12); // octave lift

                this.synths.bass.triggerAttackRelease(note, '8n', time, 0.55);
            }

            bassStep++;
        }, '4n');
        this.loops.bass.start(0);

        // Melodic motif (A minor pentatonic) – longer phrases to avoid obvious repetition
        const melodyPhrases = [
            [
                'A4', null, 'C5', null, 'D5', 'C5', 'A4', null,
                'G4', null, 'A4', 'C5', null, 'D5', null, null,
                'A4', null, 'C5', 'D5', 'E5', null, 'D5', 'C5',
                'A4', null, null, null, null, null, null, null
            ],
            [
                'C5', null, 'D5', 'E5', null, 'D5', 'C5', null,
                'A4', null, 'C5', null, 'D5', null, 'E5', null,
                'G5', null, 'E5', 'D5', 'C5', null, 'A4', null,
                null, null, null, null, null, null, null, null
            ],
            [
                null, null, 'A4', null, 'C5', null, 'D5', null,
                'E5', null, null, null, 'D5', null, 'C5', null,
                'A4', null, null, null, 'G4', null, 'A4', null,
                'C5', null, null, null, null, null, null, null
            ]
        ];

        let melodyStep = 0;
        let melodyPhrase = 0;
        this.loops.melody = new Tone.Loop((time) => {
            const phrase = melodyPhrases[melodyPhrase % melodyPhrases.length];
            const note = phrase[melodyStep % phrase.length];

            if (note) {
                this.synths.piano.triggerAttackRelease(note, '8n', time, 0.48 + Math.random() * 0.12);
            }

            melodyStep++;
            if (melodyStep % phrase.length === 0) melodyPhrase++;
        }, '8n');
        this.loops.melody.start('4m');

        // Koto arpeggios on chord changes (keeps the "Japanese VN" flavor)
        let kotoIndex = 0;
        this.loops.koto = new Tone.Loop((time) => {
            const chord = chordProgression[kotoIndex % chordProgression.length];
            const arp = [chord.chord[0], chord.chord[2], chord.chord[3]].map(n => this._transpose(n, 12));
            arp.forEach((note, i) => {
                this.synths.koto.triggerAttack(note, time + i * 0.18, 0.26 + Math.random() * 0.12);
            });
            kotoIndex++;
        }, '2m');
        this.loops.koto.start('8m');

        // Gentle lo-fi drums (start later so the menu feels calm)
        let drumBar = 0;
        this.sequences.drums = new Tone.Sequence(
            (time, step) => {
                if (step === 0) drumBar++;
                const isFillBar = drumBar > 0 && drumBar % 8 === 0;

                // Kick
                if (step === 0 || step === 8) {
                    this.synths.kick.triggerAttackRelease('C1', '8n', time, 0.8);
                } else if ((step === 6 || step === 14) && Math.random() > 0.75) {
                    this.synths.kick.triggerAttackRelease('C1', '16n', time, 0.25);
                } else if (isFillBar && step === 14) {
                    this.synths.kick.triggerAttackRelease('C1', '16n', time, 0.35);
                }

                // Snare (soft backbeat)
                if (step === 4 || step === 12) {
                    this.synths.snare.triggerAttackRelease('16n', time, 0.32);
                    this.synths.snareBody.triggerAttackRelease('C3', '16n', time, 0.22);
                } else if (isFillBar && step === 15 && Math.random() > 0.4) {
                    this.synths.snare.triggerAttackRelease('32n', time, 0.12);
                }

                // Hi-hats
                if (step % 2 === 0) {
                    const accent = step % 4 === 0;
                    this.synths.hihat.triggerAttackRelease('16n', time, accent ? 0.14 : 0.1);
                } else if (Math.random() > 0.82) {
                    this.synths.hihat.triggerAttackRelease('16n', time, 0.06);
                }

                // Open hat on fills
                if (isFillBar && step === 15 && Math.random() > 0.5) {
                    this.synths.openHat.triggerAttackRelease('8n', time, 0.08);
                }

                // Shaker texture
                if ((step === 10 || step === 2) && Math.random() > 0.7) {
                    this.synths.shaker.triggerAttackRelease('32n', time, 0.22);
                }
            },
            [...Array(16).keys()],
            '16n'
        );
        this.sequences.drums.start('4m');

        // Occasional chimes (very sparse)
        const chimeNotes = ['A6', 'C7', 'D7', 'E7', 'G7'];
        this.loops.chime = new Tone.Loop((time) => {
            if (Math.random() > 0.65) {
                const note = this._pick(chimeNotes);
                if (note) this.synths.chime.triggerAttackRelease(note, '2n', time, 0.12);
            }
        }, '4m');
        this.loops.chime.start('16m');

        this.startTransport();
        this.currentMusic = 'menu';
        this.isPlaying = true;
    }

    /**
     * Play classroom music - Warm and encouraging lo-fi
     */
    playClassroomMusic() {
        if (!this.initialized) return;
        this.stopAllMusic();
        this.recreateVinylCrackle();

        Tone.Transport.bpm.value = 80;
        Tone.Transport.swing = 0.06;
        Tone.Transport.swingSubdivision = '16n';

        this.startVinylCrackle();

        // Warm I–vi–ii–V progression (keeps focus on reading)
        const chordProgression = [
            { bass: 'C2', chord: ['G3', 'B3', 'D4', 'E4'], pad: ['C3', 'G3'] }, // Cmaj9 (no root)
            { bass: 'A1', chord: ['C4', 'E4', 'G4', 'B4'], pad: ['A3', 'E4'] }, // Am9 (no root)
            { bass: 'D2', chord: ['F3', 'A3', 'C4', 'E4'], pad: ['D3', 'A3'] }, // Dm9 (no root)
            { bass: 'G1', chord: ['F3', 'A3', 'B3', 'E4'], pad: ['G3', 'D4'] }  // G13 (no root)
        ];

        const half = Tone.Time('2n').toSeconds();
        const quarter = Tone.Time('4n').toSeconds();

        // Rhodes comping – light rhythm, consistent voicings
        let bar = 0;
        this.loops.rhodes = new Tone.Loop((time) => {
            const chord = chordProgression[Math.floor(bar / 2) % chordProgression.length];
            const isDownbeatBar = bar % 2 === 0;

            this._strum(this.synths.rhodes, chord.chord, '8n', time, isDownbeatBar ? 0.46 : 0.32, 0.013);

            if (isDownbeatBar && Math.random() > 0.18) {
                this._strum(this.synths.rhodes, chord.chord.slice(1), '8n', time + half, 0.24, 0.011);
            } else if (!isDownbeatBar && Math.random() > 0.78) {
                this._strum(this.synths.rhodes, chord.chord.slice(0, 3), '8n', time + quarter, 0.2, 0.01);
            }

            bar++;
        }, '1m');
        this.loops.rhodes.start(0);

        // Pad bed (kept subtle)
        let padIndex = 0;
        this.loops.pad = new Tone.Loop((time) => {
            const chord = chordProgression[padIndex % chordProgression.length];
            this.synths.pad.triggerAttackRelease(chord.pad, '2m', time, 0.22);
            padIndex++;
        }, '2m');
        this.loops.pad.start(0);

        // Encouraging motif (C major pentatonic) – long phrases to reduce repetition fatigue
        const melodyPhrases = [
            [
                'E4', 'G4', 'A4', null, 'G4', 'E4', 'D4', null,
                'D4', 'E4', 'G4', 'A4', 'G4', 'E4', 'D4', null,
                'E4', 'G4', 'A4', 'C5', 'A4', 'G4', 'E4', 'D4',
                'C5', null, null, null, null, null, null, null
            ],
            [
                'G4', 'A4', 'C5', 'A4', 'G4', 'E4', 'D4', null,
                'E4', 'G4', 'A4', 'G4', 'E4', 'D4', 'C4', null,
                'D4', 'E4', 'G4', 'A4', 'C5', 'A4', 'G4', 'E4',
                'D4', null, null, null, null, null, null, null
            ]
        ];

        let melodyStep = 0;
        let melodyPhrase = 0;
        this.loops.melody = new Tone.Loop((time) => {
            const phrase = melodyPhrases[melodyPhrase % melodyPhrases.length];
            const note = phrase[melodyStep % phrase.length];

            if (note && Math.random() > 0.05) {
                this.synths.piano.triggerAttackRelease(note, '8n', time, 0.5 + Math.random() * 0.12);
            }

            melodyStep++;
            if (melodyStep % phrase.length === 0) melodyPhrase++;
        }, '8n');
        this.loops.melody.start('2m');

        // Bassline: root + fifth + approach (quarter-note grid)
        let bassStep = 0;
        this.loops.bass = new Tone.Loop((time) => {
            const chordIndex = Math.floor(bassStep / 8) % chordProgression.length;
            const stepInChord = bassStep % 8;
            const chord = chordProgression[chordIndex];
            const nextChord = chordProgression[(chordIndex + 1) % chordProgression.length];

            const shouldPlay = stepInChord % 2 === 0;
            if (shouldPlay) {
                let note = chord.bass;
                if (stepInChord === 2) note = this._transpose(chord.bass, 7);
                if (stepInChord === 6) note = this._transpose(nextChord.bass, -1);
                if (stepInChord === 4 && Math.random() > 0.65) note = this._transpose(chord.bass, 12);

                this.synths.bass.triggerAttackRelease(note, '8n', time, 0.6);
            }

            bassStep++;
        }, '4n');
        this.loops.bass.start(0);

        // Gentle drum groove (starts after the harmony establishes)
        this.sequences.drums = new Tone.Sequence(
            (time, step) => {
                // Kick
                if (step === 0 || step === 8) {
                    this.synths.kick.triggerAttackRelease('C1', '8n', time, 0.75);
                } else if ((step === 6 || step === 14) && Math.random() > 0.8) {
                    this.synths.kick.triggerAttackRelease('C1', '16n', time, 0.22);
                }

                // Snare
                if (step === 4 || step === 12) {
                    this.synths.snare.triggerAttackRelease('16n', time, 0.28);
                    this.synths.snareBody.triggerAttackRelease('D3', '16n', time, 0.2);
                }

                // Hats
                if (step % 2 === 0) {
                    const accent = step % 4 === 0;
                    this.synths.hihat.triggerAttackRelease('16n', time, accent ? 0.13 : 0.09);
                } else if (Math.random() > 0.85) {
                    this.synths.hihat.triggerAttackRelease('16n', time, 0.05);
                }

                if (step === 10 && Math.random() > 0.75) {
                    this.synths.shaker.triggerAttackRelease('32n', time, 0.18);
                }
            },
            [...Array(16).keys()],
            '16n'
        );
        this.sequences.drums.start('2m');

        // Celesta sparkles (rare, helps the track feel alive without being busy)
        const celestaNotes = ['C6', 'D6', 'E6', 'G6', 'A6'];
        this.loops.celesta = new Tone.Loop((time) => {
            if (Math.random() > 0.55) {
                const note = this._pick(celestaNotes);
                if (!note) return;
                this.synths.celesta.triggerAttackRelease(note, '8n', time + Math.random() * 0.02, 0.12);
            }
        }, '2m');
        this.loops.celesta.start('8m');

        this.startTransport();
        this.currentMusic = 'classroom';
        this.isPlaying = true;
    }

    /**
     * Play cafe music - Cozy lo-fi jazz
     */
    playCafeMusic() {
        if (!this.initialized) return;
        this.stopAllMusic();
        this.recreateVinylCrackle();

        Tone.Transport.bpm.value = 72;
        Tone.Transport.swing = 0.17;
        Tone.Transport.swingSubdivision = '8n';

        this.startVinylCrackle();

        // Cozy jazz ii–V–I–vi, voiced to feel like a real comping pianist.
        const chordProgression = [
            { bass: 'D2', chord: ['F3', 'C4', 'E4', 'A4'] }, // Dm9 (no root)
            { bass: 'G1', chord: ['F3', 'B3', 'E4', 'A4'] }, // G13 (no root)
            { bass: 'C2', chord: ['E3', 'B3', 'D4', 'G4'] }, // Cmaj9 (no root)
            { bass: 'A1', chord: ['C4', 'E4', 'G4', 'B4'] }  // Am9 (no root)
        ];

        const quarter = Tone.Time('4n').toSeconds();
        const eighth = Tone.Time('8n').toSeconds();

        // Rhodes comp: hit on beats 2 & 4, with occasional anticipation.
        let measure = 0;
        this.loops.rhodes = new Tone.Loop((time) => {
            const chord = chordProgression[measure % chordProgression.length];

            this._strum(this.synths.rhodes, chord.chord, '8n', time + quarter, 0.38, 0.012);
            if (Math.random() > 0.25) {
                this._strum(this.synths.rhodes, chord.chord.slice(1), '8n', time + 3 * quarter, 0.26, 0.011);
            }
            if (Math.random() > 0.75) {
                this._strum(this.synths.rhodes, chord.chord.slice(0, 3), '16n', time + 3 * quarter + eighth, 0.18, 0.01);
            }

            measure++;
        }, '1m');
        this.loops.rhodes.start(0);

        // Walking bass - more sophisticated pattern
        const walkingBassPatterns = [
            ['D2', 'F2', 'A2', 'C3'],
            ['G2', 'A2', 'B2', 'D3'],
            ['C2', 'E2', 'G2', 'A2'],
            ['A1', 'C2', 'E2', 'G2']
        ];

        let bassStep = 0;
        this.loops.bass = new Tone.Loop((time) => {
            const chordIndex = Math.floor(bassStep / 4) % chordProgression.length; // 1 bar per chord
            const stepInBar = bassStep % 4;

            const pattern = walkingBassPatterns[chordIndex % walkingBassPatterns.length];
            let note = pattern[stepInBar];

            // Chromatic approach into the next chord (classic jazz walk)
            if (stepInBar === 3 && Math.random() > 0.6) {
                const nextBass = chordProgression[(chordIndex + 1) % chordProgression.length].bass;
                note = this._transpose(nextBass, -1);
            }

            this.synths.bass.triggerAttackRelease(note, '8n', time, 0.52 + Math.random() * 0.08);
            bassStep++;
        }, '4n');
        this.loops.bass.start(0);

        // Jazz melody with blue notes
        const melodyPhrases = [
            [
                null, 'A4', null, 'Bb4', 'A4', null, 'G4', null,
                null, 'F4', null, 'G4', null, 'A4', null, null,
                null, 'E4', null, 'G4', 'B4', null, 'A4', null,
                null, null, null, null, null, null, null, null
            ],
            [
                null, 'D4', null, 'F4', null, 'G4', null, 'A4',
                null, null, null, 'G4', null, 'F4', null, null,
                null, 'E4', null, 'G4', 'B4', 'C5', null, 'B4',
                'A4', null, null, null, null, null, null, null
            ]
        ];

        let melodyStep = 0;
        let melodyPhrase = 0;
        this.loops.melody = new Tone.Loop((time) => {
            const phrase = melodyPhrases[melodyPhrase % melodyPhrases.length];
            const note = phrase[melodyStep % phrase.length];

            if (note && Math.random() > 0.22) {
                this.synths.piano.triggerAttackRelease(note, '8n', time, 0.38 + Math.random() * 0.12);
            }

            melodyStep++;
            if (melodyStep % phrase.length === 0) melodyPhrase++;
        }, '8n');
        this.loops.melody.start('2m');

        // Jazz drums - brushes feel
        this.sequences.drums = new Tone.Sequence(
            (time, step) => {
                // Soft kick
                if (step === 0) {
                    this.synths.kick.triggerAttackRelease('C1', '16n', time, 0.6);
                } else if (step === 8 && Math.random() > 0.45) {
                    this.synths.kick.triggerAttackRelease('C1', '16n', time, 0.38);
                }

                // Snare brushes + occasional ghost
                if (step === 4 || step === 12) {
                    this.synths.snare.triggerAttackRelease('16n', time, 0.22);
                    this.synths.snareBody.triggerAttackRelease('E3', '16n', time, 0.16);
                } else if (Math.random() > 0.88) {
                    this.synths.snare.triggerAttackRelease('32n', time, 0.08);
                }

                // Light hats
                if (step % 2 === 0) {
                    const accent = step % 4 === 0;
                    this.synths.hihat.triggerAttackRelease('16n', time, accent ? 0.1 : 0.07);
                }

                if (step === 15 && Math.random() > 0.6) {
                    this.synths.openHat.triggerAttackRelease('8n', time, 0.06);
                }

                if ((step === 2 || step === 10) && Math.random() > 0.75) {
                    this.synths.shaker.triggerAttackRelease('32n', time, 0.14);
                }
            },
            [...Array(16).keys()],
            '16n'
        );
        this.sequences.drums.start(0);

        this.startTransport();
        this.currentMusic = 'cafe';
        this.isPlaying = true;
    }

    /**
     * Play emotional/melancholic music - Touching scenes
     */
    playEmotionalMusic() {
        if (!this.initialized) return;
        this.stopAllMusic();
        this.recreateVinylCrackle();

        Tone.Transport.bpm.value = 62;
        Tone.Transport.swing = 0;

        this.startVinylCrackle();

        // Melancholic i–VI–iv–V (harmonic minor touch for tension/resolution).
        const chordProgression = [
            { bass: 'A1', chord: ['C4', 'E4', 'G4', 'B4'], pad: ['A3', 'E4'] },   // Am9 (no root)
            { bass: 'F1', chord: ['A3', 'C4', 'E4', 'G4'], pad: ['F3', 'C4'] },   // Fmaj9 (no root)
            { bass: 'D2', chord: ['F3', 'A3', 'C4', 'E4'], pad: ['D3', 'A3'] },   // Dm9 (no root)
            { bass: 'E2', chord: ['G#3', 'B3', 'D4', 'F4'], pad: ['E3', 'B3'] }   // E7 (no root)
        ];

        const oneBar = Tone.Time('1m').toSeconds();

        // Slow, emotional voicings with lots of breathing room
        let chordIndex = 0;
        this.loops.rhodes = new Tone.Loop((time) => {
            const chord = chordProgression[chordIndex % chordProgression.length];
            this._strum(this.synths.rhodes, chord.chord, '1m', time, 0.22, 0.05);

            // faint echo hit in the second bar (keeps it from feeling static)
            if (Math.random() > 0.55) {
                this._strum(this.synths.rhodes, chord.chord.slice(0, 3), '1m', time + oneBar + Math.random() * 0.02, 0.16, 0.05);
            }

            chordIndex++;
        }, '2m');
        this.loops.rhodes.start(0);

        // Rich pad
        let padIndex = 0;
        this.loops.pad = new Tone.Loop((time) => {
            const chord = chordProgression[padIndex % chordProgression.length];
            this.synths.pad.triggerAttackRelease(chord.pad, '2m', time, 0.22);
            padIndex++;
        }, '2m');
        this.loops.pad.start(0);

        // Sparse melody (mostly rests, long tails)
        const melodyPhrases = [
            [
                null, null, 'E5', null, null, null, 'D5', null,
                null, null, 'C5', null, null, 'A4', null, null,
                null, null, 'G4', null, null, null, 'A4', null,
                null, 'B4', null, null, 'C5', null, null, null,
                null, null, 'E5', null, null, 'G5', null, null,
                null, null, 'F5', null, 'E5', null, null, null,
                null, null, 'C5', null, null, 'B4', null, null,
                'A4', null, null, null, null, null, null, null
            ],
            [
                null, null, 'C5', null, null, null, 'B4', null,
                null, null, 'A4', null, null, 'G4', null, null,
                null, null, 'E5', null, null, null, 'D5', null,
                null, 'C5', null, null, null, null, null, null,
                null, null, 'E5', null, null, 'F5', null, null,
                null, null, 'D5', null, 'C5', null, null, null,
                null, null, 'B4', null, null, 'G#4', null, null,
                'A4', null, null, null, null, null, null, null
            ]
        ];

        let melodyStep = 0;
        let melodyPhrase = 0;
        this.loops.melody = new Tone.Loop((time) => {
            const phrase = melodyPhrases[melodyPhrase % melodyPhrases.length];
            const note = phrase[melodyStep % phrase.length];

            if (note) {
                this.synths.piano.triggerAttackRelease(note, '4n', time, 0.38 + Math.random() * 0.1);
            }

            melodyStep++;
            if (melodyStep % phrase.length === 0) melodyPhrase++;
        }, '8n');
        this.loops.melody.start('2m');

        // Slow bass drones (anchors the harmony)
        let bassIndex = 0;
        this.loops.bass = new Tone.Loop((time) => {
            const chord = chordProgression[bassIndex % chordProgression.length];
            this.synths.bass.triggerAttackRelease(chord.bass, '2m', time, 0.42);
            bassIndex++;
        }, '2m');
        this.loops.bass.start(0);

        // Wind chimes + occasional single koto note for texture
        const chimeNotes = ['E6', 'A6', 'B6', 'C7'];
        this.loops.chime = new Tone.Loop((time) => {
            if (Math.random() > 0.7) {
                const note = this._pick(chimeNotes);
                if (!note) return;
                this.synths.chime.triggerAttackRelease(note, '2n', time, 0.1);
            }
        }, '4m');
        this.loops.chime.start('8m');

        let kotoIndex = 0;
        this.loops.koto = new Tone.Loop((time) => {
            if (Math.random() > 0.62) {
                const chord = chordProgression[kotoIndex % chordProgression.length];
                const base = this._pick(chord.chord);
                if (!base) return;
                const note = this._transpose(base, 12);
                this.synths.koto.triggerAttack(note, time + Math.random() * 0.05, 0.16);
            }
            kotoIndex++;
        }, '2m');
        this.loops.koto.start('8m');

        this.startTransport();
        this.currentMusic = 'emotional';
        this.isPlaying = true;
    }

    /**
     * Play night/evening music - Dreamy lo-fi
     */
    playNightMusic() {
        if (!this.initialized) return;
        this.stopAllMusic();
        this.recreateVinylCrackle();

        Tone.Transport.bpm.value = 68;
        Tone.Transport.swing = 0.1;
        Tone.Transport.swingSubdivision = '16n';

        this.startVinylCrackle();

        // Dreamy progression (8 bars): Ebmaj9 – Cm9 – Abmaj9 – Bb13
        const chordProgression = [
            { bass: 'Eb2', chord: ['G3', 'Bb3', 'D4', 'F4'], pad: ['Eb3', 'Bb3'] }, // Ebmaj9 (no root)
            { bass: 'C2', chord: ['Eb3', 'G3', 'Bb3', 'D4'], pad: ['C3', 'G3'] },   // Cm9 (no root)
            { bass: 'Ab1', chord: ['C3', 'Eb3', 'G3', 'Bb3'], pad: ['Ab2', 'Eb3'] }, // Abmaj9 (no root)
            { bass: 'Bb1', chord: ['Ab3', 'C4', 'D4', 'G4'], pad: ['Bb2', 'F3'] }   // Bb13 (no root)
        ];

        const half = Tone.Time('2n').toSeconds();

        // Rhodes: light, slow comping
        let bar = 0;
        this.loops.rhodes = new Tone.Loop((time) => {
            const chord = chordProgression[Math.floor(bar / 2) % chordProgression.length];
            const isDownbeatBar = bar % 2 === 0;

            this._strum(this.synths.rhodes, chord.chord, '8n', time, isDownbeatBar ? 0.34 : 0.24, 0.016);
            if (isDownbeatBar && Math.random() > 0.55) {
                this._strum(this.synths.rhodes, chord.chord.slice(1), '8n', time + half, 0.16, 0.014);
            }

            bar++;
        }, '1m');
        this.loops.rhodes.start(0);

        // Thick dreamy pad
        let padIndex = 0;
        this.loops.pad = new Tone.Loop((time) => {
            const chord = chordProgression[padIndex % chordProgression.length];
            this.synths.pad.triggerAttackRelease(chord.pad, '2m', time, 0.2);
            padIndex++;
        }, '2m');
        this.loops.pad.start(0);

        // Celesta arpeggio (drives the "dreamy" feel without a busy melody line)
        const arpOrder = [0, 2, 1, 3, 2, 1, 0, 2];
        let arpStep = 0;
        this.loops.arp = new Tone.Loop((time) => {
            const chord = chordProgression[Math.floor(arpStep / 16) % chordProgression.length]; // 2 bars per chord @ 8n
            const chordNoteIndex = arpOrder[arpStep % arpOrder.length] % chord.chord.length;

            const base = chord.chord[chordNoteIndex];
            const note = this._transpose(base, 12 + (Math.random() > 0.9 ? 12 : 0));
            this.synths.celesta.triggerAttackRelease(note, '16n', time, 0.1 + Math.random() * 0.06);

            arpStep++;
        }, '8n');
        this.loops.arp.start('2m');

        // Bass
        let bassBar = 0;
        this.loops.bass = new Tone.Loop((time) => {
            const chord = chordProgression[Math.floor(bassBar / 2) % chordProgression.length];
            this.synths.bass.triggerAttackRelease(chord.bass, '1m', time, 0.42);

            // occasional fifth in the second bar for motion
            if (bassBar % 2 === 1 && Math.random() > 0.78) {
                this.synths.bass.triggerAttackRelease(this._transpose(chord.bass, 7), '8n', time + half, 0.24);
            }

            bassBar++;
        }, '1m');
        this.loops.bass.start(0);

        // Minimal drums (mostly kick + texture)
        this.sequences.drums = new Tone.Sequence(
            (time, step) => {
                if (step === 0 || (step === 10 && Math.random() > 0.4)) {
                    this.synths.kick.triggerAttackRelease('C1', '16n', time, step === 0 ? 0.55 : 0.35);
                }

                if (step % 4 === 0) {
                    this.synths.hihat.triggerAttackRelease('16n', time, 0.06);
                }

                if ((step === 6 || step === 14) && Math.random() > 0.7) {
                    this.synths.shaker.triggerAttackRelease('32n', time, 0.12);
                }
            },
            [...Array(16).keys()],
            '16n'
        );
        this.sequences.drums.start('4m');

        // Night chimes
        const chimeNotes = ['Bb6', 'D7', 'Eb7', 'G7', 'Ab7'];
        this.loops.chime = new Tone.Loop((time) => {
            if (Math.random() > 0.65) {
                const note = this._pick(chimeNotes);
                if (!note) return;
                this.synths.chime.triggerAttackRelease(note, '2n', time, 0.1);
            }
        }, '4m');
        this.loops.chime.start('12m');

        this.startTransport();
        this.currentMusic = 'night';
        this.isPlaying = true;
    }

    /**
     * Play tense/dramatic music
     */
    playTenseMusic() {
        if (!this.initialized) return;
        this.stopAllMusic();
        this.recreateVinylCrackle();

        Tone.Transport.bpm.value = 88;
        Tone.Transport.swing = 0;

        this.startVinylCrackle();

        // Tense minor progression: Em9 – Bm9 – Am9 – B7(b9)
        const chordProgression = [
            { bass: 'E2', chord: ['G3', 'B3', 'D4', 'F#4'] },  // Em9 (no root)
            { bass: 'B1', chord: ['D3', 'F#3', 'A3', 'C#4'] }, // Bm9 (no root)
            { bass: 'A1', chord: ['C3', 'E3', 'G3', 'B3'] },   // Am9 (no root)
            { bass: 'B1', chord: ['D#3', 'A3', 'C4', 'F4'] }   // B7(b9) (no root)
        ];

        const quarter = Tone.Time('4n').toSeconds();
        const eighth = Tone.Time('8n').toSeconds();

        // Rhodes stabs on beats 2 & 4 (higher register), gives immediate tension.
        let bar = 0;
        this.loops.rhodes = new Tone.Loop((time) => {
            const chord = chordProgression[bar % chordProgression.length];
            const high = chord.chord.map(n => this._transpose(n, 12));

            this._strum(this.synths.rhodes, high, '8n', time + quarter, 0.32, 0.01);
            if (Math.random() > 0.22) {
                this._strum(this.synths.rhodes, high.slice(1), '8n', time + 3 * quarter + (Math.random() > 0.5 ? 0 : eighth), 0.22, 0.01);
            }

            bar++;
        }, '1m');
        this.loops.rhodes.start(0);

        // Pulsing bass pattern
        let bassStep = 0;
        const bassPattern = [true, false, true, false, true, true, false, true];
        this.loops.bass = new Tone.Loop((time) => {
            const chordIndex = Math.floor(bassStep / 8) % chordProgression.length; // 1 bar per chord @ 8n
            const stepInBar = bassStep % 8;

            if (bassPattern[stepInBar]) {
                const chord = chordProgression[chordIndex];
                const nextChord = chordProgression[(chordIndex + 1) % chordProgression.length];

                let note = chord.bass;
                if (stepInBar === 5 && Math.random() > 0.55) note = this._transpose(chord.bass, 12);
                if (stepInBar === 7) note = this._transpose(nextChord.bass, -1);

                this.synths.bass.triggerAttackRelease(note, '16n', time, 0.78);
            }

            bassStep++;
        }, '8n');
        this.loops.bass.start(0);

        // Aggressive drums
        this.sequences.drums = new Tone.Sequence(
            (time, step) => {
                if (step === 0 || step === 6 || step === 8 || step === 12) {
                    this.synths.kick.triggerAttackRelease('C1', '16n', time, 0.85);
                }
                if (step === 4 || step === 12) {
                    this.synths.snare.triggerAttackRelease('16n', time, 0.52);
                    this.synths.snareBody.triggerAttackRelease('E3', '16n', time, 0.32);
                }
                this.synths.hihat.triggerAttackRelease('16n', time, 0.11 + (step % 4 === 0 ? 0.07 : 0));

                if (step === 15 && Math.random() > 0.6) {
                    this.synths.openHat.triggerAttackRelease('8n', time, 0.09);
                }
            },
            [...Array(16).keys()],
            '16n'
        );
        this.sequences.drums.start(0);

        this.startTransport();
        this.currentMusic = 'tense';
        this.isPlaying = true;
    }

    /**
     * Play upbeat/happy music - For lighthearted moments
     */
    playUpbeatMusic() {
        if (!this.initialized) return;
        this.stopAllMusic();
        this.recreateVinylCrackle();

        Tone.Transport.bpm.value = 98;
        Tone.Transport.swing = 0.12;
        Tone.Transport.swingSubdivision = '16n';

        this.startVinylCrackle();

        // Bright major progression (G): Gmaj9 – Em9 – Cmaj9 – D9
        const chordProgression = [
            { bass: 'G2', chord: ['B3', 'D4', 'F#4', 'A4'], pad: ['G3', 'D4'] }, // Gmaj9 (no root)
            { bass: 'E2', chord: ['G3', 'B3', 'D4', 'F#4'], pad: ['E3', 'B3'] }, // Em9 (no root)
            { bass: 'C2', chord: ['E3', 'G3', 'B3', 'D4'], pad: ['C3', 'G3'] },  // Cmaj9 (no root)
            { bass: 'D2', chord: ['F#3', 'C4', 'E4', 'A4'], pad: ['D3', 'A3'] }  // D9 (no root)
        ];

        const half = Tone.Time('2n').toSeconds();
        const quarter = Tone.Time('4n').toSeconds();

        // Rhodes comping: punchy but still VN-friendly
        let bar = 0;
        this.loops.rhodes = new Tone.Loop((time) => {
            const chord = chordProgression[bar % chordProgression.length];

            this._strum(this.synths.rhodes, chord.chord, '8n', time, 0.44, 0.012);
            this._strum(this.synths.rhodes, chord.chord.slice(1), '8n', time + half, 0.3, 0.011);

            if (Math.random() > 0.72) {
                this._strum(this.synths.rhodes, chord.chord.slice(0, 3), '16n', time + quarter, 0.2, 0.01);
            }

            bar++;
        }, '1m');
        this.loops.rhodes.start(0);

        // Bouncy motif (G major pentatonic) – longer phrases = less obvious looping
        const melodyPhrases = [
            [
                'D5', 'E5', 'G5', null, 'A5', 'G5', 'E5', null,
                'D5', null, 'B4', 'D5', 'E5', null, null, null,
                'G5', 'A5', 'B5', null, 'A5', 'G5', 'E5', 'D5',
                'E5', null, 'G5', null, 'A5', null, null, null
            ],
            [
                'B4', 'D5', 'E5', null, 'G5', 'E5', 'D5', null,
                'A4', null, 'B4', 'D5', null, 'E5', null, null,
                'D5', 'E5', 'G5', null, 'A5', 'G5', 'E5', null,
                'D5', null, null, null, null, null, null, null
            ]
        ];

        let melodyStep = 0;
        let melodyPhrase = 0;
        this.loops.melody = new Tone.Loop((time) => {
            const phrase = melodyPhrases[melodyPhrase % melodyPhrases.length];
            const note = phrase[melodyStep % phrase.length];

            if (note && Math.random() > 0.06) {
                this.synths.piano.triggerAttackRelease(note, '8n', time, 0.52 + Math.random() * 0.16);
            }

            melodyStep++;
            if (melodyStep % phrase.length === 0) melodyPhrase++;
        }, '8n');
        this.loops.melody.start('2m');

        // Bouncy bass
        let bassStep = 0;
        this.loops.bass = new Tone.Loop((time) => {
            const chordIndex = Math.floor(bassStep / 4) % chordProgression.length; // 1 bar per chord @ 4n
            const stepInBar = bassStep % 4;
            const chord = chordProgression[chordIndex];
            const nextChord = chordProgression[(chordIndex + 1) % chordProgression.length];

            const shouldPlay = stepInBar % 2 === 0;
            if (shouldPlay) {
                let note = chord.bass;
                if (stepInBar === 2) note = Math.random() > 0.6 ? this._transpose(chord.bass, 12) : this._transpose(chord.bass, 7);
                if (stepInBar === 3 && Math.random() > 0.7) note = this._transpose(nextChord.bass, -1);
                this.synths.bass.triggerAttackRelease(note, '8n', time, 0.72);
            }

            bassStep++;
        }, '4n');
        this.loops.bass.start(0);

        // Upbeat drums
        let drumBar = 0;
        this.sequences.drums = new Tone.Sequence(
            (time, step) => {
                if (step === 0) drumBar++;
                const isFillBar = drumBar > 0 && drumBar % 8 === 0;

                if (step === 0 || step === 8) {
                    this.synths.kick.triggerAttackRelease('C1', '16n', time, 0.85);
                } else if (isFillBar && (step === 14 || step === 15)) {
                    this.synths.kick.triggerAttackRelease('C1', '16n', time, 0.3);
                }
                if (step === 4 || step === 12) {
                    this.synths.snare.triggerAttackRelease('16n', time, 0.5);
                    this.synths.snareBody.triggerAttackRelease('D3', '16n', time, 0.34);
                }
                // Driving hi-hats
                this.synths.hihat.triggerAttackRelease('16n', time, 0.15 + (step % 2 === 0 ? 0.05 : 0));

                if (step === 6 || step === 14) {
                    this.synths.shaker.triggerAttackRelease('32n', time, 0.24);
                }

                if (isFillBar && step === 15 && Math.random() > 0.5) {
                    this.synths.openHat.triggerAttackRelease('8n', time, 0.09);
                }
            },
            [...Array(16).keys()],
            '16n'
        );
        this.sequences.drums.start('1m');

        // Sparkly celesta
        const celestaNotes = ['G6', 'A6', 'B6', 'D7', 'E7'];
        this.loops.celesta = new Tone.Loop((time) => {
            if (Math.random() > 0.55) {
                const note = this._pick(celestaNotes);
                if (!note) return;
                this.synths.celesta.triggerAttackRelease(note, '8n', time, 0.14);
            }
        }, '2m');
        this.loops.celesta.start('4m');

        // Light pad support (brings warmth without clutter)
        let padIndex = 0;
        this.loops.pad = new Tone.Loop((time) => {
            const chord = chordProgression[padIndex % chordProgression.length];
            this.synths.pad.triggerAttackRelease(chord.pad, '2m', time, 0.16);
            padIndex++;
        }, '2m');
        this.loops.pad.start('4m');

        this.startTransport();
        this.currentMusic = 'upbeat';
        this.isPlaying = true;
    }

    /**
     * Play chill/relaxed music - For peaceful exploration
     */
    playChillMusic() {
        if (!this.initialized) return;
        this.stopAllMusic();
        this.recreateVinylCrackle();

        Tone.Transport.bpm.value = 65;
        Tone.Transport.swing = 0.1;
        Tone.Transport.swingSubdivision = '16n';

        this.startVinylCrackle();

        // Chill progression (8 bars): Bbmaj9 – Gm9 – Ebmaj9 – F13
        const chordProgression = [
            { bass: 'Bb1', chord: ['D3', 'F3', 'A3', 'C4'], pad: ['Bb2', 'F3'] }, // Bbmaj9 (no root)
            { bass: 'G1', chord: ['Bb2', 'D3', 'F3', 'A3'], pad: ['G2', 'D3'] },  // Gm9 (no root)
            { bass: 'Eb1', chord: ['G2', 'Bb2', 'D3', 'F3'], pad: ['Eb2', 'Bb2'] }, // Ebmaj9 (no root)
            { bass: 'F1', chord: ['A2', 'Eb3', 'G3', 'D4'], pad: ['F2', 'C3'] }   // F13 (no root)
        ];

        const half = Tone.Time('2n').toSeconds();
        const quarter = Tone.Time('4n').toSeconds();

        // Rhodes: slow comping
        let bar = 0;
        this.loops.rhodes = new Tone.Loop((time) => {
            const chord = chordProgression[Math.floor(bar / 2) % chordProgression.length];
            const isDownbeatBar = bar % 2 === 0;

            this._strum(this.synths.rhodes, chord.chord, '8n', time, isDownbeatBar ? 0.34 : 0.24, 0.016);
            if (isDownbeatBar && Math.random() > 0.2) {
                this._strum(this.synths.rhodes, chord.chord.slice(1), '8n', time + half, 0.18, 0.014);
            } else if (!isDownbeatBar && Math.random() > 0.78) {
                this._strum(this.synths.rhodes, chord.chord.slice(0, 3), '8n', time + quarter, 0.16, 0.012);
            }

            bar++;
        }, '1m');
        this.loops.rhodes.start(0);

        // Lush pad
        let padIndex = 0;
        this.loops.pad = new Tone.Loop((time) => {
            const chord = chordProgression[padIndex % chordProgression.length];
            this.synths.pad.triggerAttackRelease(chord.pad, '2m', time, 0.2);
            padIndex++;
        }, '2m');
        this.loops.pad.start(0);

        // Laid-back motif (Bb major pentatonic)
        const melodyPhrases = [
            [
                'F4', null, null, 'D4', null, null, null, null,
                'Bb4', null, null, 'C5', null, null, 'D5', null,
                'F4', null, null, 'G4', null, null, 'F4', null,
                null, null, null, null, null, null, null, null
            ],
            [
                'D4', null, null, 'F4', null, null, null, null,
                'G4', null, null, 'F4', null, null, 'D4', null,
                'C4', null, null, 'D4', null, null, 'Bb3', null,
                null, null, null, null, null, null, null, null
            ]
        ];

        let melodyStep = 0;
        let melodyPhrase = 0;
        this.loops.melody = new Tone.Loop((time) => {
            const phrase = melodyPhrases[melodyPhrase % melodyPhrases.length];
            const note = phrase[melodyStep % phrase.length];

            if (note && Math.random() > 0.12) {
                this.synths.piano.triggerAttackRelease(note, '4n', time, 0.34 + Math.random() * 0.12);
            }

            melodyStep++;
            if (melodyStep % phrase.length === 0) melodyPhrase++;
        }, '8n');
        this.loops.melody.start('4m');

        // Slow walking bass
        let bassStep = 0;
        this.loops.bass = new Tone.Loop((time) => {
            const chordIndex = Math.floor(bassStep / 8) % chordProgression.length; // 2 bars per chord @ 4n
            const stepInChord = bassStep % 8;
            const chord = chordProgression[chordIndex];
            const nextChord = chordProgression[(chordIndex + 1) % chordProgression.length];

            const shouldPlay = stepInChord % 2 === 0;
            if (shouldPlay) {
                let note = chord.bass;
                if (stepInChord === 2) note = this._transpose(chord.bass, 7);
                if (stepInChord === 6) note = this._transpose(nextChord.bass, -1);
                this.synths.bass.triggerAttackRelease(note, '8n', time, 0.46);
            }

            bassStep++;
        }, '4n');
        this.loops.bass.start(0);

        // Super chill drums
        let drumBar = 0;
        this.sequences.drums = new Tone.Sequence(
            (time, step) => {
                if (step === 0) drumBar++;
                const isFillBar = drumBar > 0 && drumBar % 8 === 0;

                if (step === 0) {
                    this.synths.kick.triggerAttackRelease('C1', '8n', time, 0.5);
                } else if (step === 8 && Math.random() > 0.5) {
                    this.synths.kick.triggerAttackRelease('C1', '16n', time, 0.25);
                }

                if (step === 12 && Math.random() > 0.5) {
                    this.synths.snare.triggerAttackRelease('16n', time, 0.18);
                }

                if (step % 4 === 0) {
                    this.synths.hihat.triggerAttackRelease('16n', time, 0.06);
                }

                if (isFillBar && step === 15 && Math.random() > 0.6) {
                    this.synths.openHat.triggerAttackRelease('8n', time, 0.06);
                }
            },
            [...Array(16).keys()],
            '16n'
        );
        this.sequences.drums.start('4m');

        // Soft chimes
        const chimeNotes = ['Bb6', 'C7', 'D7', 'F7'];
        this.loops.chime = new Tone.Loop((time) => {
            if (Math.random() > 0.7) {
                const note = this._pick(chimeNotes);
                if (!note) return;
                this.synths.chime.triggerAttackRelease(note, '2n', time, 0.09);
            }
        }, '4m');
        this.loops.chime.start('12m');

        this.startTransport();
        this.currentMusic = 'chill';
        this.isPlaying = true;
    }

    // File-based BGM overrides (replace synthesized music for all mood keys)
    playMenuMusic(fadeInSeconds = 0) {
        this._playAssetBgm('menu', fadeInSeconds);
    }

    playClassroomMusic(fadeInSeconds = 0) {
        this._playAssetBgm('classroom', fadeInSeconds);
    }

    playCafeMusic(fadeInSeconds = 0) {
        this._playAssetBgm('cafe', fadeInSeconds);
    }

    playEmotionalMusic(fadeInSeconds = 0) {
        this._playAssetBgm('emotional', fadeInSeconds);
    }

    playNightMusic(fadeInSeconds = 0) {
        this._playAssetBgm('night', fadeInSeconds);
    }

    playTenseMusic(fadeInSeconds = 0) {
        this._playAssetBgm('tense', fadeInSeconds);
    }

    playUpbeatMusic(fadeInSeconds = 0) {
        this._playAssetBgm('upbeat', fadeInSeconds);
    }

    playChillMusic(fadeInSeconds = 0) {
        this._playAssetBgm('chill', fadeInSeconds);
    }

    /**
     * Fade to game music based on story
     */
    fadeToGameMusic(storyId) {
        if (!this.initialized) return;
        this.fadeOutMusic(() => {
            this.playGameMusic(storyId);
        });
    }

    /**
     * Normalize story IDs/moods into the internal music key we track in `currentMusic`.
     */
    _resolveMusicKey(storyIdOrMood) {
        if (!storyIdOrMood) return null;

        const key = String(storyIdOrMood);

        // Mood keys
        const moods = new Set([
            'menu',
            'classroom',
            'cafe',
            'emotional',
            'night',
            'tense',
            'upbeat',
            'chill'
        ]);
        if (moods.has(key)) return key;
        if (key === 'calm') return 'chill';

        // Story IDs map to their default mood
        switch (key) {
            case 'story0': return 'classroom';
            case 'story1': return 'cafe';
            case 'story2': return 'night';
            case 'story3': return 'tense';
            case 'story4': return 'emotional';
            case 'story5': return 'upbeat';
            default: return null;
        }
    }

    /**
     * Play in-game music based on story or mood
     */
    playGameMusic(storyIdOrMood, fadeIn = false) {
        if (!this.initialized) return;

        // If the requested music is already playing, don't restart (prevents layering/CPU creep).
        const desiredKey = this._resolveMusicKey(storyIdOrMood);
        if (desiredKey && this.isPlaying && this.currentMusic === desiredKey) {
            const shouldFadeIn = !!fadeIn;
            const fadeSeconds = typeof fadeIn === 'number' ? fadeIn : 1.2;
            if (shouldFadeIn && this.musicGain) {
                this.musicGain.gain.rampTo(this.musicVolume, fadeSeconds);
            }
            return;
        }

        const shouldFadeIn = !!fadeIn;
        const fadeSeconds = typeof fadeIn === 'number' ? fadeIn : 1.2;
        if (shouldFadeIn && this.musicGain) {
            this.musicGain.gain.value = 0;
        }

        // Check if it's a mood string
        if (typeof storyIdOrMood === 'string') {
            let started = true;
            switch (storyIdOrMood) {
                case 'menu':
                    this.playMenuMusic(shouldFadeIn ? fadeSeconds : 0);
                    break;
                case 'classroom':
                    this.playClassroomMusic(shouldFadeIn ? fadeSeconds : 0);
                    break;
                case 'calm':
                    this.playChillMusic(shouldFadeIn ? fadeSeconds : 0);
                    break;
                case 'cafe':
                    this.playCafeMusic(shouldFadeIn ? fadeSeconds : 0);
                    break;
                case 'emotional':
                    this.playEmotionalMusic(shouldFadeIn ? fadeSeconds : 0);
                    break;
                case 'night':
                    this.playNightMusic(shouldFadeIn ? fadeSeconds : 0);
                    break;
                case 'tense':
                    this.playTenseMusic(shouldFadeIn ? fadeSeconds : 0);
                    break;
                case 'upbeat':
                    this.playUpbeatMusic(shouldFadeIn ? fadeSeconds : 0);
                    break;
                case 'chill':
                    this.playChillMusic(shouldFadeIn ? fadeSeconds : 0);
                    break;
                default:
                    started = false;
            }

            if (started) {
                if (shouldFadeIn && this.musicGain) {
                    this.musicGain.gain.rampTo(this.musicVolume, fadeSeconds);
                }
                return;
            }
        }

        // Story-based music selection
        switch (storyIdOrMood) {
            case 'story0':
                this.playClassroomMusic(shouldFadeIn ? fadeSeconds : 0);
                break;
            case 'story1':
                this.playCafeMusic(shouldFadeIn ? fadeSeconds : 0);
                break;
            case 'story2':
                this.playNightMusic(shouldFadeIn ? fadeSeconds : 0);
                break;
            case 'story3':
                this.playTenseMusic(shouldFadeIn ? fadeSeconds : 0);
                break;
            case 'story4':
                this.playEmotionalMusic(shouldFadeIn ? fadeSeconds : 0);
                break;
            case 'story5':
                this.playUpbeatMusic(shouldFadeIn ? fadeSeconds : 0);
                break;
            default:
                this.playClassroomMusic(shouldFadeIn ? fadeSeconds : 0);
        }

        if (shouldFadeIn && this.musicGain) {
            this.musicGain.gain.rampTo(this.musicVolume, fadeSeconds);
        }
    }

    /**
     * Fade to menu music
     */
    fadeToMenuMusic() {
        this.fadeOutMusic(() => {
            this.playMenuMusic();
        });
    }

    /**
     * Fade out current music
     */
    fadeOutMusic(callback) {
        if (this.currentBgmAudio) {
            this._clearBgmFade();

            const audio = this.currentBgmAudio;
            const startVolume = audio.volume;
            const fadeMs = 1500;
            const stepMs = 50;
            const steps = Math.max(1, Math.floor(fadeMs / stepMs));
            const delta = startVolume / steps;
            let current = startVolume;

            this.bgmFadeInterval = setInterval(() => {
                current = Math.max(0, current - delta);
                if (this.currentBgmAudio === audio) {
                    this.currentBgmAudio.volume = current;
                }

                if (current <= 0) {
                    this._clearBgmFade();
                    this.stopAllMusic();
                    if (callback) callback();
                }
            }, stepMs);

            return;
        }

        const fadeGain = this.musicGain || this.masterGain;
        if (!fadeGain) {
            if (callback) callback();
            return;
        }

        const currentGain = fadeGain.gain.value;
        fadeGain.gain.rampTo(0, 1.5);

        setTimeout(() => {
            this.stopAllMusic();
            fadeGain.gain.value = currentGain;
            if (callback) callback();
        }, 1600);
    }

    /**
     * Stop all music
     */
    stopAllMusic() {
        this._clearBgmFade();

        // Set isPlaying = false FIRST so the pause-guard on the Audio element
        // does not race and accidentally restart the track.
        this.isPlaying = false;
        this.currentMusic = null;

        if (this.currentBgmAudio) {
            try {
                this.currentBgmAudio._intentionallyStopped = true;
                this.currentBgmAudio.pause();
                this.currentBgmAudio.currentTime = 0;
            } catch (e) {
                // ignore
            }
            this.currentBgmAudio = null;
        }

        // Stop vinyl crackle (will be recreated on next music start)
        this.stopVinylCrackle();

        // Stop and dispose all sequences and loops
        this.stopAllSequences();

        // Release any sustained notes so voices don't pile up across transitions
        try {
            for (const synth of Object.values(this.synths)) {
                if (!synth) continue;
                if (typeof synth.releaseAll === 'function') synth.releaseAll();
                if (typeof synth.triggerRelease === 'function') synth.triggerRelease();
            }
        } catch {
            // ignore
        }

        // Reset transport after stopping loops (ensures we don't leave scheduled events behind)
        this.resetTransport();
    }

    /**
     * Play sound effect using pooled synths
     */
    playSFX(type) {
        if (!this.initialized) return;

        const sfxSynth = this.getSFXSynth();
        sfxSynth.oscillator.type = 'sine';

        switch (type) {
            case 'click':
                sfxSynth.triggerAttackRelease('G5', '32n');
                break;
            case 'select':
                sfxSynth.triggerAttackRelease('C5', '16n');
                setTimeout(() => sfxSynth.triggerAttackRelease('E5', '16n'), 40);
                setTimeout(() => sfxSynth.triggerAttackRelease('G5', '16n'), 80);
                break;
            case 'page':
                sfxSynth.triggerAttackRelease('E4', '32n');
                setTimeout(() => sfxSynth.triggerAttackRelease('A4', '32n'), 30);
                break;
            case 'vocab':
                sfxSynth.triggerAttackRelease('A4', '16n');
                setTimeout(() => sfxSynth.triggerAttackRelease('C5', '16n'), 60);
                setTimeout(() => sfxSynth.triggerAttackRelease('E5', '16n'), 120);
                setTimeout(() => sfxSynth.triggerAttackRelease('A5', '8n'), 180);
                break;
            case 'save':
                sfxSynth.triggerAttackRelease('E4', '8n');
                setTimeout(() => sfxSynth.triggerAttackRelease('A4', '8n'), 80);
                setTimeout(() => sfxSynth.triggerAttackRelease('C5', '4n'), 160);
                break;
            case 'error':
                sfxSynth.triggerAttackRelease('E3', '16n');
                setTimeout(() => sfxSynth.triggerAttackRelease('C3', '8n'), 100);
                break;
            case 'success':
                sfxSynth.triggerAttackRelease('C5', '16n');
                setTimeout(() => sfxSynth.triggerAttackRelease('E5', '16n'), 50);
                setTimeout(() => sfxSynth.triggerAttackRelease('G5', '16n'), 100);
                setTimeout(() => sfxSynth.triggerAttackRelease('C6', '4n'), 150);
                break;
            case 'notification':
                sfxSynth.triggerAttackRelease('G5', '16n');
                setTimeout(() => sfxSynth.triggerAttackRelease('D5', '16n'), 120);
                break;
            case 'heartbeat':
                sfxSynth.oscillator.type = 'triangle';
                sfxSynth.triggerAttackRelease('C2', '8n');
                setTimeout(() => sfxSynth.triggerAttackRelease('C2', '16n'), 200);
                break;
            case 'correct':
                sfxSynth.triggerAttackRelease('E5', '16n');
                setTimeout(() => sfxSynth.triggerAttackRelease('G5', '8n'), 80);
                break;
            case 'wrong':
                sfxSynth.triggerAttackRelease('Bb3', '8n');
                break;
            case 'levelup':
                sfxSynth.triggerAttackRelease('C5', '16n');
                setTimeout(() => sfxSynth.triggerAttackRelease('E5', '16n'), 60);
                setTimeout(() => sfxSynth.triggerAttackRelease('G5', '16n'), 120);
                setTimeout(() => sfxSynth.triggerAttackRelease('C6', '16n'), 180);
                setTimeout(() => sfxSynth.triggerAttackRelease('E6', '4n'), 240);
                break;
        }
    }

    /**
     * Set master volume
     */
    setMasterVolume(value) {
        const v = Math.max(0, Math.min(1, value));
        this.masterVolume = v;
        if (this.masterGain) {
            this.masterGain.gain.rampTo(v, 0.1);
        }
    }

    /**
     * Set music volume
     */
    setMusicVolume(value) {
        const v = Math.max(0, Math.min(1, value));
        this.musicVolume = v;

        if (this.currentBgmAudio) {
            this.currentBgmAudio.volume = v;
        }

        if (this.musicGain) {
            this.musicGain.gain.rampTo(v, 0.1);
        }
    }

    /**
     * Set SFX volume
     */
    setSFXVolume(value) {
        const v = Math.max(0, Math.min(1, value));
        this.sfxVolume = v;
        if (this.sfxGain) {
            this.sfxGain.gain.rampTo(v, 0.1);
        }
    }

    /**
     * Set voice volume (for future VO)
     */
    setVoiceVolume(value) {
        const v = Math.max(0, Math.min(1, value));
        this.voiceVolume = v;
        if (this.voiceGain) {
            this.voiceGain.gain.rampTo(v, 0.1);
        }
    }

    /**
     * Set vinyl crackle intensity (0 = off, 1 = full lo-fi)
     */
    setVinylIntensity(value) {
        if (value === 0) {
            this.stopVinylCrackle();
            return;
        }
        if (this.vinylState.gain) {
            this.vinylState.gain.gain.value = value * 0.015;  // Much lower max
        }
        if (this.vinylState.highGain) {
            this.vinylState.highGain.gain.value = value * 0.004;
        }
    }

    /**
     * Toggle VN mode (clean audio) vs Lo-fi mode (vinyl crackle, heavier drums)
     */
    setVNMode(enabled) {
        this.vnMode = !!enabled;
        this.applySoundProfile();

        if (this.vnMode) {
            this.stopVinylCrackle();
            return;
        }

        // If switching to lo-fi mid-play, rebuild the vinyl nodes and start them.
        if (this.isPlaying) {
            this.recreateVinylCrackle();
            this.startVinylCrackle();
        }
    }

    /**
     * Mute/unmute
     */
    toggleMute() {
        if (this.masterGain) {
            const currentValue = this.masterGain.gain.value;
            if (currentValue > 0) {
                this._previousVolume = currentValue;
                this.masterGain.gain.rampTo(0, 0.1);
            } else {
                this.masterGain.gain.rampTo(this._previousVolume || this.masterVolume, 0.1);
            }
        }
    }

    /**
     * Check if audio is muted
     */
    isMuted() {
        return this.masterGain && this.masterGain.gain.value === 0;
    }

    /**
     * Get current music type
     */
    getCurrentMusic() {
        return this.currentMusic;
    }

    /**
     * Clean up all audio resources
     */
    dispose() {
        this.stopAllMusic();
        this._clearBgmFade();

        // Dispose vinyl crackle system
        this.disposeVinylCrackle();

        // Dispose SFX pool
        this.sfxPool.forEach(sfx => {
            try { sfx.synth.dispose(); } catch (e) { /* ignore */ }
        });
        this.sfxPool = [];

        // Dispose synths
        for (const key of Object.keys(this.synths)) {
            if (this.synths[key]) {
                try { this.synths[key].dispose(); } catch (e) { /* ignore */ }
            }
        }
        this.synths = {};

        // Dispose effects
        for (const key of Object.keys(this.effects)) {
            if (this.effects[key]) {
                try { this.effects[key].dispose(); } catch (e) { /* ignore */ }
            }
        }
        this.effects = {};

        // Dispose buses
        if (this.musicGain) {
            try { this.musicGain.dispose(); } catch (e) { /* ignore */ }
            this.musicGain = null;
        }
        if (this.sfxGain) {
            try { this.sfxGain.dispose(); } catch (e) { /* ignore */ }
            this.sfxGain = null;
        }
        if (this.voiceGain) {
            try { this.voiceGain.dispose(); } catch (e) { /* ignore */ }
            this.voiceGain = null;
        }

        // Dispose master gain
        if (this.masterGain) {
            try { this.masterGain.dispose(); } catch (e) { /* ignore */ }
            this.masterGain = null;
        }

        this.initialized = false;
    }
}
