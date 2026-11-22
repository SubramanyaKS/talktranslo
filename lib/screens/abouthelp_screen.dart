import 'package:flutter/material.dart';
import 'package:talktranslo/utils/constant.dart';
import 'package:talktranslo/utils/language.dart';

class AbouthelpScreen extends StatelessWidget {
  const AbouthelpScreen({super.key});

  static const String appVersion = "1.0.0";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("About & Help")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                heading.toUpperCase(),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Center(
              child: Text(
                "Version $appVersion",
                style: TextStyle(fontSize: 14, color: theme.hintColor),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "About TalkTranslo",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 6),
            Text(about, style: const TextStyle(height: 1.45)),
            const SizedBox(height: 24),
            Text(
              "Frequently Asked Questions",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: questionAnswer.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: ExpansionTile(
                    title: Text(
                      questionAnswer[index]["Q"]!,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            questionAnswer[index]["A"]!,
                            style: TextStyle(height: 1.4, color: colorScheme.onSurfaceVariant),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
