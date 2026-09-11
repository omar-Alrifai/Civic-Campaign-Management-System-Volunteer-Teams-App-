import 'package:equatable/equatable.dart';

class JoiningRequestsEntity extends Equatable {
  final int? id;
  final int? userId;
  final int? projectId;
  final String? status;
  final String? userName;
  final String? projectTitle;
  const JoiningRequestsEntity({
    this.id,
    required this.userId,
    required this.projectId,
    required this.status,
    required this.userName,
    this.projectTitle,
  });
  @override
  List<Object?> get props => [
    id,
    userId,
    projectId,
    status,
    userName,
    projectTitle,
  ];
}
