import 'package:flutter/material.dart';

class GeneralButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color? textColor;

  const GeneralButton({
    super.key,
    required this.text,
    required this.onTap,
    this.gradient,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color resolvedTextColor = textColor ?? Colors.white;
    final Widget child = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: resolvedTextColor, fontSize: 20),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          color: gradient == null ? (backgroundColor ?? Theme.of(context).colorScheme.secondary) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onTap,
            child: child,
          ),
        ),
      ),
    );
  }
}
