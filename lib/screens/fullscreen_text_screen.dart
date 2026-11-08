import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/language.dart';

class FullscreenTextScreen extends StatelessWidget {
  const FullscreenTextScreen({
    super.key,
    required this.translatedText,
    required this.targetLanguage,
    required this.sourceText,
    required this.onSpeak,
  });

  final String translatedText;
  final String targetLanguage;
  final String sourceText;
  final VoidCallback onSpeak;

  void _copyText(BuildContext context) {
    Clipboard.setData(ClipboardData(text: translatedText));
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied translation to clipboard'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final langName = getLanguageNameFromValue(languageMap, targetLanguage);
    final flag = getLanguageFlag(langName);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, size: 28),
          tooltip: 'Close fullscreen',
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(flag, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Text(
              langName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy_rounded),
            tooltip: 'Copy translation',
            onPressed: () => _copyText(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Original source context card
              if (sourceText.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    sourceText,
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

              // Large High-Contrast Display Text
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: SelectableText(
                      translatedText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: translatedText.length > 80
                            ? 28
                            : (translatedText.length > 30 ? 36 : 46),
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom Audio Pronounce Action Button
              Center(
                child: FilledButton.icon(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    onSpeak();
                  },
                  icon: const Icon(Icons.volume_up_rounded, size: 26),
                  label: const Text(
                    'Play Pronunciation',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
