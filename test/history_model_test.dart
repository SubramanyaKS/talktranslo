import 'package:flutter_test/flutter_test.dart';
import 'package:talktranslo/models/history_item.dart';

void main() {
  group('TranslationHistoryItem Model Tests', () {
    test('toMap and fromMap serialization', () {
      final now = DateTime.now();
      final item = TranslationHistoryItem(
        id: 1,
        sourceText: 'Hello',
        translatedText: 'ನಮಸ್ಕಾರ',
        sourceLang: 'en-US',
        targetLang: 'kn',
        timestamp: now,
        isFavorite: true,
      );

      final map = item.toMap();
      final fromMap = TranslationHistoryItem.fromMap(map);

      expect(fromMap.id, equals(1));
      expect(fromMap.sourceText, equals('Hello'));
      expect(fromMap.translatedText, equals('ನಮಸ್ಕಾರ'));
      expect(fromMap.sourceLang, equals('en-US'));
      expect(fromMap.targetLang, equals('kn'));
      expect(fromMap.isFavorite, isTrue);
      expect(fromMap.timestamp.millisecondsSinceEpoch, equals(now.millisecondsSinceEpoch));
    });

    test('copyWith works correctly', () {
      final item = TranslationHistoryItem(
        id: 1,
        sourceText: 'Hello',
        translatedText: 'Hola',
        sourceLang: 'en',
        targetLang: 'es',
        timestamp: DateTime.now(),
        isFavorite: false,
      );

      final updated = item.copyWith(isFavorite: true);
      expect(updated.id, equals(1));
      expect(updated.isFavorite, isTrue);
      expect(updated.sourceText, equals('Hello'));
    });
  });
}
