import 'package:graduationregistration/features/auth/domain/entities/user_login_entity.dart';

class UserLoginModel extends UserLoginEntity {
  const UserLoginModel({
    super.id,
    required super.name,
    required super.email,
    required super.role,
    super.token,
  });

  factory UserLoginModel.fromJson(Map<String, dynamic> json) {
    return UserLoginModel(
      id: json['user']['id'],
      name: json['user']['name'],
      email: json['user']['email'],
      role: json['role'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': {'id': id, 'name': name, 'email': email},
      'role': role,
      'token': token,
    };
  }

  UserLoginEntity toEntity() {
    return UserLoginEntity(
      id: id,
      name: name,
      email: email,
      role: role,
      token: token,
    );
  }
}
