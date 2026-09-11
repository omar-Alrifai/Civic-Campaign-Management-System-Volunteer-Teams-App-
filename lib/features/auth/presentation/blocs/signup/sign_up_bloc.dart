import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduationregistration/core/error/failures.dart';
import 'package:graduationregistration/core/strings/error.dart';
import 'package:graduationregistration/features/auth/domain/usecases/register_user_usecase.dart';
import 'package:graduationregistration/features/auth/presentation/blocs/verification/verification_bloc.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final RegisterUserUseCase registerUserUseCase;
  final VerificationBloc verificationBloc;

  SignUpFormData formData = const SignUpFormData();

  SignUpBloc({
    required this.registerUserUseCase,
    required this.verificationBloc,
  }) : super(SignUpInitial()) {
    on<UpdateSignUpForm>(_onUpdateForm);
    on<SubmitSignUp>(_onSubmitSignUp);
    on<NextStepTapped>(_onNextStep);
    on<PreviousStepTapped>(_onPreviousStep);
  }

  void _onUpdateForm(UpdateSignUpForm event, Emitter<SignUpState> emit) {
    formData = formData.copyWith(
      name: event.name ?? formData.name,
      email: event.email ?? formData.email,
      password: event.password ?? formData.password,
      phone: event.phone ?? formData.phone,
      age: event.age ?? formData.age,
      gender: event.gender ?? formData.gender,
      bio: event.bio ?? formData.bio,
      area: event.area ?? formData.area,
      latitude: event.latitude ?? formData.latitude,
      longitude: event.longitude ?? formData.longitude,
      skills: event.skills ?? formData.skills,
      volunteerFields: event.volunteerFields ?? formData.volunteerFields,
      imagePath: event.imagePath ?? formData.imagePath,
    );
    emit(SignUpFormUpdated(formData));
  }

  Future<void> _onSubmitSignUp(
    SubmitSignUp event,
    Emitter<SignUpState> emit,
  ) async {
    emit(SignUpLoading());
    final failureOrSuccess = await registerUserUseCase(
      name: formData.name,
      email: formData.email,
      password: formData.password,
      phone: formData.phone,
      age: formData.age ?? 0,
      gender: formData.gender ?? '',
      bio: formData.bio,
      area: formData.area,
      latitude: formData.latitude,
      longitude: formData.longitude,
      skills: formData.skills,
      volunteerFields: formData.volunteerFields,
      imagePath: formData.imagePath,
    );
    failureOrSuccess.fold(
      (failure) => emit(SignUpFailure(error: _mapFailureToMessage(failure))),
      (_) {
        emit(SignUpSuccess());
      },
    );
  }

  void _onNextStep(NextStepTapped event, Emitter<SignUpState> emit) {
    final nextStep = formData.currentStep < 3 ? formData.currentStep + 1 : 3;
    formData = formData.copyWith(currentStep: nextStep);
    emit(SignUpStepChanged(currentStep: nextStep));
    emit(SignUpFormUpdated(formData));
  }

  void _onPreviousStep(PreviousStepTapped event, Emitter<SignUpState> emit) {
    final prevStep = formData.currentStep > 0 ? formData.currentStep - 1 : 0;
    formData = formData.copyWith(currentStep: prevStep);
    emit(SignUpStepChanged(currentStep: prevStep));
    emit(SignUpFormUpdated(formData));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case OfflineFailure:
        return NO_INTERNET_ERROR_MESSAGE;
      default:
        return 'حدث خطأ غير متوقع';
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
