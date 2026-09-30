import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/i18n_service.dart';

/// Overridden in `main()` after `I18nService.load()` completes, same
/// pattern as `saveServiceProvider` — the app doesn't render until both
/// are ready, so every screen can call `ref.watch(i18nProvider).t(key)`
/// synchronously without threading `AsyncValue` through the whole tree.
final i18nProvider = Provider<I18nService>((ref) {
  throw UnimplementedError('Overridden in main() after I18nService.load()');
});
