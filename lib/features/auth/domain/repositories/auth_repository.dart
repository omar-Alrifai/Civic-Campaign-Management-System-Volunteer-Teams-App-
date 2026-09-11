import 'package:dartz/dartz.dart';
import 'package:graduationregistration/core/error/failures.dart';
import 'package:graduationregistration/features/auth/data/models/user_login_model.dart';
import 'package:graduationregistration/features/auth/domain/entities/auth_status.dart';
import 'package:graduationregistration/features/auth/domain/entities/user_login_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, Unit>> registerUser({
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
  });

  Future<Either<Failure, Unit>> confirmRegistration({
    required String email,
    required String code,
  });

  Future<Either<Failure, Unit>> resendCode(String email);

  Future<Either<Failure, Unit>> requestPasswordReset(String email);

  Future<Either<Failure, Unit>> confirmPasswordReset({
    required String email,
    required String code,
    required String newPassword,
    required String confirmPassword,
  });

  Future<Either<Failure, UserLoginModel>> login({
    required String email,
    required String password,
    required String deviceToken,
  });

  Future<Either<Failure, Unit>> logout(String token);

  Future<AuthStatus> checkAuthStatus();
  Future<String?> getToken();
  Future<bool> isLoggedIn();
  Future<UserLoginEntity?> getCachedUser();
}
