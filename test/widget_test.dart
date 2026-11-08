import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talktranslo/main.dart';
import 'package:talktranslo/provider/history_provider.dart';
import 'package:talktranslo/provider/image_text_provider.dart';
import 'package:talktranslo/provider/theme_provider.dart';
import 'package:talktranslo/provider/translator_provider.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('TalkTranslo smoke test - verifies welcome screen renders on first launch', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TranslationProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => HistoryProvider()),
          ChangeNotifierProvider(create: (_) => ImageTextProvider()),
        ],
        child: const MyApp(hasSeenOnboarding: false),
      ),
    );

    // Verify Welcome Screen displays CTA button
    expect(find.text('Start Translation'), findsOneWidget);
    expect(find.text('TalkTranslo'), findsWidgets);
  });

  testWidgets('TalkTranslo smoke test - verifies HomeScreen renders directly when onboarding was completed', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TranslationProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => HistoryProvider()),
          ChangeNotifierProvider(create: (_) => ImageTextProvider()),
        ],
        child: const MyApp(hasSeenOnboarding: true),
      ),
    );

    // Verify HomeScreen renders with 4 Navigation destinations
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Translate'), findsWidgets);
    expect(find.text('Conversation'), findsOneWidget);
    expect(find.text('Camera OCR'), findsOneWidget);
    expect(find.text('Saved & History'), findsOneWidget);

    // Verify top AppBar has Settings and Quick Theme toggle icons
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
  });
}
