import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduationregistration/features/auth/presentation/blocs/auth_core_bloc/auth_core_bloc.dart';
import 'package:graduationregistration/features/auth/presentation/pages/sign_in_page.dart';

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الصفحة الرئيسية"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: BlocListener<AuthCoreBloc, AuthCoreState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => LoginPage()),
              (route) => false,
            );
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "مرحباً بك في التطبيق",
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  _showLogoutConfirmationDialog(context);
                },
                child: const Text("تسجيل الخروج"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("تأكيد تسجيل الخروج"),
            content: const Text("هل أنت متأكد أنك تريد تسجيل الخروج؟"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("إلغاء"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<AuthCoreBloc>().add(SignOutEvent());
                },
                child: const Text(
                  "تسجيل الخروج",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}
