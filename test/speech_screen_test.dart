import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talktranslo/provider/translator_provider.dart';
import 'package:talktranslo/screens/speech_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget createSpeechScreen() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TranslationProvider()),
      ],
      child: const MaterialApp(
        home: SpeechScreen(),
      ),
    );
  }

  testWidgets('SpeechScreen toggles Face-to-Face Mode with 180-degree rotation', (WidgetTester tester) async {
    await tester.pumpWidget(createSpeechScreen());
    await tester.pumpAndSettle();

    // 1. Initial State: Normal Mode
    expect(find.text('Face-to-Face Mode'), findsOneWidget);
    expect(find.textContaining('Speaker 1'), findsWidgets);
    expect(find.textContaining('Speaker 2'), findsWidgets);

    // Initial rotation of Speaker 1 card is 0 turns
    final rotatedBoxFinder = find.byType(RotatedBox);
    expect(rotatedBoxFinder, findsOneWidget);
    RotatedBox rotatedBox = tester.widget<RotatedBox>(rotatedBoxFinder);
    expect(rotatedBox.quarterTurns, equals(0));

    // Bottom dock should be visible
    expect(find.text('Conversation'), findsOneWidget);

    // 2. Activate Face-to-Face Mode
    await tester.tap(find.text('Face-to-Face Mode'));
    await tester.pumpAndSettle();

    // 3. Face-to-Face State Verification
    // RotatedBox should now be 2 quarter turns (180 degrees)
    rotatedBox = tester.widget<RotatedBox>(rotatedBoxFinder);
    expect(rotatedBox.quarterTurns, equals(2));

    // Central toolbar should now show "Face-to-Face Active (180°)"
    expect(find.text('Face-to-Face Active (180°)'), findsOneWidget);

    // In-card mic labels facing each speaker should be present
    expect(find.text('Tap mic to speak'), findsNWidgets(2));

    // Bottom dock should be hidden
    expect(find.text('Conversation'), findsNothing);

    // 4. Tap the central chip to exit Face-to-Face Mode
    await tester.tap(find.text('Face-to-Face Active (180°)'));
    await tester.pumpAndSettle();

    // 5. Restored to Normal Mode
    rotatedBox = tester.widget<RotatedBox>(rotatedBoxFinder);
    expect(rotatedBox.quarterTurns, equals(0));
    expect(find.text('Face-to-Face Mode'), findsOneWidget);
    expect(find.text('Conversation'), findsOneWidget);
  });
}
