import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int ?id;
  final String name;
  final String email;
  final String phone;
  final int age;
  final String gender;
  final String? bio;
  final double? latitude;
  final double? longitude;
  final String? area;
  final List<String>? skills;
  final List<String>? volunteerFields;
  final String? imageUrl;

  const UserEntity({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.age,
    required this.gender,
    this.bio,
    this.latitude,
    this.longitude,
    this.area,
    this.skills,
    this.volunteerFields,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    age,
    gender,
    bio,
    latitude,
    longitude,
    area,
    skills,
    volunteerFields,
    imageUrl,
  ];
}
