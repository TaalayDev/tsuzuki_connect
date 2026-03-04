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
    _t.unlockFullStoryTitle,
    textAlign: textAlign,
    style: TextStyle(color: Colors.white, fontSize: fontSize, fontWeight: FontWeight.w800, letterSpacing: -0.5),
  );

  Widget _subtitle(double fontSize, {TextAlign textAlign = TextAlign.center}) => Text(
    _t.unlockFullStorySubtitle,
    textAlign: textAlign,
    style: TextStyle(color: Colors.white.withAlpha(166), fontSize: fontSize, height: 1.5),
  );

  List<Widget> _featureRows(double fontSize) => _t.features
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
    child: Text(
      _priceBadgeText,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Color(0xFFb39ddb), fontSize: 13),
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
              _t.unlockAllStoriesCta,
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
          : Text(_t.restorePurchasesCta, style: const TextStyle(fontSize: 15)),
    ),
  );

  Widget _notNowButton(bool busy, BuildContext context) => TextButton(
    onPressed: busy ? null : () => Navigator.of(context).pop(),
    child: Text(_t.notNowCta, style: TextStyle(color: Colors.white.withAlpha(115), fontSize: 14)),
  );

  Widget _legalRow() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _legalLink(_t.privacyPolicyLabel, 'https://taalaydev.github.io/kizuna-quest/privacy-policy.html'),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text('·', style: TextStyle(color: Colors.white.withAlpha(60), fontSize: 11)),
      ),
      _legalLink(_t.termsOfServiceLabel, 'https://taalaydev.github.io/kizuna-quest/terms-of-service.html'),
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
