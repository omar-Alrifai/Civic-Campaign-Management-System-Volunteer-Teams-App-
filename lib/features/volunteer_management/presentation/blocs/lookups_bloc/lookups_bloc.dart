import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:graduationregistration/core/error/failures.dart';
import 'package:graduationregistration/core/strings/error.dart';
import 'package:graduationregistration/features/volunteer_management/domain/entities/category.dart';
import 'package:graduationregistration/features/volunteer_management/domain/entities/regions_entity.dart';
import 'package:graduationregistration/features/volunteer_management/domain/usecases/category_use_case.dart';
import 'package:graduationregistration/features/volunteer_management/domain/usecases/get_all_regions.dart';

part 'lookups_event.dart';
part 'lookups_state.dart';

class LookupsBloc extends Bloc<LookupsEvent, LookupsState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetAllRegionsUseCase getAllRegionsUseCase;

  List<RegionEntity>? _cachedRegions;

  LookupsBloc({
    required this.getCategoriesUseCase,
    required this.getAllRegionsUseCase,
  }) : super(LookupsInitial()) {
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<LoadRegionsEvent>(_onLoadRegions);
  }

  Future<void> _onLoadCategories(
    LoadCategoriesEvent event,
    Emitter<LookupsState> emit,
  ) async {
    emit(LookupsLoading());
    final failureOrCategories = await getCategoriesUseCase();

    failureOrCategories.fold(
      (failure) => emit(LookupsError(message: _mapFailureToMessage(failure))),
      (categories) {
        emit(CategoriesLoaded(categories: categories));
      },
    );
  }

  Future<void> _onLoadRegions(
    LoadRegionsEvent event,
    Emitter<LookupsState> emit,
  ) async {
    if (_cachedRegions != null && _cachedRegions!.isNotEmpty) {
      emit(RegionsLoaded(regions: _cachedRegions!));
      return;
    }

    emit(LookupsLoading());
    final failureOrRegions = await getAllRegionsUseCase();

    failureOrRegions.fold(
      (failure) => emit(LookupsError(message: _mapFailureToMessage(failure))),
      (regions) {
        _cachedRegions = regions;
        emit(RegionsLoaded(regions: regions));
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case OfflineFailure:
        return NO_INTERNET_ERROR_MESSAGE;
      default:
        return "حدث خطأ غير متوقع، يرجى المحاولة لاحقاً.";
    }
  }
}
