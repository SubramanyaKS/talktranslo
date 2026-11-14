import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../utils/language.dart';

class SpeechService {
  final FlutterTts _flutterTts = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();

  bool _isInitialized = false;
  List<stt.LocaleName>? _cachedSttLocales;

  // Active session delegates to prevent closure-capture bugs across sessions
  Function(String text, bool isFinal)? _currentOnResult;
  VoidCallback? _currentOnDone;
  Function(String error)? _currentOnError;

  bool get isAvailable => _speech.isAvailable;
  bool get isListening => _speech.isListening;

  SpeechService() {
    _initializeTts();
  }

  void _initializeTts() {
    try {
      _flutterTts.setVolume(1.0);
    } catch (e) {
      debugPrint('TTS initialization warning: $e');
    }
  }

  /// Ensures STT is initialized once and delegates events to active listeners.
  Future<bool> initializeIfNeeded() async {
    if (_isInitialized && _speech.isAvailable) return true;

    try {
      _isInitialized = await _speech.initialize(
        onError: (val) {
          debugPrint('STT error: ${val.errorMsg} (permanent: ${val.permanent})');
          _currentOnError?.call(val.errorMsg);
        },
        onStatus: (status) {
          debugPrint('STT status: $status');
          if (status == 'done' || status == 'notListening') {
            _currentOnDone?.call();
          }
        },
        debugLogging: kDebugMode,
      );

      if (_isInitialized) {
        try {
          _cachedSttLocales = await _speech.locales();
        } catch (_) {}
      }
      return _isInitialized;
    } catch (e) {
      debugPrint('STT initialization exception: $e');
      return false;
    }
  }

  /// Finds the best installed STT locale matching the requested code (e.g. kn_IN vs kn-IN).
  Future<String> _resolveBestSttLocale(String requestedLocale) async {
    try {
      if (_cachedSttLocales == null || _cachedSttLocales!.isEmpty) {
        _cachedSttLocales = await _speech.locales();
      }
      if (_cachedSttLocales == null || _cachedSttLocales!.isEmpty) {
        return requestedLocale;
      }

      final normalizedReq = requestedLocale.toLowerCase().replaceAll('_', '-');
      final langPrefix = normalizedReq.split('-').first;

      // 1. Exact match (case and separator insensitive)
      for (final loc in _cachedSttLocales!) {
        final locId = loc.localeId.toLowerCase().replaceAll('_', '-');
        if (locId == normalizedReq) {
          return loc.localeId;
        }
      }

      // 2. Starts with base language prefix (e.g. 'kn' matches 'kn_IN')
      for (final loc in _cachedSttLocales!) {
        final locId = loc.localeId.toLowerCase().replaceAll('_', '-');
        if (locId.startsWith(langPrefix)) {
          return loc.localeId;
        }
      }
    } catch (e) {
      debugPrint('Error finding best STT locale: $e');
    }
    return requestedLocale;
  }

  /// Begins listening with optimized sensitivity, silence detection, and error recovery.
  Future<bool> startListening({
    required Function(String text, bool isFinal) onResult,
    required String locale,
    VoidCallback? onDone,
    Function(String error)? onError,
    Function(double level)? onSoundLevelChange,
  }) async {
    try {
      // Always stop any playing TTS before activating microphone
      await stopSpeaking();

      final ready = await initializeIfNeeded();
      if (!ready) {
        onError?.call("Speech recognition service is unavailable on this device.");
        return false;
      }

      // Update active callbacks for this listening session
      _currentOnResult = onResult;
      _currentOnDone = onDone;
      _currentOnError = onError;

      final matchedLocale = await _resolveBestSttLocale(locale);
      debugPrint('Listening with STT locale: $matchedLocale (requested: $locale)');

      await _speech.listen(
        onResult: (val) {
          _currentOnResult?.call(val.recognizedWords, val.finalResult);
        },
        onSoundLevelChange: onSoundLevelChange,
        listenOptions: stt.SpeechListenOptions(
          localeId: matchedLocale,
          partialResults: true,
          cancelOnError: false, // Don't abort on minor noise or hesitation
          listenMode: stt.ListenMode.dictation, // Dictation mode allows continuous conversational sentences without early cutoff
          pauseFor: const Duration(seconds: 3), // 3s pause before auto-finalizing to avoid premature mic cutoff
          listenFor: const Duration(seconds: 40), // Up to 40s total speech window
        ),
      );

      return true;
    } catch (e) {
      debugPrint('Speech startListening exception: $e');
      onError?.call("Microphone error: $e");
      return false;
    }
  }

  /// Stops speech listening session safely.
  void stopListening() {
    try {
      _speech.stop();
    } catch (e) {
      debugPrint('Speech stopListening error: $e');
    }
  }

  /// Cancels speech recognition immediately.
  void cancelListening() {
    try {
      _speech.cancel();
    } catch (e) {
      debugPrint('Speech cancelListening error: $e');
    }
  }

  /// Stops ongoing TTS audio playback.
  Future<void> stopSpeaking() async {
    try {
      await _flutterTts.stop();
    } catch (e) {
      debugPrint('TTS stop error: $e');
    }
  }

  /// Speaks text with correct language BCP-47 tag, distinct male/female/robot voice, and pitch modulation.
  Future<void> speakText(
    String text,
    String language,
    double pitch,
    double speechRate,
    String selectedVoice, {
    bool isSlow = false,
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    try {
      await stopSpeaking();

      final ttsLocale = getTtsLocale(language);
      final voiceChoice = normalizeVoiceChoice(selectedVoice);

      // 1. Set language with full BCP-47 locale (e.g. kn-IN, hi-IN, es-ES)
      await _flutterTts.setLanguage(ttsLocale);

      // 2. Modulate pitch and speech rate to produce natural, distinctly gendered voice timbres
      double effectivePitch = pitch;
      double effectiveRate = speechRate;

      switch (voiceChoice) {
        case 'male':
          effectivePitch = (pitch * 0.82).clamp(0.5, 2.0);
          effectiveRate = (speechRate * 0.96).clamp(0.5, 2.0);
          break;
        case 'female':
          effectivePitch = (pitch * 1.25).clamp(0.5, 2.0);
          effectiveRate = speechRate.clamp(0.5, 2.0);
          break;
        case 'robot':
          effectivePitch = (pitch * 0.65).clamp(0.5, 2.0);
          effectiveRate = (speechRate * 0.85).clamp(0.5, 2.0);
          break;
        case 'natural':
        default:
          effectivePitch = pitch.clamp(0.5, 2.0);
          effectiveRate = speechRate.clamp(0.5, 2.0);
          break;
      }

      // If slow pronunciation mode is requested (e.g. for language learners)
      if (isSlow) {
        effectiveRate = 0.52;
      }

      await _flutterTts.setPitch(effectivePitch);
      await _flutterTts.setSpeechRate(effectiveRate);

      // 3. Dynamically set native platform voice for the target language and gender if available
      await _applyMatchingPlatformVoice(ttsLocale, voiceChoice);

      await _flutterTts.speak(trimmed);
    } catch (e) {
      debugPrint('TTS speak error: $e');
    }
  }

  /// Dynamically sets matching native voice for target locale and gender without breaking unmatching languages.
  Future<void> _applyMatchingPlatformVoice(String ttsLocale, String voiceChoice) async {
    if (voiceChoice == 'natural') return;

    try {
      final dynamic rawVoices = await _flutterTts.getVoices;
      if (rawVoices is! List || rawVoices.isEmpty) return;

      final langPrefix = ttsLocale.toLowerCase().split(RegExp(r'[-_]')).first;
      final targetLocale = ttsLocale.toLowerCase().replaceAll('_', '-');

      // Filter installed voices matching the target language
      final matchingVoices = rawVoices.where((v) {
        if (v is! Map) return false;
        final vLocale = (v['locale'] ?? '').toString().toLowerCase().replaceAll('_', '-');
        return vLocale == targetLocale || vLocale.startsWith(langPrefix);
      }).toList();

      if (matchingVoices.isEmpty) return;

      dynamic chosenVoice;
      if (voiceChoice == 'female') {
        chosenVoice = matchingVoices.firstWhere(
          (v) {
            final name = (v['name'] ?? '').toString().toLowerCase();
            final gender = (v['gender'] ?? '').toString().toLowerCase();
            return gender == 'female' ||
                name.contains('female') ||
                name.contains('-w-') ||
                name.contains('woman') ||
                name.contains('f0');
          },
          orElse: () => null,
        );
      } else if (voiceChoice == 'male') {
        chosenVoice = matchingVoices.firstWhere(
          (v) {
            final name = (v['name'] ?? '').toString().toLowerCase();
            final gender = (v['gender'] ?? '').toString().toLowerCase();
            return gender == 'male' ||
                name.contains('male') ||
                name.contains('-m-') ||
                name.contains('man') ||
                name.contains('m0');
          },
          orElse: () => null,
        );
      }

      if (chosenVoice != null && chosenVoice['name'] != null) {
        await _flutterTts.setVoice({
          "name": chosenVoice['name'].toString(),
          "locale": chosenVoice['locale']?.toString() ?? ttsLocale,
        });
      }
    } catch (e) {
      debugPrint('Voice selection warning: $e');
    }
  }
}
