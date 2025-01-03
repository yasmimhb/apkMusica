import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
   MyButton({super.key, required this.onTap, required this.text, required Color textColor});
   Function() ? onTap;
   final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25.0),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18
            )
          ),
        ),
      ),
    );
  }
}