import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/text_recognition_service.dart';
import '../services/translator_service.dart';
import '../utils/language.dart';

class ImageTextProvider with ChangeNotifier {
  static final TextRecognitionService _textRecognitionService =
      TextRecognitionService();
  static final TranslationService _translationService = TranslationService();

  XFile? _imageFile;
  String _scannedText = '';
  bool _textScanning = false;
  String _translatedText ='';
  String _translationLanguage = 'kn';
  String _sourceLanguage = 'English'; // Language to detect from image
  String _sourceScript = 'latin'; // Script for text recognition

  XFile? get imageFile => _imageFile;
  String get scannedText => _scannedText;
  bool get textScanning => _textScanning;
  String get translatedText => _translatedText;
  String get translationLanguage =>_translationLanguage;
  String get sourceLanguage => _sourceLanguage;
  String get sourceScript => _sourceScript;

  Future<void> translateText() async {
    if (_scannedText.isEmpty) {
      _translatedText = '';
      notifyListeners();
      return;
    }

    try {
      _textScanning = true;
      notifyListeners();

      final translatedText =
          await _translationService.translateText(_scannedText, _translationLanguage);
      _translatedText = translatedText;
      _textScanning = false;
      notifyListeners();
    } catch (e) {
      _translatedText = 'Translation error: $e';
      _textScanning = false;
      debugPrint('Translation error: $e');
      notifyListeners();
    }
  }

  void translateLanguage(language){
    _translationLanguage=language;
    notifyListeners();
  }

  void setSourceLanguage(String language) {
    _sourceLanguage = language;
    _sourceScript = languageToScript[language] ?? 'latin';
    notifyListeners();
  }

  Future<void> pickFromCamera() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.camera,
      );

      if (image != null) {
        _imageFile = image;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Camera permission error: $e');
      _imageFile = null;
      notifyListeners();
    }
  }

  Future<void> pickImage() async {
    try {
      _textScanning = true;
      notifyListeners();

      final imagePick = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 40,
        maxWidth: 1200,
      );

      if (imagePick != null) {
        _imageFile = imagePick;
        notifyListeners();
          await Future.delayed(
    const Duration(milliseconds: 100),
  );
        // Perform text recognition
        await getTextRecognition(imagePick);
      } else {
        // User canceled picking
        _textScanning = false;
        notifyListeners();
      }
    } catch (e) {
      _textScanning = false;
      _imageFile = null;
      _scannedText = 'Error occurred while scanning';
      debugPrint("Error picking image: $e");
      notifyListeners();
    }
  }

  Future<void> getTextRecognition(XFile image) async {
    _textScanning = true;
    _scannedText = "";
    notifyListeners();

    try {
      final recognizedText =
          await _textRecognitionService.recognizeTextFromImage(
            image,
            script: _sourceScript,
          );

      _scannedText = recognizedText;
      translateText();
      _textScanning = false;
      notifyListeners();
    } catch (e) {
      _textScanning = false;
      _scannedText = "Error occurred while scanning.";
      debugPrint("Text recognition error: $e");
      notifyListeners();
    }
  }

  void clearData() {
    _imageFile = null;
    _scannedText = '';
    _textScanning = false;
    notifyListeners();
  }
}

