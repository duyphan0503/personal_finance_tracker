import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final TextStyle style;

  const CustomButton({super.key, required this.text, required this.onPressed, this.style = const TextStyle(color: Colors.white),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text,
        style: style,),
    );
  }
}