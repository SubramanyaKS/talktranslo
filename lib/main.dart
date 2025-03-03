import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talktranslo/provider/translator_provider.dart';
import 'package:talktranslo/screens/welcome_screen.dart';

void main() {
  runApp( MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => TranslationProvider()),
    ],
    child: MyApp(),
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}

