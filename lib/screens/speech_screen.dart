import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:talktranslo/component/audio_waveform.dart';
import 'package:talktranslo/component/custom_dropdown.dart';
import 'package:talktranslo/utils/language.dart';

import '../provider/translator_provider.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  bool _isFaceToFace = false;

  void _copyText(BuildContext context, String text) async {
    if (text.trim().isEmpty) return;
    HapticFeedback.selectionClick();
    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

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
        final hasConversation = provider.speakerASpeech.isNotEmpty ||
            provider.speakerATranslation.isNotEmpty ||
            provider.speakerBSpeech.isNotEmpty ||
            provider.speakerBTranslation.isNotEmpty;

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                // Top Action Toolbar (shown when NOT in Face-to-Face mode)
                if (!_isFaceToFace)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FilterChip(
                          avatar: Icon(
                            Icons.stay_current_portrait_rounded,
                            size: 16,
                            color: colorScheme.primary,
                          ),
                          label: Text(
                            'Face-to-Face Mode',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          selected: false,
                          showCheckmark: false,
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          onSelected: (val) {
                            HapticFeedback.selectionClick();
                            setState(() {
                              _isFaceToFace = true;
                            });
                          },
                        ),
                        if (hasConversation)
                          TextButton.icon(
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              provider.clearConversation();
                            },
                            icon: const Icon(Icons.restart_alt_rounded, size: 16),
                            label: const Text('Reset', style: TextStyle(fontSize: 12)),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              foregroundColor: colorScheme.error,
                            ),
                          ),
                      ],
                    ),
                  ),

                // Warning Banner if Speech Error
                if (provider.speechError != null)
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 4, 16, 0),
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
                // In Face-to-Face mode, rotated 180° for the person sitting opposite.
                Expanded(
                  child: RotatedBox(
                    quarterTurns: _isFaceToFace ? 2 : 0,
                    child: _buildSpeakerCard(
                      context: context,
                      speakerNum: 1,
                      speakerTitle: "Speaker 1 ($flagA)",
                      langName: langAName,
                      langValue: provider.selectedLanguage,
                      langMap: talklanguageMap,
                      onLanguageChanged: (val) {
                        if (val != null) provider.selectLanguage(val);
                      },
                      isListening: isListeningA,
                      speechText: provider.speakerASpeech,
                      translationText: provider.speakerATranslation,
                      isTranslating: provider.isTranslatingSpeech,
                      primaryColor: colorScheme.primary,
                      containerColor: colorScheme.primaryContainer,
                      listeningPlaceholder: "Listening in $langAName... Speak now",
                      idlePlaceholder: _isFaceToFace
                          ? "Tap mic below to speak in $langAName..."
                          : "Tap Speaker 1 mic below to start speaking...",
                      onTranslate: () => provider.translateSpeakerASpeech(),
                      onSpeak: () => provider.speakSpeakerATranslation(),
                      onCopy: (text) => _copyText(context, text),
                      soundLevel: provider.soundLevelNotifier,
                      // In Face-to-Face mode, provide in-card mic directly facing Speaker 1
                      showInCardMic: _isFaceToFace,
                      onMicTap: () => provider.toggleSpeakerAListening(),
                      languageFlag: flagA,
                    ),
                  ),
                ),

                // Face-to-Face Central Control Strip
                if (_isFaceToFace)
                  _buildCenterDivider(
                    context: context,
                    colorScheme: colorScheme,
                    provider: provider,
                    hasConversation: hasConversation,
                  ),

                // Bottom Section: Speaker 2 (B)
                // Always normal orientation facing the device owner.
                Expanded(
                  child: _buildSpeakerCard(
                    context: context,
                    speakerNum: 2,
                    speakerTitle: "Speaker 2 ($flagB)",
                    langName: langBName,
                    langValue: provider.translationLanguage,
                    langMap: languageMap,
                    onLanguageChanged: (val) {
                      if (val != null) provider.translateLanguage(val);
                    },
                    isListening: isListeningB,
                    speechText: provider.speakerBSpeech,
                    translationText: provider.speakerBTranslation,
                    isTranslating: provider.isTranslatingSpeech,
                    primaryColor: colorScheme.secondary,
                    containerColor: colorScheme.secondaryContainer,
                    listeningPlaceholder: "Listening in $langBName... Speak now",
                    idlePlaceholder: _isFaceToFace
                        ? "Tap mic below to speak in $langBName..."
                        : "Tap Speaker 2 mic below to start speaking...",
                    onTranslate: () => provider.translateSpeakerBSpeech(),
                    onSpeak: () => provider.speakSpeakerBTranslation(),
                    onCopy: (text) => _copyText(context, text),
                    soundLevel: provider.soundLevelNotifier,
                    // In Face-to-Face mode, provide in-card mic directly facing Speaker 2
                    showInCardMic: _isFaceToFace,
                    onMicTap: () => provider.toggleSpeakerBListening(),
                    languageFlag: flagB,
                  ),
                ),

                // Floating Action Dock with Dual Microphones (shown ONLY in normal mode)
                if (!_isFaceToFace)
                  _buildBottomDock(
                    context: context,
                    colorScheme: colorScheme,
                    provider: provider,
                    isListeningA: isListeningA,
                    isListeningB: isListeningB,
                    flagA: flagA,
                    langAName: langAName,
                    flagB: flagB,
                    langBName: langBName,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Builds a unified speaker conversation card with responsive headers,
  /// scrollable transcripts, translation display, and optional in-card mic.
  Widget _buildSpeakerCard({
    required BuildContext context,
    required int speakerNum,
    required String speakerTitle,
    required String langName,
    required String langValue,
    required Map<String, String> langMap,
    required ValueChanged<String?> onLanguageChanged,
    required bool isListening,
    required String speechText,
    required String translationText,
    required bool isTranslating,
    required Color primaryColor,
    required Color containerColor,
    required String listeningPlaceholder,
    required String idlePlaceholder,
    required VoidCallback onTranslate,
    required VoidCallback onSpeak,
    required ValueChanged<String> onCopy,
    required ValueListenable<double> soundLevel,
    required bool showInCardMic,
    required VoidCallback onMicTap,
    required String languageFlag,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isListening
            ? containerColor.withValues(alpha: 0.35)
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isListening
              ? primaryColor
              : colorScheme.outlineVariant.withValues(alpha: 0.6),
          width: isListening ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isListening ? 0.08 : 0.03),
            blurRadius: isListening ? 12 : 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: Speaker Badge + Mini Waveform + Language Dropdown
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  speakerTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: primaryColor,
                  ),
                ),
              ),
              if (isListening && !showInCardMic) ...[
                const SizedBox(width: 6),
                AudioWaveform(
                  soundLevel: soundLevel,
                  isListening: true,
                  activeColor: primaryColor,
                  barCount: 4,
                  height: 14.0,
                  width: 28.0,
                ),
              ],
              const Spacer(),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 145, minWidth: 100),
                child: CustomDropdown(
                  value: langValue,
                  map: langMap,
                  title: 'Speaker $speakerNum Language',
                  dense: true,
                  onChanged: onLanguageChanged,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Scrollable Transcript & Translation Body
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recognized Speech Text
                  SelectableText(
                    speechText.isEmpty
                        ? (isListening ? listeningPlaceholder : idlePlaceholder)
                        : speechText,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: speechText.isEmpty ? theme.hintColor : colorScheme.onSurface,
                      fontStyle: speechText.isEmpty ? FontStyle.italic : FontStyle.normal,
                    ),
                  ),

                  // Manual Translate Button if speech exists but translation is pending
                  if (speechText.isNotEmpty && translationText.isEmpty) ...[
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: isTranslating ? null : onTranslate,
                        icon: isTranslating
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.translate_rounded, size: 16),
                        label: Text(
                          isTranslating ? "Translating..." : "Translate",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],

                  // Translation Result & Audio / Copy Actions
                  if (translationText.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    const Divider(height: 1),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SelectableText(
                            translationText,
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.volume_up_rounded),
                          tooltip: 'Listen translation',
                          color: primaryColor,
                          onPressed: onSpeak,
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy_rounded, size: 20),
                          tooltip: 'Copy translation',
                          color: primaryColor,
                          onPressed: () => onCopy(translationText),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          // In-Card Microphone Bar (Facing the speaker in Face-to-Face mode)
          if (showInCardMic)
            _buildInCardMic(
              context: context,
              isListening: isListening,
              color: primaryColor,
              containerColor: containerColor,
              onTap: onMicTap,
              languageName: langName,
              flag: languageFlag,
              soundLevel: soundLevel,
            ),
        ],
      ),
    );
  }

  /// Compact, ergonomic microphone control bar embedded directly inside each speaker card.
  Widget _buildInCardMic({
    required BuildContext context,
    required bool isListening,
    required Color color,
    required Color containerColor,
    required VoidCallback onTap,
    required String languageName,
    required String flag,
    required ValueListenable<double> soundLevel,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      margin: const EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        color: isListening
            ? color.withValues(alpha: 0.14)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isListening ? color.withValues(alpha: 0.6) : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          AvatarGlow(
            animate: isListening,
            glowColor: color,
            child: Material(
              shape: const CircleBorder(),
              color: isListening ? color : containerColor,
              elevation: isListening ? 4 : 1,
              child: InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onTap();
                },
                customBorder: const CircleBorder(),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    isListening ? Icons.mic : Icons.mic_none_rounded,
                    size: 22,
                    color: isListening ? Colors.white : color,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isListening ? 'Listening... Speak now' : 'Tap mic to speak',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isListening ? color : theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  '$flag $languageName',
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (isListening)
            AudioWaveform(
              soundLevel: soundLevel,
              isListening: true,
              activeColor: color,
              barCount: 5,
              height: 18.0,
              width: 44.0,
            ),
        ],
      ),
    );
  }

  /// Central dividing toolbar between the two speakers in Face-to-Face mode.
  Widget _buildCenterDivider({
    required BuildContext context,
    required ColorScheme colorScheme,
    required TranslationProvider provider,
    required bool hasConversation,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Swap Speaker Languages
          IconButton.filledTonal(
            icon: const Icon(Icons.swap_vert_rounded, size: 20),
            tooltip: 'Swap Speaker Languages',
            onPressed: () {
              HapticFeedback.selectionClick();
              provider.swapLanguages();
            },
          ),
          const SizedBox(width: 10),

          // Face-to-Face Toggle Pill
          FilterChip(
            avatar: const Icon(Icons.screen_rotation_rounded, size: 16),
            label: const Text(
              'Face-to-Face Active (180°)',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            selected: true,
            selectedColor: colorScheme.primaryContainer,
            showCheckmark: false,
            onSelected: (val) {
              HapticFeedback.selectionClick();
              setState(() {
                _isFaceToFace = false;
              });
            },
          ),
          const SizedBox(width: 10),

          // Reset Conversation Button
          if (hasConversation)
            IconButton.filledTonal(
              icon: Icon(Icons.restart_alt_rounded, size: 20, color: colorScheme.error),
              tooltip: 'Reset Conversation',
              onPressed: () {
                HapticFeedback.mediumImpact();
                provider.clearConversation();
              },
            )
          else
            const SizedBox(width: 40),
        ],
      ),
    );
  }

  /// Dual-microphone dock shown at the bottom when in normal handheld mode.
  Widget _buildBottomDock({
    required BuildContext context,
    required ColorScheme colorScheme,
    required TranslationProvider provider,
    required bool isListeningA,
    required bool isListeningB,
    required String flagA,
    required String langAName,
    required String flagB,
    required String langBName,
  }) {
    return Container(
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

          // Middle Audio Waveform Visualizer
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AudioWaveform(
                soundLevel: provider.soundLevelNotifier,
                isListening: isListeningA || isListeningB,
                activeColor: isListeningA ? colorScheme.primary : colorScheme.secondary,
                barCount: 7,
                height: 30.0,
                width: 82.0,
              ),
              const SizedBox(height: 4),
              Text(
                isListeningA || isListeningB ? "Listening..." : "Conversation",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isListeningA
                      ? colorScheme.primary
                      : (isListeningB ? colorScheme.secondary : colorScheme.outline),
                ),
              ),
            ],
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
    );
  }
}
