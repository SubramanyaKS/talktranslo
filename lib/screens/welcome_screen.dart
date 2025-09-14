import 'package:flutter/material.dart';
import 'package:talktranslo/screens/home_screen.dart';

import '../component/elevation_button.dart';
import '../utils/constant.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            // Chatbot Icon
            Icon(Icons.translate, size: 100, color: Colors.white),

            SizedBox(height: 20),
            Text(
              HEADING,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            SizedBox(height: 10),

            // Subtitle
            Text(
              SUBTITLE,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 100),
            Spacer(),
            // Start Chat Button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevationButton(onPress:  () {
                // Navigate to Chat Screen
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
              }, title: "Start Translation", foregroundColor: Colors.blueAccent, backgroundColor: Colors.white),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}