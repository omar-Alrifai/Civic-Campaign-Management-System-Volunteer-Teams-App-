import 'package:flutter/material.dart';

class SelectedCategoryBar extends StatelessWidget {
  final String selectedCategoryFilter;
  final VoidCallback onClearFilter;

  const SelectedCategoryBar({
    Key? key,
    required this.selectedCategoryFilter,
    required this.onClearFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'التصنيف: $selectedCategoryFilter',
            style: const TextStyle(fontSize: 14),
          ),
          TextButton.icon(
            icon: const Icon(Icons.close, size: 18, color: Colors.red),
            label: const Text(
              'إزالة الفلتر',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: onClearFilter,
          ),
        ],
      ),
    );
  }
}
