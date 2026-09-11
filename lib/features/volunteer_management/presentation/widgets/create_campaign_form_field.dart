import 'package:flutter/material.dart';
import 'package:graduationregistration/core/app_colors.dart';

class CreateCampaignFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final int? maxLines;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;

  const CreateCampaignFormField({
    Key? key,
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.maxLines,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 14, color: Colors.grey),
        prefixIcon: Icon(icon, color: AppColors.OceanBlue),
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      onChanged: onChanged,
    );
  }
}
