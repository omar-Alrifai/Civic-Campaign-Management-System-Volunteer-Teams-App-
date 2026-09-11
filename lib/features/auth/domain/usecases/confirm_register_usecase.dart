import 'package:dartz/dartz.dart';
import 'package:graduationregistration/core/error/failures.dart';
import 'package:graduationregistration/features/auth/domain/repositories/auth_repository.dart';

class ConfirmRegistrationUseCase {
  final AuthRepository repository;

  ConfirmRegistrationUseCase(this.repository);

  Future<Either<Failure, Unit>> call({
    required String email,
    required String code,
  }) async {
    return await repository.confirmRegistration(email: email, code: code);
  }
}
