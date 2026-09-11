import 'package:graduationregistration/features/volunteer_management/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    int? userId,
    required String? createdBy,
    required String? role,
  }) : super(userId: userId, createdBy: createdBy, role: role);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userID'],
      createdBy: json['created_by'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'userID': userId, 'created_by': createdBy, 'role': role};
  }
}
