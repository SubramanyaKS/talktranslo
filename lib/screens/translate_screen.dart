import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talktranslo/utils/language.dart';
import 'package:talktranslo/component/custom_dropdown.dart';
import 'package:flutter/services.dart';

import '../component/text_card.dart';
import '../provider/translator_provider.dart';

class TranslateScreen extends StatefulWidget {
  const TranslateScreen({super.key});

  @override
  State<TranslateScreen> createState() => _TranslateScreenState();
}

class _TranslateScreenState extends State<TranslateScreen> {

  void copyContent(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              // 🌍 Language Selector Row
              Consumer<TranslationProvider>(
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
                            value: translationProvider.selectedLanguage,
                            map: talklanguageMap,
                            onChanged: (val) =>
                                translationProvider.selectLanguage(val!),
                          ),
                        ),

                        IconButton(
                          onPressed: (){},
                          // onPressed: () {
                          //   translationProvider.swapLanguages(); // optional
                          // },
                          icon: const Icon(Icons.swap_horiz),
                        ),

                        Expanded(
                          child: CustomDropdown(
                            value: translationProvider.translationLanguage,
                            map: languageMap,
                            onChanged: (val) =>
                                translationProvider.translateLanguage(val!),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // 📝 Input Card
              Consumer<TranslationProvider>(
                builder: (context, translationProvider, _) {
                  return TextCard(
                    controller: translationProvider.inputController,
                    hint: "Enter text",
                    onCopy: () => copyContent(
                        translationProvider.inputController.text),
                    onSpeak: translationProvider.speakInputText,
                    editable: true,
                  );
                },
              ),

              const SizedBox(height: 20),

              // 🔁 Translate Button
              Consumer<TranslationProvider>(
                builder: (context, translationProvider, _) {
                  return SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: translationProvider.translateText,
                      icon: const Icon(Icons.translate),
                      label: const Text("Translate"),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // 📤 Output Card
              Consumer<TranslationProvider>(
                builder: (context, translationProvider, _) {
                  return TextCard(
                    controller: translationProvider.translatedController,
                    hint: "Translation",
                    onCopy: () => copyContent(
                        translationProvider.translatedController.text),
                    onSpeak: translationProvider.speakTranslatedText,
                    editable: false,
                  );
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}
