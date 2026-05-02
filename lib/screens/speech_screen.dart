import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talktranslo/component/dialog.dart';
import 'package:talktranslo/component/ripple_iconbutton.dart';
import 'package:talktranslo/component/custom_dropdown.dart';
import 'package:talktranslo/utils/language.dart';

import '../provider/translator_provider.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {

  @override
  Widget build(BuildContext context) {
    return Consumer<TranslationProvider>(
      builder: (context, translationProvider, _) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: CustomDropdown(
                    value: translationProvider.translationLanguage,
                    map: languageMap,
                    onChanged: (String? newValue) {
                      translationProvider.translateLanguage(newValue!);
                    },
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    translationProvider.generated.isEmpty
                        ? 'Tap the mic to start speaking...'
                        : translationProvider.generated,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      color: translationProvider.generated.isEmpty
                          ? Colors.grey[600]
                          : Colors.white70,
                      fontStyle: translationProvider.generated.isEmpty
                          ? FontStyle.italic
                          : FontStyle.normal,
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RippleIconbutton(
                      onTap: translationProvider.translated.isEmpty
                          ? () {}
                          : () => translationProvider.speakSpeechTranslatedText(),
                      icon: Icons.volume_up_outlined,
                      iconSize: 40,
                    ),
                    const SizedBox(width: 30),
                    RippleIconbutton(
                      onTap: translationProvider.generated.isEmpty
                          ? () {}
                          : () => translationProvider.translateSpeechText(),
                      icon: Icons.translate,
                      iconSize: 40,
                    ),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    translationProvider.translated.isEmpty
                        ? 'Translation will appear here'
                        : translationProvider.translated,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      color: translationProvider.translated.isEmpty
                          ? Colors.grey[600]
                          : Colors.white70,
                      fontStyle: translationProvider.translated.isEmpty
                          ? FontStyle.italic
                          : FontStyle.normal,
                    ),
                  ),
                ),
                const Spacer(),
                Center(
                  child: AvatarGlow(
                    glowColor: Colors.blue,
                    animate: translationProvider.isListening,
                    child: Material(
                      elevation: 8.0,
                      shape: const CircleBorder(),
                      child: CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 40,
                        child: IconButton(
                          onPressed: () async {
                            try {
                              if (!translationProvider.isListening) {
                                _showDialog(context);
                              } else {
                                await translationProvider.toggleListening();
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: ${e.toString()}'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            }
                          },
                          icon: Icon(
                            translationProvider.isListening
                                ? Icons.mic
                                : Icons.mic_off,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: const DialogBox(),
        );
      },
    );
  }
}
