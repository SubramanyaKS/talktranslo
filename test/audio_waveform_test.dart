import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talktranslo/component/audio_waveform.dart';

void main() {
  group('AudioWaveform Widget Tests', () {
    testWidgets('renders resting bars when isListening is false', (WidgetTester tester) async {
      final soundLevelNotifier = ValueNotifier<double>(0.0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AudioWaveform(
              soundLevel: soundLevelNotifier,
              isListening: false,
              activeColor: Colors.blue,
              barCount: 7,
            ),
          ),
        ),
      );

      // Verify Row of animated bars renders
      expect(find.byType(AudioWaveform), findsOneWidget);
      expect(find.byType(AnimatedContainer), findsNWidgets(7));
    });

    testWidgets('renders active vibrating bars when isListening is true and soundLevel updates', (WidgetTester tester) async {
      final soundLevelNotifier = ValueNotifier<double>(0.0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AudioWaveform(
              soundLevel: soundLevelNotifier,
              isListening: true,
              activeColor: Colors.blue,
              barCount: 7,
            ),
          ),
        ),
      );

      // Update sound level to simulate speech input
      soundLevelNotifier.value = 0.8;
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(AudioWaveform), findsOneWidget);
      expect(find.byType(AnimatedContainer), findsNWidgets(7));
    });
  });
}
