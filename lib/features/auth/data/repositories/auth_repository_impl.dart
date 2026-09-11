import 'package:dartz/dartz.dart';
import 'package:graduationregistration/core/error/exceptions.dart';
import 'package:graduationregistration/core/error/failures.dart';
import 'package:graduationregistration/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:graduationregistration/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:graduationregistration/features/auth/data/models/user_login_model.dart';
import 'package:graduationregistration/features/auth/data/models/user_model.dart';
import 'package:graduationregistration/features/auth/domain/entities/auth_status.dart';
import 'package:graduationregistration/features/auth/domain/entities/user_login_entity.dart';
import 'package:graduationregistration/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
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
  }) async {
    try {
      final userModel = await remoteDataSource.registerUser(
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

      // await localDataSource.cacheUser(userModel);

      return Future.value(Right(unit));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> confirmRegistration({
    required String email,
    required String code,
  }) async {
    try {
      await remoteDataSource.confirmRegistration(email: email, code: code);
      return Future.value(Right(unit));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> resendCode(String email) async {
    try {
      await remoteDataSource.resendCode(email);
      return Future.value(Right(unit));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> requestPasswordReset(String email) async {
    try {
      await remoteDataSource.requestPasswordReset(email);
      return Future.value(Right(unit));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> confirmPasswordReset({
    required String email,
    required String code,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      await remoteDataSource.confirmPasswordReset(
        email: email,
        code: code,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      return Future.value(Right(unit));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, UserLoginModel>> login({
    required String email,
    required String password,
    required String deviceToken,
  }) async {
    try {
      final userModel = await remoteDataSource.login(
        email: email,
        password: password,
        deviceToken: deviceToken,
      );
      await localDataSource.cacheUser(userModel); // حفظ بيانات المستخدم محلياً
      await localDataSource.setLoggedIn(true); // حفظ حالة تسجيل الدخول
      return Right(userModel);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> logout(String token) async {
    try {
      await remoteDataSource.logout(token);
      await localDataSource.clearCache();
      await localDataSource.setLoggedIn(false); // تحديث حالة تسجيل الدخول
      return Right(unit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<AuthStatus> checkAuthStatus() async {
    final isLoggedIn = await localDataSource.isLoggedIn();
    final userModel = await localDataSource.getCachedUser();
    return AuthStatus(isLoggedIn, userModel?.toEntity());
  }

  @override
  Future<String?> getToken() async {
    return await localDataSource.getToken();
  }

  @override
  Future<bool> isLoggedIn() async {
    return await localDataSource.isLoggedIn();
  }

  @override
  Future<UserLoginEntity?> getCachedUser() async {
    final model = await localDataSource.getCachedUser();
    return model?.toEntity();
  }
}
