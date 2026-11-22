import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../provider/translator_provider.dart';
import '../services/offline_translation_service.dart';
import '../utils/language.dart';

class OfflineLanguagesScreen extends StatefulWidget {
  const OfflineLanguagesScreen({super.key});

  @override
  State<OfflineLanguagesScreen> createState() => _OfflineLanguagesScreenState();
}

class _OfflineLanguagesScreenState extends State<OfflineLanguagesScreen> {
  final OfflineTranslationService _offlineService = OfflineTranslationService.instance;
  final List<OfflineLanguageInfo> _languages = OfflineTranslationService.supportedLanguages;

  final Map<String, bool> _downloaded = {};
  final Set<String> _downloading = {};
  bool _isLoadingStatus = true;
  bool _wifiOnly = true;

  @override
  void initState() {
    super.initState();
    _refreshModelStatuses();
  }

  Future<void> _refreshModelStatuses() async {
    setState(() => _isLoadingStatus = true);
    final statuses = <String, bool>{};
    for (final lang in _languages) {
      statuses[lang.code] = await _offlineService.isModelDownloaded(lang.code);
    }
    if (!mounted) return;
    setState(() {
      _downloaded
        ..clear()
        ..addAll(statuses);
      _isLoadingStatus = false;
    });
  }

  Future<void> _handleDownload(OfflineLanguageInfo lang) async {
    HapticFeedback.lightImpact();
    setState(() => _downloading.add(lang.code));

    final success = await _offlineService.downloadModel(
      lang.code,
      isWifiRequired: _wifiOnly,
    );

    if (!mounted) return;
    setState(() {
      _downloading.remove(lang.code);
      if (success) _downloaded[lang.code] = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? '${lang.name} offline pack downloaded!'
              : _wifiOnly
                  ? 'Could not download ${lang.name}. Check Wi-Fi or turn off Wi-Fi Only.'
                  : 'Could not download ${lang.name}. Please check your internet connection.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _handleDelete(OfflineLanguageInfo lang) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Remove ${lang.name}?'),
        content: Text(
          'This will delete the downloaded offline translation pack for ${lang.name} (~30 MB) from your device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    HapticFeedback.mediumImpact();

    final success = await _offlineService.deleteModel(lang.code);
    if (!mounted) return;
    setState(() {
      if (success) _downloaded[lang.code] = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? '${lang.name} offline pack removed' : 'Failed to remove ${lang.name} pack',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final downloadedCount = _downloaded.values.where((v) => v).length;
    final onlineOnly = OfflineTranslationService.onlineOnlyLanguages;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Translation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh download status',
            onPressed: _isLoadingStatus ? null : _refreshModelStatuses,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Offline Mode Preferences
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
            child: Text(
              'Offline Preferences',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ),
          Consumer<TranslationProvider>(
            builder: (context, provider, _) {
              return Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      secondary: Icon(Icons.cloud_off_rounded, color: colorScheme.primary),
                      title: const Text(
                        'Auto Offline Fallback',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: const Text(
                        'Automatically translate on-device when internet is unavailable',
                        style: TextStyle(fontSize: 12.5),
                      ),
                      value: provider.offlineFallbackEnabled,
                      onChanged: (val) {
                        HapticFeedback.selectionClick();
                        provider.setOfflineFallbackEnabled(val);
                      },
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      secondary: Icon(Icons.airplanemode_active_rounded, color: colorScheme.secondary),
                      title: const Text(
                        'Prefer Offline Mode',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: const Text(
                        'Always use downloaded language packs first (saves mobile data)',
                        style: TextStyle(fontSize: 12.5),
                      ),
                      value: provider.preferOfflineMode,
                      onChanged: (val) {
                        HapticFeedback.selectionClick();
                        provider.setPreferOfflineMode(val);
                      },
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      secondary: Icon(Icons.wifi_rounded, color: colorScheme.tertiary),
                      title: const Text(
                        'Download Over Wi-Fi Only',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: const Text(
                        'Prevent ~30 MB language packs from using cellular data',
                        style: TextStyle(fontSize: 12.5),
                      ),
                      value: _wifiOnly,
                      onChanged: (val) {
                        HapticFeedback.selectionClick();
                        setState(() => _wifiOnly = val);
                      },
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 18),

          // Language Packs Header
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Offline Language Packs',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                Text(
                  '$downloadedCount of ${_languages.length} downloaded',
                  style: TextStyle(fontSize: 12, color: theme.hintColor),
                ),
              ],
            ),
          ),

          if (_isLoadingStatus)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: CircularProgressIndicator()),
            )
          else
            Card(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _languages.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final lang = _languages[index];
                  final isDownloaded = _downloaded[lang.code] ?? false;
                  final isDownloading = _downloading.contains(lang.code);
                  final flag = getLanguageFlag(lang.name == 'Chinese' ? 'Chinese (Simplified)' : lang.name);

                  return ListTile(
                    leading: Text(flag, style: const TextStyle(fontSize: 24)),
                    title: Text(
                      lang.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      isDownloading
                          ? 'Downloading (~30 MB)...'
                          : (isDownloaded ? 'Ready for offline translation' : 'On-device pack (~30 MB)'),
                      style: TextStyle(
                        fontSize: 12,
                        color: isDownloaded ? colorScheme.primary : theme.hintColor,
                      ),
                    ),
                    trailing: isDownloading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2.5),
                          )
                        : isDownloaded
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check_circle_rounded, color: colorScheme.primary, size: 22),
                                  const SizedBox(width: 4),
                                  IconButton(
                                    icon: Icon(Icons.delete_outline_rounded, color: colorScheme.error, size: 20),
                                    tooltip: 'Remove offline pack',
                                    onPressed: () => _handleDelete(lang),
                                  ),
                                ],
                              )
                            : FilledButton.tonalIcon(
                                onPressed: () => _handleDownload(lang),
                                icon: const Icon(Icons.download_rounded, size: 16),
                                label: const Text('Download', style: TextStyle(fontSize: 12)),
                                style: FilledButton.styleFrom(
                                  visualDensity: VisualDensity.compact,
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                ),
                              ),
                  );
                },
              ),
            ),

          if (onlineOnly.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline_rounded, size: 18, color: colorScheme.onSurfaceVariant),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Note: ${onlineOnly.join(', ')} are currently online-only because on-device ML Kit models are not yet available for them. Download both source and target packs (e.g. English + Kannada) to translate between them offline.',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
