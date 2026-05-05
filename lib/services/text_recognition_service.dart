import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class TextRecognitionService {
  Future<String> recognizeTextFromImage(XFile image) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

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

      return buffer.toString();
    } catch (e) {
      throw Exception("Error occurred while scanning: $e");
    } finally {
      await textRecognizer.close();
    }
  }
}
