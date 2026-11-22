import 'package:flutter/foundation.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import '../utils/language.dart';
import 'translator_service.dart';

class OfflineLanguageInfo {
  final String name;
  final String code;
  final TranslateLanguage mlKitLanguage;

  const OfflineLanguageInfo({
    required this.name,
    required this.code,
    required this.mlKitLanguage,
  });
}

class OfflineTranslationService {
  static final OfflineTranslationService instance = OfflineTranslationService._internal();
  OfflineTranslationService._internal();

  final OnDeviceTranslatorModelManager _modelManager = OnDeviceTranslatorModelManager();

  /// Maps any TalkTranslo language name, ISO code, or BCP-47 locale to ML Kit's [TranslateLanguage].
  /// Returns null for languages not supported by on-device ML Kit models.
  static TranslateLanguage? toMlKitLanguage(String codeOrLocale) {
    final trimmed = codeOrLocale.trim();
    if (trimmed.isEmpty || trimmed.toLowerCase() == 'auto') return null;

    // Resolve full language name if provided (e.g. 'Kannada' -> 'kn')
    String resolved = trimmed;
    if (languageMap.containsKey(trimmed)) {
      resolved = languageMap[trimmed]!;
    } else if (talklanguageMap.containsKey(trimmed)) {
      resolved = talklanguageMap[trimmed]!;
    }

    final normalized = TranslationService.normalizeLanguageCode(resolved);
    switch (normalized) {
      case 'ar':
        return TranslateLanguage.arabic;
      case 'bn':
        return TranslateLanguage.bengali;
      case 'zh-cn':
      case 'zh-tw':
      case 'zh':
        return TranslateLanguage.chinese;
      case 'en':
        return TranslateLanguage.english;
      case 'fr':
        return TranslateLanguage.french;
      case 'de':
        return TranslateLanguage.german;
      case 'gu':
        return TranslateLanguage.gujarati;
      case 'iw':
      case 'he':
        return TranslateLanguage.hebrew;
      case 'hi':
        return TranslateLanguage.hindi;
      case 'ja':
        return TranslateLanguage.japanese;
      case 'kn':
        return TranslateLanguage.kannada;
      case 'ko':
        return TranslateLanguage.korean;
      case 'ru':
        return TranslateLanguage.russian;
      case 'es':
        return TranslateLanguage.spanish;
      case 'ta':
        return TranslateLanguage.tamil;
      case 'te':
        return TranslateLanguage.telugu;
      case 'th':
        return TranslateLanguage.thai;
      default:
        return null;
    }
  }

  static bool isOfflineSupported(String codeOrLocale) => toMlKitLanguage(codeOrLocale) != null;

  /// Unique list of offline-downloadable languages supported by both TalkTranslo and ML Kit.
  static List<OfflineLanguageInfo> get supportedLanguages {
    final seenBcpCodes = <String>{};
    final result = <OfflineLanguageInfo>[];

    for (final entry in languageMap.entries) {
      final mlLang = toMlKitLanguage(entry.value);
      if (mlLang != null && seenBcpCodes.add(mlLang.bcpCode)) {
        final displayName = entry.key.startsWith('Chinese') ? 'Chinese' : entry.key;
        result.add(
          OfflineLanguageInfo(
            name: displayName,
            code: entry.value,
            mlKitLanguage: mlLang,
          ),
        );
      }
    }
    return result;
  }

  /// Languages in TalkTranslo that currently require an internet connection.
  static List<String> get onlineOnlyLanguages {
    return languageMap.entries
        .where((e) => toMlKitLanguage(e.value) == null)
        .map((e) => e.key)
        .toList();
  }

  Future<bool> isModelDownloaded(String codeOrLocale) async {
    final mlLang = toMlKitLanguage(codeOrLocale);
    if (mlLang == null) return false;
    try {
      return await _modelManager
          .isModelDownloaded(mlLang.bcpCode)
          .timeout(const Duration(seconds: 3), onTimeout: () => false);
    } catch (e) {
      debugPrint('Offline model check error ($codeOrLocale): $e');
      return false;
    }
  }

  Future<bool> downloadModel(String codeOrLocale, {bool isWifiRequired = false}) async {
    final mlLang = toMlKitLanguage(codeOrLocale);
    if (mlLang == null) return false;
    try {
      return await _modelManager.downloadModel(
        mlLang.bcpCode,
        isWifiRequired: isWifiRequired,
      );
    } catch (e) {
      debugPrint('Offline model download error ($codeOrLocale): $e');
      return false;
    }
  }

  Future<bool> deleteModel(String codeOrLocale) async {
    final mlLang = toMlKitLanguage(codeOrLocale);
    if (mlLang == null) return false;
    try {
      return await _modelManager.deleteModel(mlLang.bcpCode);
    } catch (e) {
      debugPrint('Offline model delete error ($codeOrLocale): $e');
      return false;
    }
  }

  /// Translates text completely on-device ONLY if both source and target models are already downloaded.
  /// Never silently downloads models without explicit user permission.
  Future<String?> translateOffline(
    String text, {
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return '';

    final effectiveSource = (sourceLanguage.isEmpty || sourceLanguage == 'auto')
        ? 'en'
        : sourceLanguage;

    final srcLang = toMlKitLanguage(effectiveSource);
    final tgtLang = toMlKitLanguage(targetLanguage);
    if (srcLang == null || tgtLang == null) return null;
    if (srcLang == tgtLang) return trimmed;

    try {
      final srcReady = await _modelManager.isModelDownloaded(srcLang.bcpCode);
      final tgtReady = await _modelManager.isModelDownloaded(tgtLang.bcpCode);
      if (!srcReady || !tgtReady) {
        return null;
      }

      final translator = OnDeviceTranslator(
        sourceLanguage: srcLang,
        targetLanguage: tgtLang,
      );
      try {
        final result = await translator.translateText(trimmed);
        return result.trim().isNotEmpty ? result.trim() : null;
      } finally {
        await translator.close();
      }
    } catch (e) {
      debugPrint('On-device offline translation failed: $e');
      return null;
    }
  }
}
