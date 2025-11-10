import 'package:flutter/material.dart';

class TypedTextBox extends StatelessWidget {
  const TypedTextBox({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        reverse: true,
        padding: const EdgeInsets.all(4.0),
        child: Text(
          text,
          style: TextStyle(fontSize: 20, color: Colors.grey[700]),
        ),
      ),
    );
  }
}
