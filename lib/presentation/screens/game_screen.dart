import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/mock_subscription_service.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final InAppLocalhostServer localhostServer = InAppLocalhostServer(documentRoot: 'assets');
  final SubscriptionService _subService = SubscriptionService();
  InAppWebViewController? _webViewController;
  StreamSubscription<bool>? _subSubscription;
  bool _isServerRunning = false;

  @override
  void initState() {
    super.initState();
    _startServer();
    _subService.initialize();
    _subSubscription = _subService.premiumStream.listen((isPremium) {
      _updateJsSubscriptionStatus(isPremium);
    });
  }

  Future<void> _startServer() async {
    if (!localhostServer.isRunning()) {
      await localhostServer.start();
    }
    if (mounted) {
      setState(() => _isServerRunning = true);
    }
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
    localhostServer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isServerRunning) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
        ),
        initialUrlRequest: URLRequest(url: WebUri("http://localhost:8080/index.html")),
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
        },
        onLoadStop: (controller, url) {
          _updateJsSubscriptionStatus(_subService.isPremium);
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
  String? _statusMessage;
  StreamSubscription<bool>? _sub;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 550))..forward();
    _scale = CurvedAnimation(parent: _anim, curve: Curves.easeOutBack);

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
        _statusMessage = 'Purchase could not be initiated. Please try again.';
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
          _statusMessage = 'No previous purchase found.';
        }
      });
    }
  }

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

          // On wide/desktop show as a centered card instead of bottom sheet
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
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1a1035), Color(0xFF2d1b5e)],
                ),
                boxShadow: [BoxShadow(color: const Color(0xFF7c4dff).withAlpha(102), blurRadius: 40, spreadRadius: 4)],
                border: Border.all(color: const Color(0xFF7c4dff).withAlpha(128), width: 1.5),
              ),
              child: wide ? _buildWideLayout(context, constraints, desktop) : _buildNarrowLayout(context),
            ),
          );
        },
      ),
    );
  }

  // ─── Narrow / Portrait phone layout (original) ───────────────────────────
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

  // ─── Wide / Landscape / Tablet / Desktop layout ──────────────────────────
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
    decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
  );

  Widget _iconBadge(double size, double iconSize) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: const LinearGradient(
        colors: [Color(0xFFffd700), Color(0xFFff9800)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [BoxShadow(color: const Color(0xFFffd700).withAlpha(128), blurRadius: 2, spreadRadius: 1)],
    ),
    child: Icon(Icons.auto_stories_rounded, color: Colors.white, size: iconSize),
  );

  Widget _headline(double fontSize, {TextAlign textAlign = TextAlign.center}) => Text(
    'Unlock Full Story',
    textAlign: textAlign,
    style: TextStyle(color: Colors.white, fontSize: fontSize, fontWeight: FontWeight.w800, letterSpacing: -0.5),
  );

  Widget _subtitle(double fontSize, {TextAlign textAlign = TextAlign.center}) => Text(
    'Continue your Japanese learning adventure\nwith all 8 immersive stories.',
    textAlign: textAlign,
    style: TextStyle(color: Colors.white.withAlpha(166), fontSize: fontSize, height: 1.5),
  );

  List<Widget> _featureRows(double fontSize) => _kFeatures
      .map(
        (f) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Color(0xFF7c4dff), size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  f,
                  style: TextStyle(color: Colors.white70, fontSize: fontSize),
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
      color: const Color(0xFF7c4dff).withAlpha(46),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: const Color(0xFF7c4dff).withAlpha(102)),
    ),
    child: const Text(
      '\$4.99  ·  One-time purchase  ·  No subscription',
      textAlign: TextAlign.center,
      style: TextStyle(color: Color(0xFFb39ddb), fontSize: 13),
    ),
  );

  Widget _statusText() => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      _statusMessage!,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Color(0xFFe57373), fontSize: 13),
    ),
  );

  Widget _purchaseButton(bool busy, double width, double height, double fontSize) => SizedBox(
    width: width,
    height: height,
    child: ElevatedButton(
      onPressed: busy ? null : _handlePurchase,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF7c4dff),
        foregroundColor: Colors.white,
        disabledBackgroundColor: const Color(0xFF7c4dff).withAlpha(128),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: _purchasing
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
            )
          : Text(
              'Unlock All Stories',
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w700, letterSpacing: 0.3),
            ),
    ),
  );

  Widget _restoreButton(bool busy, double width, double height) => SizedBox(
    width: width,
    height: height,
    child: OutlinedButton(
      onPressed: busy ? null : _handleRestore,
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFFb39ddb),
        side: BorderSide(color: const Color(0xFF7c4dff).withAlpha(102)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: _restoring
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(color: Color(0xFFb39ddb), strokeWidth: 2.0),
            )
          : const Text('Restore Purchases', style: TextStyle(fontSize: 15)),
    ),
  );

  Widget _notNowButton(bool busy, BuildContext context) => TextButton(
    onPressed: busy ? null : () => Navigator.of(context).pop(),
    child: Text('Not now', style: TextStyle(color: Colors.white.withAlpha(115), fontSize: 14)),
  );

  Widget _legalRow() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _legalLink('Privacy Policy', 'https://taalaydev.github.io/kizuna-quest/privacy-policy.html'),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text('·', style: TextStyle(color: Colors.white.withAlpha(60), fontSize: 11)),
      ),
      _legalLink('Terms of Service', 'https://taalaydev.github.io/kizuna-quest/terms-of-service.html'),
    ],
  );

  Widget _legalLink(String label, String url) => GestureDetector(
    onTap: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
    child: Text(
      label,
      style: TextStyle(
        color: Colors.white.withAlpha(90),
        fontSize: 11,
        decoration: TextDecoration.underline,
        decorationColor: Colors.white.withAlpha(60),
      ),
    ),
  );

  static const _kFeatures = [
    'All 8 chapters with 200+ dialogue scenes',
    'Full vocabulary log & word cards',
    'Chapter Select unlocked at any time',
    'Future story updates included free',
  ];
}
