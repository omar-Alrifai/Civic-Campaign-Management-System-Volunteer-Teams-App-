import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduationregistration/core/error/failures.dart';
import 'package:graduationregistration/core/strings/error.dart';
import 'package:graduationregistration/features/auth/data/models/user_login_model.dart';
import 'package:graduationregistration/features/auth/domain/entities/user_login_entity.dart';
import 'package:graduationregistration/features/auth/domain/usecases/check_auth_status_use_case.dart';
import 'package:graduationregistration/features/auth/domain/usecases/get_token_use_case.dart';
import 'package:graduationregistration/features/auth/domain/usecases/login_use_case.dart';
import 'package:graduationregistration/features/auth/domain/usecases/logout_use_case.dart';
part 'auth_core_event.dart';
part 'auth_core_state.dart';

class AuthCoreBloc extends Bloc<AuthCoreEvent, AuthCoreState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;
  final GetTokenUseCase getTokenUseCase;
  bool isPasswordVisible = false;
  AuthCoreBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.checkAuthStatusUseCase,
    required this.getTokenUseCase,
  }) : super(AuthCoreInitial()) {
    on<SignInEvent>(_onSignInEvent);
    on<SignOutEvent>(_onSignOutEvent);
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<UpdateAuthStatus>(_onUpdateAuthStatus);
    on<UpdateToken>(_onUpdateToken);
    on<TogglePasswordVisibility>(_onTogglePasswordVisibility);
  }

  Future<void> _onSignInEvent(
    SignInEvent event,
    Emitter<AuthCoreState> emit,
  ) async {
    emit(SignInLoading());
    final result = await loginUseCase(
      email: event.email,
      password: event.password,
      deviceToken: event.deviceToken,
    );
    result.fold(
      (failure) => emit(SignInFailure(error: _mapFailureToMessage(failure))),
      (user) {
        emit(SignInSuccess(userLoginModel: user));
        emit(Authenticated(user.toEntity()));
      },
    );
  }

  Future<void> _onSignOutEvent(
    SignOutEvent event,
    Emitter<AuthCoreState> emit,
  ) async {
    emit(SignOutLoading());
    final token = await getTokenUseCase();
    if (token == null) {
      emit(SignOutFailure(error: 'لا يوجد token'));
      return;
    }
    final result = await logoutUseCase(token);
    result.fold(
      (failure) => emit(SignOutFailure(error: _mapFailureToMessage(failure))),
      (_) {
        emit(SignOutSuccess());
        emit(Unauthenticated());
      },
    );
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthCoreState> emit,
  ) async {
    emit(AuthCheckLoading());
    final authStatus = await checkAuthStatusUseCase();
    if (authStatus.isLoggedIn && authStatus.user != null) {
      emit(Authenticated(authStatus.user!));
    } else {
      emit(Unauthenticated());
    }
  }

  void _onUpdateAuthStatus(
    UpdateAuthStatus event,
    Emitter<AuthCoreState> emit,
  ) {
    if (event.isAuthenticated && event.user != null) {
      emit(Authenticated(event.user!));
    } else {
      emit(Unauthenticated());
    }
  }

  void _onUpdateToken(UpdateToken event, Emitter<AuthCoreState> emit) {
    emit(TokenUpdated(event.token));
  }

  void _onTogglePasswordVisibility(
    TogglePasswordVisibility event,
    Emitter<AuthCoreState> emit,
  ) {
    isPasswordVisible = !isPasswordVisible;
    emit(PasswordVisibilityToggled(isPasswordVisible));
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
