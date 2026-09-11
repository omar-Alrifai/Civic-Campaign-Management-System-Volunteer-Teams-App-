import 'package:dartz/dartz.dart';
import 'package:graduationregistration/core/error/failures.dart';
import 'package:graduationregistration/features/auth/domain/repositories/auth_repository.dart';

class RequestPasswordResetUseCase {
  final AuthRepository authRepository;

  RequestPasswordResetUseCase(this.authRepository);

  Future<Either<Failure, Unit>> call({required String email}) async {
    return await authRepository.requestPasswordReset(email);
  }
}
