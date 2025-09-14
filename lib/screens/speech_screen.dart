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
    final translationProvider = Provider.of<TranslationProvider>(context);
    return Scaffold(
      body: Column(
        children: [
          CustomDropdown(value: translationProvider.translationLanguage, map: languageMap, onChanged: (String? newValue) {
            setState(() {
              translationProvider.translationLanguage = newValue!;
            });
          },),
          Spacer(),
          Text(
            translationProvider.generated,
            style: TextStyle(fontSize: 30,color: Colors.white70),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RippleIconbutton(
                  onTap: translationProvider.speakSpeechTranslatedText,
                  icon: Icons.volume_up_outlined,
                  iconSize: 40),
              SizedBox(
                height: 20,
                width: 20,
              ),
              RippleIconbutton(
                  onTap: translationProvider.translateSpeechText, icon: Icons.translate, iconSize: 40),
            ],
          ),
          Spacer(),
          Text(
            translationProvider.translated,
            style: TextStyle(fontSize: 30,color: Colors.white70),
          ),
          Spacer(),

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
                          if(!translationProvider.isListening) {
                            _showDialog(context);
                          }
                          else{
                            translationProvider.toggleListening();
                          }

                        },
                        icon: Icon(translationProvider.isListening ? Icons.mic : Icons.mic_off,color: Colors.white,
                            size: 35))),
              ),
            ),
          ),
          // SizedBox(height: 50,)
          Spacer(),
        ],
      ),
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
          child: DialogBox(),
        );
      },
    );
  }
}
