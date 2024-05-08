import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget{
  final controller;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    });

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 172, 136, 135)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 138, 255, 193))
                    ),
                    fillColor: const Color.fromARGB(255, 138, 255, 193),
                    filled: true,
                    hintText: hintText,
                    ),
                  ),
    );
  }
}