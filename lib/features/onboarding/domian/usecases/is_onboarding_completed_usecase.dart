import 'package:graduationregistration/features/onboarding/domian/repositories/onboarding_repository.dart';

class IsOnboardingCompletedUseCase {
  final OnboardingRepository repository;

  IsOnboardingCompletedUseCase({required this.repository});

  Future<bool> call() async {
    return await repository.isOnboardingCompleted();
  }
}
