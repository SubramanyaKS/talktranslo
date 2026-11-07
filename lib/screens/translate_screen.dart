import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:talktranslo/provider/history_provider.dart';
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
  double _swapTurns = 0.0;
  bool _isTranslating = false;

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

  void _handleSwap(TranslationProvider provider) {
    setState(() {
      _swapTurns += 0.5; // Smooth 180° rotation
    });
    provider.swapLanguages();
  }

  Future<void> _handleTranslate(TranslationProvider provider) async {
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
      } else if (provider.translationError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.translationError!),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 3),
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
                            map: talklanguageMap,
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

              // 📝 Input Card
              Consumer<TranslationProvider>(
                builder: (context, provider, _) {
                  return TextCard(
                    controller: provider.inputController,
                    hint: "Type text to translate...",
                    editable: true,
                    onCopy: () => _copyContent(provider.inputController.text),
                    onSpeak: provider.speakInputText,
                    onClear: () {
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
                    child: ElevatedButton.icon(
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
                      style: ElevatedButton.styleFrom(
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
                    onShare: () => _handleShare(
                      provider.inputController.text,
                      provider.translatedController.text,
                    ),
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
