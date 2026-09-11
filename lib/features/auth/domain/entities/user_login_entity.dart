import 'package:equatable/equatable.dart';

class UserLoginEntity extends Equatable {
  final int? id;
  final String name;
  final String email;
  final String role; // 'client' أو 'volunteer_admin'
  final String? token;

  const UserLoginEntity({
    this.id,
    required this.name,
    required this.email,
    required this.role,
    this.token,
  });

  bool get isVolunteerAdmin => role == 'volunteer_admin';
  bool get isClient => role == 'client';

  @override
  List<Object?> get props => [id, name, email, role, token];
}
