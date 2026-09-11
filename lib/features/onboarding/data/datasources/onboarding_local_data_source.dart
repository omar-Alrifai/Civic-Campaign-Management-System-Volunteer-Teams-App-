import 'package:dartz/dartz.dart';
import 'package:graduationregistration/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class OnboardingLocalDataSource {
  Future<Either<Exception, Unit>> setOnboardingCompleted();
  Future<bool> isOnboardingCompleted();
}

const String CACHED_ONBOARDING_COMPLETED = 'ONBOARDING_COMPLETED';

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  final SharedPreferences sharedPreferences;

  OnboardingLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<Either<Exception, Unit>> setOnboardingCompleted() async {
    try {
      await sharedPreferences.setBool(CACHED_ONBOARDING_COMPLETED, true);
      return const Right(unit);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    return sharedPreferences.getBool(CACHED_ONBOARDING_COMPLETED) ?? false;
  }
}
