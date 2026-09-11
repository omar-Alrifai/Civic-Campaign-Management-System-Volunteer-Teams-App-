import 'package:equatable/equatable.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

class NextPageEvent extends OnboardingEvent {
  const NextPageEvent();
}

class PreviousPageEvent extends OnboardingEvent {
  const PreviousPageEvent();
}

class SetPageEvent extends OnboardingEvent {
  final int index;
  const SetPageEvent(this.index);

  @override
  List<Object?> get props => [index];
}

// حدث عند تخطي أو إنهاء الـ onboarding
class CompleteOnboardingEvent extends OnboardingEvent {
  const CompleteOnboardingEvent();
}
