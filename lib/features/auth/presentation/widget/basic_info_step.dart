import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduationregistration/features/auth/presentation/blocs/signup/sign_up_bloc.dart';

class BasicInfoStep extends StatelessWidget {
  final SignUpFormData formData;
  const BasicInfoStep({Key? key, required this.formData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          initialValue: formData.name,

          decoration: const InputDecoration(labelText: 'الاسم'),
          onChanged: (value) =>
              context.read<SignUpBloc>().add(UpdateSignUpForm(name: value)),
          validator: (value) =>
              (value == null || value.isEmpty) ? 'الاسم مطلوب' : null,
        ),
        TextFormField(
          initialValue: formData.email,

          decoration: const InputDecoration(labelText: 'البريد الإلكتروني'),
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) =>
              context.read<SignUpBloc>().add(UpdateSignUpForm(email: value)),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'البريد الإلكتروني مطلوب';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'أدخل بريد إلكتروني صحيح';
            }
            return null;
          },
        ),
        TextFormField(
          initialValue: formData.password,

          decoration: const InputDecoration(labelText: 'كلمة المرور'),
          obscureText: true,
          onChanged: (value) =>
              context.read<SignUpBloc>().add(UpdateSignUpForm(password: value)),
          validator: (value) => (value == null || value.length < 6)
              ? 'كلمة المرور يجب أن تكون 6 أحرف على الأقل'
              : null,
        ),
        TextFormField(
          initialValue: formData.phone,

          decoration: const InputDecoration(labelText: 'رقم الهاتف'),
          keyboardType: TextInputType.phone,

          onChanged: (value) =>
              context.read<SignUpBloc>().add(UpdateSignUpForm(phone: value)),
          validator: (value) =>
              (value == null || value.isEmpty) ? 'رقم الهاتف مطلوب' : null,
        ),
      ],
    );
  }
}
