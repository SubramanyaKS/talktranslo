import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';
import 'offline_translation_service.dart';

class TranslationResult {
  final String text;
  final String? detectedSourceLanguage;
  final String? transliteration;
  final bool isOffline;

  const TranslationResult({
    required this.text,
    this.detectedSourceLanguage,
    this.transliteration,
    this.isOffline = false,
  });
}

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
    final result = await translateWithDetails(text, targetLanguage, sourceLanguage: sourceLanguage);
    return result.text;
  }

  Future<TranslationResult> translateWithDetails(
    String text,
    String targetLanguage, {
    String sourceLanguage = 'auto',
    bool allowOfflineFallback = true,
    bool preferOffline = false,
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return const TranslationResult(text: "");

    final targetCode = normalizeLanguageCode(targetLanguage);
    final sourceCode = (sourceLanguage.isEmpty || sourceLanguage == 'auto')
        ? 'auto'
        : normalizeLanguageCode(sourceLanguage);

    // Optional Offline-First Mode (if user enabled "Prefer Offline Mode" and models are downloaded)
    if (preferOffline) {
      final offlineResult = await OfflineTranslationService.instance.translateOffline(
        trimmed,
        sourceLanguage: sourceCode,
        targetLanguage: targetCode,
      );
      if (offlineResult != null && offlineResult.isNotEmpty) {
        return TranslationResult(text: offlineResult, isOffline: true);
      }
    }

    // Tier 1: Direct HTTP request to Google Translate GTX endpoint (includes romanization via dt=rm)
    try {
      final url = Uri.parse(
        'https://translate.googleapis.com/translate_a/single?client=gtx&sl=$sourceCode&tl=$targetCode&dt=t&dt=rm&q=${Uri.encodeComponent(trimmed)}',
      );
      final response = await http.get(url).timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);
        if (data is List && data.isNotEmpty && data[0] is List) {
          final buffer = StringBuffer();
          final translitBuffer = StringBuffer();
          for (final item in data[0]) {
            if (item is List && item.isNotEmpty) {
              if (item[0] != null) {
                buffer.write(item[0]);
              } else if (item.length > 2 && item[2] is String) {
                translitBuffer.write(item[2]);
              }
            }
          }
          final result = buffer.toString().trim();
          if (result.isNotEmpty) {
            final detected = (sourceCode == 'auto' && data.length > 2 && data[2] is String)
                ? data[2] as String
                : null;
            final rawTranslit = translitBuffer.toString().trim();
            final translit = (rawTranslit.isNotEmpty &&
                    rawTranslit.toLowerCase() != result.toLowerCase())
                ? rawTranslit
                : null;
            return TranslationResult(
              text: result,
              detectedSourceLanguage: detected,
              transliteration: translit,
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Tier 1 (GTX endpoint) failed: $e. Trying Tier 2 fallback...');
    }

    // Tier 2: Try package:translator
    try {
      final translation = await _translator
          .translate(trimmed, from: sourceCode, to: targetCode)
          .timeout(const Duration(seconds: 8));
      if (translation.text.trim().isNotEmpty) {
        final detected = (sourceCode == 'auto' &&
                translation.sourceLanguage.code.isNotEmpty &&
                translation.sourceLanguage.code != 'auto')
            ? translation.sourceLanguage.code
            : null;
        return TranslationResult(
          text: translation.text,
          detectedSourceLanguage: detected,
        );
      }
    } catch (e) {
      debugPrint('Tier 2 (translator package) failed: $e. Trying Tier 3 fallback...');
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
            if (result.isNotEmpty) {
              final detected = (sourceCode == 'auto' &&
                      (data[0] as List).length > 1 &&
                      data[0][1] is String)
                  ? data[0][1] as String
                  : null;
              return TranslationResult(
                text: result,
                detectedSourceLanguage: detected,
              );
            }
          } else if (data[0] is String) {
            final result = data[0].toString().trim();
            if (result.isNotEmpty) {
              return TranslationResult(text: result);
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Tier 3 (Chrome extension endpoint) failed: $e');
    }

    // Tier 4: Automatic On-Device Offline Fallback (only uses already-downloaded ML Kit models)
    if (allowOfflineFallback && !preferOffline) {
      final offlineResult = await OfflineTranslationService.instance.translateOffline(
        trimmed,
        sourceLanguage: sourceCode,
        targetLanguage: targetCode,
      );
      if (offlineResult != null && offlineResult.isNotEmpty) {
        return TranslationResult(text: offlineResult, isOffline: true);
      }
    }

    throw Exception(
      'Unable to translate. Check your internet connection or download Offline Language Packs in Settings.',
    );
  }
}
