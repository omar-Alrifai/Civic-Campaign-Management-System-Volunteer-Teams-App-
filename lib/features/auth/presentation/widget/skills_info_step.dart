import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduationregistration/features/auth/presentation/blocs/signup/sign_up_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

class SkillsInfoStep extends StatelessWidget {
  final SignUpFormData formData;

  const SkillsInfoStep({Key? key, required this.formData}) : super(key: key);

  static const List<String> availableSkills = [
    'تمريض',
    'طبخ',
    'جمع تبرعات',
    'تصوير',
    'مهنية',
  ];

  static const List<String> availableVolunteerFields = [
    'ترميم بيوت',
    'توزيع مساعدات',
    'تنظيم فعالية',
    'إغاثة الكوارث',
    'مساعدات الطريق',
    'تنظيف البيئة',
  ];

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      context.read<SignUpBloc>().add(
        UpdateSignUpForm(imagePath: pickedFile.path),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                final result = await showDialog<List<String>>(
                  context: context,
                  builder: (_) {
                    return MultiSelectDialog<String>(
                      items: availableSkills
                          .map((e) => MultiSelectItem(e, e))
                          .toList(),
                      initialValue: formData.skills,

                      title: const Text('اختر المهارات'),
                      confirmText: const Text('موافق'),
                      cancelText: const Text('إلغاء'),
                    );
                  },
                );
                if (result != null) {
                  context.read<SignUpBloc>().add(
                    UpdateSignUpForm(skills: result),
                  );
                }
              },
              child: const Text('اختر المهارات'),
            ),
            ElevatedButton(
              onPressed: () async {
                final result = await showDialog<List<String>>(
                  context: context,
                  builder: (_) {
                    return MultiSelectDialog<String>(
                      items: availableVolunteerFields
                          .map((e) => MultiSelectItem(e, e))
                          .toList(),
                      initialValue: formData.volunteerFields,

                      title: const Text('اختر مجالات التطوع'),
                      confirmText: const Text('موافق'),
                      cancelText: const Text('إلغاء'),
                    );
                  },
                );
                if (result != null) {
                  context.read<SignUpBloc>().add(
                    UpdateSignUpForm(volunteerFields: result),
                  );
                }
              },
              child: const Text('اختر مجالات التطوع'),
            ),
            ElevatedButton(
              onPressed: () => _pickImage(context),
              child: const Text('اختر صورة شخصية'),
            ),
            const SizedBox(height: 10),
            if (formData.imagePath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(formData.imagePath!),
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        );
      },
    );
  }
}
