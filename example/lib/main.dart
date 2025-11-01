import 'package:flutter/material.dart';
// Import your package!
import 'package:smart_review_prompter/smart_review_prompter.dart';

void main() async {
  // This is required for async code in main
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize your package
  await SmartReviewPrompter.instance.initialize();

  // 2. Increment the app open count
  await SmartReviewPrompter.instance.incrementAppOpenCount();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Smart Review Example')),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              // 3. Try to show the review!
              // The package handles all the logic.
              debugPrint('Button pressed, trying to show review...');
              SmartReviewPrompter.instance.tryShowingReview(
                SmartReviewConditions(
                  minAppOpens: 3, // Set low for easy testing
                  minDaysSinceInstall: 0, // Set to 0 for easy testing
                ),
              );
            },
            child: const Text('Trigger Action & Try Showing Review'),
          ),
        ),
      ),
    );
  }
}