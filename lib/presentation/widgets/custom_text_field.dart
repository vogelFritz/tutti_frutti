import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final void Function(String value)? onChanged;

  const CustomTextField({
    super.key,
    this.label,
    this.hintText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          label: label != null ? Text(label!) : null, hintText: hintText),
      onChanged: onChanged,
    );
  }
}
