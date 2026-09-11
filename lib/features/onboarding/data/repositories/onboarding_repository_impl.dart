import 'package:dartz/dartz.dart';
import 'package:graduationregistration/core/error/exceptions.dart';
import 'package:graduationregistration/core/error/failures.dart';
import 'package:graduationregistration/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:graduationregistration/features/onboarding/domian/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource localDataSource;

  OnboardingRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, Unit>> setOnboardingCompleted() async {
    try {
      await localDataSource.setOnboardingCompleted();
      return const Right(unit);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    try {
      return await localDataSource.isOnboardingCompleted();
    } on CacheException {
      return false;
    }
  }
}
