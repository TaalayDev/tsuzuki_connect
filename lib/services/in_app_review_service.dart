import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for handling app reviews.
/// This class manages when to prompt for reviews, and handles the actual review request.
class InAppReviewService {
  static const _lastReviewRequestTimeKey = 'last_review_request_time';
  static const _sessionCountKey = 'app_session_count';
  static const _completedLessonsCountKey = 'app_completed_lessons_count';
  static const _hasRatedKey = 'user_has_rated_app';

  // Configuration settings
  // Ask after 5 sessions
  static const int _sessionsBeforeFirstRequest = 5;
  // Ask again after 20 more sessions
  static const int _sessionsBeforeReminder = 20;
  // Don't ask more than once every 60 days
  static const Duration _minIntervalBetweenRequests = Duration(days: 60);
  // Ask right after the player completes their second lesson. If the request
  // can't be shown then (e.g. the OS review dialog is unavailable), the next
  // completed lesson (the third, and so on) tries again.
  static const int _lessonsBeforeFirstRequest = 2;

  final InAppReview _inAppReview = InAppReview.instance;

  /// Increment session count when the app is opened
  Future<void> incrementSessionCount() async {
    if (kIsWeb) return; // Not available on web

    final prefs = await SharedPreferences.getInstance();
    final currentCount = prefs.getInt(_sessionCountKey) ?? 0;
    await prefs.setInt(_sessionCountKey, currentCount + 1);
  }

  /// Increment the number of lessons the player has completed for the first
  /// time (sentence lessons and vocabulary lessons).
  Future<void> incrementCompletedLessonCount() async {
    if (kIsWeb) return; // Not available on web

    final prefs = await SharedPreferences.getInstance();
    final currentCount = prefs.getInt(_completedLessonsCountKey) ?? 0;
    await prefs.setInt(_completedLessonsCountKey, currentCount + 1);
  }

  /// Check if we should request a review based on sessions and time since last request
  Future<bool> shouldRequestReview() async {
    if (kIsWeb) return false; // Not available on web

    // Check if review dialog is available on this device
    final bool isAvailable = await _inAppReview.isAvailable();
    if (!isAvailable) return false;

    final prefs = await SharedPreferences.getInstance();

    // If the user has already rated the app, don't ask again
    final hasRated = prefs.getBool(_hasRatedKey) ?? false;
    if (hasRated) return false;

    final sessionCount = prefs.getInt(_sessionCountKey) ?? 0;
    final completedLessons = prefs.getInt(_completedLessonsCountKey) ?? 0;
    final lastRequestTime = prefs.getInt(_lastReviewRequestTimeKey);

    // Check if the player has completed enough lessons
    if (completedLessons < _lessonsBeforeFirstRequest) {
      return false;
    } else if (lastRequestTime == null) {
      return true; // First request
    }

    // Check if enough sessions have passed
    if (sessionCount < _sessionsBeforeFirstRequest) {
      return false;
    }

    // Not the first request: respect the minimum interval
    final lastRequest = DateTime.fromMillisecondsSinceEpoch(lastRequestTime);
    final daysSinceLastRequest = DateTime.now().difference(lastRequest);

    // If not enough days have passed AND not enough new sessions, don't request
    if (daysSinceLastRequest < _minIntervalBetweenRequests &&
        (sessionCount - _sessionsBeforeFirstRequest) %
                _sessionsBeforeReminder !=
            0) {
      return false;
    }

    return true;
  }

  /// Request a review from the user
  Future<void> requestReview() async {
    if (kIsWeb) return; // Not available on web

    try {
      final prefs = await SharedPreferences.getInstance();

      // If on Android or iOS, use the platform-specific review flow
      if (Platform.isAndroid || Platform.isIOS) {
        await _inAppReview.requestReview();
      } else {
        // For other platforms, open the store page directly
        await _inAppReview.openStoreListing(appStoreId: '6736886514');
      }

      // Update the last request time
      await prefs.setInt(
        _lastReviewRequestTimeKey,
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      debugPrint('Error requesting review: $e');
    }
  }

  /// Mark that the user has rated the app, so we don't ask again
  Future<void> markAsRated() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasRatedKey, true);
  }

  /// For debug purposes: Reset all review-related data
  Future<void> resetReviewData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastReviewRequestTimeKey);
    await prefs.remove(_sessionCountKey);
    await prefs.remove(_completedLessonsCountKey);
    await prefs.remove(_hasRatedKey);
  }

  Future<int> getSessionCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_sessionCountKey) ?? 0;
  }

  /// Call after the player completes a lesson for the first time. Counts the
  /// lesson and shows the review prompt once the player has finished enough
  /// lessons (see [_lessonsBeforeFirstRequest]).
  Future<void> onLessonCompleted() async {
    await incrementCompletedLessonCount();
    if (await shouldRequestReview()) {
      await requestReview();
    }
  }
}
