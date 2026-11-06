import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talktranslo/component/custom_dropdown.dart';
import '../provider/translator_provider.dart';
import '../utils/language.dart';

class SpeechSettingScreen extends StatefulWidget {
  const SpeechSettingScreen({super.key});

  @override
  State<SpeechSettingScreen> createState() => _SpeechSettingScreenState();
}

class _SpeechSettingScreenState extends State<SpeechSettingScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final provider = Provider.of<TranslationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Speech Rate Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Speech Rate",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "${provider.speechRate.toStringAsFixed(1)}x",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Slider(
                      value: provider.speechRate,
                      divisions: 15,
                      min: 0.5,
                      max: 2.0,
                      onChanged: (value) => provider.selectSpeedRate(value),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Pitch Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Voice Pitch",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "${provider.pitch.toStringAsFixed(1)}x",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Slider(
                      value: provider.pitch,
                      divisions: 15,
                      min: 0.5,
                      max: 2.0,
                      onChanged: (value) => provider.selectPitch(value),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Voice Style Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Voice Type",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      children: availableVoices.map((voice) {
                        final isSelected = provider.selectedVoice == voice["value"];
                        return ChoiceChip(
                          label: Text(voice["name"]!),
                          selected: isSelected,
                          onSelected: (_) => provider.selectVoice(voice["value"]),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Default Speech Language
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Default Speech Language",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomDropdown(
                      value: provider.selectedLanguage,
                      map: talklanguageMap,
                      title: 'Select Speech Language',
                      onChanged: (val) {
                        if (val != null) provider.selectLanguage(val);
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Default Translation Language
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Default Translation Language",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomDropdown(
                      value: provider.translationLanguage,
                      map: languageMap,
                      title: 'Select Translation Language',
                      onChanged: (val) {
                        if (val != null) provider.translateLanguage(val);
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Test Speech Preview Button
            FilledButton.tonalIcon(
              onPressed: () {
                provider.speakInputText();
              },
              icon: const Icon(Icons.volume_up_rounded),
              label: const Text("Test Current Voice & Speech Settings"),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
