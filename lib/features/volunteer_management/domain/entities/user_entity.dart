import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int? userId;
  final String? createdBy;
  final String? role;
  const UserEntity({this.userId, required this.createdBy, required this.role});

  @override
  List<Object?> get props => [userId, createdBy, role];
}
