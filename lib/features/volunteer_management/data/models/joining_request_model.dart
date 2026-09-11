import 'package:graduationregistration/features/volunteer_management/domain/entities/joining_requests_entity.dart';

class JoiningRequestModel extends JoiningRequestsEntity {
  const JoiningRequestModel({
    int? id,
    required int? userId,
    required int? projectId,
    required String? status,
    required String? userName,
    String? projectTitle,
  }) : super(
         id: id,
         userId: userId,
         projectId: projectId,
         status: status,
         userName: userName,
         projectTitle: projectTitle,
       );

  factory JoiningRequestModel.fromJson(Map<String, dynamic> json) {
    return JoiningRequestModel(
      id: json['id'],
      userId: json['user_id'],
      projectId: json['project_id'],
      status: json['status'],
      userName: json['user_name'],
      projectTitle: json['project_title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'project_id': projectId,
      'status': status,
      'user_name': userName,
      'project_title': projectTitle,
    };
  }
}
