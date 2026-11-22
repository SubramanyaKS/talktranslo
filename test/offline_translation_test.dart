import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talktranslo/provider/translator_provider.dart';
import 'package:talktranslo/screens/offline_languages_screen.dart';
import 'package:talktranslo/services/offline_translation_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('google_mlkit_translation'),
      (call) async => false,
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('google_mlkit_translation'), null);
  });

  group('OfflineTranslationService Unit Tests', () {
    test('toMlKitLanguage maps ISO codes, BCP-47 locales, and names accurately', () {
      expect(OfflineTranslationService.toMlKitLanguage('en'), equals(TranslateLanguage.english));
      expect(OfflineTranslationService.toMlKitLanguage('en-US'), equals(TranslateLanguage.english));
      expect(OfflineTranslationService.toMlKitLanguage('kn-IN'), equals(TranslateLanguage.kannada));
      expect(OfflineTranslationService.toMlKitLanguage('Kannada'), equals(TranslateLanguage.kannada));
      expect(OfflineTranslationService.toMlKitLanguage('hi'), equals(TranslateLanguage.hindi));
      expect(OfflineTranslationService.toMlKitLanguage('ko-KR'), equals(TranslateLanguage.korean));
      expect(OfflineTranslationService.toMlKitLanguage('zh-CN'), equals(TranslateLanguage.chinese));
      expect(OfflineTranslationService.toMlKitLanguage('iw'), equals(TranslateLanguage.hebrew));

      // Unsupported / auto returns null
      expect(OfflineTranslationService.toMlKitLanguage('auto'), isNull);
      expect(OfflineTranslationService.toMlKitLanguage('ml'), isNull); // Malayalam
      expect(OfflineTranslationService.toMlKitLanguage('gom'), isNull); // Konkani
    });

    test('supportedLanguages and onlineOnlyLanguages partition languageMap cleanly', () {
      final supported = OfflineTranslationService.supportedLanguages;
      final onlineOnly = OfflineTranslationService.onlineOnlyLanguages;

      expect(supported.any((l) => l.name == 'Kannada'), isTrue);
      expect(supported.any((l) => l.name == 'English'), isTrue);
      expect(supported.any((l) => l.name == 'Korean'), isTrue);
      expect(onlineOnly, containsAll(['Assamese', 'Konkani', 'Malayalam', 'Sanskrit']));
    });
  });

  group('OfflineLanguagesScreen Widget Tests', () {
    testWidgets('renders offline preference switches and language pack list',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => TranslationProvider()),
          ],
          child: const MaterialApp(
            home: OfflineLanguagesScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Offline Translation'), findsOneWidget);
      expect(find.text('Auto Offline Fallback'), findsOneWidget);
      expect(find.text('Prefer Offline Mode'), findsOneWidget);
      expect(find.text('Download Over Wi-Fi Only'), findsOneWidget);
      expect(find.text('Offline Language Packs'), findsOneWidget);
    });
  });
}
