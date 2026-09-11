import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduationregistration/features/auth/presentation/blocs/verification/verification_bloc.dart';
import 'package:graduationregistration/features/auth/presentation/widget/confirmation_form.dart';
import 'package:graduationregistration/features/auth/presentation/pages/sign_in_page.dart';
import 'package:graduationregistration/features/auth/presentation/widget/confirm_test.dart';

class ConfirmationPageContent extends StatelessWidget {
  final String email;
  const ConfirmationPageContent({Key? key, required this.email})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<VerificationBloc>().add(SendVerificationCode(email: email));
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(title: const Text("تأكيد التسجيل")),
        body: BlocListener<VerificationBloc, VerificationState>(
          listener: (context, state) {
            _handleVerificationStates(context, state);
          },
          child: BlocBuilder<VerificationBloc, VerificationState>(
            builder: (context, state) {
              final timerState = _getTimerState(state);
              final isCodeValid = timerState.remainingTime > 0;
              final isResendButtonEnabled = _isResendButtonEnabled(
                state,
                isCodeValid,
              );
              final isVerifying = state is EmailVerificationLoading;

              return _buildContent(
                context,
                timerState,
                isCodeValid,
                isResendButtonEnabled,
                isVerifying,
              );
            },
          ),
        ),
      ),
    );
  }

  void _handleVerificationStates(
    BuildContext context,
    VerificationState state,
  ) {
    if (state is EmailVerificationSuccess) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
      );
    }
    if (state is EmailVerificationFailure) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى التحقق من رمز التأكيد')),
      );
    }
    if (state is EmailVerificationResendSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إعادة إرسال رمز التأكيد')),
      );
    }
    if (state is EmailVerificationResendFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء المحاولة مرة اخرى لاحقا')),
      );
    }
  }

  _TimerState _getTimerState(VerificationState state) {
    final remainingTime = state is EmailVerificationCodeSent
        ? state.expiryTimeInSeconds ?? 180
        : (state is EmailVerificationCodeExpired ? 0 : 180);

    return _TimerState(
      remainingTime: remainingTime,
      displayTime:
          "${(remainingTime ~/ 60).toString().padLeft(2, '0')}:"
          "${(remainingTime % 60).toString().padLeft(2, '0')}",
      isExpired: remainingTime <= 0,
    );
  }

  bool _isResendButtonEnabled(VerificationState state, bool isCodeValid) {
    return state is! EmailVerificationResendLoading &&
        (state is EmailVerificationCodeExpired || !isCodeValid);
  }

  Widget _buildContent(
    BuildContext context,
    _TimerState timerState,
    bool isCodeValid,
    bool isResendButtonEnabled,
    bool isVerifying,
  ) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // const SizedBox(height: 16),
              const Text(
                "تأكيد التسجيل عبر الرمز",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text("لقد قمنا بإرسال كود التفعيل الخاص بك الى \n$email"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "سوف تنتهي صلاحية كود التفعيل بعد ",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    timerState.displayTime,
                    style: TextStyle(
                      color: isCodeValid ? Colors.blue : Colors.red,
                    ),
                  ),
                ],
              ),

              Center(
                child: Image.asset(
                  'assets/images/Enter OTP-bro.png',
                  height: 400,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              ),
              ConfirmationForm(
                onVerificationCodeEntered: (enteredCode) {
                  _handleCodeSubmission(context, enteredCode, isCodeValid);
                },
              ),
              const SizedBox(height: 20),
              if (!isVerifying)
                _buildResendButton(context, isResendButtonEnabled)
              else
                const CircularProgressIndicator(),
              if (timerState.isExpired)
                const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text(
                    "انتهت صلاحية كود التحقق. يرجى طلب رمز جديد.",
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleCodeSubmission(
    BuildContext context,
    String enteredCode,
    bool isCodeValid,
  ) {
    if (enteredCode.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('يرجى إدخال رمز التأكيد')));
      return;
    }

    if (!isCodeValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('انتهت صلاحية كود التفعيل، يرجى طلب رمز جديد'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    context.read<VerificationBloc>().add(
      VerifyEmailEvent(email: email, verificationCode: enteredCode),
    );
  }

  Widget _buildResendButton(BuildContext context, bool isEnabled) {
    return GestureDetector(
      onTap: isEnabled ? () => _resendVerificationCode(context) : null,
      child: TextButton(
        onPressed: null,
        child: Text(
          "إعادة ارسال كود التفعيل",
          style: TextStyle(
            decoration: TextDecoration.underline,
            color: isEnabled ? Colors.blue : Colors.grey,
          ),
        ),
      ),
    );
  }

  void _resendVerificationCode(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pop(context);
      context.read<VerificationBloc>().add(
        ResendVerificationCodeEvent(email: email),
      );
    });
  }
}

class _TimerState {
  final int remainingTime;
  final String displayTime;
  final bool isExpired;

  _TimerState({
    required this.remainingTime,
    required this.displayTime,
    required this.isExpired,
  });
}
