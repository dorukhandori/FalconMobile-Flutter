import 'package:flutter/material.dart';

class AllproxLogo extends StatelessWidget {
  final double? height;

  const AllproxLogo({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/epic_soft_logo.png',
      height: height,
      fit: BoxFit.contain,
    );
  }
}
