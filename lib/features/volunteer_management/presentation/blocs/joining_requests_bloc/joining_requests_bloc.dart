import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:graduationregistration/core/error/failures.dart';
import 'package:graduationregistration/core/strings/error.dart';
import 'package:graduationregistration/features/volunteer_management/domain/entities/joining_requests_entity.dart';
import 'package:graduationregistration/features/volunteer_management/domain/usecases/accept_to_join_the_campaign_usecase.dart';
import 'package:graduationregistration/features/volunteer_management/domain/usecases/get_all_joining_request_to_campaign_usecase.dart';
import 'package:graduationregistration/features/volunteer_management/domain/usecases/refuse_to_join_the_campaign_usecase.dart';

part 'joining_requests_event.dart';
part 'joining_requests_state.dart';

class JoiningRequestsBloc
    extends Bloc<JoiningRequestsEvent, JoiningRequestsState> {
  final GetAllJoiningRequestToCampaignUsecase
  getAllJoiningRequestToCampaignUsecase;
  final AcceptToJoinTheCampaignUsecase acceptToJoinTheCampaignUsecase;
  final RefuseToJoinTheCampaignUsecase refuseToJoinTheCampaignUsecase;

  JoiningRequestsBloc({
    required this.getAllJoiningRequestToCampaignUsecase,
    required this.acceptToJoinTheCampaignUsecase,
    required this.refuseToJoinTheCampaignUsecase,
  }) : super(JoiningRequestsInitial()) {
    on<LoadAllJoiningRequestsEvent>(_onLoadAllJoiningRequests);
    on<AcceptJoiningRequestEvent>(_onAcceptJoiningRequest);
    on<RefuseJoiningRequestEvent>(_onRefuseJoiningRequest);

    on<RefreshAllJoiningRequestsEvent>(_onRefreshAllJoiningRequests);
  }

  Future<void> _onLoadAllJoiningRequests(
    LoadAllJoiningRequestsEvent event,
    Emitter<JoiningRequestsState> emit,
  ) async {
    emit(JoiningRequestsLoading());
    final failureOrRequests = await getAllJoiningRequestToCampaignUsecase();
    emit(_mapFailureOrRequestsToState(failureOrRequests));
  }

  Future<void> _onAcceptJoiningRequest(
    AcceptJoiningRequestEvent event,
    Emitter<JoiningRequestsState> emit,
  ) async {
    emit(JoiningRequestsLoading());
    final failureOrSuccess = await acceptToJoinTheCampaignUsecase(
      participantId: event.participantId,
    );

    failureOrSuccess.fold(
      (failure) =>
          emit(JoiningRequestsError(message: _mapFailureToMessage(failure))),
      (_) {
        emit(
          const JoiningRequestActionSuccess(
            message: "تمت الموافقة على طلب الانضمام بنجاح.",
          ),
        );
        add(const LoadAllJoiningRequestsEvent());
      },
    );
  }

  Future<void> _onRefuseJoiningRequest(
    RefuseJoiningRequestEvent event,
    Emitter<JoiningRequestsState> emit,
  ) async {
    emit(JoiningRequestsLoading());
    final failureOrSuccess = await refuseToJoinTheCampaignUsecase(
      participantId: event.participantId,
    );
    failureOrSuccess.fold(
      (failure) {
        emit(JoiningRequestsError(message: _mapFailureToMessage(failure)));
      },
      (_) {
        emit(
          const JoiningRequestActionSuccess(
            message: "تم رفض طلب الانضمام بنجاح.",
          ),
        );
        add(const LoadAllJoiningRequestsEvent());
      },
    );
  }

  Future<void> _onRefreshAllJoiningRequests(
    RefreshAllJoiningRequestsEvent event,
    Emitter<JoiningRequestsState> emit,
  ) async {
    final failureOrRequests = await getAllJoiningRequestToCampaignUsecase();
    emit(_mapFailureOrRequestsToState(failureOrRequests));
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

  JoiningRequestsState _mapFailureOrRequestsToState(
    Either<Failure, List<JoiningRequestsEntity>> failureOrRequests,
  ) {
    return failureOrRequests.fold(
      (failure) => JoiningRequestsError(message: _mapFailureToMessage(failure)),
      (requests) => JoiningRequestsLoaded(requests: requests),
    );
  }
}
