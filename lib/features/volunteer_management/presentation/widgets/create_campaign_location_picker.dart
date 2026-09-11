import 'package:flutter/material.dart';
import 'package:graduationregistration/core/app_colors.dart';
import 'package:latlong2/latlong.dart';

class CreateCampaignLocationPicker extends StatelessWidget {
  final LatLng? selectedLocation;
  final VoidCallback onPickLocation;

  const CreateCampaignLocationPicker({
    Key? key,
    required this.selectedLocation,
    required this.onPickLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'يجب اختيار الموقع من الخريطة',
          style: TextStyle(fontSize: 11, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.OceanBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: onPickLocation,
            child: const Text(
              'اختر موقع الحملة من الخريطة',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        if (selectedLocation != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'الموقع المحدد: ${selectedLocation!.latitude.toStringAsFixed(4)}, ${selectedLocation!.longitude.toStringAsFixed(4)}',
              style: const TextStyle(fontSize: 12, color: Colors.green),
            ),
          ),
      ],
    );
  }
}
