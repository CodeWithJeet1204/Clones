import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.keyboardType,
    this.isObscured = false,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final bool isObscured;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: border,
        filled: true,
        focusedBorder: border,
        enabledBorder: border,
        fillColor: const Color.fromARGB(255, 24, 24, 24),
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: keyboardType,
      obscureText: isObscured,
    );
  }
}
