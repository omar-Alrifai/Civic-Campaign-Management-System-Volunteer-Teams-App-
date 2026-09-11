import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduationregistration/features/auth/presentation/blocs/signup/sign_up_bloc.dart';
import 'package:graduationregistration/features/auth/presentation/pages/confirmation_page1.dart';
import 'package:graduationregistration/features/auth/presentation/widget/basic_info_step.dart';
import 'package:graduationregistration/features/auth/presentation/widget/location_info_step.dart';
import 'package:graduationregistration/features/auth/presentation/widget/personal_info_step.dart';
import 'package:graduationregistration/features/auth/presentation/widget/skills_info_step.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKeys = List.generate(4, (_) => GlobalKey<FormState>());
  String? userEmail;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          final formData = context.read<SignUpBloc>().formData;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ConfirmationPageContent(email: formData.email),
            ),
          );
        }
      },
      builder: (context, state) {
        final formData = (state is SignUpFormUpdated)
            ? state.formData
            : const SignUpFormData();
        final currentStep = formData.currentStep;
        return Scaffold(
          appBar: AppBar(title: const Text('إنشاء حساب')),
          body: Stack(
            children: [
              Stepper(
                currentStep: currentStep,
                onStepContinue: () {
                  if (_formKeys[currentStep].currentState?.validate() ?? true) {
                    FocusScope.of(context).unfocus();

                    if (currentStep < 3) {
                      context.read<SignUpBloc>().add(const NextStepTapped());
                    } else {
                      _showConfirmationDialog(context, formData);
                    }
                  }
                },
                onStepCancel: () {
                  if (currentStep > 0) {
                    context.read<SignUpBloc>().add(const PreviousStepTapped());
                  } else {
                    Navigator.pop(context);
                  }
                },
                steps: [
                  Step(
                    title: const Text('معلومات أساسية'),
                    content: Form(
                      key: _formKeys[0],
                      child: BasicInfoStep(formData: formData),
                    ),
                    isActive: currentStep >= 0,
                  ),
                  Step(
                    title: const Text('معلومات شخصية'),
                    content: Form(
                      key: _formKeys[1],
                      child: PersonalInfoStep(formData: formData),
                    ),
                    isActive: currentStep >= 1,
                  ),
                  Step(
                    title: const Text('معلومات الموقع'),
                    content: Form(
                      key: _formKeys[2],
                      child: LocationInfoStep(formData: formData),
                    ),
                    isActive: currentStep >= 2,
                  ),
                  Step(
                    title: const Text('المهارات والصورة'),
                    content: Form(
                      key: _formKeys[3],
                      child: SkillsInfoStep(formData: formData),
                    ),
                    isActive: currentStep >= 3,
                  ),
                ],
                controlsBuilder: (context, controls) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      children: [
                        if (currentStep > 0)
                          TextButton(
                            onPressed: controls.onStepCancel,
                            child: const Text('السابق'),
                          ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: controls.onStepContinue,
                          child: Text(currentStep < 3 ? 'التالي' : 'تأكيد'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              if (state is SignUpLoading)
                const ModalBarrier(color: Colors.black45, dismissible: false),
              if (state is SignUpLoading)
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        );
      },
    );
  }

  //  تابع لتأكيد معلومات التسجيل
  void _showConfirmationDialog(BuildContext context, SignUpFormData formData) {
    userEmail = formData.email;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(child: Text('تأكيد بيانات التسجيل')),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'الرجاء مراجعة البيانات قبل التأكيد:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // المعلومات الأساسية
              _buildSectionTitle('المعلومات الأساسية'),
              _buildDataRow('الاسم الكامل', formData.name),
              _buildDataRow('البريد الإلكتروني', formData.email),
              _buildDataRow('كلمة المرور', '••••••••'),
              _buildDataRow('رقم الهاتف', formData.phone),

              // المعلومات الشخصية
              if (formData.age != null ||
                  formData.gender != null ||
                  formData.bio != null)
                _buildSectionTitle('المعلومات الشخصية'),
              if (formData.age != null)
                _buildDataRow('العمر', formData.age.toString()),
              if (formData.gender != null)
                _buildDataRow(
                  'الجنس',
                  formData.gender == 'male' ? 'ذكر' : 'أنثى',
                ),
              if (formData.bio != null && formData.bio!.isNotEmpty)
                _buildDataRow('نبذة عنك', formData.bio!),

              // معلومات الموقع
              if (formData.area != null || formData.latitude != null)
                _buildSectionTitle('معلومات الموقع'),
              if (formData.area != null)
                _buildDataRow('المنطقة', formData.area!),
              if (formData.latitude != null && formData.longitude != null)
                _buildDataRow(
                  'الإحداثيات',
                  '${formData.latitude!.toStringAsFixed(4)}, ${formData.longitude!.toStringAsFixed(4)}',
                ),

              // المهارات والاهتمامات
              if (formData.skills.isNotEmpty ||
                  formData.volunteerFields.isNotEmpty)
                _buildSectionTitle('المهارات والاهتمامات'),
              if (formData.skills.isNotEmpty)
                _buildDataRow('المهارات', formData.skills.join(', ')),
              if (formData.volunteerFields.isNotEmpty)
                _buildDataRow(
                  'مجالات التطوع',
                  formData.volunteerFields.join(', '),
                ),

              // الصورة الشخصية
              if (formData.imagePath != null) ...[
                _buildSectionTitle('الصورة الشخصية'),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(formData.imagePath!),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('تراجع', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              Navigator.pop(context);
              context.read<SignUpBloc>().add(const SubmitSignUp());
            },
            child: const Text('تأكيد التسجيل'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 14, color: Colors.black),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
