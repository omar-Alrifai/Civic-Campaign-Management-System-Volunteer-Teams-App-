import 'package:graduationregistration/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    int? id,
    required String name,
    required String email,
    required String phone,
    required int age,
    required String gender,
    String? bio,
    double? latitude,
    double? longitude,
    String? area,
    List<String>? skills,
    List<String>? volunteerFields,
    String? imageUrl,
  }) : super(
         id: id,
         name: name,
         email: email,
         phone: phone,
         age: age,
         gender: gender,
         bio: bio,
         latitude: latitude,
         longitude: longitude,
         area: area,
         skills: skills,
         volunteerFields: volunteerFields,
         imageUrl: imageUrl,
       );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      age: json['age'],
      gender: json['gender'],
      bio: json['bio'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      area: json['area'],
      skills: json['skills'] != null ? List<String>.from(json['skills']) : null,
      volunteerFields:
          json['volunteer_fields'] != null
              ? List<String>.from(json['volunteer_fields'])
              : null,
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'age': age,
      'gender': gender,
      'bio': bio,
      'latitude': latitude,
      'longitude': longitude,
      'area': area,
      'skills': skills,
      'volunteer_fields': volunteerFields,
      'image_url': imageUrl,
    };
  }
}
