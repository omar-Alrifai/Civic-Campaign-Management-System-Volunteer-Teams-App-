part of 'verification_bloc.dart';

abstract class VerificationEvent extends Equatable {
  const VerificationEvent();

  @override
  List<Object?> get props => [];
}

// أحداث تأكيد الحساب (Email Verification)
class VerifyEmailEvent extends VerificationEvent {
  final String email;
  final String verificationCode;
  const VerifyEmailEvent({required this.email, required this.verificationCode});
  @override
  List<Object> get props => [verificationCode, email];
}

class ResendVerificationCodeEvent extends VerificationEvent {
  final String email;

  const ResendVerificationCodeEvent({required this.email});
  @override
  List<Object> get props => [email];
}

// حدث لتحديث العداد
class UpdateVerificationTimer extends VerificationEvent {
  final int remainingTime;

  const UpdateVerificationTimer(this.remainingTime);
  @override
  List<Object> get props => [remainingTime];
}

class SendVerificationCode extends VerificationEvent {
  final String email;
  const SendVerificationCode({required this.email});
  @override
  List<Object> get props => [email];
}
