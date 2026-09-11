part of 'verification_bloc.dart';

abstract class VerificationState extends Equatable {
  const VerificationState();

  @override
  List<Object?> get props => [];
}

final class VerificationInitial extends VerificationState {}

// حالات تأكيد الحساب (Email Verification)
class EmailVerificationLoading extends VerificationState {}

class EmailVerificationSuccess extends VerificationState {}

class EmailVerificationFailure extends VerificationState {
  final String error;
  const EmailVerificationFailure({required this.error});
  @override
  List<Object> get props => [error];
}

class EmailVerificationCodeSent extends VerificationState {
  final int? expiryTimeInSeconds;

  const EmailVerificationCodeSent({required this.expiryTimeInSeconds});

  @override
  List<Object> get props => [expiryTimeInSeconds!];
}

class EmailVerificationResendLoading extends VerificationState {}

class EmailVerificationResendSuccess extends VerificationState {}

class EmailVerificationResendFailure extends VerificationState {
  final String error;
  const EmailVerificationResendFailure({required this.error});
  @override
  List<Object> get props => [error];
}

class EmailVerificationCodeExpired extends VerificationState {}
