import 'package:flutter/material.dart';

class TextCard extends StatelessWidget {
  const TextCard({super.key, required this.controller, required this.hint,
    required this.onCopy,
    required this.onSpeak,
    required this.editable});
  final TextEditingController controller;
  final String hint;
  final VoidCallback onCopy;
  final VoidCallback onSpeak;
  final bool editable;


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8)
        ],
      ),
      child: Column(
        children: [

          // 🔊 Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: onCopy,
                icon: const Icon(Icons.copy, size: 20),
              ),
              IconButton(
                onPressed: onSpeak,
                icon: const Icon(Icons.volume_up, size: 20),
              ),
            ],
          ),

          // ✍️ Text Field
          TextField(
            controller: controller,
            readOnly: !editable,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }
}
