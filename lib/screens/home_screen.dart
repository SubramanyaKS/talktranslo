import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talktranslo/provider/history_provider.dart';
import 'package:talktranslo/screens/history_screen.dart';
import 'package:talktranslo/screens/imagetext_screen.dart';
import 'package:talktranslo/screens/setting_screen.dart';
import 'package:talktranslo/screens/speech_screen.dart';
import 'package:talktranslo/screens/translate_screen.dart';
import 'package:talktranslo/provider/translator_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    TranslateScreen(),
    SpeechScreen(),
    ImageTextScreen(),
    HistoryScreen(),
    SettingScreen(),
  ];

  static const List<String> _titles = <String>[
    'Translate',
    'Voice Conversation',
    'Image OCR',
    'History & Saved',
    'Settings',
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
        actions: _selectedIndex == 3
            ? [
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
              ]
            : null,
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
            icon: Icon(Icons.mic_none_outlined),
            selectedIcon: Icon(Icons.mic),
            label: 'Speak',
          ),
          NavigationDestination(
            icon: Icon(Icons.image_outlined),
            selectedIcon: Icon(Icons.image),
            label: 'Image',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history_rounded),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
