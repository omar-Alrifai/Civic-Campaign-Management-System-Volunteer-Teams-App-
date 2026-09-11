import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:graduationregistration/core/error/failures.dart';
import 'package:graduationregistration/core/strings/error.dart';
import 'package:graduationregistration/features/volunteer_profile/domain/entity/volunteer_profile_entity.dart';
import 'package:graduationregistration/features/volunteer_profile/domain/usecases/get_volunteer_profile_usecase.dart';
import 'package:graduationregistration/features/volunteer_profile/domain/usecases/refresh_volunteer_profile_usecase.dart';
import 'package:graduationregistration/features/volunteer_profile/presentation/bloc/profile_event.dart';
import 'package:graduationregistration/features/volunteer_profile/presentation/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetVolunteerProfileUseCase getVolunteerProfileUseCase;
  final RefreshVolunteerProfileUseCase refreshVolunteerProfileUseCase;

  ProfileBloc({
    required this.getVolunteerProfileUseCase,
    required this.refreshVolunteerProfileUseCase,
  }) : super(ProfileInitial()) {
    on<LoadVolunteerProfileEvent>(_onLoadVolunteerProfile);
    on<RefreshVolunteerProfileEvent>(_onRefreshVolunteerProfile);
  }

  Future<void> _onLoadVolunteerProfile(
    LoadVolunteerProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final failureOrProfile = await getVolunteerProfileUseCase();

    failureOrProfile.fold(
      (failure) => emit(ProfileError(message: _mapFailureToMessage(failure))),
      (profile) => emit(VolunteerProfileLoaded(profile: profile)),
    );
  }

  Future<void> _onRefreshVolunteerProfile(
    RefreshVolunteerProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final failureOrProfile = await refreshVolunteerProfileUseCase();

    failureOrProfile.fold(
      (failure) => emit(ProfileError(message: _mapFailureToMessage(failure))),
      (profile) => emit(VolunteerProfileLoaded(profile: profile)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case EmptyCacheFailure:
        return EMPTY_CACHE_FAILURE_MESSAGE;
      case OfflineFailure:
        return NO_INTERNET_ERROR_MESSAGE;

      default:
        return "Unexpected Error, Please try again later.";
    }
  }
}
