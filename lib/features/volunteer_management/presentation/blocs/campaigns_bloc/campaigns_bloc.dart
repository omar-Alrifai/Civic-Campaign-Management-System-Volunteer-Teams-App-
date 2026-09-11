import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:graduationregistration/core/error/failures.dart';
import 'package:graduationregistration/core/strings/error.dart';
import 'package:graduationregistration/features/volunteer_management/data/datasources/volunteer_management_local_data_source.dart';
import 'package:graduationregistration/features/volunteer_management/data/models/campaign_model.dart';
import 'package:graduationregistration/features/volunteer_management/domain/entities/campaign_entity.dart';
import 'package:graduationregistration/features/volunteer_management/domain/usecases/get_all_campaigns_by_category_usecase.dart';
import 'package:graduationregistration/features/volunteer_management/domain/usecases/get_all_campaigns_created_by_volunteer_admin_usecase.dart';
import 'package:graduationregistration/features/volunteer_management/domain/usecases/get_all_campaigns_usecase.dart';
import 'package:graduationregistration/features/volunteer_management/domain/usecases/get_campaign_details_usecase.dart';
import 'package:graduationregistration/features/volunteer_management/domain/usecases/search_campaigns_usecase.dart';

part 'campaigns_event.dart';
part 'campaigns_state.dart';

class CampaignBloc extends Bloc<CampaignEvent, CampaignState> {
  final GetAllCampaignsUsecase getAllCampaignsUsecase;
  final GetAllCampaignsByCategoryUsecase getAllCampaignsByCategoryUsecase;
  final GetCampaignDetailsUsecase getCampaignDetailsUsecase;
  final GetAllCampaignsCreatedByVolunteerAdminUsecase
  getAllCampaignsCreatedByVolunteerAdminUsecase;
  final SearchCampaignsUsecase searchCampaignsUsecase;
  List<CampaignEntity>? lastLoadedAllCampaigns;
  List<CampaignEntity>? lastLoadedVolunteerCampaigns;

  final VolunteerManagementLocalDataSource localDataSource;

  CampaignBloc({
    required this.getAllCampaignsUsecase,
    required this.getAllCampaignsByCategoryUsecase,
    required this.getCampaignDetailsUsecase,
    required this.getAllCampaignsCreatedByVolunteerAdminUsecase,
    required this.searchCampaignsUsecase,
    required this.localDataSource,
  }) : super(CampaignInitial()) {
    on<LoadAllCampaignsEvent>(_onLoadAllCampaigns);
    on<LoadCampaignsByCategoryEvent>(_onLoadCampaignsByCategory);
    on<LoadCampaignDetailsEvent>(_onLoadCampaignDetails);
    on<LoadVolunteerAdminCampaignsEvent>(_onLoadVolunteerAdminCampaigns);

    on<RefreshAllCampaignsEvent>(_onRefreshAllCampaigns);
    on<RefreshVolunteerAdminCampaignsEvent>(_onRefreshVolunteerAdminCampaigns);
    on<SearchCampaignsEvent>(_onSearchCampaigns);
  }

  Future<List<CampaignEntity>?> _getOldCampaignsByContext({
    required bool isVolunteer,
  }) async {
    final inMemory = isVolunteer
        ? lastLoadedVolunteerCampaigns
        : lastLoadedAllCampaigns;
    if (inMemory != null) return inMemory;

    try {
      final cachedModels = isVolunteer
          ? await localDataSource.getCachedCampaigns()
          : await localDataSource.getCachedAllCampaigns();
      return cachedModels;
    } catch (_) {
      return null;
    }
  }

  Future<void> _onLoadAllCampaigns(
    LoadAllCampaignsEvent event,
    Emitter<CampaignState> emit,
  ) async {
    final oldData = await _getOldCampaignsByContext(isVolunteer: false);

    emit(CampaignLoading(oldCampaigns: oldData));

    if (lastLoadedAllCampaigns != null && lastLoadedAllCampaigns!.isNotEmpty) {
      emit(CampaignsLoaded(campaigns: lastLoadedAllCampaigns!));
      return;
    }

    final failureOrCampaigns = await getAllCampaignsUsecase(
      status: event.status,
    );

    await failureOrCampaigns.fold(
      (failure) async {
        emit(
          CampaignError(
            message: _mapFailureToMessage(failure),
            oldCampaigns: oldData,
          ),
        );
      },
      (campaigns) async {
        lastLoadedAllCampaigns = campaigns;
        await localDataSource.cacheAllCampaigns(
          campaigns.cast<CampaignModel>(),
        );
        emit(CampaignsLoaded(campaigns: campaigns));
      },
    );
  }

  Future<void> _onLoadCampaignsByCategory(
    LoadCampaignsByCategoryEvent event,
    Emitter<CampaignState> emit,
  ) async {
    final oldData = await _getOldCampaignsByContext(isVolunteer: false);
    emit(CampaignLoading(oldCampaigns: null));

    final failureOrCampaigns = await getAllCampaignsByCategoryUsecase(
      categoryId: event.categoryId,
      status: event.status,
    );

    await _handleCampaignsResult(
      failureOrCampaigns,
      emit,
      shouldUpdateLastLoaded: false,
    );
  }

  Future<void> _onLoadCampaignDetails(
    LoadCampaignDetailsEvent event,
    Emitter<CampaignState> emit,
  ) async {
    final oldData = await _getOldCampaignsByContext(isVolunteer: false);
    emit(CampaignLoading(oldCampaigns: oldData));

    final failureOrCampaign = await getCampaignDetailsUsecase(
      campaignId: event.campaignId,
    );

    await failureOrCampaign.fold(
      (failure) async {
        emit(
          CampaignError(
            message: _mapFailureToMessage(failure),
            oldCampaigns: oldData,
          ),
        );
      },
      (campaign) async {
        emit(CampaignDetailsLoaded(campaign: campaign));
      },
    );
  }

  Future<void> _onLoadVolunteerAdminCampaigns(
    LoadVolunteerAdminCampaignsEvent event,
    Emitter<CampaignState> emit,
  ) async {
    final oldData = await _getOldCampaignsByContext(isVolunteer: true);

    emit(CampaignLoading(oldCampaigns: oldData));

    if (lastLoadedVolunteerCampaigns != null &&
        lastLoadedVolunteerCampaigns!.isNotEmpty) {
      emit(CampaignsLoaded(campaigns: lastLoadedVolunteerCampaigns!));
      return;
    }

    final failureOrCampaigns =
        await getAllCampaignsCreatedByVolunteerAdminUsecase(status: null);

    await failureOrCampaigns.fold(
      (failure) async {
        emit(
          CampaignError(
            message: _mapFailureToMessage(failure),
            oldCampaigns: oldData,
          ),
        );
      },
      (campaigns) async {
        lastLoadedVolunteerCampaigns = campaigns;
        await localDataSource.cacheCampaigns(campaigns.cast<CampaignModel>());
        emit(CampaignsLoaded(campaigns: campaigns));
      },
    );
  }

  Future<void> _handleRefreshEvent({
    required Emitter<CampaignState> emit,
    required bool isVolunteer,
    required Future<Either<Failure, List<CampaignEntity>>> Function() fetchData,
  }) async {
    final oldData = await _getOldCampaignsByContext(isVolunteer: isVolunteer);

    emit(CampaignLoading(oldCampaigns: oldData));

    final failureOrCampaigns = await fetchData();

    await failureOrCampaigns.fold(
      (failure) async {
        emit(
          CampaignError(
            message: _mapFailureToMessage(failure),
            oldCampaigns: oldData, // الاحتفاظ بالبيانات القديمة في حالة الخطأ
          ),
        );
      },
      (campaigns) async {
        if (isVolunteer) {
          lastLoadedVolunteerCampaigns = campaigns;
          await localDataSource.cacheCampaigns(campaigns.cast<CampaignModel>());
        } else {
          lastLoadedAllCampaigns = campaigns;
          await localDataSource.cacheAllCampaigns(
            campaigns.cast<CampaignModel>(),
          );
        }

        emit(CampaignsLoaded(campaigns: campaigns));
      },
    );
  }

  Future<void> _onRefreshAllCampaigns(
    RefreshAllCampaignsEvent event,
    Emitter<CampaignState> emit,
  ) async {
    await _handleRefreshEvent(
      emit: emit,
      isVolunteer: false,
      fetchData: () => getAllCampaignsUsecase(status: event.status),
    );
  }

  Future<void> _onRefreshVolunteerAdminCampaigns(
    RefreshVolunteerAdminCampaignsEvent event,
    Emitter<CampaignState> emit,
  ) async {
    await _handleRefreshEvent(
      emit: emit,
      isVolunteer: true,
      fetchData: () =>
          getAllCampaignsCreatedByVolunteerAdminUsecase(status: null),
    );
  }

  Future<void> _onSearchCampaigns(
    SearchCampaignsEvent event,
    Emitter<CampaignState> emit,
  ) async {
    final oldData = await _getOldCampaignsByContext(isVolunteer: false);
    emit(CampaignLoading(oldCampaigns: null));

    final failureOrCampaigns = await searchCampaignsUsecase(
      query: event.query,
      categoryFilter: event.categoryFilter,
      statusFilter: event.statusFilter,
    );

    await _handleCampaignsResult(
      failureOrCampaigns,
      emit,
      shouldUpdateLastLoaded: false,
    );
  }

  // -------- Helpers --------

  Future<void> _handleCampaignsResult(
    Either<Failure, List<CampaignEntity>> failureOrCampaigns,
    Emitter<CampaignState> emit, {
    bool shouldUpdateLastLoaded = false,
    bool isVolunteer = false,
  }) async {
    await failureOrCampaigns.fold(
      (failure) async {
        emit(
          CampaignError(
            message: _mapFailureToMessage(failure),
            oldCampaigns: (state is CampaignLoading)
                ? (state as CampaignLoading).oldCampaigns
                : null,
          ),
        );
      },
      (campaigns) async {
        if (shouldUpdateLastLoaded) {
          if (isVolunteer) {
            lastLoadedVolunteerCampaigns = campaigns;
          } else {
            lastLoadedAllCampaigns = campaigns;
          }
        }
        emit(CampaignsLoaded(campaigns: campaigns));
      },
    );
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
        return "Unexpected Error, Please try again later.";
    }
  }
}
