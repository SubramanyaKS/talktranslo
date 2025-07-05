import 'package:flutter/material.dart';
class CustomDropdown extends StatelessWidget {
  const CustomDropdown({super.key, required this.value, required this.map, this.onChanged});
  final String value;
  final Map<String, String> map;
  final  void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      dropdownColor: Colors.grey,

      value: value,
      items: map.entries.map((entry) {
        return DropdownMenuItem<String>(

          value: entry.value,
          child: Text(entry.key,style: TextStyle(fontSize: 18),),
        );
      }).toList(),
      onChanged: onChanged
    );
  }
}
