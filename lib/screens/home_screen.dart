import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talktranslo/provider/history_provider.dart';
import 'package:talktranslo/provider/theme_provider.dart';
import 'package:talktranslo/provider/translator_provider.dart';
import 'package:talktranslo/screens/history_screen.dart';
import 'package:talktranslo/screens/imagetext_screen.dart';
import 'package:talktranslo/screens/setting_screen.dart';
import 'package:talktranslo/screens/speech_screen.dart';
import 'package:talktranslo/screens/translate_screen.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;
  const HomeScreen({super.key, this.initialIndex = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  static const List<Widget> _pages = <Widget>[
    TranslateScreen(),
    SpeechScreen(),
    ImageTextScreen(),
    HistoryScreen(),
  ];

  static const List<String> _titles = <String>[
    'Translate',
    'Voice Conversation',
    'Image OCR',
    'History & Saved',
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      Provider.of<TranslationProvider>(context, listen: false).stopAllSpeechAndListening();
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          if (_selectedIndex == 3)
            Consumer<HistoryProvider>(
              builder: (context, histProvider, _) {
                if (histProvider.allItems.isEmpty) return const SizedBox.shrink();
                return IconButton(
                  icon: const Icon(Icons.delete_sweep_rounded),
                  tooltip: 'Clear history',
                  onPressed: () => HistoryScreen.confirmClearDialog(context, histProvider),
                );
              },
            ),
          // Quick Light/Dark Mode toggle
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                ),
                tooltip: themeProvider.isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                onPressed: () => themeProvider.toggleTheme(),
              );
            },
          ),
          // Settings navigation button
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () {
              Provider.of<TranslationProvider>(context, listen: false).stopAllSpeechAndListening();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingScreen()),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.translate_outlined),
            selectedIcon: Icon(Icons.translate),
            label: 'Translate',
          ),
          NavigationDestination(
            icon: Icon(Icons.record_voice_over_outlined),
            selectedIcon: Icon(Icons.record_voice_over_rounded),
            label: 'Conversation',
          ),
          NavigationDestination(
            icon: Icon(Icons.document_scanner_outlined),
            selectedIcon: Icon(Icons.document_scanner_rounded),
            label: 'Camera OCR',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmarks_outlined),
            selectedIcon: Icon(Icons.bookmarks_rounded),
            label: 'Saved & History',
          ),
        ],
      ),
    );
  }
}
