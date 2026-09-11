part of 'joining_requests_bloc.dart';

abstract class JoiningRequestsState extends Equatable {
  const JoiningRequestsState();

  @override
  List<Object?> get props => [];
}

class JoiningRequestsInitial extends JoiningRequestsState {}

class JoiningRequestsLoading extends JoiningRequestsState {}

class JoiningRequestsLoaded extends JoiningRequestsState {
  final List<JoiningRequestsEntity> requests;

  const JoiningRequestsLoaded({required this.requests});

  @override
  List<Object?> get props => [requests];
}

class JoiningRequestActionSuccess extends JoiningRequestsState {
  final String message;

  const JoiningRequestActionSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class JoiningRequestsError extends JoiningRequestsState {
  final String message;

  const JoiningRequestsError({required this.message});

  @override
  List<Object?> get props => [message];
}
