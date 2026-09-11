part of 'auth_core_bloc.dart';

abstract class AuthCoreState extends Equatable {
  const AuthCoreState();

  @override
  List<Object?> get props => [];
}

final class AuthCoreInitial extends AuthCoreState {}

class SignInLoading extends AuthCoreState {}

class SignInSuccess extends AuthCoreState {
  final UserLoginModel userLoginModel;

  const SignInSuccess({required this.userLoginModel});
  @override
  List<Object?> get props => [userLoginModel];
}

class SignInFailure extends AuthCoreState {
  final String error;
  const SignInFailure({required this.error});
  @override
  List<Object> get props => [error];
}

// حالة رؤية كلمة المرور
class PasswordVisibilityToggled extends AuthCoreState {
  final bool isVisible;

  const PasswordVisibilityToggled(this.isVisible);

  @override
  List<Object> get props => [isVisible];
}

// حالات تسجيل الخروج (Sign Out)
class SignOutLoading extends AuthCoreState {}

class SignOutSuccess extends AuthCoreState {}

class SignOutFailure extends AuthCoreState {
  final String error;
  const SignOutFailure({required this.error});
  @override
  List<Object> get props => [error];
}

class Authenticated extends AuthCoreState {
  final UserLoginEntity user;

  const Authenticated(this.user);
  @override
  List<Object?> get props => [user];
}

// حالة عندما لا يكون المستخدم مسجل الدخول
class Unauthenticated extends AuthCoreState {}

// حالة انتهاء صلاحية الجلسة وبالتالي يحتاج الى توكن جديد لان التوكن القديم قد انتهى
class SessionExpired extends AuthCoreState {}

class AuthCheckLoading extends AuthCoreState {}

// حالة تحديث التوكن
class TokenUpdated extends AuthCoreState {
  final String token;

  const TokenUpdated(this.token);
  @override
  List<Object> get props => [token];
}
