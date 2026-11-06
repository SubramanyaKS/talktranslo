import 'package:flutter/material.dart';
import '../services/speech_service.dart';
import '../services/translator_service.dart';
import '../utils/language.dart';

class TranslationProvider with ChangeNotifier {
  static final TranslationService _translationService = TranslationService();
  static final SpeechService _speechService = SpeechService();

  TextEditingController inputController = TextEditingController();
  TextEditingController translatedController = TextEditingController();
  bool isListening = false;
  String selectedLanguage = 'en-US';
  String translationLanguage = "kn"; // Default to Kannada
  String generated = '';
  String translated = '';
  double speechRate = 1.0;
  double pitch = 1.0;
  String selectedVoice = "en-us-x-sfg#male_1-local";

  String? translationError;
  String? speechError;

  void clearSpeechError() {
    speechError = null;
    notifyListeners();
  }

  // Conversational Voice Mode State
  int activeSpeaker = 0; // 0: None, 1: Speaker A, 2: Speaker B
  String speakerASpeech = '';
  String speakerATranslation = '';
  String speakerBSpeech = '';
  String speakerBTranslation = '';
  bool isTranslatingSpeech = false;

  void selectLanguage(dynamic language) {
    selectedLanguage = language.toString();
    notifyListeners();
  }

  void selectSpeedRate(double rate) {
    speechRate = rate;
    notifyListeners();
  }

  void selectVoice(dynamic voice) {
    selectedVoice = voice.toString();
    notifyListeners();
  }

  void selectPitch(double selectedPitch) {
    pitch = selectedPitch;
    notifyListeners();
  }

  void translateLanguage(dynamic language) {
    translationLanguage = language.toString();
    notifyListeners();
  }

  void swapLanguages() {
    final sourceName = getLanguageNameFromValue(talklanguageMap, selectedLanguage);
    final targetName = getLanguageNameFromValue(languageMap, translationLanguage);

    if (talklanguageMap.containsKey(targetName)) {
      selectedLanguage = talklanguageMap[targetName]!;
    }
    if (languageMap.containsKey(sourceName)) {
      translationLanguage = languageMap[sourceName]!;
    }

    final prevInput = inputController.text;
    final prevTranslated = translatedController.text;
    if (prevTranslated.isNotEmpty) {
      inputController.text = prevTranslated;
      translatedController.text = prevInput;
    }

    notifyListeners();
  }

  Future<bool> translateText() async {
    final text = inputController.text.trim();
    if (text.isEmpty) return false;
    try {
      translationError = null;
      notifyListeners();
      final translatedText = await _translationService.translateText(
        text,
        translationLanguage,
      );
      translatedController.text = translatedText;
      notifyListeners();
      return true;
    } catch (e) {
      translationError = e.toString().replaceFirst('Exception: ', '');
      debugPrint('Translation error: $e');
      notifyListeners();
      return false;
    }
  }

  Future<void> translateSpeechText() async {
    final text = generated.trim();
    if (text.isEmpty) return;
    try {
      final translatedText = await _translationService.translateText(
        text,
        translationLanguage,
      );
      translated = translatedText;
      notifyListeners();
    } catch (e) {
      debugPrint('Speech translation error: $e');
    }
  }

  Future<void> speakTranslatedText() async {
    if (translatedController.text.trim().isEmpty) return;
    await _speechService.speakText(
      translatedController.text,
      translationLanguage,
      pitch,
      speechRate,
      selectedVoice,
    );
  }

  Future<void> speakSpeechTranslatedText() async {
    if (translated.trim().isEmpty) return;
    await _speechService.speakText(
      translated,
      translationLanguage,
      pitch,
      speechRate,
      selectedVoice,
    );
  }

  Future<void> speakInputText() async {
    if (inputController.text.trim().isEmpty) return;
    await _speechService.speakText(
      inputController.text,
      selectedLanguage,
      pitch,
      speechRate,
      selectedVoice,
    );
  }

  Future<void> toggleListening() async {
    if (!isListening) {
      final available = await _speechService.startListening(
        onResult: (text, _) {
          generated = text;
          notifyListeners();
        },
        locale: selectedLanguage,
        onDone: () {
          isListening = false;
          notifyListeners();
        },
      );
      isListening = available;
    } else {
      _speechService.stopListening();
      isListening = false;
    }
    notifyListeners();
  }

  // Dual Conversational Mode Handlers
  Future<void> toggleSpeakerAListening() async {
    speechError = null;

    if (activeSpeaker == 1) {
      _speechService.stopListening();
      activeSpeaker = 0;
      notifyListeners();
      if (speakerASpeech.trim().isNotEmpty) {
        await translateSpeakerASpeech();
      }
      return;
    }

    _speechService.stopListening();
    activeSpeaker = 1;
    speakerASpeech = '';
    speakerATranslation = '';
    notifyListeners();

    final available = await _speechService.startListening(
      onResult: (text, isFinal) {
        speakerASpeech = text;
        generated = text;
        notifyListeners();
        if (isFinal && text.trim().isNotEmpty) {
          activeSpeaker = 0;
          translateSpeakerASpeech();
        }
      },
      locale: selectedLanguage,
      onDone: () {
        if (activeSpeaker == 1) {
          activeSpeaker = 0;
          notifyListeners();
          if (speakerASpeech.trim().isNotEmpty && speakerATranslation.isEmpty) {
            translateSpeakerASpeech();
          }
        }
      },
    );

    if (!available) {
      activeSpeaker = 0;
      speechError = "Microphone is unavailable. Please check microphone permissions in Settings.";
      notifyListeners();
    }
  }

  Future<void> translateSpeakerASpeech() async {
    if (speakerASpeech.trim().isEmpty) return;
    try {
      isTranslatingSpeech = true;
      notifyListeners();
      final res = await _translationService.translateText(
        speakerASpeech,
        translationLanguage,
      );
      speakerATranslation = res;
      translated = res;
      isTranslatingSpeech = false;
      notifyListeners();
      await speakSpeakerATranslation();
    } catch (e) {
      isTranslatingSpeech = false;
      speakerATranslation = "Translation failed: $e";
      notifyListeners();
    }
  }

  Future<void> toggleSpeakerBListening() async {
    speechError = null;

    if (activeSpeaker == 2) {
      _speechService.stopListening();
      activeSpeaker = 0;
      notifyListeners();
      if (speakerBSpeech.trim().isNotEmpty) {
        await translateSpeakerBSpeech();
      }
      return;
    }

    _speechService.stopListening();
    activeSpeaker = 2;
    speakerBSpeech = '';
    speakerBTranslation = '';
    notifyListeners();

    final targetLangName = getLanguageNameFromValue(languageMap, translationLanguage);
    final speakerBLocale = talklanguageMap[targetLangName] ?? 'kn-IN';

    final available = await _speechService.startListening(
      onResult: (text, isFinal) {
        speakerBSpeech = text;
        notifyListeners();
        if (isFinal && text.trim().isNotEmpty) {
          activeSpeaker = 0;
          translateSpeakerBSpeech();
        }
      },
      locale: speakerBLocale,
      onDone: () {
        if (activeSpeaker == 2) {
          activeSpeaker = 0;
          notifyListeners();
          if (speakerBSpeech.trim().isNotEmpty && speakerBTranslation.isEmpty) {
            translateSpeakerBSpeech();
          }
        }
      },
    );

    if (!available) {
      activeSpeaker = 0;
      speechError = "Microphone is unavailable. Please check microphone permissions in Settings.";
      notifyListeners();
    }
  }

  Future<void> translateSpeakerBSpeech() async {
    if (speakerBSpeech.trim().isEmpty) return;
    try {
      isTranslatingSpeech = true;
      notifyListeners();
      final sourceLangName = getLanguageNameFromValue(talklanguageMap, selectedLanguage);
      final targetCode = languageMap[sourceLangName] ?? 'en';
      final res = await _translationService.translateText(
        speakerBSpeech,
        targetCode,
      );
      speakerBTranslation = res;
      isTranslatingSpeech = false;
      notifyListeners();
      await speakSpeakerBTranslation();
    } catch (e) {
      isTranslatingSpeech = false;
      speakerBTranslation = "Translation failed: $e";
      notifyListeners();
    }
  }

  Future<void> speakSpeakerATranslation() async {
    if (speakerATranslation.trim().isEmpty) return;
    await _speechService.speakText(
      speakerATranslation,
      translationLanguage,
      pitch,
      speechRate,
      selectedVoice,
    );
  }

  Future<void> speakSpeakerBTranslation() async {
    if (speakerBTranslation.trim().isEmpty) return;
    final sourceLangName = getLanguageNameFromValue(talklanguageMap, selectedLanguage);
    final targetCode = languageMap[sourceLangName] ?? 'en';
    await _speechService.speakText(
      speakerBTranslation,
      targetCode,
      pitch,
      speechRate,
      selectedVoice,
    );
  }
}
