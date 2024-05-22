import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget{
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Icon icon;
  final Function(String)? onChanged;


  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.icon,
    this.onChanged,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {

    late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: widget.controller,
        obscureText: _isObscured,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          prefixIcon: widget.icon,
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _isObscured ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                )
              : null,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 255, 0, 0)),
          ),
          fillColor: const Color.fromARGB(255, 255, 246, 164),
          filled: true,
          hintText: widget.hintText,
        ),
      ),
    );
  }
}