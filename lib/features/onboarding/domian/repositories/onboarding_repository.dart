import 'package:dartz/dartz.dart';
import 'package:graduationregistration/core/error/failures.dart';

abstract class OnboardingRepository {
  Future<Either<Failure, Unit>> setOnboardingCompleted();
  Future<bool> isOnboardingCompleted(); // للتحقق من الحالة
}
