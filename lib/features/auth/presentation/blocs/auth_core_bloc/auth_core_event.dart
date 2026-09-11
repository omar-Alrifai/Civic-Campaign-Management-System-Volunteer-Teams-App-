part of 'auth_core_bloc.dart';

abstract class AuthCoreEvent extends Equatable {
  const AuthCoreEvent();

  @override
  List<Object?> get props => [];
}

// أحداث تسجيل الدخول (Sign In)
class SignInEvent extends AuthCoreEvent {
  final String email;
  final String password;
  final String deviceToken;
  const SignInEvent({
    required this.email,
    required this.password,
    required this.deviceToken,
  });
  @override
  List<Object> get props => [email, password, deviceToken];
}

// حدث تبديل رؤية كلمة المرور
class TogglePasswordVisibility extends AuthCoreEvent {}

// حدث تسجيل الخروج (Sign Out)
class SignOutEvent extends AuthCoreEvent {}

class CheckAuthStatus extends AuthCoreEvent {
  const CheckAuthStatus();
}

// حدث لتحديث حالة المستخدم
class UpdateAuthStatus extends AuthCoreEvent {
  final bool isAuthenticated;
  final UserLoginModel? user;

  const UpdateAuthStatus(this.isAuthenticated, [this.user]);
  @override
  List<Object?> get props => [isAuthenticated, user];
}

// حدث لتحديث التوكن في حالة انتهت صلاحية التوكن
class UpdateToken extends AuthCoreEvent {
  final String token;

  const UpdateToken(this.token);
  @override
  List<Object?> get props => [token];
}
