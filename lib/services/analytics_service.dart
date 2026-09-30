import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Thin wrapper around [FirebaseAnalytics] so screens log events through a
/// single, testable entry point instead of reaching for the singleton. All
/// methods swallow failures — analytics must never crash the app or block a
/// user flow.
class AnalyticsService {
  AnalyticsService({FirebaseAnalytics? analytics})
      : _analytics = analytics ?? FirebaseAnalytics.instance;

  final FirebaseAnalytics _analytics;

  /// Attach to `MaterialApp.navigatorObservers` for automatic
  /// `screen_view` events on every route push/pop.
  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  Future<void> logAppOpen() => _guard(() => _analytics.logAppOpen());

  Future<void> logScreenView(String screenName) => _guard(
        () => _analytics.logScreenView(screenName: screenName),
      );

  Future<void> logEvent(String name, [Map<String, Object>? parameters]) =>
      _guard(() => _analytics.logEvent(name: name, parameters: parameters));

  Future<void> setUserProperty(String name, String? value) =>
      _guard(() => _analytics.setUserProperty(name: name, value: value));

  Future<void> _guard(Future<void> Function() action) async {
    try {
      await action();
    } catch (error, stack) {
      debugPrint('AnalyticsService error: $error\n$stack');
    }
  }
}
