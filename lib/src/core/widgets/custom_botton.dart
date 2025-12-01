import 'package:flutter/material.dart';

class CustomBotton extends StatelessWidget {
  const CustomBotton({
    required this.text,
    this.onPressed,
    this.isEnabled = true,
    super.key,
  });

  final bool isEnabled;
  final VoidCallback? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      child: Text(text),
    );
  }
}
