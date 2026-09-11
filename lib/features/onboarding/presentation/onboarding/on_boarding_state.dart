import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

class OnboardingInitial extends OnboardingState {
  final int currentPage;
  const OnboardingInitial({this.currentPage = 0});

  @override
  List<Object?> get props => [currentPage];
}

class OnboardingPageChanged extends OnboardingState {
  final int page;
  const OnboardingPageChanged(this.page);

  @override
  List<Object?> get props => [page];
}

class OnboardingLoading extends OnboardingState {}

class OnboardingCompletedState extends OnboardingState {}

class OnboardingError extends OnboardingState {
  final String message;
  const OnboardingError({required this.message});

  @override
  List<Object?> get props => [message];
}
