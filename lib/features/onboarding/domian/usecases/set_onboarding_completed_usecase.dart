import 'package:dartz/dartz.dart';
import 'package:graduationregistration/core/error/failures.dart';
import 'package:graduationregistration/features/onboarding/domian/repositories/onboarding_repository.dart';

class SetOnboardingCompletedUseCase {
  final OnboardingRepository repository;

  SetOnboardingCompletedUseCase({required this.repository});

  Future<Either<Failure, Unit>> call() async {
    return await repository.setOnboardingCompleted();
  }
}
