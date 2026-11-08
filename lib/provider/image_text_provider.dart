import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../models/history_item.dart';
import '../services/database_service.dart';
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

      // Auto-save successful OCR translation to History
      try {
        await DatabaseService.instance.insertTranslation(
          TranslationHistoryItem(
            sourceText: _scannedText,
            translatedText: translatedText,
            sourceLang: _sourceLanguage,
            targetLang: _translationLanguage,
            timestamp: DateTime.now(),
          ),
        );
      } catch (e) {
        debugPrint('Error auto-saving OCR translation: $e');
      }
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
      _textScanning = true;
      notifyListeners();

      final image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 40,
        maxWidth: 1200,
      );

      if (image != null) {
        _imageFile = image;
        notifyListeners();
        await Future.delayed(
          const Duration(milliseconds: 100),
        );
        // Perform text recognition
        await getTextRecognition(image);
      } else {
        // User canceled picking
        _textScanning = false;
        notifyListeners();
      }
    } catch (e) {
      _textScanning = false;
      _imageFile = null;
      _scannedText = 'Error occurred while capturing';
      debugPrint('Camera error: $e');
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
    _translatedText = "";
    notifyListeners();

    try {
      final recognizedText =
          await _textRecognitionService.recognizeTextFromImage(
            image,
            script: _sourceScript,
          );

      _scannedText = recognizedText;
      if (recognizedText.isNotEmpty) {
        await translateText();
      } else {
        _translatedText = "";
        _textScanning = false;
        notifyListeners();
      }
    } catch (e) {
      _textScanning = false;
      _scannedText = "Error occurred while scanning.";
      _translatedText = "";
      debugPrint("Text recognition error: $e");
      notifyListeners();
    }
  }

  /// Opens the native image cropper to allow focusing and rotating on specific text.
  Future<bool> cropCurrentImage() async {
    if (_imageFile == null) return false;
    try {
      final cropped = await ImageCropper().cropImage(
        sourcePath: _imageFile!.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop & Focus Text',
            toolbarColor: const Color(0xFF2563EB),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9,
            ],
          ),
          IOSUiSettings(
            title: 'Crop & Focus Text',
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9,
            ],
          ),
        ],
      );

      if (cropped != null) {
        _imageFile = XFile(cropped.path);
        notifyListeners();
        await getTextRecognition(_imageFile!);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Crop image error: $e');
      return false;
    }
  }

  void clearData() {
    _imageFile = null;
    _scannedText = '';
    _translatedText = '';
    _textScanning = false;
    notifyListeners();
  }
}

