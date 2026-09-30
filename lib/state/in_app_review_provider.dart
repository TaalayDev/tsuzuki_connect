import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/in_app_review_service.dart';

final inAppReviewProvider = Provider<InAppReviewService>(
  (ref) => InAppReviewService(),
);
