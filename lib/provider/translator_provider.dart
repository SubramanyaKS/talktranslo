import 'package:flutter/material.dart';
import '../services/speech_service.dart';
import '../services/translator_service.dart';

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

  void selectLanguage(language){
    selectedLanguage=language;
    notifyListeners();
  }
  void selectSpeedRate(rate){
    speechRate=rate;
    notifyListeners();
  }
  void selectVoice(voice){
    selectedVoice=voice;
    notifyListeners();
  }
  void selectPitch(selectedPitch){
    pitch=selectedPitch;
    notifyListeners();
  }
  void translateLanguage(language){
    translationLanguage=language;
    notifyListeners();
  }

  Future<void> translateText() async {
    String translatedText = await _translationService.translateText(inputController.text, translationLanguage);
    translatedController.text = translatedText;
    notifyListeners();
  }
  Future<void> translateSpeechText() async {
    String translatedText = await _translationService.translateText(generated, translationLanguage);
    translated = translatedText;
    notifyListeners();
  }

  Future<void> speakTranslatedText() async {
    await _speechService.speakText(translatedController.text, translationLanguage,pitch,speechRate,selectedVoice);
  }
  Future<void> speakSpeechTranslatedText() async {
    await _speechService.speakText(translated, translationLanguage,pitch,speechRate,selectedVoice);
  }
  Future<void> speakInputText() async {
    await _speechService.speakText(inputController.text, translationLanguage,pitch,speechRate,selectedVoice);
  }
  Future<void> toggleListening() async {
    if (!isListening) {
      bool available = await _speechService.startListening((text) {
        generated = text;
        notifyListeners();
      }, selectedLanguage);
      isListening = available;
    } else {
      _speechService.stopListening();
      isListening = false;
    }
    notifyListeners();
  }
}