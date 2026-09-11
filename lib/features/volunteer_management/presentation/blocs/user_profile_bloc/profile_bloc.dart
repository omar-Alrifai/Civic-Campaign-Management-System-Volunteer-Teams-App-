import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:graduationregistration/core/error/failures.dart';
import 'package:graduationregistration/core/strings/error.dart';
import 'package:graduationregistration/features/volunteer_management/domain/entities/user_profile_entity.dart';
import 'package:graduationregistration/features/volunteer_management/domain/usecases/get_user_profile_by_userid.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final GetUserProfileByUserIdUsecase getUserProfileByUserIdUseCase;

  UserProfileBloc({required this.getUserProfileByUserIdUseCase})
    : super(ProfileInitial()) {
    on<GetUserProfileByUserIdEvent>((event, emit) async {
      emit(const ProfileLoading());
      try {
        final result = await getUserProfileByUserIdUseCase(event.userId);
        result.fold(
          (failure) =>
              emit(ProfileError(message: _mapFailureToMessage(failure))),
          (profile) => emit(ProfileLoaded(userProfile: profile)),
        );
      } catch (e) {
        print(
          " UNHANDLED ERROR in GetProfileByUserIdEvent for user ${event.userId}: $e",
        );
        emit(
          const ProfileError(
            message:
                "An unexpected error occurred while loading the user's profile.",
          ),
        );
      }
    });
  }
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case OfflineFailure:
        return NO_INTERNET_ERROR_MESSAGE;
      case EmptyCacheFailure:
        return EMPTY_CACHE_FAILURE_MESSAGE;
      default:
        return "حدث خطأ غير متوقع، يرجى المحاولة لاحقاً.";
    }
  }
}
