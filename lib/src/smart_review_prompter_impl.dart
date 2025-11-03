// In lib/src/smart_review_prompter_impl.dart

import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Internal class to hold storage keys
class _StorageKeys {
  static const String appOpenCount = 'smart_review_app_open_count';
  static const String firstInstallDate = 'smart_review_first_install_date';
  static const String didRequestReview = 'smart_review_did_request_review';
}

/// A simple class to hold the conditions for showing a review.
class SmartReviewConditions {
  /// The minimum number of times the app must be opened.
  final int minAppOpens;

  /// The minimum number of days that must pass since first install.
  final int minDaysSinceInstall;

  SmartReviewConditions({this.minAppOpens = 5, this.minDaysSinceInstall = 3});
}

/// The main class for the Smart Review Prompter.
class SmartReviewPrompter {
  // --- Singleton Setup ---
  // This ensures there's only one instance of this class in the app
  SmartReviewPrompter._();
  static final SmartReviewPrompter instance = SmartReviewPrompter._();

  // --- Private Variables ---
  final InAppReview _inAppReview = InAppReview.instance;
  late SharedPreferences _prefs;

  /// Call this method once in main.dart to initialize the package.
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();

    // Check if this is the first time we're running this
    if (_prefs.getString(_StorageKeys.firstInstallDate) == null) {
      await _prefs.setString(
        _StorageKeys.firstInstallDate,
        DateTime.now().toIso8601String(),
      );
    }
  }

  /// Call this method every time the app is opened (e.g., in main.dart).
  Future<void> incrementAppOpenCount() async {
    int currentCount = _prefs.getInt(_StorageKeys.appOpenCount) ?? 0;
    await _prefs.setInt(_StorageKeys.appOpenCount, currentCount + 1);
    debugPrint('SmartReviewPrompter: App open count: ${currentCount + 1}');
  }

  /// Call this method when you want to check conditions and possibly show the review.
  /// For example, after a user completes a level or a positive action.
  Future<void> tryShowingReview(SmartReviewConditions conditions) async {
    try {
      // 1. Check if we've ALREADY asked
      final bool didRequestReview =
          _prefs.getBool(_StorageKeys.didRequestReview) ?? false;
      if (didRequestReview) {
        debugPrint('SmartReviewPrompter: Already requested review, skipping.');
        return;
      }

      // 2. Check the conditions
      final int appOpenCount = _prefs.getInt(_StorageKeys.appOpenCount) ?? 0;
      final String? installDateString = _prefs.getString(
        _StorageKeys.firstInstallDate,
      );

      final DateTime installDate = installDateString != null
          ? DateTime.parse(installDateString)
          : DateTime.now();
      final int daysSinceInstall = DateTime.now()
          .difference(installDate)
          .inDays;

      final bool appOpensMet = appOpenCount >= conditions.minAppOpens;
      final bool daysMet = daysSinceInstall >= conditions.minDaysSinceInstall;

      debugPrint(
        'SmartReviewPrompter: Checking conditions... App Opens: $appOpenCount/${conditions.minAppOpens}. Days: $daysSinceInstall/${conditions.minDaysSinceInstall}',
      );

      if (appOpensMet && daysMet) {
        debugPrint(
          'SmartReviewPrompter: Conditions met, attempting to show review...',
        );
        // 3. All conditions met. Let's ask!
        if (await _inAppReview.isAvailable()) {
          await _inAppReview.requestReview();
          // 4. IMPORTANT: Save that we've asked
          await _prefs.setBool(_StorageKeys.didRequestReview, true);
        }
      }
    } catch (e) {
      debugPrint('SmartReviewPrompter: Error trying to show review: $e');
    }
  }
}
