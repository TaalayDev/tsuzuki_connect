import 'dart:ui' show PlatformDispatcher;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';
import 'screens/main_menu/main_menu_screen.dart';
import 'services/analytics_service.dart';
import 'services/device_language.dart';
import 'services/i18n_service.dart';
import 'services/in_app_review_service.dart';
import 'services/save_service.dart';
import 'state/analytics_provider.dart';
import 'state/i18n_provider.dart';
import 'state/settings_provider.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final analyticsService = AnalyticsService();
  await analyticsService.logAppOpen();

  await InAppReviewService().incrementSessionCount();

  final saveService = await SaveService.create();
  final storedSettings = saveService.settings;
  final storedLanguage = storedSettings['language'] as String?;
  final language = storedLanguage == null || storedLanguage.isEmpty
      ? DeviceLanguage.detect(PlatformDispatcher.instance.locales)
      : storedLanguage;

  // Persist device detection exactly once. Subsequent launches keep the
  // stored value, including any language the user selected in Settings.
  if (storedLanguage == null || storedLanguage.isEmpty) {
    await saveService.saveSettings({...storedSettings, 'language': language});
  }

  final i18nService = I18nService();
  await i18nService.load();
  i18nService.setLanguage(language);

  runApp(
    ProviderScope(
      overrides: [
        saveServiceProvider.overrideWithValue(saveService),
        i18nProvider.overrideWithValue(i18nService),
        analyticsProvider.overrideWithValue(analyticsService),
      ],
      child: const TsuzukiConnectApp(),
    ),
  );
}

class TsuzukiConnectApp extends ConsumerWidget {
  const TsuzukiConnectApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Tsuzuki Connect',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      navigatorObservers: [ref.read(analyticsProvider).observer],
      home: const MainMenuScreen(),
    );
  }
}
