part of 'lookups_bloc.dart';

abstract class LookupsEvent extends Equatable {
  const LookupsEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategoriesEvent extends LookupsEvent {
  const LoadCategoriesEvent();
}

class LoadRegionsEvent extends LookupsEvent {
  const LoadRegionsEvent();
}
