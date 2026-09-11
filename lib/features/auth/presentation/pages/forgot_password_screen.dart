import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduationregistration/features/auth/presentation/blocs/password_reset/password_reset_bloc.dart';
import 'package:graduationregistration/features/auth/presentation/pages/reset_password_screen.dart';
import 'package:graduationregistration/features/auth/presentation/widget/animated_circle_background.dart';
import 'package:graduationregistration/features/auth/presentation/widget/round_text_form_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PasswordResetBloc, PasswordResetState>(
      listener: (context, state) {
        if (state is ForgotPasswordFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        } else if (state is ForgotPasswordEmailSent) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ResetPasswordScreen(email: _emailController.text),
            ),
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
                          // العنوان
                          Text(
                            'إعادة تعيين كلمة المرور',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'أدخل بريدك الإلكتروني لإرسال رمز التحقق',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),

                          // حقل البريد الإلكتروني
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'البريد الإلكتروني',
                              labelStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                              prefixIcon: const Icon(
                                Icons.email,
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
                                return 'يجب إدخال البريد الإلكتروني';
                              } else if (!RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              ).hasMatch(value)) {
                                return 'أدخل بريد إلكتروني صحيح';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),

                          // زر الإرسال
                          if (state is ForgotPasswordLoading)
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
                                      ForgotPasswordEvent(
                                        email: _emailController.text,
                                      ),
                                    );
                                  }
                                },
                                child: const Text(
                                  'إرسال الرمز',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                          const SizedBox(height: 16),

                          // زر العودة لتسجيل الدخول
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'العودة لتسجيل الدخول',
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
