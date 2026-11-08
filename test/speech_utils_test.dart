import 'package:flutter_test/flutter_test.dart';
import 'package:talktranslo/utils/language.dart';

void main() {
  group('Speech & Voice Utils Tests', () {
    test('normalizeVoiceChoice correctly parses standard and legacy voice strings', () {
      expect(normalizeVoiceChoice('female'), equals('female'));
      expect(normalizeVoiceChoice('male'), equals('male'));
      expect(normalizeVoiceChoice('robot'), equals('robot'));
      expect(normalizeVoiceChoice('natural'), equals('natural'));
      expect(normalizeVoiceChoice('default'), equals('natural'));

      // Legacy Android strings
      expect(normalizeVoiceChoice('en-us-x-sfg#female_1-local'), equals('female'));
      expect(normalizeVoiceChoice('en-us-x-sfg#male_1-local'), equals('male'));
      expect(normalizeVoiceChoice('en-us-x-sfg#robot-local'), equals('robot'));

      // Null or empty fallback
      expect(normalizeVoiceChoice(null), equals('natural'));
      expect(normalizeVoiceChoice(''), equals('natural'));
      expect(normalizeVoiceChoice('unknown-random'), equals('natural'));
    });

    test('getTtsLocale resolves 2-letter codes, language names, and locales to valid BCP-47 tags', () {
      // 2-letter codes from languageMap
      expect(getTtsLocale('kn'), equals('kn-IN'));
      expect(getTtsLocale('hi'), equals('hi-IN'));
      expect(getTtsLocale('en'), equals('en-US'));
      expect(getTtsLocale('es'), equals('es-ES'));
      expect(getTtsLocale('fr'), equals('fr-FR'));
      expect(getTtsLocale('de'), equals('de-DE'));
      expect(getTtsLocale('ta'), equals('ta-IN'));
      expect(getTtsLocale('te'), equals('te-IN'));
      expect(getTtsLocale('ru'), equals('ru-RU'));
      expect(getTtsLocale('zh-CN'), equals('zh-CN'));

      // Full language names
      expect(getTtsLocale('Kannada'), equals('kn-IN'));
      expect(getTtsLocale('Hindi'), equals('hi-IN'));
      expect(getTtsLocale('English'), equals('en-US'));
      expect(getTtsLocale('English (India)'), equals('en-IN'));
      expect(getTtsLocale('English (US)'), equals('en-US'));
      expect(getTtsLocale('Spanish'), equals('es-ES'));

      // Direct BCP-47 locales
      expect(getTtsLocale('kn-IN'), equals('kn-IN'));
      expect(getTtsLocale('en-IN'), equals('en-IN'));
      expect(getTtsLocale('en-US'), equals('en-US'));

      // Fallback on empty or unknown
      expect(getTtsLocale(''), equals('en-US'));
    });

    test('English India and US dropdown mapping and flag resolution', () {
      expect(talklanguageMap['English (India)'], equals('en-IN'));
      expect(talklanguageMap['English (US)'], equals('en-US'));
      expect(getLanguageNameFromValue(talklanguageMap, 'en-IN'), equals('English (India)'));
      expect(getLanguageNameFromValue(talklanguageMap, 'en-US'), equals('English (US)'));
      expect(getLanguageFlag('English (India)'), equals('🇮🇳'));
      expect(getLanguageFlag('English (US)'), equals('🇺🇸'));
    });
  });
}
