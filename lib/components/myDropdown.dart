import 'package:flutter/material.dart';

class MyDropdown extends StatelessWidget {
  final String hintText;
  final Icon icon;
  final List<String> items;
  final String value;
  final Function(String?)? onChanged;

  const MyDropdown({super.key, 
    required this.hintText,
    required this.icon,
    required this.items,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        decoration:  BoxDecoration(
          color: const Color.fromARGB(255, 255, 246, 164),
          borderRadius: BorderRadius.circular(5.0), // Rounded corners
          border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)), // Border color
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value.isEmpty ? null : value, // Ensure value can be null initially
            icon: icon,
            isExpanded: true,
            onChanged: onChanged,
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            hint: Text(hintText),
          ),
        ),
      ),
    );
  }
}
