import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:talktranslo/component/custom_dropdown.dart';
import 'package:talktranslo/data/phrasebook_data.dart';
import 'package:talktranslo/provider/history_provider.dart';
import 'package:talktranslo/provider/translator_provider.dart';
import 'package:talktranslo/services/speech_service.dart';
import 'package:talktranslo/services/translator_service.dart';
import 'package:talktranslo/utils/language.dart';

import 'fullscreen_text_screen.dart';

/// Full-page route for the Travel & Survival Phrasebook.
class PhrasebookScreen extends StatelessWidget {
  const PhrasebookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text('📖', style: TextStyle(fontSize: 22)),
            SizedBox(width: 8),
            Text('Travel Phrasebook', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
      ),
      body: const SafeArea(
        child: PhrasebookView(isStandalone: true),
      ),
    );
  }
}

/// Reusable Phrasebook widget that can be embedded in HistoryScreen or displayed standalone.
class PhrasebookView extends StatefulWidget {
  final bool isStandalone;
  final VoidCallback? onNavigateToTranslate;

  const PhrasebookView({
    super.key,
    this.isStandalone = false,
    this.onNavigateToTranslate,
  });

  @override
  State<PhrasebookView> createState() => _PhrasebookViewState();
}

class _PhrasebookViewState extends State<PhrasebookView> {
  final TranslationService _translationService = TranslationService();
  final SpeechService _speechService = SpeechService();
  final TextEditingController _searchController = TextEditingController();

  PhraseCategory _selectedCategory = PhraseCategory.all;
  String _targetLanguage = 'es'; // Initialized from provider in didChangeDependencies
  bool _hasInitializedLanguage = false;

  // Cache: key = "${phraseId}_${targetLangCode}"
  final Map<String, String> _translationCache = {};
  final Set<String> _loadingKeys = {};
  final Set<String> _failedKeys = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasInitializedLanguage) {
      final translationProvider = Provider.of<TranslationProvider>(context, listen: false);
      _targetLanguage = translationProvider.translationLanguage;
      _hasInitializedLanguage = true;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onTargetLanguageChanged(String? newLang) {
    if (newLang == null || newLang == _targetLanguage) return;
    HapticFeedback.selectionClick();
    setState(() {
      _targetLanguage = newLang;
    });
  }

  String? _getTranslation(PhraseItem phrase) {
    // 1. Check bundled offline translations first
    if (phrase.offlineTranslations.containsKey(_targetLanguage)) {
      return phrase.offlineTranslations[_targetLanguage];
    }

    // 2. Check dynamic in-memory cache
    final key = "${phrase.id}_$_targetLanguage";
    if (_translationCache.containsKey(key)) {
      return _translationCache[key];
    }

    // 3. Trigger asynchronous translation if not already loading or failed
    if (!_loadingKeys.contains(key) && !_failedKeys.contains(key)) {
      _fetchTranslation(phrase, key);
    }

    return null;
  }

  Future<void> _fetchTranslation(PhraseItem phrase, String key) async {
    _loadingKeys.add(key);
    try {
      final result = await _translationService.translateText(
        phrase.text,
        _targetLanguage,
        sourceLanguage: 'en',
      );
      if (mounted) {
        setState(() {
          _translationCache[key] = result;
          _loadingKeys.remove(key);
          _failedKeys.remove(key);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadingKeys.remove(key);
          _failedKeys.add(key);
        });
      }
    }
  }

  void _copyPhrase(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    HapticFeedback.selectionClick();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied translation to clipboard'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _speakPhrase(String text, TranslationProvider provider) {
    HapticFeedback.lightImpact();
    _speechService.speakText(
      text,
      _targetLanguage,
      provider.pitch,
      provider.speechRate,
      provider.selectedVoice,
    );
  }

  void _openFullscreen(BuildContext context, String sourceText, String translatedText, TranslationProvider provider) {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FullscreenTextScreen(
          translatedText: translatedText,
          targetLanguage: _targetLanguage,
          sourceText: sourceText,
          onSpeak: () => _speakPhrase(translatedText, provider),
        ),
      ),
    );
  }

  void _sendToTranslateScreen(BuildContext context, PhraseItem phrase, String translatedText) {
    HapticFeedback.mediumImpact();
    final translationProvider = Provider.of<TranslationProvider>(context, listen: false);

    // Populate source input and target translation in main Translate screen
    translationProvider.inputController.text = phrase.text;
    translationProvider.translatedController.text = translatedText;
    translationProvider.translationLanguage = _targetLanguage;

    if (widget.onNavigateToTranslate != null) {
      widget.onNavigateToTranslate!();
    } else if (widget.isStandalone) {
      Navigator.of(context).pop();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Loaded phrase into Translate screen'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final translationProvider = Provider.of<TranslationProvider>(context);
    final historyProvider = Provider.of<HistoryProvider>(context);

    final targetLangName = getLanguageNameFromValue(languageMap, _targetLanguage);
    final targetFlag = getLanguageFlag(targetLangName);

    // Filter phrases by category and search text
    final query = _searchController.text.trim().toLowerCase();
    final filteredPhrases = PhrasebookData.phrases.where((p) {
      final matchesCategory = _selectedCategory == PhraseCategory.all || p.category == _selectedCategory;
      if (!matchesCategory) return false;
      if (query.isEmpty) return true;
      final matchesEnglish = p.text.toLowerCase().contains(query);
      final cachedTranslation = _translationCache["${p.id}_$_targetLanguage"] ?? p.offlineTranslations[_targetLanguage] ?? '';
      final matchesTranslation = cachedTranslation.toLowerCase().contains(query);
      return matchesEnglish || matchesTranslation;
    }).toList();

    return Column(
      children: [
        // Target Language Header & Search Bar
        Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
          color: colorScheme.surface,
          child: Column(
            children: [
              // Target Language Picker Bar
              Row(
                children: [
                  Icon(Icons.translate_rounded, size: 20, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Translate phrases to:',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 160, minWidth: 120),
                    child: CustomDropdown(
                      value: _targetLanguage,
                      map: languageMap,
                      title: 'Select Phrasebook Language',
                      dense: true,
                      onChanged: _onTargetLanguageChanged,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Search Bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search survival phrases (e.g. taxi, wifi, allergy)...',
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ],
          ),
        ),

        // Horizontal Category Filter Chips Bar
        SizedBox(
          height: 48,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            scrollDirection: Axis.horizontal,
            itemCount: PhraseCategory.values.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final cat = PhraseCategory.values[index];
              final isSelected = _selectedCategory == cat;
              return FilterChip(
                label: Text(
                  '${cat.emoji} ${cat.title}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
                  ),
                ),
                selected: isSelected,
                selectedColor: colorScheme.primary,
                showCheckmark: false,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                onSelected: (val) {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _selectedCategory = cat;
                  });
                },
              );
            },
          ),
        ),

        const Divider(height: 1),

        // List of Phrase Cards
        Expanded(
          child: filteredPhrases.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off_rounded, size: 48, color: colorScheme.outline),
                      const SizedBox(height: 12),
                      Text(
                        'No phrases found for "${_searchController.text}"',
                        style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                  itemCount: filteredPhrases.length,
                  itemBuilder: (context, index) {
                    final phrase = filteredPhrases[index];
                    final translation = _getTranslation(phrase);
                    final key = "${phrase.id}_$_targetLanguage";
                    final isLoading = _loadingKeys.contains(key);
                    final isFailed = _failedKeys.contains(key);

                    // Check if already in favorites
                    final isFavorite = historyProvider.allItems.any(
                      (item) => item.sourceText.trim() == phrase.text.trim() && item.isFavorite,
                    );

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top Row: Category Badge + Star Action
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${phrase.category.emoji} ${phrase.category.title}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                                    color: isFavorite ? Colors.amber : colorScheme.outline,
                                    size: 22,
                                  ),
                                  tooltip: isFavorite ? 'Starred in history' : 'Save phrase to favorites',
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    final currentTrans = translation ?? phrase.text;
                                    historyProvider.addTranslation(
                                      sourceText: phrase.text,
                                      translatedText: currentTrans,
                                      sourceLang: 'en',
                                      targetLang: _targetLanguage,
                                    );
                                    // Mark favorite
                                    final matched = historyProvider.allItems.firstWhere(
                                      (item) => item.sourceText.trim() == phrase.text.trim(),
                                      orElse: () => historyProvider.allItems.first,
                                    );
                                    if (!matched.isFavorite) {
                                      historyProvider.toggleFavorite(matched);
                                    }
                                  },
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            // Source English Text
                            SelectableText(
                              phrase.text,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),

                            const SizedBox(height: 8),
                            const Divider(height: 1),
                            const SizedBox(height: 8),

                            // Translated Target Text
                            if (isLoading)
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Translating into $targetLangName...',
                                    style: TextStyle(fontSize: 13, color: colorScheme.outline),
                                  ),
                                ],
                              )
                            else if (isFailed)
                              Row(
                                children: [
                                  Icon(Icons.wifi_off_rounded, size: 16, color: colorScheme.error),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Offline - tap to retry',
                                    style: TextStyle(fontSize: 13, color: colorScheme.error),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(Icons.refresh_rounded, size: 18),
                                    onPressed: () => _fetchTranslation(phrase, key),
                                  ),
                                ],
                              )
                            else if (translation != null)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(targetFlag, style: const TextStyle(fontSize: 18)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: SelectableText(
                                      translation,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                            const SizedBox(height: 8),

                            // Bottom Action Icons
                            if (translation != null && !isLoading && !isFailed)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Send to Translate screen button
                                  TextButton.icon(
                                    onPressed: () => _sendToTranslateScreen(context, phrase, translation),
                                    icon: const Icon(Icons.edit_note_rounded, size: 16),
                                    label: const Text('Translate', style: TextStyle(fontSize: 12)),
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    ),
                                  ),
                                  const SizedBox(width: 4),

                                  // Fullscreen Traveler Mode
                                  IconButton(
                                    icon: const Icon(Icons.fullscreen_rounded, size: 20),
                                    tooltip: 'Fullscreen traveler view',
                                    color: colorScheme.primary,
                                    onPressed: () => _openFullscreen(context, phrase.text, translation, translationProvider),
                                  ),

                                  // Copy Button
                                  IconButton(
                                    icon: const Icon(Icons.copy_rounded, size: 18),
                                    tooltip: 'Copy translation',
                                    color: colorScheme.primary,
                                    onPressed: () => _copyPhrase(context, translation),
                                  ),

                                  // Listen TTS Audio Button
                                  FilledButton.tonalIcon(
                                    onPressed: () => _speakPhrase(translation, translationProvider),
                                    icon: const Icon(Icons.volume_up_rounded, size: 18),
                                    label: const Text('Speak', style: TextStyle(fontSize: 12)),
                                    style: FilledButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
