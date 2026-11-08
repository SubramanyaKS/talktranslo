import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';

class TranslationService {
  final GoogleTranslator _translator = GoogleTranslator();

  /// Normalizes any language code or locale into a valid ISO code for Google Translate.
  static String normalizeLanguageCode(String codeOrLocale) {
    final lower = codeOrLocale.trim().toLowerCase();
    if (lower.startsWith('zh-cn') || lower.contains('simplified')) return 'zh-cn';
    if (lower.startsWith('zh-tw') || lower.contains('traditional')) return 'zh-tw';
    if (lower == 'he' || lower == 'iw') return 'iw';
    if (lower.contains('-')) {
      return lower.split('-').first;
    }
    return lower;
  }

  Future<String> translateText(String text, String targetLanguage, {String sourceLanguage = 'auto'}) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return "";

    final targetCode = normalizeLanguageCode(targetLanguage);
    final sourceCode = (sourceLanguage.isEmpty || sourceLanguage == 'auto')
        ? 'auto'
        : normalizeLanguageCode(sourceLanguage);

    // Tier 1: Try package:translator
    try {
      final translation = await _translator
          .translate(trimmed, from: sourceCode, to: targetCode)
          .timeout(const Duration(seconds: 8));
      if (translation.text.trim().isNotEmpty) {
        return translation.text;
      }
    } catch (e) {
      debugPrint('Tier 1 (translator package) failed: $e. Trying Tier 2 fallback...');
    }

    // Tier 2: Direct HTTP request to Google Translate GTX endpoint
    try {
      final url = Uri.parse(
        'https://translate.googleapis.com/translate_a/single?client=gtx&sl=$sourceCode&tl=$targetCode&dt=t&q=${Uri.encodeComponent(trimmed)}',
      );
      final response = await http.get(url).timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);
        if (data is List && data.isNotEmpty && data[0] is List) {
          final buffer = StringBuffer();
          for (final item in data[0]) {
            if (item is List && item.isNotEmpty && item[0] != null) {
              buffer.write(item[0]);
            }
          }
          final result = buffer.toString().trim();
          if (result.isNotEmpty) return result;
        }
      }
    } catch (e) {
      debugPrint('Tier 2 (GTX endpoint) failed: $e. Trying Tier 3 fallback...');
    }

    // Tier 3: Direct HTTP request to Google Translate Chrome extension endpoint
    try {
      final url = Uri.parse(
        'https://clients5.google.com/translate_a/t?client=dict-chrome-ex&sl=$sourceCode&tl=$targetCode&q=${Uri.encodeComponent(trimmed)}',
      );
      final response = await http.get(url).timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);
        if (data is List && data.isNotEmpty) {
          if (data[0] is List && (data[0] as List).isNotEmpty) {
            final result = data[0][0].toString().trim();
            if (result.isNotEmpty) return result;
          } else if (data[0] is String) {
            final result = data[0].toString().trim();
            if (result.isNotEmpty) return result;
          }
        }
      }
    } catch (e) {
      debugPrint('Tier 3 (Chrome extension endpoint) failed: $e');
    }

    throw Exception(
      'Unable to translate. Please check your internet connection and try again.',
    );
  }
}
