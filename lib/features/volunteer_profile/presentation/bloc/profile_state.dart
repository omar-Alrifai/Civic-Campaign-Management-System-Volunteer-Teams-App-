import 'package:equatable/equatable.dart';
import 'package:graduationregistration/features/volunteer_profile/domain/entity/volunteer_profile_entity.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class VolunteerProfileLoaded extends ProfileState {
  final VolunteerProfileEntity profile;
  const VolunteerProfileLoaded({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError({required this.message});

  @override
  List<Object?> get props => [message];
}
