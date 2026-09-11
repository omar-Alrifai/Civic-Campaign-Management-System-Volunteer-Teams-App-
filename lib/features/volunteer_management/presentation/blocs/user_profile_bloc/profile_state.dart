part of 'profile_bloc.dart';

sealed class UserProfileState extends Equatable {
  const UserProfileState();
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends UserProfileState {}

class ProfileLoading extends UserProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends UserProfileState {
  final UserProfileEntity userProfile;
  const ProfileLoaded({required this.userProfile});
  @override
  List<Object?> get props => [userProfile];
}

class ProfileError extends UserProfileState {
  final String message;
  const ProfileError({required this.message});
  @override
  List<Object?> get props => [message];
}
