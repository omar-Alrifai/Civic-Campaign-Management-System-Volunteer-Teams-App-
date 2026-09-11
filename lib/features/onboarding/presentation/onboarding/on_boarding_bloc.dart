import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:graduationregistration/core/error/failures.dart';
import 'package:graduationregistration/core/strings/error.dart';
import 'package:graduationregistration/features/onboarding/data/model/onboarding_model.dart';
import 'package:graduationregistration/features/onboarding/domian/usecases/set_onboarding_completed_usecase.dart';
import 'package:graduationregistration/features/onboarding/presentation/onboarding/on_boarding_event.dart';
import 'package:graduationregistration/features/onboarding/presentation/onboarding/on_boarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final SetOnboardingCompletedUseCase setOnboardingCompletedUseCase;

  // **تحديد بيانات صفحات الـ Onboarding هنا**
  static const List<OnBoardingModel> onboardingPagesData = [
    OnBoardingModel(
      title: "مرحباً بك في تطبيق التطوع",
      image: 'assets/images/drawn-clothing-donation-concept.png',
      body:
          "اكتشف فرصًا لا حصر لها للمساهمة في مجتمعك وتحقيق التغيير الإيجابي.",
    ),
    OnBoardingModel(
      title: "إدارة حملاتك بسهولة",
      image: 'assets/images/volunteer1.png',
      body: "كقائد فريق، يمكنك إنشاء، إدارة، ومتابعة حملاتك التطوعية بسلاسة.",
    ),
    OnBoardingModel(
      title: "انضمام المتطوعين ودعم المجتمع",
      image: 'assets/images/تطوع3.png',
      body:
          "اجمع المتطوعين، وتلقى الدعم، وساهم في مبادرات المحافظة بكل فعالية.",
    ),
  ];

  int _currentPage = 0;

  OnboardingBloc({required this.setOnboardingCompletedUseCase})
    : super(const OnboardingInitial(currentPage: 0)) {
    on<NextPageEvent>(_onNextPage);
    on<PreviousPageEvent>(_onPreviousPage);
    on<SetPageEvent>(_onSetPage);
    on<CompleteOnboardingEvent>(_onCompleteOnboarding);
  }

  void _onNextPage(NextPageEvent event, Emitter<OnboardingState> emit) async {
    if (_currentPage < onboardingPagesData.length - 1) {
      _currentPage++;
      emit(OnboardingPageChanged(_currentPage));
    } else {
      await _onCompleteOnboarding(CompleteOnboardingEvent(), emit);
    }
  }

  void _onPreviousPage(PreviousPageEvent event, Emitter<OnboardingState> emit) {
    if (_currentPage > 0) {
      _currentPage--;
      emit(OnboardingPageChanged(_currentPage));
    }
  }

  void _onSetPage(SetPageEvent event, Emitter<OnboardingState> emit) {
    _currentPage = event.index;
    emit(OnboardingPageChanged(_currentPage));
  }

  Future<void> _onCompleteOnboarding(
    CompleteOnboardingEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    final result = await setOnboardingCompletedUseCase();
    result.fold(
      (failure) =>
          emit(OnboardingError(message: _mapFailureToMessage(failure))),
      (_) => emit(OnboardingCompletedState()),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case OfflineFailure:
        return NO_INTERNET_ERROR_MESSAGE;
      default:
        return "حدث خطأ غير متوقع.";
    }
  }
}
