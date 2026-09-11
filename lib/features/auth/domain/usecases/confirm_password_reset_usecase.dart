import 'package:dartz/dartz.dart';
import 'package:graduationregistration/core/error/failures.dart';
import 'package:graduationregistration/features/auth/domain/repositories/auth_repository.dart';

class ConfirmPasswordResetUseCase {
  final AuthRepository authRepository;

  ConfirmPasswordResetUseCase(this.authRepository);

  Future<Either<Failure, Unit>> call({
    required String email,
    required String code,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return await authRepository.confirmPasswordReset(
      email: email,
      code: code,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
  }
}
