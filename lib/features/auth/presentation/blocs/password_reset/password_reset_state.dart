part of 'password_reset_bloc.dart';

abstract class PasswordResetState extends Equatable {
  const PasswordResetState();

  @override
  List<Object?> get props => [];
}

final class PasswordResetInitial extends PasswordResetState {}

class CurrentUserLoaded extends PasswordResetState {
  final UserLoginModel user;

  const CurrentUserLoaded(this.user);
  @override
  List<Object?> get props => [user];
}

// حالات نسيان كلمة المرور (Forgot Password)
class ForgotPasswordLoading extends PasswordResetState {}

class ForgotPasswordEmailSent extends PasswordResetState {}

class ForgotPasswordFailure extends PasswordResetState {
  final String error;
  const ForgotPasswordFailure({required this.error});
  @override
  List<Object> get props => [error];
}

// حالات إعادة تعيين كلمة المرور (Reset Password)
class ResetPasswordLoading extends PasswordResetState {}

class ResetPasswordSuccess extends PasswordResetState {}

class ResetPasswordFailure extends PasswordResetState {
  final String error;

  const ResetPasswordFailure({required this.error});
  @override
  List<Object> get props => [error];
}

// حالة رؤية كلمة المرور
class PasswordVisibilityToggled extends PasswordResetState {
  final bool isVisible;

  const PasswordVisibilityToggled(this.isVisible);

  @override
  List<Object> get props => [isVisible];
}
