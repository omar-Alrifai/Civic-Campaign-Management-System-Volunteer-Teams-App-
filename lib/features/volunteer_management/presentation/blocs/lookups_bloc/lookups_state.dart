part of 'lookups_bloc.dart';

abstract class LookupsState extends Equatable {
  const LookupsState();

  @override
  List<Object?> get props => [];
}

class LookupsInitial extends LookupsState {}

class LookupsLoading extends LookupsState {}

class CategoriesLoaded extends LookupsState {
  final List<MyCategory> categories;
  const CategoriesLoaded({required this.categories});

  @override
  List<Object?> get props => [categories];
}

class RegionsLoaded extends LookupsState {
  final List<RegionEntity> regions;
  const RegionsLoaded({required this.regions});

  @override
  List<Object?> get props => [regions];
}

class LookupsError extends LookupsState {
  final String message;
  const LookupsError({required this.message});

  @override
  List<Object?> get props => [message];
}

// حالة لدمج الفئات والمناطق إذا تم تحميل كليهما
class LookupsDataLoaded extends LookupsState {
  final List<MyCategory> categories;
  final List<RegionEntity> regions;

  const LookupsDataLoaded({required this.categories, required this.regions});

  @override
  List<Object?> get props => [categories, regions];
}
