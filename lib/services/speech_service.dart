import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'translator_service.dart';

class SpeechService {
  final FlutterTts _flutterTts = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();

  bool get isAvailable => _speech.isAvailable;
  bool get isListening => _speech.isListening;

  Future<void> speakText(
    String text,
    String language,
    double pitch,
    double speechRate,
    String selectedVoice,
  ) async {
    if (text.trim().isEmpty) return;
    try {
      final cleanLang = TranslationService.normalizeLanguageCode(language);
      await _flutterTts.setLanguage(cleanLang);
      await _flutterTts.setPitch(pitch);
      await _flutterTts.setSpeechRate(speechRate);
      if (selectedVoice.isNotEmpty) {
        try {
          await _flutterTts.setVoice({"name": selectedVoice});
        } catch (_) {}
      }
      await _flutterTts.speak(text.trim());
    } catch (e) {
      debugPrint('TTS speak error: $e');
    }
  }

  Future<bool> startListening({
    required Function(String text, bool isFinal) onResult,
    required String locale,
    VoidCallback? onDone,
  }) async {
    try {
      bool available = _speech.isAvailable;
      if (!available) {
        available = await _speech.initialize(
          onError: (val) => debugPrint('STT error: $val'),
          onStatus: (status) {
            debugPrint('STT status: $status');
            if (status == 'done' || status == 'notListening') {
              onDone?.call();
            }
          },
        );
      }

      if (available) {
        await _speech.listen(
          onResult: (val) {
            onResult(val.recognizedWords, val.finalResult);
          },
          listenOptions: stt.SpeechListenOptions(
            localeId: locale,
            partialResults: true,
            cancelOnError: true,
            listenMode: stt.ListenMode.dictation,
          ),
        );
      }
      return available;
    } catch (e) {
      debugPrint('Speech startListening exception: $e');
      return false;
    }
  }

  void stopListening() {
    try {
      _speech.stop();
    } catch (e) {
      debugPrint('Speech stopListening error: $e');
    }
  }
}
