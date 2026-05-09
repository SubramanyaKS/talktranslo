import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talktranslo/component/custom_dropdown.dart';
import 'package:talktranslo/provider/translator_provider.dart';
import 'package:talktranslo/utils/language.dart';

class DialogBox extends StatefulWidget {
  const DialogBox({super.key});

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  
  @override
  Widget build(BuildContext context) {
    return Consumer<TranslationProvider>(
      builder: (context, translationProvider, _) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Language',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20.0),
              CustomDropdown(
                value: translationProvider.selectedLanguage,
                map: talklanguageMap,
                onChanged: (String? newValue) {
                  translationProvider.selectLanguage(newValue!);
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  await translationProvider.toggleListening();
                  if (!mounted) return;
                  Navigator.of(this.context).pop();
                },
                child: const Text('Start Listening'),
              ),
            ],
          ),
        );
      },
    );
  }
}