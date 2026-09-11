import 'package:graduationregistration/features/auth/domain/entities/auth_status.dart';
import 'package:graduationregistration/features/auth/domain/repositories/auth_repository.dart';

class CheckAuthStatusUseCase {
  final AuthRepository repository;

  CheckAuthStatusUseCase(this.repository);

  Future<AuthStatus> call() async {
    return await repository.checkAuthStatus();
  }
}
