
import 'package:dartz/dartz.dart';
import 'package:graduationregistration/core/error/failures.dart';
import 'package:graduationregistration/features/auth/domain/repositories/auth_repository.dart';

class RegisterUserUseCase {
  final AuthRepository repository;

  RegisterUserUseCase(this.repository);

  Future<Either<Failure, Unit>> call({
    required String name,
    required String email,
    required String password,
    required String phone,
    required int age,
    required String gender,
    String? bio,
    double? latitude,
    double? longitude,
    String? area,
    List<String>? skills,
    List<String>? volunteerFields,
    String? imagePath,
  }) async {
    return await repository.registerUser(
      name: name,
      email: email,
      password: password,
      phone: phone,
      age: age,
      gender: gender,
      bio: bio,
      latitude: latitude,
      longitude: longitude,
      area: area,
      skills: skills,
      volunteerFields: volunteerFields,
      imagePath: imagePath,
    );
  }
}
