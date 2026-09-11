import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graduationregistration/core/app_colors.dart';

class CreateCampaignImagePicker extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onTap;

  const CreateCampaignImagePicker({
    Key? key,
    required this.imagePath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: imagePath != null && imagePath!.isNotEmpty
            ? Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(imagePath!),
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              )
            : Center(
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 28,
                        color: AppColors.OceanBlue,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'اضغط لإضافة صورة للحملة',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
