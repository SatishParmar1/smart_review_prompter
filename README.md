# Smart Review Prompter

[![pub package](https://img.shields.io/pub/v/smart_review_prompter.svg)](https://pub.dev/packages/smart_review_prompter)

A simple, smart way to show in-app review prompts in Flutter based on user engagement metrics such as app open count and days since install.

## Why Use This Package?

Asking users for reviews at the right time significantly increases the chances of getting positive reviews. This package helps you:

- ✅ Ask for reviews only after users have actually engaged with your app
- ✅ Track app opens and install date automatically
- ✅ Ensure the review prompt is shown only once
- ✅ Wrap `in_app_review` and `shared_preferences` in one simple API
- ✅ Customize conditions based on your app's needs

## Features

* 🎯 **Smart Timing**: Show review prompts based on app opens and days since install
* 🔒 **One-Time Prompt**: Automatically tracks if a review has already been requested
* 📊 **Automatic Tracking**: Counts app opens and stores install date
* 🎨 **Simple API**: Just three methods to integrate
* 🚀 **Native Experience**: Uses the official platform review dialogs (iOS App Store & Google Play)

## Installation

Add this to your `pubspec.yaml`:
```yaml
dependencies:
  smart_review_prompter: ^0.0.2
```

Then run:
```bash
flutter pub get
```

## Usage

### Step 1: Initialize in `main.dart`
```dart
import 'package:flutter/material.dart';
import 'package:smart_review_prompter/smart_review_prompter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the package
  await SmartReviewPrompter.instance.initialize();

  // Increment app open count
  await SmartReviewPrompter.instance.incrementAppOpenCount();

  runApp(const MyApp());
}
```

### Step 2: Trigger Review at the Right Moment

Call this method when users complete a positive action (e.g., finish a level, complete a task, make a purchase):
```dart
SmartReviewPrompter.instance.tryShowingReview(
  SmartReviewConditions(
    minAppOpens: 5,           // Show after 5 app opens
    minDaysSinceInstall: 3,   // Show after 3 days since install
  ),
);
```

### Complete Example
```dart
import 'package:flutter/material.dart';
import 'package:smart_review_prompter/smart_review_prompter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await SmartReviewPrompter.instance.initialize();
  await SmartReviewPrompter.instance.incrementAppOpenCount();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Smart Review Example'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              // Trigger after a positive user action
              SmartReviewPrompter.instance.tryShowingReview(
                SmartReviewConditions(
                  minAppOpens: 5,
                  minDaysSinceInstall: 3,
                ),
              );
            },
            child: const Text('Complete Positive Action'),
          ),
        ),
      ),
    );
  }
}
```

## API Reference

### `SmartReviewPrompter.instance`

The singleton instance of the prompter.

#### Methods

##### `initialize()`

Initializes the package and sets up storage. Call this once in `main()` before `runApp()`.
```dart
await SmartReviewPrompter.instance.initialize();
```

##### `incrementAppOpenCount()`

Increments the app open counter. Call this in `main()` after `initialize()`.
```dart
await SmartReviewPrompter.instance.incrementAppOpenCount();
```

##### `tryShowingReview(SmartReviewConditions conditions)`

Checks if conditions are met and shows the review prompt if appropriate.
```dart
SmartReviewPrompter.instance.tryShowingReview(
  SmartReviewConditions(
    minAppOpens: 5,
    minDaysSinceInstall: 3,
  ),
);
```

### `SmartReviewConditions`

Configuration class for review conditions.

#### Parameters

- `minAppOpens` (int, default: 5): Minimum number of app opens required
- `minDaysSinceInstall` (int, default: 3): Minimum days since first install required

## Best Practices

### When to Ask for Reviews

✅ **Good Times:**
- After completing a level or achievement
- After a successful transaction
- After using a key feature multiple times
- After receiving positive feedback in-app

❌ **Bad Times:**
- Immediately on app launch
- During user onboarding
- When user is trying to complete a task
- After an error or crash

### Recommended Settings
```dart
// For casual apps (games, social)
SmartReviewConditions(
  minAppOpens: 5,
  minDaysSinceInstall: 3,
)

// For productivity apps
SmartReviewConditions(
  minAppOpens: 10,
  minDaysSinceInstall: 7,
)

// For professional tools
SmartReviewConditions(
  minAppOpens: 15,
  minDaysSinceInstall: 14,
)
```

## Platform Support

- ✅ iOS (uses SKStoreReviewController)
- ✅ Android (uses Google Play In-App Review API)
- ⚠️ Web, Windows, macOS, Linux: Review dialog won't show (gracefully handled)

**Note:** The review prompt will **not appear in simulators/emulators**. Always test on real devices.

## Testing

For testing purposes, you can set low thresholds:
```dart
SmartReviewConditions(
  minAppOpens: 2,           // Easy to reach
  minDaysSinceInstall: 0,   // No wait time
)
```

To reset the package state during development:
1. Uninstall and reinstall the app, or
2. Clear app data from device settings

## How It Works

1. **First Launch**: Records install date and initializes app open counter
2. **Every Launch**: Increments the app open counter
3. **On Trigger**: Checks if:
    - App has been opened enough times
    - Enough days have passed since install
    - Review hasn't been requested before
4. **Shows Review**: Uses native platform dialogs (won't interrupt if unavailable)
5. **Marks as Requested**: Never asks again

## Dependencies

This package wraps:
- [`in_app_review`](https://pub.dev/packages/in_app_review): For native review prompts
- [`shared_preferences`](https://pub.dev/packages/shared_preferences): For persistent storage

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Issues and Feedback

Please file issues, bugs, or feature requests on our [GitHub Issues](https://github.com/SatishParmar1/smart_review_prompter/issues) page.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

Created by [SatishParmar](https://github.com/SatishParmar1)

---

If you found this package helpful, please consider giving it a ⭐ on [GitHub](https://github.com/SatishParmar1/smart_review_prompter) and a 👍 on [pub.dev](https://pub.dev/packages/smart_review_prompter)!