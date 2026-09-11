import 'package:dartz/dartz.dart';
import 'package:graduationregistration/core/error/failures.dart';
import 'package:graduationregistration/features/auth/domain/repositories/auth_repository.dart';

class ResendCodeUseCase {
  final AuthRepository authRepository;

  ResendCodeUseCase(this.authRepository);

  Future<Either<Failure, Unit>> call({required String email}) async {
    return await authRepository.resendCode(email);
  }
}
