import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talktranslo/provider/theme_provider.dart';
import 'package:talktranslo/provider/translator_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Settings Persistence Tests', () {
    test('ThemeProvider persists and reloads theme mode', () async {
      final themeProvider1 = ThemeProvider();
      await Future.delayed(const Duration(milliseconds: 50));
      expect(themeProvider1.isDarkMode, isFalse);

      // Toggle to dark mode
      await themeProvider1.toggleTheme();
      expect(themeProvider1.isDarkMode, isTrue);

      // Instantiate a new ThemeProvider to simulate app restart
      final themeProvider2 = ThemeProvider();
      await Future.delayed(const Duration(milliseconds: 50));
      expect(themeProvider2.isDarkMode, isTrue);
    });

    test('TranslationProvider persists and reloads language and speech preferences', () async {
      final provider1 = TranslationProvider();
      await Future.delayed(const Duration(milliseconds: 50));

      // Modify preferences
      await provider1.selectLanguage('kn-IN');
      await provider1.translateLanguage('fr');
      await provider1.selectSpeedRate(1.5);
      await provider1.selectPitch(1.2);
      await provider1.selectVoice('female');

      // Instantiate a new TranslationProvider to simulate app restart
      final provider2 = TranslationProvider();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(provider2.selectedLanguage, equals('kn-IN'));
      expect(provider2.translationLanguage, equals('fr'));
      expect(provider2.speechRate, equals(1.5));
      expect(provider2.pitch, equals(1.2));
      expect(provider2.selectedVoice, equals('female'));
    });

    test('TranslationProvider normalizes legacy voice preference string to valid voice', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('pref_selected_voice', 'en-us-x-sfg#female_1-local');

      final provider = TranslationProvider();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(provider.selectedVoice, equals('female'));
    });
  });
}
