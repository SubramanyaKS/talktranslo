import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../component/custom_dropdown.dart';
import '../provider/image_text_provider.dart';
import '../utils/language.dart';

class ImageTextScreen extends StatelessWidget {
  const ImageTextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ImageTextProvider(),
      child: Scaffold(
        body: SafeArea(
          child: Consumer<ImageTextProvider>(
            builder: (context, provider, child) {
              // FULL SCREEN LOADING
              if (provider.textScanning) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        "Recognizing text...",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// SOURCE LANGUAGE
                          const Text(
                            'Source Language (Text in Image)',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Container(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                )
                              ],
                            ),
                            child: CustomDropdown(
                              value: provider.sourceLanguage,
                              map: languageToScript.keys.fold(
                                <String, String>{},
                                    (map, key) {
                                  map[key] = key;
                                  return map;
                                },
                              ),
                              onChanged: (val) {
                                provider.setSourceLanguage(val!);
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// TARGET LANGUAGE
                          const Text(
                            'Target Language (Translation)',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Container(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                )
                              ],
                            ),
                            child: CustomDropdown(
                              value: provider.translationLanguage,
                              map: languageMap,
                              onChanged: (val) {
                                provider.translateLanguage(val!);
                              },
                            ),
                          ),

                          const SizedBox(height: 24),

                          /// IMAGE PREVIEW
                          Center(
                            child: Container(
                              height: 300,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: provider.imageFile != null
                                  ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  File(provider.imageFile!.path),

                                  // IMPORTANT FIXES
                                  fit: BoxFit.contain,
                                  cacheWidth: 800,
                                  filterQuality: FilterQuality.low,
                                ),
                              )
                                  : const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    "Import or capture an image to translate text",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          /// BUTTONS
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              /// GALLERY BUTTON
                              IconButton(
                                padding: const EdgeInsets.all(16),
                                iconSize: 40,
                                onPressed: () async {
                                  await provider.pickImage();
                                },
                                style: IconButton.styleFrom(
                                  shape: const CircleBorder(),
                                  side: const BorderSide(
                                    color: Colors.blue,
                                    width: 2,
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.photo,
                                  color: Colors.blue,
                                ),
                              ),

                              const SizedBox(width: 16),

                              /// TRANSLATE BUTTON
                              IconButton(
                                padding: const EdgeInsets.all(16),
                                iconSize: 40,
                                onPressed: provider.scannedText.isEmpty
                                    ? null
                                    : () async {
                                  await provider.translateText();
                                },
                                style: IconButton.styleFrom(
                                  shape: const CircleBorder(),
                                  side: BorderSide(
                                    color: provider.scannedText.isEmpty
                                        ? Colors.grey
                                        : Colors.blue,
                                    width: 2,
                                  ),
                                ),
                                icon: Icon(
                                  Icons.translate_outlined,
                                  color: provider.scannedText.isEmpty
                                      ? Colors.grey
                                      : Colors.blue,
                                ),
                              ),

                              const SizedBox(width: 16),

                              /// CAMERA BUTTON
                              IconButton(
                                padding: const EdgeInsets.all(16),
                                iconSize: 40,
                                onPressed: () async {
                                  await provider.pickFromCamera();
                                },
                                style: IconButton.styleFrom(
                                  shape: const CircleBorder(),
                                  side: const BorderSide(
                                    color: Colors.blue,
                                    width: 2,
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          /// RECOGNIZED TEXT
                          if (provider.scannedText.isNotEmpty) ...[
                            const Text(
                              'Recognized Text:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: SelectableText(
                                provider.scannedText,
                              ),
                            ),

                            const SizedBox(height: 20),
                          ],

                          /// TRANSLATED TEXT
                          if (provider.translatedText.isNotEmpty) ...[
                            const Text(
                              'Translated Text:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.green),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: SelectableText(
                                provider.translatedText,
                                style: TextStyle(
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ),
                          ],

                          if (provider.scannedText.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Text(
                                  'No text recognized yet',
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}