import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talktranslo/provider/history_provider.dart';
import 'package:talktranslo/provider/image_text_provider.dart';
import 'package:talktranslo/provider/theme_provider.dart';
import 'package:talktranslo/provider/translator_provider.dart';
import 'package:talktranslo/screens/home_screen.dart';
import 'package:talktranslo/screens/welcome_screen.dart';
import 'package:talktranslo/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Global uncaught Flutter error handler
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Flutter Error: ${details.exceptionAsString()}');
  };

  final prefs = await SharedPreferences.getInstance();
  final bool hasSeenOnboarding = prefs.getBool('pref_has_seen_onboarding') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TranslationProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ChangeNotifierProvider(create: (_) => ImageTextProvider()),
      ],
      child: MyApp(hasSeenOnboarding: hasSeenOnboarding),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool hasSeenOnboarding;
  const MyApp({super.key, this.hasSeenOnboarding = false});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'TalkTranslo',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          home: hasSeenOnboarding ? const HomeScreen() : const WelcomeScreen(),
        );
      },
    );
  }
}

