import 'package:graduationregistration/features/auth/domain/entities/user_login_entity.dart';
import 'package:graduationregistration/features/auth/domain/repositories/auth_repository.dart';

class GetCachedUserUseCase {
  final AuthRepository repository;

  GetCachedUserUseCase(this.repository);

  Future<UserLoginEntity?> call() async {
    return await repository.getCachedUser();
  }
}
