import 'package:flutter/material.dart';

class RoundTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType type;
  final String hintText;
  final Color hintTextColor;
  final IconData prefixIcon;
  final Color prefixIconColor;
  final String? Function(String?) validate;
  final IconData? suffixIcon;
  final Color? suffixIconColor;
  final bool isPasswordVisible;
  final bool readOnly;
  final Function(String)? onValueChanged;
  final Function? onValueSubmitted;
  final VoidCallback? suffixPressed;
  final EdgeInsets? margin;
  final double? width;
  final double? height;

  const RoundTextFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.type,
    required this.hintText,
    required this.hintTextColor,
    required this.prefixIcon,
    required this.prefixIconColor,
    required this.validate,
    this.suffixIcon,
    this.suffixIconColor,
    this.isPasswordVisible = false,
    this.readOnly = false,
    this.onValueChanged,
    this.onValueSubmitted,
    this.suffixPressed,
    this.margin,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: width,
      height: height,
      margin: margin,
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        obscureText: isPasswordVisible,
        readOnly: readOnly,
        validator: validate,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: onValueChanged,
        cursorColor: theme.colorScheme.primary,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 16,
          fontFamily: 'Cairo',
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
          filled: true,
          fillColor: Colors.white,
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey[700],
            fontSize: 14,
            fontFamily: 'Cairo',
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: hintTextColor,
            fontSize: 14,
            fontFamily: 'Cairo',
          ),
          prefixIcon: Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(left: 16, right: 8),
            child: Icon(prefixIcon, color: prefixIconColor, size: 20),
          ),
          suffixIcon: suffixIcon != null
              ? IconButton(
                  icon: Icon(suffixIcon, color: suffixIconColor, size: 20),
                  onPressed: suffixPressed,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
        ),
      ),
    );
  }
}
