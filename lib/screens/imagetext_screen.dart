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
      create: (context) => ImageTextProvider(),
      child: Consumer<ImageTextProvider>(
        builder: (context, imageTextProvider, child) {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      Consumer<ImageTextProvider>(
                        builder: (context, translationProvider, _) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(color: Colors.black12, blurRadius: 6)
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: CustomDropdown(
                                    value: translationProvider.translationLanguage,
                                    map: languageMap,
                                    onChanged: (val) =>
                                        translationProvider.translateLanguage(val!),
                                  ),
                                ),

                                // IconButton(
                                //   onPressed: (){},
                                //   // onPressed: () {
                                //   //   translationProvider.swapLanguages(); // optional
                                //   // },
                                //   icon: const Icon(Icons.swap_horiz),
                                // ),

                                // Expanded(
                                //   child: CustomDropdown(
                                //     value: translationProvider.translationLanguage,
                                //     map: languageMap,
                                //     onChanged: (val) =>
                                //         translationProvider.translateLanguage(val!),
                                //   ),
                                // ),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 40),
                      Container(
                        height: 300,
                        width: 300,
                        color: Colors.grey,
                        child: imageTextProvider.imageFile != null
                            ? Image.file(
                                File(imageTextProvider.imageFile!.path),
                                fit: BoxFit.cover,
                              )
                            : Center(
                                child: Text(
                                  "Import or capture an image to translate text",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            padding: EdgeInsets.all(16.0),
                            iconSize: 40,
                            onPressed: () {
                              imageTextProvider.pickImage();
                            },
                            style: IconButton.styleFrom(
                              shape: CircleBorder(),
                              side: BorderSide(color: Colors.blue, width: 2),
                            ),
                            icon: Icon(Icons.photo, color: Colors.blue),
                          ),
                          SizedBox(width: 20),
                          IconButton(
                            padding: EdgeInsets.all(16.0),
                            iconSize: 40,
                            onPressed: () {
                              imageTextProvider.translateText();
                            },
                            style: IconButton.styleFrom(
                              shape: CircleBorder(),
                              side: BorderSide(color: Colors.blue, width: 2),
                            ),
                            icon: Icon(Icons.translate_outlined,
                                color: Colors.blue),
                          ),
                          SizedBox(width: 20),
                          IconButton(
                            padding: EdgeInsets.all(16.0),
                            iconSize: 40,
                            onPressed: () {
                              imageTextProvider.pickFromCamera();
                            },
                            style: IconButton.styleFrom(
                              shape: CircleBorder(),
                              side: BorderSide(color: Colors.blue, width: 2),
                            ),
                            icon: Icon(Icons.camera_alt_outlined,
                                color: Colors.blue),
                          ),
                        ],
                      ),
                      imageTextProvider.textScanning
                          ? Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            )
                          : Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(imageTextProvider.translatedText),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}