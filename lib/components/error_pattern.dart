import 'package:flutter/material.dart';

class ErrorPattern extends StatelessWidget {
  final String errorText;

  const ErrorPattern({required this.errorText, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.error_outline_rounded,
          color: Colors.white,
          size: 70,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            errorText,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
