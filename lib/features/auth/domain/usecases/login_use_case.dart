import 'package:dartz/dartz.dart';
import 'package:graduationregistration/core/error/failures.dart';
import 'package:graduationregistration/features/auth/data/models/user_login_model.dart';
import 'package:graduationregistration/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, UserLoginModel>> call({
    required String email,
    required String password,
    required String deviceToken,
  }) async {
    return await repository.login(
      email: email,
      password: password,
      deviceToken: deviceToken,
    );
  }
}
