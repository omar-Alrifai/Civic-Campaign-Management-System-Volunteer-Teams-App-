import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduationregistration/core/app_colors.dart';
import 'package:graduationregistration/core/widget/loading_widget.dart';
import 'package:graduationregistration/features/auth/presentation/blocs/auth_core_bloc/auth_core_bloc.dart';
import 'package:graduationregistration/features/auth/presentation/pages/forgot_password_screen.dart';
import 'package:graduationregistration/features/auth/presentation/pages/register_page.dart';
import 'package:graduationregistration/features/auth/presentation/widget/animated_circle_background.dart';
import 'package:graduationregistration/features/auth/presentation/widget/confirm_test.dart';
import 'package:graduationregistration/features/notifications/presentation/firebase/api_notification_firebase.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/pages/volunteer_leader_home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final resetEmailController = TextEditingController();
  final firebaseApi = FirebaseApi();

  void _onLoginPressed() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      final String? fcmToken = await firebaseApi.getFCMToken();
      if (fcmToken == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Could not get notification token. Please check your connection and try again.',
              ),
            ),
          );
        }
        return;
      }
      if (mounted) {
        context.read<AuthCoreBloc>().add(
          SignInEvent(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
            deviceToken: fcmToken,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An unexpected error occurred: $e')),
        );
      }
    }
  }

  void _onResetPasswordPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    resetEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCoreBloc, AuthCoreState>(
        listener: (context, state) {
          if (state is SignInFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('يرجى التأكد من صحة الايميل وكلمة المرور'),
              ),
            );
          }
          if (state is Authenticated) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => state.user.isVolunteerAdmin
                    ? VolunteerLeaderHomePage()
                    : ConfirmTest(userEmail: "omar.ri2020@gmail.com"),
              ),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is SignInLoading || state is AuthCheckLoading;
          final isPasswordVisible = context.select<AuthCoreBloc, bool>(
            (bloc) => bloc.isPasswordVisible,
          );

          return Stack(
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
              // النص الترحيبي
              Positioned(
                top: 280,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    "لتبدأ معنا رحلة العطاء والبناء\n قم بتسجيل الدخول!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // بطاقة تسجيل الدخول
              Align(
                alignment: Alignment.bottomCenter,
                child:
                    Container(
                          margin: const EdgeInsets.all(10),
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
                              children: [
                                Text(
                                  'تسجيل الدخول',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // حقل البريد الإلكتروني
                                TextFormField(
                                  controller: emailController,
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
                                    if (value == null || value.trim().isEmpty) {
                                      return 'يرجى إدخال البريد الإلكتروني';
                                    }
                                    final emailRegex = RegExp(
                                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                    );
                                    if (!emailRegex.hasMatch(value.trim())) {
                                      return 'يرجى إدخال بريد إلكتروني صالح';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                // حقل كلمة المرور
                                TextFormField(
                                  controller: passwordController,
                                  obscureText: !isPasswordVisible,
                                  decoration: InputDecoration(
                                    labelText: 'كلمة المرور',
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
                                        isPasswordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        context.read<AuthCoreBloc>().add(
                                          TogglePasswordVisibility(),
                                        );
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
                                      return 'يرجى إدخال كلمة المرور';
                                    }
                                    if (value.length < 6) {
                                      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 24),

                                // زر تسجيل الدخول
                                if (isLoading)
                                  LoadingWidget(
                                    textColor: Colors.black87,
                                    shaderMaskColors: [
                                      AppColors.CedarOlive,
                                      AppColors.OceanBlue,
                                    ],
                                    spinKitChasingDots: AppColors.CharcoalGrey,
                                  )
                                else
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Colors.white,
                                          Color(0xFF0172B2),
                                        ],
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
                                        minimumSize: const Size(
                                          double.infinity,
                                          50,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                      ),
                                      onPressed: _onLoginPressed,
                                      child: const Text(
                                        'تسجيل الدخول',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 12),

                                // نسيت كلمة المرور
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: _onResetPasswordPressed,
                                    child: Text(
                                      'هل نسيت كلمة السر؟',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // رابط إنشاء حساب جديد
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => RegisterPage(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'إنشاء حساب جديد',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .animate()
                        .fade(duration: 800.ms)
                        .slideY(begin: 0.2, curve: Curves.easeOut),
              ),
            ],
          );
        },
      ),
    );
  }
}
