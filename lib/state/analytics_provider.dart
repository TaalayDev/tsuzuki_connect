import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/analytics_service.dart';

/// Overridden in `main()` after `Firebase.initializeApp()` completes, same
/// pattern as `saveServiceProvider` — screens call
/// `ref.read(analyticsProvider).logEvent(...)` synchronously.
final analyticsProvider = Provider<AnalyticsService>((ref) {
  throw UnimplementedError('Overridden in main() after Firebase.initializeApp()');
});
