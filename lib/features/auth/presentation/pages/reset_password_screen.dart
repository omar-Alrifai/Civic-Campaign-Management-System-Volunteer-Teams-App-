import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduationregistration/features/auth/presentation/blocs/password_reset/password_reset_bloc.dart';
import 'package:graduationregistration/features/auth/presentation/pages/sign_in_page.dart';
import 'package:graduationregistration/features/auth/presentation/widget/animated_circle_background.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({required this.email, Key? key}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PasswordResetBloc, PasswordResetState>(
      listener: (context, state) {
        if (state is ResetPasswordFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        } else if (state is ResetPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم تغيير كلمة المرور بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            fit: StackFit.expand,
            children: [
              // Gradient Background
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Color(0xFF0172B2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),

              // الخلفية المتحركة
              const WaveBackground(),

              // المحتوى الرئيسي
              Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 15,
                          spreadRadius: 5,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // الصورة
                          Image.asset(
                            'assets/images/Two_factor_authentication-bro-removebg-preview.png',
                            height: 200,
                            fit: BoxFit.contain,
                          ),

                          // العنوان
                          Text(
                            'تعيين كلمة مرور جديدة',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'أدخل رمز التحقق وكلمة المرور الجديدة',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),

                          // حقل رمز التحقق
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: PinCodeTextField(
                              appContext: context,
                              length: 6,
                              controller: _codeController,
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(12),
                                fieldHeight: 50,
                                fieldWidth: 45,
                                activeFillColor: Colors.grey[50],
                                activeColor: Colors.blue,
                                selectedColor: Colors.blue,
                                inactiveColor: Colors.grey[300],
                              ),
                              keyboardType: TextInputType.number,
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              animationType: AnimationType.fade,
                              onCompleted: (v) {},
                            ),
                          ),
                          const SizedBox(height: 20),

                          // حقل كلمة المرور الجديدة
                          TextFormField(
                            controller: _newPasswordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'كلمة المرور الجديدة',
                              labelStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Colors.black,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يجب إدخال كلمة المرور';
                              } else if (value.length < 6) {
                                return 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // حقل تأكيد كلمة المرور
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'تأكيد كلمة المرور الجديدة',
                              labelStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Colors.black,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يجب تأكيد كلمة المرور';
                              } else if (value != _newPasswordController.text) {
                                return 'كلمتا المرور غير متطابقتين';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),

                          // زر تغيير كلمة المرور
                          if (state is ResetPasswordLoading)
                            const Center(child: CircularProgressIndicator())
                          else
                            Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.white, Color(0xFF0172B2)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<PasswordResetBloc>().add(
                                      ResetPasswordEvent(
                                        email: widget.email,
                                        verificationCode: _codeController.text,
                                        newPassword:
                                            _newPasswordController.text,
                                        confirmNewPassword:
                                            _confirmPasswordController.text,
                                      ),
                                    );
                                  }
                                },
                                child: const Text(
                                  'تغيير كلمة المرور',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                          const SizedBox(height: 16),

                          // زر الإعادة الإرسال
                          TextButton(
                            onPressed: () {
                              // إعادة إرسال الرمز
                              context.read<PasswordResetBloc>().add(
                                ForgotPasswordEvent(email: widget.email),
                              );
                            },
                            child: Text(
                              'إعادة إرسال الرمز',
                              style: TextStyle(
                                color: Colors.blue[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
