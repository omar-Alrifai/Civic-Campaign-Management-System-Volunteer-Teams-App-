part of 'profile_bloc.dart';

sealed class UserProfileEvent extends Equatable {
  const UserProfileEvent();
  @override
  List<Object?> get props => [];
}

class GetUserProfileByUserIdEvent extends UserProfileEvent {
  final int userId;
  const GetUserProfileByUserIdEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}
