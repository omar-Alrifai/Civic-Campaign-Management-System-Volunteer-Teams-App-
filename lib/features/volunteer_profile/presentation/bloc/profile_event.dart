import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadVolunteerProfileEvent extends ProfileEvent {
  const LoadVolunteerProfileEvent();
}

class RefreshVolunteerProfileEvent extends ProfileEvent {
  const RefreshVolunteerProfileEvent();
}
