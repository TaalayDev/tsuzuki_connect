import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../core/services/in_app_review_service.dart';

final inAppReviewProvider = Provider<InAppReviewService>((ref) {
  return InAppReviewService();
});

/// Class to hold report form data
class TranslationErrorReport {
  final String errorType;
  final String description;
  final String? context;
  final String? screenshot;

  TranslationErrorReport({required this.errorType, required this.description, this.context, this.screenshot});
}

/// Class to hold feedback form data
class AppFeedback {
  final String feedbackType;
  final String content;
  final int? rating;

  AppFeedback({required this.feedbackType, required this.content, this.rating});
}
