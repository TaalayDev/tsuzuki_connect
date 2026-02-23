import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'config/router/app_router.dart';
import 'providers/app_providers.dart';
import 'providers/theme_providers.dart';

/// The main application widget for Tsuzuki Connect.
class TsuzukiConnectApp extends ConsumerStatefulWidget {
  const TsuzukiConnectApp({super.key});

  @override
  ConsumerState<TsuzukiConnectApp> createState() => _TsuzukiConnectAppState();
}

class _TsuzukiConnectAppState extends ConsumerState<TsuzukiConnectApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _incrementSessionCount();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _incrementSessionCount();
    }
  }

  void _incrementSessionCount() async {
    final reviewService = ref.read(inAppReviewProvider);
    await reviewService.incrementSessionCount();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Tsuzuki Connect',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      // navigatorObservers: [
      //   FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      // ],
      theme: ThemeData(),
      themeMode: themeMode,

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      builder: (context, child) {
        return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0), child: child!);
      },
    );
  }
}
