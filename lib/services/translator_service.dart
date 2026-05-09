import 'dart:async';

import 'package:translator/translator.dart';

class TranslationService {
  final GoogleTranslator _translator = GoogleTranslator();

  Future<String> translateText(String text, String targetLanguage) async {
    if (text.isEmpty) return "";
    
    try {
      // Add timeout to prevent indefinite hanging
      final translation = await _translator
          .translate(text, to: targetLanguage)
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw TimeoutException('Translation request timed out'),
          );
      return translation.text;
    } on TimeoutException catch (e) {
      throw Exception('Translation timeout: Please check your internet connection: ${e.message}');
    } on Exception catch (e) {
      throw Exception('Translation failed: ${e.toString()}');
    } catch (e) {
      throw Exception('Unexpected error during translation: $e');
    }
  }
}