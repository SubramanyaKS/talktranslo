import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../provider/history_provider.dart';
import '../provider/translator_provider.dart';
import '../utils/language.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  static void exportHistory(BuildContext context, HistoryProvider provider) {
    final items = provider.displayItems;
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No translations available to export'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    HapticFeedback.lightImpact();

    final buffer = StringBuffer();
    final filterTitle = provider.showFavoritesOnly ? "Starred Phrasebook" : "Translation History";
    buffer.writeln("=== TalkTranslo - $filterTitle ===");
    buffer.writeln("Exported: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}");
    buffer.writeln("Total Items: ${items.length}\n");

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final srcName = getLanguageNameFromValue(talklanguageMap, item.sourceLang);
      final trgName = getLanguageNameFromValue(languageMap, item.targetLang);
      final star = item.isFavorite ? " ★" : "";
      buffer.writeln("${i + 1}. [$srcName ➔ $trgName$star]");
      buffer.writeln("Source: ${item.sourceText}");
      buffer.writeln("Translated: ${item.translatedText}");
      buffer.writeln("");
    }

    buffer.writeln("(Exported from TalkTranslo App)");

    Share.share(
      buffer.toString(),
      subject: 'TalkTranslo $filterTitle Export',
    );
  }

  static void confirmClearDialog(BuildContext context, HistoryProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Clear History'),
          content: const Text(
            'Do you want to delete all history entries or keep your starred phrases?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                provider.clearHistory(keepFavorites: true);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cleared history (starred phrases kept)'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Keep Starred'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
                provider.clearHistory(keepFavorites: false);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All history deleted'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Delete All'),
            ),
          ],
        );
      },
    );
  }

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatTimestamp(DateTime dt) {
    final now = DateTime.now();
    final difference = now.difference(dt);

    if (difference.inSeconds < 60) return "Just now";
    if (difference.inMinutes < 60) return "${difference.inMinutes}m ago";
    if (difference.inHours < 24 && dt.day == now.day) {
      final hour = dt.hour.toString().padLeft(2, '0');
      final minute = dt.minute.toString().padLeft(2, '0');
      return "Today $hour:$minute";
    }
    if (difference.inDays < 7) {
      return "${difference.inDays}d ago";
    }
    return "${dt.day}/${dt.month}/${dt.year}";
  }

  void _copyText(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied translation to clipboard'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareText(String source, String translated) {
    Share.share(
      '$source\n\n→ $translated\n\n(Translated with TalkTranslo)',
      subject: 'Translation from TalkTranslo',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final historyProvider = Provider.of<HistoryProvider>(context);
    final translationProvider = Provider.of<TranslationProvider>(context, listen: false);

    final displayItems = historyProvider.displayItems;

    return Column(
      children: [
        // Search & Filter Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search history or phrases...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: historyProvider.searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          historyProvider.setSearchQuery('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) => historyProvider.setSearchQuery(val),
            ),
          ),

          // Filter Segmented Controls: All vs Starred + Quick Export Action
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: SegmentedButton<bool>(
                    segments: [
                      ButtonSegment<bool>(
                        value: false,
                        label: Text('All (${historyProvider.allItems.length})'),
                        icon: const Icon(Icons.history_rounded, size: 18),
                      ),
                      ButtonSegment<bool>(
                        value: true,
                        label: Text('Saved (${historyProvider.favoriteItems.length})'),
                        icon: const Icon(Icons.star_rounded, size: 18),
                      ),
                    ],
                    selected: {historyProvider.showFavoritesOnly},
                    onSelectionChanged: (Set<bool> newSelection) {
                      HapticFeedback.selectionClick();
                      historyProvider.setShowFavoritesOnly(newSelection.first);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  icon: const Icon(Icons.share_outlined, size: 20),
                  tooltip: 'Export / Share translations',
                  onPressed: displayItems.isEmpty
                      ? null
                      : () => HistoryScreen.exportHistory(context, historyProvider),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // List View
          Expanded(
            child: historyProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : displayItems.isEmpty
                    ? Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                historyProvider.showFavoritesOnly
                                    ? Icons.star_outline_rounded
                                    : Icons.history_toggle_off_rounded,
                                size: 64,
                                color: theme.hintColor.withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                historyProvider.showFavoritesOnly
                                    ? 'No saved phrases yet'
                                    : (historyProvider.searchQuery.isNotEmpty
                                        ? 'No matching translations found'
                                        : 'No translation history yet'),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                historyProvider.showFavoritesOnly
                                    ? 'Tap the star icon on any translation to save it to your phrasebook.'
                                    : 'Translations you make will automatically appear here.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: theme.hintColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => historyProvider.loadHistory(),
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: displayItems.length,
                          itemBuilder: (context, index) {
                            final item = displayItems[index];

                            final srcName = getLanguageNameFromValue(talklanguageMap, item.sourceLang);
                            final trgName = getLanguageNameFromValue(languageMap, item.targetLang);
                            final srcFlag = getLanguageFlag(srcName);
                            final trgFlag = getLanguageFlag(trgName);

                            return Dismissible(
                              key: ValueKey('history_${item.id}'),
                              direction: DismissDirection.endToStart,
                              confirmDismiss: (direction) async {
                                return await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Delete Translation'),
                                    content: Text(
                                      item.isFavorite
                                          ? 'This is a starred phrase. Are you sure you want to delete it from history?'
                                          : 'Are you sure you want to delete this translation from your history?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(ctx).pop(false),
                                        child: const Text('Cancel'),
                                      ),
                                      FilledButton(
                                        style: FilledButton.styleFrom(
                                          backgroundColor: colorScheme.error,
                                        ),
                                        onPressed: () => Navigator.of(ctx).pop(true),
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                  color: colorScheme.error,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Delete',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(
                                      Icons.delete_outline_rounded,
                                      color: Colors.white,
                                      size: 26,
                                    ),
                                  ],
                                ),
                              ),
                              onDismissed: (_) {
                                final deletedItem = item;
                                historyProvider.deleteItem(item.id!);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Translation removed'),
                                    behavior: SnackBarBehavior.floating,
                                    action: SnackBarAction(
                                      label: 'UNDO',
                                      onPressed: () {
                                        historyProvider.restoreItem(deletedItem);
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: BorderSide(
                                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(16, 12, 12, 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Header: Language Pair and Timestamp
                                      Row(
                                        children: [
                                          Text(
                                            '$srcFlag $srcName  →  $trgFlag $trgName',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: colorScheme.primary,
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            _formatTimestamp(item.timestamp),
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: theme.hintColor,
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 10),

                                      // Source Text
                                      SelectableText(
                                        item.sourceText,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),

                                      const SizedBox(height: 6),

                                      // Translated Text
                                      SelectableText(
                                        item.translatedText,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.onSurface,
                                        ),
                                      ),

                                      const SizedBox(height: 8),
                                      const Divider(height: 1, thickness: 0.5),

                                      // Actions Toolbar
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          // Star / Favorite Toggle
                                          IconButton(
                                            icon: Icon(
                                              item.isFavorite
                                                  ? Icons.star_rounded
                                                  : Icons.star_outline_rounded,
                                              color: item.isFavorite
                                                  ? Colors.amber.shade700
                                                  : colorScheme.onSurfaceVariant,
                                            ),
                                            tooltip: item.isFavorite ? 'Unstar' : 'Star phrase',
                                            onPressed: () => historyProvider.toggleFavorite(item),
                                          ),

                                          // Speak Audio Playback
                                          IconButton(
                                            icon: const Icon(Icons.volume_up_rounded, size: 20),
                                            tooltip: 'Listen pronunciation',
                                            color: colorScheme.onSurfaceVariant,
                                            onPressed: () {
                                              translationProvider.speakCustomText(
                                                item.translatedText,
                                                item.targetLang,
                                              );
                                            },
                                          ),

                                          // Copy
                                          IconButton(
                                            icon: const Icon(Icons.copy_rounded, size: 20),
                                            tooltip: 'Copy translation',
                                            color: colorScheme.onSurfaceVariant,
                                            onPressed: () => _copyText(item.translatedText),
                                          ),

                                          // Share
                                          IconButton(
                                            icon: const Icon(Icons.share_rounded, size: 20),
                                            tooltip: 'Share',
                                            color: colorScheme.onSurfaceVariant,
                                            onPressed: () => _shareText(
                                              item.sourceText,
                                              item.translatedText,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      );
  }
}
