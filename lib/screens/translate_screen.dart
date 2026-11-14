import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:talktranslo/provider/history_provider.dart';
import 'package:talktranslo/utils/language.dart';
import 'package:talktranslo/component/custom_dropdown.dart';
import 'package:flutter/services.dart';

import '../component/text_card.dart';
import '../data/phrasebook_data.dart';
import '../provider/translator_provider.dart';
import 'fullscreen_text_screen.dart';
import 'phrasebook_screen.dart';

class TranslateScreen extends StatefulWidget {
  const TranslateScreen({super.key});

  @override
  State<TranslateScreen> createState() => _TranslateScreenState();
}

class _TranslateScreenState extends State<TranslateScreen> {
  double _swapTurns = 0.0;
  bool _isTranslating = false;
  String? _clipboardText;
  String? _dismissedClipboardText;

  @override
  void initState() {
    super.initState();
    _checkClipboard();
  }

  Future<void> _checkClipboard() async {
    try {
      final data = await Clipboard.getData(Clipboard.kTextPlain);
      final text = data?.text?.trim();
      if (text != null &&
          text.isNotEmpty &&
          text.length >= 2 &&
          text.length <= 400 &&
          text != _dismissedClipboardText &&
          mounted) {
        final provider = Provider.of<TranslationProvider>(context, listen: false);
        if (text != provider.inputController.text.trim()) {
          setState(() {
            _clipboardText = text;
          });
        }
      }
    } catch (_) {}
  }

  void _applyClipboardText(TranslationProvider provider, String text) {
    HapticFeedback.lightImpact();
    provider.inputController.text = text;
    setState(() {
      _dismissedClipboardText = text;
      _clipboardText = null;
    });
    _handleTranslate(provider);
  }

  void _copyContent(String text, {String message = 'Copied to clipboard'}) async {
    if (text.trim().isEmpty) return;
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleShare(String sourceText, String translatedText) {
    if (translatedText.trim().isEmpty) return;
    Share.share(
      '$sourceText\n\n→ $translatedText\n\n(Translated with TalkTranslo)',
      subject: 'Translation from TalkTranslo',
    );
  }

  void _openFullscreen(TranslationProvider provider) {
    if (provider.translatedController.text.trim().isEmpty) return;
    HapticFeedback.lightImpact();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FullscreenTextScreen(
          translatedText: provider.translatedController.text,
          targetLanguage: provider.translationLanguage,
          sourceText: provider.inputController.text,
          onSpeak: provider.speakTranslatedText,
        ),
      ),
    );
  }

  void _handleSwap(TranslationProvider provider) {
    if (provider.selectedLanguage == 'auto') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot swap languages when source is Auto Detect'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    setState(() {
      _swapTurns += 0.5; // Smooth 180° rotation
    });
    provider.swapLanguages();
  }

  Future<void> _handleTranslate(TranslationProvider provider) async {
    HapticFeedback.lightImpact();
    final text = provider.inputController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter some text to translate'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final targetLang = provider.translationLanguage;

    // Check offline phrasebook matches for immediate offline fallback
    PhraseItem? offlineMatch;
    for (final item in PhrasebookData.phrases) {
      if (item.text.trim().toLowerCase() == text.toLowerCase() &&
          item.offlineTranslations.containsKey(targetLang)) {
        offlineMatch = item;
        break;
      }
    }

    setState(() => _isTranslating = true);
    final success = await provider.translateText();

    if (mounted) {
      setState(() => _isTranslating = false);
      if (success) {
        // Automatically save translation to local history database
        Provider.of<HistoryProvider>(context, listen: false).addTranslation(
          sourceText: text,
          translatedText: provider.translatedController.text,
          sourceLang: provider.selectedLanguage,
          targetLang: provider.translationLanguage,
        );
      } else if (offlineMatch != null) {
        // Successful offline fallback!
        final offlineTranslation = offlineMatch.offlineTranslations[targetLang]!;
        provider.translatedController.text = offlineTranslation;
        provider.translationError = null;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Translated instantly using Offline Phrasebook! 📶'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
          ),
        );

        Provider.of<HistoryProvider>(context, listen: false).addTranslation(
          sourceText: text,
          translatedText: offlineTranslation,
          sourceLang: provider.selectedLanguage,
          targetLang: targetLang,
        );
      } else if (provider.translationError != null) {
        // Graceful offline banner with direct action to open Offline Phrasebook
        final isNetworkErr = provider.translationError!.toLowerCase().contains('client') ||
            provider.translationError!.toLowerCase().contains('socket') ||
            provider.translationError!.toLowerCase().contains('network') ||
            provider.translationError!.toLowerCase().contains('failed');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isNetworkErr
                  ? "Offline: Couldn't connect to translation server"
                  : provider.translationError!,
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Phrasebook 📖',
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PhrasebookScreen()),
                );
              },
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 📖 Quick Travel Phrasebook Access Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ActionChip(
                    avatar: const Icon(Icons.auto_stories_rounded, size: 16),
                    label: const Text(
                      'Travel Phrasebook 📖',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const PhrasebookScreen()),
                      );
                    },
                  ),
                  Consumer<TranslationProvider>(
                    builder: (context, provider, _) {
                      if (provider.translatedController.text.trim().isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return ActionChip(
                        avatar: const Icon(Icons.fullscreen_rounded, size: 16),
                        label: const Text('Fullscreen', style: TextStyle(fontSize: 12)),
                        onPressed: () => _openFullscreen(provider),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // 🌍 Language Selector Header Bar
              Consumer<TranslationProvider>(
                builder: (context, provider, _) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withValues(alpha: 0.6),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Source Language Picker
                        Expanded(
                          child: CustomDropdown(
                            value: provider.selectedLanguage,
                            map: translateSourceLanguageMap,
                            title: 'Source Language',
                            onChanged: (val) {
                              if (val != null) provider.selectLanguage(val);
                            },
                          ),
                        ),

                        // Animated Swap Button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: AnimatedRotation(
                            turns: _swapTurns,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOutBack,
                            child: IconButton.filledTonal(
                              onPressed: () => _handleSwap(provider),
                              icon: const Icon(Icons.swap_horiz_rounded),
                              tooltip: 'Swap languages',
                              style: IconButton.styleFrom(
                                shape: const CircleBorder(),
                              ),
                            ),
                          ),
                        ),

                        // Target Language Picker
                        Expanded(
                          child: CustomDropdown(
                            value: provider.translationLanguage,
                            map: languageMap,
                            title: 'Target Language',
                            onChanged: (val) {
                              if (val != null) provider.translateLanguage(val);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // 📋 Clipboard Quick-Translate Banner
              Consumer<TranslationProvider>(
                builder: (context, provider, _) {
                  if (_clipboardText == null || provider.inputController.text.trim().isNotEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: colorScheme.primary.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.content_paste_rounded, size: 18, color: colorScheme.primary),
                        const SizedBox(width: 10),
                        Expanded(
                          child: InkWell(
                            onTap: () => _applyClipboardText(provider, _clipboardText!),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Translate copied text',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.primary,
                                  ),
                                ),
                                Text(
                                  _clipboardText!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        FilledButton.tonal(
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            visualDensity: VisualDensity.compact,
                          ),
                          onPressed: () => _applyClipboardText(provider, _clipboardText!),
                          child: const Text('Translate', style: TextStyle(fontSize: 12)),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 16),
                          visualDensity: VisualDensity.compact,
                          tooltip: 'Dismiss',
                          onPressed: () => setState(() {
                            _dismissedClipboardText = _clipboardText;
                            _clipboardText = null;
                          }),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // 📝 Input Card
              Consumer<TranslationProvider>(
                builder: (context, provider, _) {
                  return TextCard(
                    controller: provider.inputController,
                    hint: "Type text to translate...",
                    editable: true,
                    isListening: provider.isListening,
                    onMicTap: provider.toggleListening,
                    onCopy: () => _copyContent(provider.inputController.text),
                    onSpeak: provider.speakInputText,
                    onSpeakSlow: () => provider.speakInputText(isSlow: true),
                    onClear: () {
                      provider.inputController.clear();
                      provider.translatedController.clear();
                      setState(() {});
                    },
                  );
                },
              ),

              const SizedBox(height: 16),

              // 🔁 Action Translate Button
              Consumer<TranslationProvider>(
                builder: (context, provider, _) {
                  return SizedBox(
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: _isTranslating ? null : () => _handleTranslate(provider),
                      icon: _isTranslating
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.translate_rounded),
                      label: Text(
                        _isTranslating ? "Translating..." : "Translate",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // 📤 Output Translation Card
              Consumer2<TranslationProvider, HistoryProvider>(
                builder: (context, provider, histProvider, _) {
                  final sourceText = provider.inputController.text.trim();
                  final translatedText = provider.translatedController.text.trim();

                  // Find if current translation is starred in history
                  final matchingHistory = histProvider.allItems.where((item) {
                    return item.sourceText == sourceText &&
                        item.translatedText == translatedText;
                  }).toList();

                  final isFavorite = matchingHistory.isNotEmpty && matchingHistory.first.isFavorite;

                  return TextCard(
                    controller: provider.translatedController,
                    hint: "Translation will appear here...",
                    editable: false,
                    isFavorite: isFavorite,
                    onFavorite: () {
                      if (matchingHistory.isNotEmpty) {
                        histProvider.toggleFavorite(matchingHistory.first);
                      } else if (sourceText.isNotEmpty && translatedText.isNotEmpty) {
                        histProvider.addTranslation(
                          sourceText: sourceText,
                          translatedText: translatedText,
                          sourceLang: provider.selectedLanguage,
                          targetLang: provider.translationLanguage,
                        );
                      }
                    },
                    onCopy: () => _copyContent(provider.translatedController.text),
                    onSpeak: provider.speakTranslatedText,
                    onSpeakSlow: () => provider.speakTranslatedText(isSlow: true),
                    onShare: () => _handleShare(
                      provider.inputController.text,
                      provider.translatedController.text,
                    ),
                    onFullscreen: () => _openFullscreen(provider),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
