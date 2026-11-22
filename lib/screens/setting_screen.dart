import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talktranslo/screens/abouthelp_screen.dart';
import 'package:talktranslo/screens/offline_languages_screen.dart';
import 'package:talktranslo/screens/speechsetting_screen.dart';
import '../provider/theme_provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Section Header: Appearance
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
            child: Text(
              'Appearance',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ),

          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          themeProvider.themeMode == ThemeMode.system
                              ? Icons.brightness_auto_rounded
                              : (themeProvider.isDarkMode
                                  ? Icons.dark_mode_rounded
                                  : Icons.light_mode_rounded),
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Theme Mode',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              themeProvider.themeMode == ThemeMode.system
                                  ? 'Matches your device appearance'
                                  : (themeProvider.isDarkMode
                                      ? 'Dark theme enabled'
                                      : 'Light theme enabled'),
                              style: TextStyle(fontSize: 13, color: theme.hintColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<ThemeMode>(
                      segments: const [
                        ButtonSegment<ThemeMode>(
                          value: ThemeMode.system,
                          label: Text('System'),
                          icon: Icon(Icons.brightness_auto_rounded, size: 16),
                        ),
                        ButtonSegment<ThemeMode>(
                          value: ThemeMode.light,
                          label: Text('Light'),
                          icon: Icon(Icons.light_mode_rounded, size: 16),
                        ),
                        ButtonSegment<ThemeMode>(
                          value: ThemeMode.dark,
                          label: Text('Dark'),
                          icon: Icon(Icons.dark_mode_rounded, size: 16),
                        ),
                      ],
                      selected: {themeProvider.themeMode},
                      onSelectionChanged: (selection) {
                        themeProvider.setThemeMode(selection.first);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Section Header: Audio & Speech
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
            child: Text(
              'Audio & Speech',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ),

          Card(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.mic_rounded,
                  color: colorScheme.secondary,
                ),
              ),
              title: const Text(
                'Speech Settings',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                'Speed, pitch, voices, default languages',
                style: TextStyle(fontSize: 13, color: theme.hintColor),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SpeechSettingScreen()),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Section Header: Offline Translation
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
            child: Text(
              'Offline Translation',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ),

          Card(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.download_for_offline_rounded,
                  color: colorScheme.primary,
                ),
              ),
              title: const Text(
                'Offline Language Packs',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                'Download languages for on-device offline translation',
                style: TextStyle(fontSize: 13, color: theme.hintColor),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const OfflineLanguagesScreen()),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Section Header: Support & About
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
            child: Text(
              'Support & About',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ),

          Card(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.tertiary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.help_outline_rounded,
                  color: colorScheme.tertiary,
                ),
              ),
              title: const Text(
                'About & Help',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                'FAQs, application info, and version',
                style: TextStyle(fontSize: 13, color: theme.hintColor),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AbouthelpScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
