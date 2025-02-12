import 'package:flutter/material.dart';

class AllproxLogo extends StatelessWidget {
  const AllproxLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: 'ALL',
            style: TextStyle(color: Color(0xFF1B3E41)),
          ),
          TextSpan(
            text: 'PR',
            style: TextStyle(color: Color(0xFF4A90A4)),
          ),
          TextSpan(
            text: 'O',
            style: TextStyle(color: Color(0xFF4CAF50)),
          ),
          TextSpan(
            text: 'X',
            style: TextStyle(color: Color(0xFF1B3E41)),
          ),
        ],
      ),
    );
  }
}
