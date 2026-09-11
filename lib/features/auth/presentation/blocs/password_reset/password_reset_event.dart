part of 'password_reset_bloc.dart';

abstract class PasswordResetEvent extends Equatable {
  const PasswordResetEvent();

  @override
  List<Object?> get props => [];
}

class GetCurrentUserEvent extends PasswordResetEvent {
  const GetCurrentUserEvent();
}

// أحداث نسيان كلمة المرور (Forgot Password)
class ForgotPasswordEvent extends PasswordResetEvent {
  final String email;
  const ForgotPasswordEvent({required this.email});
  @override
  List<Object> get props => [email];
}

// أحداث إعادة تعيين كلمة المرور (Reset Password)
class ResetPasswordEvent extends PasswordResetEvent {
  final String email;
  final String verificationCode;
  final String newPassword;
  final String confirmNewPassword;
  const ResetPasswordEvent({
    required this.email,
    required this.verificationCode,
    required this.newPassword,
    required this.confirmNewPassword,
  });
  @override
  List<Object> get props => [
    email,
    verificationCode,
    newPassword,
    confirmNewPassword,
  ];
}

// حدث تبديل رؤية كلمة المرور
class TogglePasswordVisibility extends PasswordResetEvent {
  const TogglePasswordVisibility();
}
