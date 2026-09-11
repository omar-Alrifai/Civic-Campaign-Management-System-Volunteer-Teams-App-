import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduationregistration/core/error/failures.dart';
import 'package:graduationregistration/core/strings/error.dart';
import 'package:graduationregistration/features/auth/domain/usecases/confirm_register_usecase.dart';
import 'package:graduationregistration/features/auth/domain/usecases/resend_code_usecase.dart';

part 'verification_event.dart';
part 'verification_state.dart';

class VerificationBloc extends Bloc<VerificationEvent, VerificationState> {
  final ConfirmRegistrationUseCase confirmUseCase;
  final ResendCodeUseCase resendUseCase;
  final StreamController<int> _timerController =
      StreamController<int>.broadcast();
  Timer? _verificationTimer;
  int _remainingTime = 180;

  VerificationBloc({required this.confirmUseCase, required this.resendUseCase})
    : super(VerificationInitial()) {
    on<VerifyEmailEvent>(_onVerifyEmail);
    on<ResendVerificationCodeEvent>(_onResendCode);
    on<UpdateVerificationTimer>(_onUpdateTimer);
    on<SendVerificationCode>(_onSendVerificationCode);
  }

  Future<void> _onSendVerificationCode(
    SendVerificationCode event,
    Emitter<VerificationState> emit,
  ) async {
    final failureOrSuccess = await resendUseCase(email: event.email);
    failureOrSuccess.fold(
      (failure) => emit(
        EmailVerificationResendFailure(error: _mapFailureToMessage(failure)),
      ),
      (_) {
        startVerificationTimer(emit);
        emit(EmailVerificationCodeSent(expiryTimeInSeconds: _remainingTime));
      },
    );
  }

  Future<void> _onVerifyEmail(
    VerifyEmailEvent event,
    Emitter<VerificationState> emit,
  ) async {
    emit(EmailVerificationLoading());
    final failureOrSuccess = await confirmUseCase(
      email: event.email,
      code: event.verificationCode,
    );
    failureOrSuccess.fold(
      (failure) =>
          emit(EmailVerificationFailure(error: _mapFailureToMessage(failure))),
      (_) {
        _verificationTimer?.cancel();
        emit(EmailVerificationSuccess());
      },
    );
  }

  Future<void> _onResendCode(
    ResendVerificationCodeEvent event,
    Emitter<VerificationState> emit,
  ) async {
    emit(EmailVerificationResendLoading());
    final failureOrSuccess = await resendUseCase(email: event.email);
    failureOrSuccess.fold(
      (failure) => emit(
        EmailVerificationResendFailure(error: _mapFailureToMessage(failure)),
      ),
      (_) {
        startVerificationTimer(emit);
        emit(EmailVerificationResendSuccess());
      },
    );
  }

  void _onUpdateTimer(
    UpdateVerificationTimer event,
    Emitter<VerificationState> emit,
  ) {
    if (event.remainingTime > 0) {
      emit(EmailVerificationCodeSent(expiryTimeInSeconds: event.remainingTime));
    } else {
      emit(EmailVerificationCodeExpired());
    }
  }

  void startVerificationTimer(Emitter<VerificationState> emit) {
    _verificationTimer?.cancel();
    _remainingTime = 180;
    emit(EmailVerificationCodeSent(expiryTimeInSeconds: _remainingTime));
    _verificationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _remainingTime--;
      _timerController.add(_remainingTime);
      if (_remainingTime <= 0) _verificationTimer?.cancel();
    });
    _timerController.stream.listen((remainingTime) {
      _remainingTime = remainingTime;
      add(UpdateVerificationTimer(remainingTime));
    });
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
    _verificationTimer?.cancel();
    _timerController.close();
    return super.close();
  }
}
