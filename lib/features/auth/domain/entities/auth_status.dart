import 'package:equatable/equatable.dart';
import 'package:graduationregistration/features/auth/domain/entities/user_login_entity.dart';

class AuthStatus extends Equatable {
  final bool isLoggedIn;
  final UserLoginEntity? user;

  AuthStatus(this.isLoggedIn, this.user);

  @override
  List<Object?> get props => [isLoggedIn, user];
}
