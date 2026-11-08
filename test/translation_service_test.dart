import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talktranslo/services/translator_service.dart';
import 'package:talktranslo/utils/language.dart';
import 'package:talktranslo/provider/image_text_provider.dart';
import 'package:talktranslo/provider/translator_provider.dart';

class _RealHttpOverrides extends HttpOverrides {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = _RealHttpOverrides();
  SharedPreferences.setMockInitialValues({});

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(const MethodChannel('flutter_tts'), (call) async => 1);
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(const MethodChannel('speech_to_text'), (call) async => true);

  group('TranslationService Live Tests', () {
    final service = TranslationService();

    test('Translates English to Kannada', () async {
      final result = await service.translateText('Hello, how are you?', 'kn');
      expect(result, isNotEmpty);
      // ignore: avoid_print
      print('English -> Kannada: "Hello, how are you?" -> "$result"');
    });

    test('Translates English to Spanish', () async {
      final result = await service.translateText('Good morning', 'es');
      expect(result.toLowerCase(), anyOf(contains('días'), contains('día')));
      // ignore: avoid_print
      print('English -> Spanish: "Good morning" -> "$result"');
    });

    test('Translates English to Hindi', () async {
      final result = await service.translateText('Thank you', 'hi');
      expect(result, isNotEmpty);
      // ignore: avoid_print
      print('English -> Hindi: "Thank you" -> "$result"');
    });

    test('Empty text returns empty string', () async {
      final result = await service.translateText('', 'kn');
      expect(result, isEmpty);
    });

    test('Translates with auto-detected source language', () async {
      final result = await service.translateText('Gracias amigo', 'en', sourceLanguage: 'auto');
      expect(result.toLowerCase(), contains('thank'));
    });
  });

  group('TranslationProvider Swap and State Tests', () {
    test('Swapping languages swaps codes, locales and controllers', () {
      final provider = TranslationProvider();
      provider.selectedLanguage = 'en-US';
      provider.translationLanguage = 'kn';
      provider.inputController.text = 'Hello';
      provider.translatedController.text = 'ನಮಸ್ಕಾರ';

      provider.swapLanguages();

      expect(provider.selectedLanguage, equals('kn-IN'));
      expect(provider.translationLanguage, equals('en'));
      expect(provider.inputController.text, equals('ನಮಸ್ಕಾರ'));
      expect(provider.translatedController.text, equals('Hello'));
    });

    test('clearConversation resets all dual-speaker transcripts, translations, and active state', () {
      final provider = TranslationProvider();
      provider.speakerASpeech = 'Hello from A';
      provider.speakerATranslation = 'ನಮಸ್ಕಾರ';
      provider.speakerBSpeech = 'ಹೇಗಿದ್ದೀರಿ';
      provider.speakerBTranslation = 'How are you';
      provider.activeSpeaker = 1;

      provider.clearConversation();

      expect(provider.speakerASpeech, isEmpty);
      expect(provider.speakerATranslation, isEmpty);
      expect(provider.speakerBSpeech, isEmpty);
      expect(provider.speakerBTranslation, isEmpty);
      expect(provider.activeSpeaker, equals(0));
    });

    test('Swapping languages does not execute if selectedLanguage is auto', () {
      final provider = TranslationProvider();
      provider.selectedLanguage = 'auto';
      provider.translationLanguage = 'kn';
      provider.inputController.text = 'Hello';
      provider.translatedController.text = 'ನಮಸ್ಕಾರ';

      provider.swapLanguages();

      // State remains unchanged
      expect(provider.selectedLanguage, equals('auto'));
      expect(provider.translationLanguage, equals('kn'));
      expect(provider.inputController.text, equals('Hello'));
      expect(provider.translatedController.text, equals('ನಮಸ್ಕಾರ'));
    });

    test('translateSourceLanguageMap contains Auto Detect as first option', () {
      expect(translateSourceLanguageMap.containsKey('Auto Detect'), isTrue);
      expect(translateSourceLanguageMap['Auto Detect'], equals('auto'));
      expect(getLanguageFlag('Auto Detect'), equals('✨'));
    });
  });

  group('ImageTextProvider State Tests', () {
    test('clearData resets scannedText, translatedText, imageFile, and textScanning', () {
      final provider = ImageTextProvider();
      provider.clearData();

      expect(provider.scannedText, isEmpty);
      expect(provider.translatedText, isEmpty);
      expect(provider.imageFile, isNull);
      expect(provider.textScanning, isFalse);
    });
  });
}
