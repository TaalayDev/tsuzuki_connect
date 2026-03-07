import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/subscription_service.dart';

// ---------------------------------------------------------------------------
// Custom scheme used to serve web assets without a local HTTP server.
// All asset URLs look like:  tsuzuki://css/main.css
//                            tsuzuki://js/main.js
//                            tsuzuki://assets/characters/tanaka_neutral.png
// ---------------------------------------------------------------------------
const _kScheme = 'tsuzuki';
const _kHost = 'index.html'; // The virtual "host" for the entry point

String _mimeType(String path) {
  final ext = path.split('.').last.toLowerCase();
  return switch (ext) {
    'html' => 'text/html',
    'css' => 'text/css',
    'js' => 'application/javascript',
    'json' => 'application/json',
    'png' => 'image/png',
    'jpg' || 'jpeg' => 'image/jpeg',
    'gif' => 'image/gif',
    'svg' => 'image/svg+xml',
    'webp' => 'image/webp',
    'ico' => 'image/x-icon',
    'woff' => 'font/woff',
    'woff2' => 'font/woff2',
    'ttf' => 'font/ttf',
    'otf' => 'font/otf',
    'mp3' => 'audio/mpeg',
    'ogg' => 'audio/ogg',
    'wav' => 'audio/wav',
    'mp4' => 'video/mp4',
    _ => 'application/octet-stream',
  };
}

// JavaScript shim injected at document-start.
// Intercepts fetch() and HTMLMediaElement.src for tsuzuki:// audio files,
// loads them via the Flutter bridge, and substitutes blob:// URLs so that
// AVFoundation (macOS/iOS media pipeline) never has to range-fetch a custom
// scheme (which it cannot do without a real HTTP 206 response).
const _kAudioBridgeScript = r"""
(function () {
  const isMedia = (u) => /\.(mp3|ogg|wav|m4a|aac|flac)(\?.*)?$/i.test(u);
  // Returns the normalized absolute URL if it belongs to our custom scheme.
  const getTsuzukiUrl = (rawUrl) => {
    if (typeof rawUrl !== 'string') return null;
    try {
      const url = new URL(rawUrl, window.location.href);
      return url.protocol === 'tsuzuki:' ? url.href : null;
    } catch { return null; }
  };
  const mimeOf = (u) => {
    const ext = u.split('.').pop().split('?')[0].toLowerCase();
    return ({mp3:'audio/mpeg',ogg:'audio/ogg',wav:'audio/wav',
             m4a:'audio/mp4',aac:'audio/aac',flac:'audio/flac'})[ext] || 'audio/mpeg';
  };

  // Cache blob URLs so each audio file is only fetched once.
  const _cache = {};
  async function toBlobUrl(rawUrl) {
    const url = getTsuzukiUrl(rawUrl);
    if (!url) throw new Error('Not a tsuzuki URL');

    if (_cache[url]) return _cache[url];
    const b64 = await window.flutter_inappwebview.callHandler('_fetchAssetBase64', url);
    if (!b64) throw new Error('empty response');
    const bin = atob(b64);
    const bytes = new Uint8Array(bin.length);
    for (let i = 0; i < bin.length; i++) bytes[i] = bin.charCodeAt(i);
    const blobUrl = URL.createObjectURL(new Blob([bytes], {type: mimeOf(url)}));
    _cache[url] = blobUrl;
    return blobUrl;
  }

  // 1. Patch window.fetch so Tone.js / Web Audio API fetch() calls work.
  const _origFetch = window.fetch.bind(window);
  window.fetch = async function (input, init) {
    const rawUrl = (input instanceof Request) ? input.url : String(input);
    const tzUrl = getTsuzukiUrl(rawUrl);
    if (tzUrl && isMedia(tzUrl)) {
      try { return _origFetch(await toBlobUrl(tzUrl), init); }
      catch (e) { console.warn('[tsuzuki] fetch audio bridge failed:', tzUrl, e); }
    }
    return _origFetch(input, init);
  };

  // 2. Patch HTMLMediaElement.prototype.src so that any <audio src="tsuzuki://">
  //    or el.src = 'tsuzuki://...' is swapped for a blob URL before the
  //    native media pipeline (AVFoundation on macOS/iOS) ever sees it.
  const srcDesc = Object.getOwnPropertyDescriptor(HTMLMediaElement.prototype, 'src');
  const pendingBlobSwaps = new WeakMap();

  if (srcDesc && srcDesc.set) {
    Object.defineProperty(HTMLMediaElement.prototype, 'src', {
      set(value) {
        const tzUrl = getTsuzukiUrl(value);
        if (tzUrl && isMedia(tzUrl)) {
          const promise = toBlobUrl(tzUrl)
            .then(blobUrl => { 
                // Only apply if this is still the active fetch for this element
                if (pendingBlobSwaps.get(this) === promise) {
                    srcDesc.set.call(this, blobUrl); 
                    this.load(); 
                }
            })
            .catch(() => { srcDesc.set.call(this, value); });
            
          pendingBlobSwaps.set(this, promise);
        } else {
          pendingBlobSwaps.delete(this);
          srcDesc.set.call(this, value);
        }
      },
      get: srcDesc.get,
      configurable: true,
    });
  }

  // 3. Patch HTMLMediaElement.prototype.play so it waits for any pending
  //    blob URL swap to finish first. Otherwise, swapping the src while
  //    play() is pending causes an AbortError.
  const origPlay = HTMLMediaElement.prototype.play;
  HTMLMediaElement.prototype.play = async function() {
    const promise = pendingBlobSwaps.get(this);
    if (promise) await promise;
    return origPlay.call(this);
  };

  // 4. Patch the `new Audio(url)` constructor because native constructors
  //    bypass the prototype setter on WebKit.
  const OriginalAudio = window.Audio;
  window.Audio = function(src) {
    const audio = new OriginalAudio();
    if (src != null) {
      // Bumps into our patched setter above!
      audio.src = src; 
    }
    return audio;
  };
  window.Audio.prototype = OriginalAudio.prototype;
})();
""";

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final SubscriptionService _subService = SubscriptionService();
  InAppWebViewController? _webViewController;
  StreamSubscription<bool>? _subSubscription;

  @override
  void initState() {
    super.initState();
    _subService.initialize();
    _subSubscription = _subService.premiumStream.listen((isPremium) {
      _updateJsSubscriptionStatus(isPremium);
    });
  }

  void _updateJsSubscriptionStatus(bool isPremium) {
    _webViewController?.evaluateJavascript(
      source: "if (window.updateSubscriptionStatus != null) { window.updateSubscriptionStatus($isPremium); }",
    );
  }

  Future<void> _showPurchaseDialog() async {
    if (!mounted) return;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _PurchaseSheet(subService: _subService),
    );
  }

  @override
  void dispose() {
    _subSubscription?.cancel();
    _subService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     final consoleController = TextEditingController();
      //     showDialog(
      //       context: context,
      //       builder: (ctx) => Dialog(
      //         child: Padding(
      //           padding: const EdgeInsets.all(16.0),
      //           child: ConstrainedBox(
      //             constraints: const BoxConstraints(maxWidth: 400),
      //             child: Column(
      //               mainAxisSize: MainAxisSize.min,
      //               children: [
      //                 const Text('Run console'),
      //                 TextFormField(controller: consoleController),
      //                 const SizedBox(height: 16),
      //                 ElevatedButton(
      //                   onPressed: () {
      //                     _webViewController?.evaluateJavascript(source: consoleController.text);
      //                   },
      //                   child: const Text('Run console'),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      //       ),
      //     );
      //   },
      //   child: const Icon(Icons.star),
      // ),
      body: InAppWebView(
        initialSettings: InAppWebViewSettings(
          isInspectable: true,
          javaScriptEnabled: true,
          javaScriptCanOpenWindowsAutomatically: true,
          useHybridComposition: true,
          mediaPlaybackRequiresUserGesture: false,
          // Register our custom scheme so the WebView intercepts these URLs
          // instead of trying to resolve them over the network.
          resourceCustomSchemes: [_kScheme],
        ),
        // Load the entry point via the custom scheme (no local server needed).
        initialUrlRequest: URLRequest(url: WebUri('$_kScheme://$_kHost')),
        // Inject the audio-bridge shim before any page script runs so that
        // Tone.js and plain <audio> elements get blob URLs instead of
        // tsuzuki:// URLs (which AVFoundation can't range-fetch).
        initialUserScripts: UnmodifiableListView([
          UserScript(source: _kAudioBridgeScript, injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START),
        ]),
        onWebViewCreated: (controller) {
          _webViewController = controller;
          controller.addJavaScriptHandler(
            handlerName: 'getSubscriptionStatus',
            callback: (args) => _subService.isPremium,
          );
          controller.addJavaScriptHandler(
            handlerName: 'showPurchaseDialog',
            callback: (args) async {
              await _showPurchaseDialog();
              return null;
            },
          );
          // Returns a Flutter-bundled asset as a base64 string so the JS
          // audio-bridge shim can turn it into a blob URL.
          controller.addJavaScriptHandler(
            handlerName: '_fetchAssetBase64',
            callback: (args) async {
              if (args.isEmpty) return null;
              final url = args[0] as String;
              final uri = Uri.parse(url);
              final path = Uri.decodeFull((uri.path.isNotEmpty && uri.path != '/') ? uri.path.substring(1) : uri.host);
              try {
                final data = await rootBundle.load('assets/$path');
                return base64Encode(data.buffer.asUint8List());
              } catch (e) {
                if (kDebugMode) print('[tsuzuki] fetchAssetBase64 error: $url → $e');
                return null;
              }
            },
          );
        },
        onLoadStop: (controller, url) {
          _updateJsSubscriptionStatus(_subService.isPremium);
        },
        // Serve Flutter-bundled assets for every tsuzuki:// request.
        onLoadResourceWithCustomScheme: (controller, request) async {
          try {
            // tsuzuki://index.html         → assets/index.html
            // tsuzuki://css/main.css       → assets/css/main.css
            // tsuzuki://assets/bg/foo.png  → assets/assets/bg/foo.png
            final uri = request.url;
            // tsuzuki://index.html           → host="index.html", path=""
            // tsuzuki://index.html/css/a.css → host="index.html", path="/css/a.css"
            // Use path (strip leading '/') for sub-resources; host for root.
            final path = Uri.decodeFull((uri.path.isNotEmpty && uri.path != '/') ? uri.path.substring(1) : uri.host);
            final assetPath = 'assets/$path';
            final data = await rootBundle.load(assetPath);
            return CustomSchemeResponse(
              data: data.buffer.asUint8List(),
              contentType: _mimeType(path),
              contentEncoding: 'utf-8',
            );
          } catch (e) {
            if (kDebugMode) print('[tsuzuki] Asset not found: ${request.url} → $e');
            return null;
          }
        },
        onConsoleMessage: (controller, message) {
          if (kDebugMode) print(message);
        },
        onReceivedError: (controller, request, error) {
          if (kDebugMode) print(error);
        },
        onReceivedHttpError: (controller, request, error) {
          if (kDebugMode) print(error);
        },
      ),
    );
  }
}

class _PurchaseSheet extends StatefulWidget {
  final SubscriptionService subService;
  const _PurchaseSheet({required this.subService});

  @override
  State<_PurchaseSheet> createState() => _PurchaseSheetState();
}

class _PurchaseSheetState extends State<_PurchaseSheet> with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _scale;

  bool _purchasing = false;
  bool _restoring = false;
  String? _localizedPrice;
  String? _statusMessage;
  StreamSubscription<bool>? _sub;

  _PurchaseSheetTexts get _t => _PurchaseSheetTexts.of(Localizations.localeOf(context));

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 550))..forward();
    _scale = CurvedAnimation(parent: _anim, curve: Curves.easeOutBack);
    _localizedPrice = widget.subService.localizedPrice;
    _loadLocalizedPrice();

    _sub = widget.subService.premiumStream.listen((isPremium) {
      if (isPremium && mounted) Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    _anim.dispose();
    super.dispose();
  }

  Future<void> _handlePurchase() async {
    if (_purchasing || _restoring) return;
    setState(() {
      _purchasing = true;
      _statusMessage = null;
    });
    final ok = await widget.subService.buyUnlockAll();
    if (!ok && mounted) {
      setState(() {
        _purchasing = false;
        _statusMessage = _t.purchaseFailedMessage;
      });
    }
  }

  Future<void> _handleRestore() async {
    if (_purchasing || _restoring) return;
    setState(() {
      _restoring = true;
      _statusMessage = null;
    });
    await widget.subService.restorePurchases();
    if (mounted) {
      setState(() {
        _restoring = false;
        if (!widget.subService.isPremium) {
          _statusMessage = _t.noPreviousPurchaseMessage;
        }
      });
    }
  }

  Future<void> _loadLocalizedPrice() async {
    final price = await widget.subService.fetchLocalizedPrice();
    if (!mounted || price == null || price == _localizedPrice) return;
    setState(() => _localizedPrice = price);
  }

  String get _priceBadgeText {
    print('priceBadgeText: $_localizedPrice');
    if (_localizedPrice == null) return _t.priceBadge;
    final parts = _t.priceBadge.split('  ·  ');
    if (parts.length <= 1) return _localizedPrice!;
    return '${_localizedPrice!}  ·  ${parts.sublist(1).join('  ·  ')}';
  }

  // ─── Game palette constants ───────────────────────────────────────────────
  static const _pink = Color(0xFFFF91A4); // primary pink / --color-orange-light
  static const _pinkLight = Color(0xFFFFB7C5); // --color-orange
  static const _mint = Color(0xFF98D8C8); // --color-green (accent)
  static const _brown = Color(0xFF795548); // --color-brown
  static const _brownDark = Color(0xFF3E2723); // --color-brown-dark

  /// Breakpoint helpers
  static bool _isWide(BoxConstraints c) => c.maxWidth >= 600;
  static bool _isDesktop(BoxConstraints c) => c.maxWidth >= 900;

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = _isWide(constraints);
          final desktop = _isDesktop(constraints);

          final double hPad = desktop ? 0 : 16;
          final double vPad = desktop ? 0 : 32;
          final double borderRadius = desktop ? 32 : 28;
          final double maxWidth = desktop ? 860.0 : (wide ? 560.0 : double.infinity);

          return Align(
            alignment: desktop ? Alignment.center : Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.fromLTRB(hPad, desktop ? 24 : 0, hPad, vPad),
              constraints: BoxConstraints(maxWidth: maxWidth),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                // Frosted-glass cream/white gradient — matches web UI left panel
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFF8FA), Color(0xFFFDF0F3)],
                ),
                boxShadow: [
                  BoxShadow(color: _pink.withAlpha(77), blurRadius: 40, spreadRadius: 4),
                  BoxShadow(color: Colors.black.withAlpha(18), blurRadius: 16, offset: const Offset(0, 8)),
                ],
                border: Border.all(color: _pinkLight.withAlpha(120), width: 1.5),
              ),
              child: wide ? _buildWideLayout(context, constraints, desktop) : _buildNarrowLayout(context),
            ),
          );
        },
      ),
    );
  }

  // ─── Narrow / Portrait phone layout ──────────────────────────────────────
  Widget _buildNarrowLayout(BuildContext context) {
    final busy = _purchasing || _restoring;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _dragHandle(),
          _iconBadge(80, 40),
          const SizedBox(height: 24),
          _headline(26),
          const SizedBox(height: 8),
          _subtitle(15),
          const SizedBox(height: 28),
          ..._featureRows(14),
          const SizedBox(height: 32),
          _priceBadge(),
          const SizedBox(height: 20),
          if (_statusMessage != null) _statusText(),
          _purchaseButton(busy, double.infinity, 56, 17),
          const SizedBox(height: 12),
          _restoreButton(busy, double.infinity, 48),
          const SizedBox(height: 10),
          _notNowButton(busy, context),
          const SizedBox(height: 6),
          _legalRow(),
        ],
      ),
    );
  }

  // ─── Wide / Landscape / Tablet / Desktop layout ───────────────────────────
  Widget _buildWideLayout(BuildContext context, BoxConstraints constraints, bool desktop) {
    final busy = _purchasing || _restoring;
    final double vPadding = desktop ? 48 : 32;
    final double hPadding = desktop ? 48 : 32;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: vPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Left column: branding + features ──
          Expanded(
            flex: desktop ? 5 : 4,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _iconBadge(desktop ? 96 : 76, desktop ? 48 : 38),
                  const SizedBox(height: 20),
                  _headline(desktop ? 30 : 24, textAlign: TextAlign.left),
                  const SizedBox(height: 8),
                  _subtitle(desktop ? 15 : 14, textAlign: TextAlign.left),
                  const SizedBox(height: 24),
                  ..._featureRows(desktop ? 15 : 13),
                ],
              ),
            ),
          ),

          SizedBox(width: desktop ? 48 : 32),

          // ── Right column: pricing + actions ──
          Expanded(
            flex: desktop ? 4 : 5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _priceBadge(),
                const SizedBox(height: 20),
                if (_statusMessage != null) _statusText(),
                _purchaseButton(busy, double.infinity, 56, 16),
                const SizedBox(height: 12),
                _restoreButton(busy, double.infinity, 48),
                const SizedBox(height: 10),
                _notNowButton(busy, context),
                const SizedBox(height: 8),
                _legalRow(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Shared sub-widgets ───────────────────────────────────────────────────

  Widget _dragHandle() => Container(
    width: 40,
    height: 4,
    margin: const EdgeInsets.only(bottom: 28),
    decoration: BoxDecoration(color: _pinkLight.withAlpha(120), borderRadius: BorderRadius.circular(2)),
  );

  Widget _iconBadge(double size, double iconSize) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: const LinearGradient(colors: [_pinkLight, _pink], begin: Alignment.topLeft, end: Alignment.bottomRight),
      boxShadow: [BoxShadow(color: _pink.withAlpha(100), blurRadius: 16, spreadRadius: 2)],
    ),
    child: Icon(Icons.auto_stories_rounded, color: Colors.white, size: iconSize),
  );

  Widget _headline(double fontSize, {TextAlign textAlign = TextAlign.center}) => Text(
    _t.unlockFullStoryTitle,
    textAlign: textAlign,
    style: TextStyle(color: _brownDark, fontSize: fontSize, fontWeight: FontWeight.w800, letterSpacing: -0.3),
  );

  Widget _subtitle(double fontSize, {TextAlign textAlign = TextAlign.center}) => Text(
    _t.unlockFullStorySubtitle,
    textAlign: textAlign,
    style: TextStyle(color: _brown.withAlpha(180), fontSize: fontSize, height: 1.5),
  );

  List<Widget> _featureRows(double fontSize) => _t.features
      .map(
        (f) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              // Mint green check — matches --color-green accent
              const Icon(Icons.check_circle_rounded, color: _mint, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  f,
                  style: TextStyle(color: _brown, fontSize: fontSize),
                ),
              ),
            ],
          ),
        ),
      )
      .toList();

  Widget _priceBadge() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
    decoration: BoxDecoration(
      color: _pinkLight.withAlpha(40),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: _pink.withAlpha(100)),
    ),
    child: Text(
      _priceBadgeText,
      textAlign: TextAlign.center,
      style: const TextStyle(color: _brown, fontSize: 13),
    ),
  );

  Widget _statusText() => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      _statusMessage!,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Color(0xFFE57373), fontSize: 13),
    ),
  );

  Widget _purchaseButton(bool busy, double width, double height, double fontSize) => SizedBox(
    width: width,
    height: height,
    child: ElevatedButton(
      onPressed: busy ? null : _handlePurchase,
      style: ElevatedButton.styleFrom(
        // Pink gradient via the overlay trick
        backgroundColor: _pink,
        foregroundColor: Colors.white,
        disabledBackgroundColor: _pinkLight.withAlpha(120),
        elevation: 0,
        shadowColor: _pink.withAlpha(80),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
      child: _purchasing
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
            )
          : Text(
              _t.unlockAllStoriesCta,
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w700, letterSpacing: 0.5),
            ),
    ),
  );

  Widget _restoreButton(bool busy, double width, double height) => SizedBox(
    width: width,
    height: height,
    child: OutlinedButton(
      onPressed: busy ? null : _handleRestore,
      style: OutlinedButton.styleFrom(
        foregroundColor: _brown,
        side: BorderSide(color: _pink.withAlpha(120)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
      child: _restoring
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(color: _brown.withAlpha(180), strokeWidth: 2.0),
            )
          : Text(_t.restorePurchasesCta, style: const TextStyle(fontSize: 15)),
    ),
  );

  Widget _notNowButton(bool busy, BuildContext context) => TextButton(
    onPressed: busy ? null : () => Navigator.of(context).pop(),
    child: Text(_t.notNowCta, style: TextStyle(color: _brown.withAlpha(130), fontSize: 14)),
  );

  Widget _legalRow() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _legalLink(_t.privacyPolicyLabel, 'https://taalaydev.github.io/kizuna-quest/privacy-policy.html'),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text('·', style: TextStyle(color: _brown.withAlpha(80), fontSize: 11)),
      ),
      _legalLink(_t.termsOfServiceLabel, 'https://taalaydev.github.io/kizuna-quest/terms-of-service.html'),
    ],
  );

  Widget _legalLink(String label, String url) => GestureDetector(
    onTap: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
    child: Text(
      label,
      style: TextStyle(
        color: _brown.withAlpha(110),
        fontSize: 11,
        decoration: TextDecoration.underline,
        decorationColor: _brown.withAlpha(60),
      ),
    ),
  );
}

class _PurchaseSheetTexts {
  final String purchaseFailedMessage;
  final String noPreviousPurchaseMessage;
  final String unlockFullStoryTitle;
  final String unlockFullStorySubtitle;
  final List<String> features;
  final String priceBadge;
  final String unlockAllStoriesCta;
  final String restorePurchasesCta;
  final String notNowCta;
  final String privacyPolicyLabel;
  final String termsOfServiceLabel;

  const _PurchaseSheetTexts({
    required this.purchaseFailedMessage,
    required this.noPreviousPurchaseMessage,
    required this.unlockFullStoryTitle,
    required this.unlockFullStorySubtitle,
    required this.features,
    required this.priceBadge,
    required this.unlockAllStoriesCta,
    required this.restorePurchasesCta,
    required this.notNowCta,
    required this.privacyPolicyLabel,
    required this.termsOfServiceLabel,
  });

  static const _en = _PurchaseSheetTexts(
    purchaseFailedMessage: 'Purchase could not be initiated. Please try again.',
    noPreviousPurchaseMessage: 'No previous purchase found.',
    unlockFullStoryTitle: 'Unlock Full Story',
    unlockFullStorySubtitle: 'Continue your Japanese learning adventure\nwith all 8 immersive stories.',
    features: [
      'All 8 chapters with 200+ dialogue scenes',
      'Full vocabulary log & word cards',
      'Chapter Select unlocked at any time',
      'Future story updates included free',
    ],
    priceBadge: r'$4.99  ·  One-time purchase  ·  No subscription',
    unlockAllStoriesCta: 'Unlock All Stories',
    restorePurchasesCta: 'Restore Purchases',
    notNowCta: 'Not now',
    privacyPolicyLabel: 'Privacy Policy',
    termsOfServiceLabel: 'Terms of Service',
  );

  static _PurchaseSheetTexts of(Locale locale) {
    return switch (locale.languageCode) {
      'zh' => const _PurchaseSheetTexts(
        purchaseFailedMessage: '无法发起购买。请重试。',
        noPreviousPurchaseMessage: '未找到以前的购买记录。',
        unlockFullStoryTitle: '解锁完整故事',
        unlockFullStorySubtitle: '继续你的日语学习冒险，\n畅玩全部 8 个沉浸式故事。',
        features: ['全部 8 个章节，含 200+ 对话场景', '完整词汇日志与单词卡', '随时解锁章节选择', '后续故事更新免费包含'],
        priceBadge: r'$4.99  ·  一次性购买  ·  无订阅',
        unlockAllStoriesCta: '解锁全部故事',
        restorePurchasesCta: '恢复购买',
        notNowCta: '暂不',
        privacyPolicyLabel: '隐私政策',
        termsOfServiceLabel: '服务条款',
      ),
      'hi' => const _PurchaseSheetTexts(
        purchaseFailedMessage: 'खरीद शुरू नहीं हो सकी। कृपया फिर से कोशिश करें।',
        noPreviousPurchaseMessage: 'कोई पिछली खरीद नहीं मिली।',
        unlockFullStoryTitle: 'पूरी कहानी अनलॉक करें',
        unlockFullStorySubtitle: 'सभी 8 इमर्सिव कहानियों के साथ\nअपनी जापानी सीखने की यात्रा जारी रखें।',
        features: [
          '200+ संवाद दृश्यों के साथ सभी 8 अध्याय',
          'पूरा शब्दावली लॉग और वर्ड कार्ड्स',
          'चैप्टर चयन कभी भी अनलॉक',
          'भविष्य के कहानी अपडेट मुफ्त शामिल',
        ],
        priceBadge: r'$4.99  ·  एक बार की खरीद  ·  कोई सदस्यता नहीं',
        unlockAllStoriesCta: 'सभी कहानियां अनलॉक करें',
        restorePurchasesCta: 'खरीद बहाल करें',
        notNowCta: 'अभी नहीं',
        privacyPolicyLabel: 'गोपनीयता नीति',
        termsOfServiceLabel: 'सेवा की शर्तें',
      ),
      'es' => const _PurchaseSheetTexts(
        purchaseFailedMessage: 'No se pudo iniciar la compra. Inténtalo de nuevo.',
        noPreviousPurchaseMessage: 'No se encontró ninguna compra anterior.',
        unlockFullStoryTitle: 'Desbloquea la historia completa',
        unlockFullStorySubtitle: 'Continúa tu aventura de aprendizaje de japonés\ncon las 8 historias inmersivas.',
        features: [
          'Los 8 capítulos con más de 200 escenas de diálogo',
          'Registro completo de vocabulario y tarjetas',
          'Selección de capítulos desbloqueada en cualquier momento',
          'Actualizaciones futuras de historia incluidas gratis',
        ],
        priceBadge: r'$4.99  ·  Compra única  ·  Sin suscripción',
        unlockAllStoriesCta: 'Desbloquear todas las historias',
        restorePurchasesCta: 'Restaurar compras',
        notNowCta: 'Ahora no',
        privacyPolicyLabel: 'Política de privacidad',
        termsOfServiceLabel: 'Términos del servicio',
      ),
      'fr' => const _PurchaseSheetTexts(
        purchaseFailedMessage: 'Impossible de lancer l’achat. Veuillez réessayer.',
        noPreviousPurchaseMessage: 'Aucun achat précédent trouvé.',
        unlockFullStoryTitle: 'Débloquer l’histoire complète',
        unlockFullStorySubtitle:
            'Poursuivez votre aventure d’apprentissage du japonais\navec les 8 histoires immersives.',
        features: [
          'Les 8 chapitres avec plus de 200 scènes de dialogue',
          'Journal de vocabulaire complet et cartes de mots',
          'Sélection de chapitre débloquée à tout moment',
          'Mises à jour futures de l’histoire incluses gratuitement',
        ],
        priceBadge: r'$4.99  ·  Achat unique  ·  Sans abonnement',
        unlockAllStoriesCta: 'Débloquer toutes les histoires',
        restorePurchasesCta: 'Restaurer les achats',
        notNowCta: 'Pas maintenant',
        privacyPolicyLabel: 'Politique de confidentialité',
        termsOfServiceLabel: 'Conditions d’utilisation',
      ),
      'ar' => const _PurchaseSheetTexts(
        purchaseFailedMessage: 'تعذر بدء عملية الشراء. يرجى المحاولة مرة أخرى.',
        noPreviousPurchaseMessage: 'لم يتم العثور على أي عملية شراء سابقة.',
        unlockFullStoryTitle: 'افتح القصة كاملة',
        unlockFullStorySubtitle: 'واصل مغامرة تعلم اليابانية\nمع جميع القصص الثماني الغامرة.',
        features: [
          'جميع الفصول الثمانية مع أكثر من 200 مشهد حوار',
          'سجل مفردات كامل وبطاقات كلمات',
          'فتح اختيار الفصل في أي وقت',
          'تحديثات القصة المستقبلية مشمولة مجانًا',
        ],
        priceBadge: r'$4.99  ·  شراء لمرة واحدة  ·  بدون اشتراك',
        unlockAllStoriesCta: 'افتح كل القصص',
        restorePurchasesCta: 'استعادة المشتريات',
        notNowCta: 'ليس الآن',
        privacyPolicyLabel: 'سياسة الخصوصية',
        termsOfServiceLabel: 'شروط الخدمة',
      ),
      'bn' => const _PurchaseSheetTexts(
        purchaseFailedMessage: 'ক্রয় শুরু করা যায়নি। আবার চেষ্টা করুন।',
        noPreviousPurchaseMessage: 'আগের কোনো ক্রয় পাওয়া যায়নি।',
        unlockFullStoryTitle: 'সম্পূর্ণ গল্প আনলক করুন',
        unlockFullStorySubtitle: 'সব ৮টি ইমার্সিভ গল্পসহ\nআপনার জাপানি শেখার যাত্রা চালিয়ে যান।',
        features: [
          '২০০+ সংলাপ দৃশ্যসহ সব ৮টি অধ্যায়',
          'সম্পূর্ণ শব্দভান্ডার লগ ও ওয়ার্ড কার্ড',
          'যেকোনো সময় অধ্যায় নির্বাচন আনলক',
          'ভবিষ্যৎ গল্প আপডেট বিনামূল্যে অন্তর্ভুক্ত',
        ],
        priceBadge: r'$4.99  ·  এককালীন ক্রয়  ·  সাবস্ক্রিপশন নয়',
        unlockAllStoriesCta: 'সব গল্প আনলক করুন',
        restorePurchasesCta: 'ক্রয় পুনরুদ্ধার করুন',
        notNowCta: 'এখন নয়',
        privacyPolicyLabel: 'গোপনীয়তা নীতি',
        termsOfServiceLabel: 'সেবার শর্তাবলী',
      ),
      'pt' => const _PurchaseSheetTexts(
        purchaseFailedMessage: 'Não foi possível iniciar a compra. Tente novamente.',
        noPreviousPurchaseMessage: 'Nenhuma compra anterior encontrada.',
        unlockFullStoryTitle: 'Desbloqueie a história completa',
        unlockFullStorySubtitle:
            'Continue sua aventura de aprendizagem de japonês\ncom todas as 8 histórias imersivas.',
        features: [
          'Todos os 8 capítulos com mais de 200 cenas de diálogo',
          'Registro completo de vocabulário e cartões de palavras',
          'Seleção de capítulo liberada a qualquer momento',
          'Atualizações futuras da história incluídas gratuitamente',
        ],
        priceBadge: r'$4.99  ·  Compra única  ·  Sem assinatura',
        unlockAllStoriesCta: 'Desbloquear todas as histórias',
        restorePurchasesCta: 'Restaurar compras',
        notNowCta: 'Agora não',
        privacyPolicyLabel: 'Política de Privacidade',
        termsOfServiceLabel: 'Termos de Serviço',
      ),
      'ru' => const _PurchaseSheetTexts(
        purchaseFailedMessage: 'Не удалось начать покупку. Попробуйте еще раз.',
        noPreviousPurchaseMessage: 'Предыдущие покупки не найдены.',
        unlockFullStoryTitle: 'Открыть полную историю',
        unlockFullStorySubtitle: 'Продолжайте изучать японский язык\nсо всеми 8 захватывающими историями.',
        features: [
          'Все 8 глав с более чем 200 сценами диалогов',
          'Полный словарь и карточки слов',
          'Выбор главы открыт в любое время',
          'Будущие обновления истории включены бесплатно',
        ],
        priceBadge: r'$4.99  ·  Разовая покупка  ·  Без подписки',
        unlockAllStoriesCta: 'Открыть все истории',
        restorePurchasesCta: 'Восстановить покупки',
        notNowCta: 'Не сейчас',
        privacyPolicyLabel: 'Политика конфиденциальности',
        termsOfServiceLabel: 'Условия использования',
      ),
      'ja' => const _PurchaseSheetTexts(
        purchaseFailedMessage: '購入を開始できませんでした。もう一度お試しください。',
        noPreviousPurchaseMessage: '以前の購入が見つかりませんでした。',
        unlockFullStoryTitle: 'ストーリーをすべて解放',
        unlockFullStorySubtitle: '全8本の没入型ストーリーで\n日本語学習の冒険を続けましょう。',
        features: ['200以上の会話シーンを含む全8章', '完全な語彙ログと単語カード', 'チャプター選択をいつでも解放', '今後のストーリー更新も無料で含む'],
        priceBadge: r'$4.99  ·  買い切り  ·  サブスクなし',
        unlockAllStoriesCta: 'すべてのストーリーを解放',
        restorePurchasesCta: '購入を復元',
        notNowCta: '今はしない',
        privacyPolicyLabel: 'プライバシーポリシー',
        termsOfServiceLabel: '利用規約',
      ),
      _ => _en,
    };
  }
}
