import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/text_recognition_service.dart';
import '../services/translator_service.dart';

class ImageTextProvider with ChangeNotifier {
  static final TextRecognitionService _textRecognitionService =
      TextRecognitionService();
  static final TranslationService _translationService = TranslationService();

  XFile? _imageFile;
  String _scannedText = '';
  bool _textScanning = false;
  String _translatedText ='';
  String _translationLanguage = 'kn';

  XFile? get imageFile => _imageFile;
  String get scannedText => _scannedText;
  bool get textScanning => _textScanning;
  String get translatedText => _translatedText;
  String get translationLanguage =>_translationLanguage;

  Future<void> translateText() async {
    String translateText = await _translationService.translateText(scannedText, translationLanguage);
    _translatedText = translateText;
    notifyListeners();
  }
  void translateLanguage(language){
    _translationLanguage=language;
    notifyListeners();
  }


  Future<void> pickFromCamera() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    if (image != null) {
      _imageFile = image;
      notifyListeners();
    }
  }

  Future<void> pickImage() async {
    try {
      _textScanning = true;
      notifyListeners();

      final imagePick = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      if (imagePick != null) {
        _imageFile = imagePick;
        notifyListeners();

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
          await _textRecognitionService.recognizeTextFromImage(image);

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
