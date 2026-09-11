import 'package:graduationregistration/features/auth/domain/repositories/auth_repository.dart';

class GetTokenUseCase {
  final AuthRepository repository;

  GetTokenUseCase(this.repository);

  Future<String?> call() async {
    return await repository.getToken();
  }
}
