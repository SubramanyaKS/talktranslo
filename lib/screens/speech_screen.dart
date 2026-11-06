import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Consumer<TranslationProvider>(
      builder: (context, provider, _) {
        final langAName = getLanguageNameFromValue(talklanguageMap, provider.selectedLanguage);
        final langBName = getLanguageNameFromValue(languageMap, provider.translationLanguage);
        final flagA = getLanguageFlag(langAName);
        final flagB = getLanguageFlag(langBName);

        final isListeningA = provider.activeSpeaker == 1;
        final isListeningB = provider.activeSpeaker == 2;

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                // Warning Banner if Speech Error
                if (provider.speechError != null)
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: colorScheme.error, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            provider.speechError!,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onErrorContainer,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 16),
                          onPressed: () => provider.clearSpeechError(),
                        ),
                      ],
                    ),
                  ),

                // Top Section: Speaker 1 (A)
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isListeningA
                          ? colorScheme.primaryContainer.withValues(alpha: 0.35)
                          : colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isListeningA
                            ? colorScheme.primary
                            : colorScheme.outlineVariant.withValues(alpha: 0.6),
                        width: isListeningA ? 2 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Speaker 1 Header
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "Speaker 1 ($flagA)",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 170,
                              child: CustomDropdown(
                                value: provider.selectedLanguage,
                                map: talklanguageMap,
                                title: 'Speaker 1 Language',
                                onChanged: (val) {
                                  if (val != null) provider.selectLanguage(val);
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Transcript & Translation
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SelectableText(
                                  provider.speakerASpeech.isEmpty
                                      ? (isListeningA
                                          ? "Listening to Speaker 1... (speak now)"
                                          : "Tap Speaker 1 mic below to start speaking...")
                                      : provider.speakerASpeech,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: provider.speakerASpeech.isEmpty
                                        ? theme.hintColor
                                        : colorScheme.onSurface,
                                    fontStyle: provider.speakerASpeech.isEmpty
                                        ? FontStyle.italic
                                        : FontStyle.normal,
                                  ),
                                ),

                                // Manual Translate action if recognized text exists
                                if (provider.speakerASpeech.isNotEmpty &&
                                    provider.speakerATranslation.isEmpty) ...[
                                  const SizedBox(height: 10),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton.icon(
                                      onPressed: provider.isTranslatingSpeech
                                          ? null
                                          : () => provider.translateSpeakerASpeech(),
                                      icon: provider.isTranslatingSpeech
                                          ? const SizedBox(
                                              width: 16,
                                              height: 16,
                                              child: CircularProgressIndicator(strokeWidth: 2),
                                            )
                                          : const Icon(Icons.translate_rounded, size: 16),
                                      label: Text(
                                        provider.isTranslatingSpeech ? "Translating..." : "Translate",
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  ),
                                ],

                                if (provider.speakerATranslation.isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  const Divider(height: 1),
                                  const SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: SelectableText(
                                          provider.speakerATranslation,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: colorScheme.primary,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.volume_up_rounded),
                                        tooltip: 'Listen translation',
                                        color: colorScheme.primary,
                                        onPressed: provider.speakSpeakerATranslation,
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Section: Speaker 2 (B)
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 6, 16, 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isListeningB
                          ? colorScheme.secondaryContainer.withValues(alpha: 0.35)
                          : colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isListeningB
                            ? colorScheme.secondary
                            : colorScheme.outlineVariant.withValues(alpha: 0.6),
                        width: isListeningB ? 2 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Speaker 2 Header
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: colorScheme.secondary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "Speaker 2 ($flagB)",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: colorScheme.secondary,
                                ),
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 170,
                              child: CustomDropdown(
                                value: provider.translationLanguage,
                                map: languageMap,
                                title: 'Speaker 2 Language',
                                onChanged: (val) {
                                  if (val != null) provider.translateLanguage(val);
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Transcript & Translation
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SelectableText(
                                  provider.speakerBSpeech.isEmpty
                                      ? (isListeningB
                                          ? "Listening to Speaker 2... (speak now)"
                                          : "Tap Speaker 2 mic below to start speaking...")
                                      : provider.speakerBSpeech,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: provider.speakerBSpeech.isEmpty
                                        ? theme.hintColor
                                        : colorScheme.onSurface,
                                    fontStyle: provider.speakerBSpeech.isEmpty
                                        ? FontStyle.italic
                                        : FontStyle.normal,
                                  ),
                                ),

                                // Manual Translate action if recognized text exists
                                if (provider.speakerBSpeech.isNotEmpty &&
                                    provider.speakerBTranslation.isEmpty) ...[
                                  const SizedBox(height: 10),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton.icon(
                                      onPressed: provider.isTranslatingSpeech
                                          ? null
                                          : () => provider.translateSpeakerBSpeech(),
                                      icon: provider.isTranslatingSpeech
                                          ? const SizedBox(
                                              width: 16,
                                              height: 16,
                                              child: CircularProgressIndicator(strokeWidth: 2),
                                            )
                                          : const Icon(Icons.translate_rounded, size: 16),
                                      label: Text(
                                        provider.isTranslatingSpeech ? "Translating..." : "Translate",
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  ),
                                ],

                                if (provider.speakerBTranslation.isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  const Divider(height: 1),
                                  const SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: SelectableText(
                                          provider.speakerBTranslation,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: colorScheme.secondary,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.volume_up_rounded),
                                        tooltip: 'Listen translation',
                                        color: colorScheme.secondary,
                                        onPressed: provider.speakSpeakerBTranslation,
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Floating Action Dock with Dual Microphones
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Speaker 1 Mic
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AvatarGlow(
                            animate: isListeningA,
                            glowColor: colorScheme.primary,
                            child: Material(
                              elevation: isListeningA ? 8 : 2,
                              shape: const CircleBorder(),
                              color: isListeningA ? colorScheme.primary : colorScheme.primaryContainer,
                              child: InkWell(
                                onTap: () => provider.toggleSpeakerAListening(),
                                customBorder: const CircleBorder(),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Icon(
                                    isListeningA ? Icons.mic : Icons.mic_none_rounded,
                                    size: 32,
                                    color: isListeningA ? Colors.white : colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "$flagA $langAName",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isListeningA ? colorScheme.primary : colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),

                      // Middle status / divider indicator
                      Container(
                        height: 40,
                        width: 1,
                        color: colorScheme.outlineVariant.withValues(alpha: 0.6),
                      ),

                      // Speaker 2 Mic
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AvatarGlow(
                            animate: isListeningB,
                            glowColor: colorScheme.secondary,
                            child: Material(
                              elevation: isListeningB ? 8 : 2,
                              shape: const CircleBorder(),
                              color: isListeningB ? colorScheme.secondary : colorScheme.secondaryContainer,
                              child: InkWell(
                                onTap: () => provider.toggleSpeakerBListening(),
                                customBorder: const CircleBorder(),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Icon(
                                    isListeningB ? Icons.mic : Icons.mic_none_rounded,
                                    size: 32,
                                    color: isListeningB ? Colors.white : colorScheme.secondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "$flagB $langBName",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isListeningB ? colorScheme.secondary : colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
