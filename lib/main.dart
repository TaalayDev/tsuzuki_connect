import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:window_manager/window_manager.dart';

import 'core/services/settings_service.dart';
import 'core/utils/app_logger.dart';
import 'app.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initWindowManager();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: [SystemUiOverlay.top]);
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

  await SettingsService.initialize();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (!kIsWeb) {
    try {
      // FlutterError.onError = (errorDetails) {
      //   FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      // };

      // PlatformDispatcher.instance.onError = (error, stack) {
      //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      //   return true;
      // };

      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(!kDebugMode);
    } catch (e, stack) {
      AppLogger.error('Failed to initialize Firebase', error: e, stackTrace: stack);
    }
  }

  runApp(ProviderScope(child: const TsuzukiConnectApp()));
}

Future<void> initWindowManager() async {
  if (kIsWeb || !_isDesktop()) {
    return;
  }

  const size = Size(1280, 720);
  await windowManager.ensureInitialized();
  const windowOptions = WindowOptions(
    minimumSize: size,
    size: size,
    center: true,
    fullScreen: true,
    backgroundColor: Color.fromARGB(255, 255, 255, 255),
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    title: 'Tsuzuki Connect',
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}

bool _isDesktop() {
  return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
}
