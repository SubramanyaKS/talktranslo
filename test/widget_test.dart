import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:talktranslo/main.dart';
import 'package:talktranslo/provider/theme_provider.dart';
import 'package:talktranslo/provider/translator_provider.dart';

void main() {
  testWidgets('TalkTranslo smoke test - verifies welcome screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TranslationProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        child: const MyApp(),
      ),
    );

    // Verify Welcome Screen displays CTA button
    expect(find.text('Start Translation'), findsOneWidget);
    expect(find.text('TalkTranslo'), findsWidgets);
  });
}
