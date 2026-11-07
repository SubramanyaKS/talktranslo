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

  testWidgets('TalkTranslo smoke test - verifies welcome screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TranslationProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => HistoryProvider()),
          ChangeNotifierProvider(create: (_) => ImageTextProvider()),
        ],
        child: const MyApp(),
      ),
    );

    // Verify Welcome Screen displays CTA button
    expect(find.text('Start Translation'), findsOneWidget);
    expect(find.text('TalkTranslo'), findsWidgets);
  });
}
