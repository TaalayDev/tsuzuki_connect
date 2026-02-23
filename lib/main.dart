import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsuzuki_connect/core/services/settings_service.dart';
import 'package:window_manager/window_manager.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/utils/app_logger.dart';
import 'app.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: [SystemUiOverlay.top]);
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

  // await initWindowManager();
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
  if (kIsWeb || !Platform.isWindows && !Platform.isLinux && !Platform.isMacOS) {
    return;
  }

  const size = Size(1024, 800);
  await windowManager.ensureInitialized();
  const windowOptions = WindowOptions(
    // minimumSize: size,
    size: size,
    center: true,
    fullScreen: true,
    backgroundColor: Color.fromARGB(255, 255, 255, 255),
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    title: 'Tsuzuki Connect',
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}
