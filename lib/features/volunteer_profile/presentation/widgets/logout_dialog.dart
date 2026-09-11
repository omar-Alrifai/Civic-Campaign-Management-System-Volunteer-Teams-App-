import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduationregistration/core/app_colors.dart';
import 'package:graduationregistration/core/widget/loading_widget.dart';
import 'package:graduationregistration/features/auth/presentation/blocs/auth_core_bloc/auth_core_bloc.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocConsumer<AuthCoreBloc, AuthCoreState>(
        listener: (context, authState) {
          if (authState is SignOutSuccess) {
            Navigator.pop(context);
          } else if (authState is SignOutFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(authState.error),
                backgroundColor: Colors.red,
              ),
            );
            Navigator.pop(context);
          }
        },
        builder: (context, authState) {
          if (authState is SignOutLoading) {
            return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LoadingWidget(
                      textColor: AppColors.OceanBlue,
                      shaderMaskColors: [
                        AppColors.OceanBlue,
                        AppColors.WhisperWhite,
                      ],
                      spinKitChasingDots: AppColors.CharcoalGrey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'جاري تسجيل الخروج...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.logout, color: Colors.red),
                SizedBox(width: 10),
                Text("تأكيد تسجيل الخروج"),
              ],
            ),
            content: const Text(
              "هل أنت متأكد أنك تريد تسجيل الخروج من التطبيق؟",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "إلغاء",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthCoreBloc>().add(SignOutEvent());
                },
                child: const Text(
                  "تسجيل الخروج",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Colors.white,
            elevation: 8,
          );
        },
      ),
    );
  }
}
