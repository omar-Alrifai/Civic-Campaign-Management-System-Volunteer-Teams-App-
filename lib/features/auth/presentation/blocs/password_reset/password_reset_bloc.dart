import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduationregistration/core/error/failures.dart';
import 'package:graduationregistration/core/strings/error.dart';
import 'package:graduationregistration/features/auth/data/models/user_login_model.dart';
import 'package:graduationregistration/features/auth/domain/usecases/confirm_password_reset_usecase.dart';
import 'package:graduationregistration/features/auth/domain/usecases/request_password_reset_usecase.dart';

part 'password_reset_event.dart';
part 'password_reset_state.dart';

class PasswordResetBloc extends Bloc<PasswordResetEvent, PasswordResetState> {
  final RequestPasswordResetUseCase requestResetUseCase;
  final ConfirmPasswordResetUseCase confirmResetUseCase;
  bool _isPasswordVisible = false; // تتبع حالة رؤية كلمة المرور

  PasswordResetBloc({
    required this.requestResetUseCase,
    required this.confirmResetUseCase,
  }) : super(PasswordResetInitial()) {
    on<ForgotPasswordEvent>(_onForgotPassword);
    on<ResetPasswordEvent>(_onResetPassword);
    on<TogglePasswordVisibility>(_onTogglePasswordVisibility);
  }

  void _onTogglePasswordVisibility(
    TogglePasswordVisibility event,
    Emitter<PasswordResetState> emit,
  ) {
    _isPasswordVisible = !_isPasswordVisible;
    emit(PasswordVisibilityToggled(_isPasswordVisible));
  }

  Future<void> _onForgotPassword(
    ForgotPasswordEvent event,
    Emitter<PasswordResetState> emit,
  ) async {
    emit(ForgotPasswordLoading());
    final failureOrSuccess = await requestResetUseCase(email: event.email);
    failureOrSuccess.fold(
      (failure) =>
          emit(ForgotPasswordFailure(error: _mapFailureToMessage(failure))),
      (_) => emit(ForgotPasswordEmailSent()),
    );
  }

  Future<void> _onResetPassword(
    ResetPasswordEvent event,
    Emitter<PasswordResetState> emit,
  ) async {
    emit(ResetPasswordLoading());
    try {
      final failureOrSuccess = await confirmResetUseCase(
        email: event.email,
        code: event.verificationCode,
        newPassword: event.newPassword,
        confirmPassword: event.confirmNewPassword,
      );
      failureOrSuccess.fold(
        (failure) =>
            emit(ResetPasswordFailure(error: _mapFailureToMessage(failure))),
        (_) => emit(ResetPasswordSuccess()),
      );
    } catch (e) {
      emit(
        ResetPasswordFailure(
          error:
              'حدث خطأ أثناء تأكيد إعادة تعيين كلمة المرور.الرجاء التأكد من رمز اعادة التعيين',
        ),
      );
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case OfflineFailure:
        return NO_INTERNET_ERROR_MESSAGE;
      case InvalidResetCodeFailure:
        return INVALID_RESET_CODE_MESSAGE;
      default:
        return 'حدث خطأ غير متوقع';
    }
  }
}
