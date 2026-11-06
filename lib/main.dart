import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talktranslo/provider/theme_provider.dart';
import 'package:talktranslo/provider/translator_provider.dart';
import 'package:talktranslo/screens/welcome_screen.dart';
import 'package:talktranslo/utils/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TranslationProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          home: const WelcomeScreen(),
        );
      },
    );
  }
}

