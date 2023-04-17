import 'package:flutter/material.dart';
import 'package:milk_user/utils/colors.dart';
import 'package:provider/provider.dart';

import '../dark_theme_provider.dart';

class TextFormFieldWidget extends StatelessWidget {
  final String? label;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final bool? autoFocus;
  final TextInputType? keyboardType;
  final String? initialValue;
  final void Function(String)? onChanged;
  final int? maxLength;
  final Widget? suffixIcon;
  final bool? obscureText;
  final bool? readOnly;
  final String? hintText;
  final int? maxLines;
  final String? suffixText;
  final Widget? suffix;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  const TextFormFieldWidget(
      {super.key,
      this.label,
      this.validator,
      this.controller,
      this.keyboardType,
      this.initialValue,
      this.onChanged,
      this.maxLength,
      this.suffixIcon,
      this.autoFocus,
      this.obscureText,
      this.readOnly,
      this.maxLines,
      this.suffix,
      this.labelStyle,
      this.suffixText,
      this.hintText, this.hintStyle});

  @override
  Widget build(BuildContext context) {
    final themeChange= Provider.of<DarkThemeProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label ?? "",
          style: labelStyle ??
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextFormField(
          cursorColor: themeChange.darkTheme?grey300:black,
          cursorHeight: 22,
          autofocus: autoFocus ?? false,
          controller: controller,
          readOnly: readOnly ?? false,
          initialValue: initialValue,
          keyboardType: keyboardType,
          maxLength: maxLength,
          onChanged: onChanged,
          obscureText: obscureText ?? false,
          validator: validator,
          maxLines: maxLines ?? 1,
          decoration: InputDecoration(
            suffix: suffix,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(12),
            ),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: red)),
            errorStyle: const TextStyle(fontSize: 12.5),
            contentPadding: const EdgeInsets.all(18),
            hintText: hintText,
            hintStyle: hintStyle,
            suffixText: suffixText,
            fillColor: themeChange.darkTheme?Colors.white12:grey300,
            filled: true,
          ),
        ),
      ],
    );
  }
}
