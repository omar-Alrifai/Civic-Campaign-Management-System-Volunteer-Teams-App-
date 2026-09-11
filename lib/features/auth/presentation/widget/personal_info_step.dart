import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduationregistration/features/auth/presentation/blocs/signup/sign_up_bloc.dart';

class PersonalInfoStep extends StatelessWidget {
  final SignUpFormData formData;

  const PersonalInfoStep({Key? key, required this.formData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'العمر'),
              keyboardType: TextInputType.number,
              onChanged: (value) => context.read<SignUpBloc>().add(
                UpdateSignUpForm(age: int.tryParse(value) ?? 0),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'العمر مطلوب';
                if (int.tryParse(value) == null || int.parse(value) <= 0)
                  return 'أدخل عمر صحيح';
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'الجنس'),
              value: formData.gender,

              onChanged: (value) {
                if (value != null) {
                  context.read<SignUpBloc>().add(
                    UpdateSignUpForm(gender: value),
                  );
                }
              },
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'اختر الجنس' : null,
              items: const [
                DropdownMenuItem(value: 'male', child: Text('ذكر')),
                DropdownMenuItem(value: 'female', child: Text('أنثى')),
              ],
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'نبذة عنك (اختياري)',
              ),
              onChanged: (value) =>
                  context.read<SignUpBloc>().add(UpdateSignUpForm(bio: value)),

              validator: (value) {
                if (value != null && value.length > 255)
                  return 'النبذة يجب أن تكون أقل من 255 حرف';
                return null;
              },
            ),
          ],
        );
      },
    );
  }
}
