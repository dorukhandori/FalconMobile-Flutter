import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final String message;

  const ErrorView({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.red,
      child: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
