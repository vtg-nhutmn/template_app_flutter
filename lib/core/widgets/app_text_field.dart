import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool enabled;
  final AutovalidateMode? autovalidateMode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final String? helperText;
  final int? helperMaxLines;
  final Key? formFieldKey;

  const AppTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.prefixIcon,
    this.keyboardType,
    this.textInputAction,
    this.enabled = true,
    this.autovalidateMode,
    this.onChanged,
    this.onFieldSubmitted,
    this.helperText,
    this.helperMaxLines,
    this.formFieldKey,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: formFieldKey,
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon,
        helperText: helperText,
        helperMaxLines: helperMaxLines,
      ),
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autovalidateMode: autovalidateMode,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
