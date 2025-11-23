import 'package:flutter/material.dart';

class GeneralTextfield extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final Color? backgroundColor;
  final Widget? suffixIcon;

  const GeneralTextfield({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    this.backgroundColor,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          // Use provided backgroundColor if given, otherwise fallback to theme
          fillColor: backgroundColor ?? Theme.of(context).colorScheme.secondary,
          filled: true,
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
