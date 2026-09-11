part of 'joining_requests_bloc.dart';

abstract class JoiningRequestsEvent extends Equatable {
  const JoiningRequestsEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllJoiningRequestsEvent extends JoiningRequestsEvent {
  const LoadAllJoiningRequestsEvent();
}

class AcceptJoiningRequestEvent extends JoiningRequestsEvent {
  final int participantId;

  const AcceptJoiningRequestEvent({required this.participantId});

  @override
  List<Object?> get props => [participantId];
}

class RefuseJoiningRequestEvent extends JoiningRequestsEvent {
  final int participantId;

  const RefuseJoiningRequestEvent({required this.participantId});

  @override
  List<Object?> get props => [participantId];
}

class RefreshAllJoiningRequestsEvent extends JoiningRequestsEvent {
  const RefreshAllJoiningRequestsEvent();
}
