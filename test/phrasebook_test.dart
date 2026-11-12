import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talktranslo/data/phrasebook_data.dart';
import 'package:talktranslo/provider/history_provider.dart';
import 'package:talktranslo/provider/translator_provider.dart';
import 'package:talktranslo/screens/history_screen.dart';
import 'package:talktranslo/screens/phrasebook_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget createTestWidget(Widget child) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TranslationProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
      ],
      child: MaterialApp(
        home: Scaffold(body: child),
      ),
    );
  }

  test('PhrasebookData contains essential phrases across categories', () {
    expect(PhrasebookData.phrases.isNotEmpty, isTrue);
    expect(
      PhrasebookData.phrases.any((p) => p.category == PhraseCategory.emergency),
      isTrue,
    );
    expect(
      PhrasebookData.phrases.any((p) => p.category == PhraseCategory.dining),
      isTrue,
    );
    expect(
      PhrasebookData.phrases.any((p) => p.category == PhraseCategory.transit),
      isTrue,
    );
    expect(
      PhrasebookData.phrases.any((p) => p.category == PhraseCategory.hotel),
      isTrue,
    );
    expect(
      PhrasebookData.phrases.any((p) => p.category == PhraseCategory.essentials),
      isTrue,
    );
  });

  testWidgets('PhrasebookView renders categories, search bar, and phrase cards', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(const PhrasebookView(isStandalone: true)));
    await tester.pumpAndSettle();

    // Verify search bar exists
    expect(find.byType(TextField), findsOneWidget);

    // Verify category chips and badges exist
    expect(find.text('🚨 Emergency'), findsWidgets);
    expect(find.text('🚕 Transit & Directions'), findsWidgets);
    expect(find.text('🍽️ Dining & Food'), findsWidgets);

    // Verify sample phrase is displayed
    expect(find.textContaining('Help! Call the police immediately!'), findsOneWidget);

    // Test Search Filtering
    await tester.enterText(find.byType(TextField), 'Wi-Fi');
    await tester.pumpAndSettle();

    expect(find.textContaining('Wi-Fi'), findsWidgets);
    expect(find.textContaining('police'), findsNothing);
  });

  testWidgets('HistoryScreen switches between History and Phrasebook tabs', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(const HistoryScreen()));
    await tester.pumpAndSettle();

    // Initially in History mode
    expect(find.textContaining('All (0)'), findsOneWidget);
    expect(find.text('Phrasebook 📖'), findsOneWidget);

    // Tap Phrasebook tab in SegmentedButton
    await tester.tap(find.text('Phrasebook 📖'));
    await tester.pumpAndSettle();

    // Verify Phrasebook view is displayed inside HistoryScreen
    expect(find.text('🚨 Emergency'), findsWidgets);
    expect(find.textContaining('Translate phrases to:'), findsOneWidget);
  });
}
