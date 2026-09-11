import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduationregistration/features/auth/presentation/blocs/signup/sign_up_bloc.dart';
import 'package:graduationregistration/features/auth/presentation/pages/pick_location_page.dart';
import 'package:latlong2/latlong.dart';

class LocationInfoStep extends StatelessWidget {
  final SignUpFormData formData;

  const LocationInfoStep({Key? key, required this.formData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'المنطقة (اختياري)'),
              value: formData.area,
              onChanged: (value) {
                if (value != null) {
                  context.read<SignUpBloc>().add(UpdateSignUpForm(area: value));
                }
              },
              items: const [
                DropdownMenuItem(
                  value: 'دمشق القديمة',
                  child: Text('دمشق القديمة'),
                ),
                DropdownMenuItem(value: 'ساروجة', child: Text('ساروجة')),
                DropdownMenuItem(value: 'القنوات', child: Text('القنوات')),
                DropdownMenuItem(value: 'جوبر', child: Text('جوبر')),
                DropdownMenuItem(value: 'الميدان', child: Text('الميدان')),
                DropdownMenuItem(value: 'الشاغور', child: Text('الشاغور')),
                DropdownMenuItem(value: 'القدم', child: Text('القدم')),
                DropdownMenuItem(value: 'كفر سوسة', child: Text('كفر سوسة')),
                DropdownMenuItem(value: 'المزة', child: Text('المزة')),
                DropdownMenuItem(value: 'دمر', child: Text('دمر')),
                DropdownMenuItem(value: 'برزة', child: Text('برزة')),
                DropdownMenuItem(value: 'القابون', child: Text('القابون')),
                DropdownMenuItem(value: 'ركن الدين', child: Text('ركن الدين')),
                DropdownMenuItem(value: 'الصالحية', child: Text('الصالحية')),
                DropdownMenuItem(value: 'المهاجرين', child: Text('المهاجرين')),
                DropdownMenuItem(value: 'اليرموك', child: Text('اليرموك')),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final LatLng? pickedLocation = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PickLocationPage()),
                );
                if (pickedLocation != null) {
                  context.read<SignUpBloc>().add(
                    UpdateSignUpForm(
                      latitude: pickedLocation.latitude,
                      longitude: pickedLocation.longitude,
                    ),
                  );
                }
              },
              child: const Text('اختر موقعك على الخريطة'),
            ),
          ],
        );
      },
    );
  }
}
