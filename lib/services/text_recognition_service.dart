import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class TextRecognitionService {
  // Map script string to TextRecognitionScript enum
  static TextRecognitionScript _getScriptFromString(String scriptName) {
    switch (scriptName.toLowerCase()) {
      case 'latin':
        return TextRecognitionScript.latin;
      case 'chinese':
        return TextRecognitionScript.chinese;
      case 'devanagari':
        return TextRecognitionScript.devanagiri;
      case 'japanese':
        return TextRecognitionScript.japanese;
      case 'korean':
        return TextRecognitionScript.korean;
      default:
        return TextRecognitionScript.latin;
    }
  }

  Future<String> recognizeTextFromImage(XFile image, {String script = 'latin'}) async {
    final textRecognizer = TextRecognizer(
      script: _getScriptFromString(script),
    );

    try {
      final inputImage = InputImage.fromFilePath(image.path);
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);

      final StringBuffer buffer = StringBuffer();

      for (final block in recognizedText.blocks) {
        for (final line in block.lines) {
          buffer.writeln(line.text);
        }
      }

      final result = buffer.toString().trim();
      debugPrint('Text recognition completed: ${result.isEmpty ? "No text found" : "Text found"}');
      
      return result;
    } on Exception catch (e) {
      debugPrint('Text recognition error: $e');
      throw Exception("Error occurred while scanning text: $e");
    } catch (e) {
      debugPrint('Unexpected error in text recognition: $e');
      throw Exception("Unexpected error occurred while scanning: $e");
    } finally {
      await textRecognizer.close();
    }
  }
}

