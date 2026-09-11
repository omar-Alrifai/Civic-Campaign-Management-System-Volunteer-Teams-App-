import 'package:equatable/equatable.dart';
import 'package:graduationregistration/features/volunteer_profile/domain/entity/location_entity.dart';

class VolunteerProfileEntity extends Equatable {
  final String? name;
  final String? bio;
  final int? experienceYears;
  final String? phone;
  final LocationEntity? location;
  final String? imageUrl;
  final String? email;

  const VolunteerProfileEntity({
    this.name,
    this.bio,
    this.experienceYears,
    this.phone,
    this.location,
    this.imageUrl,
    this.email,
  });

  @override
  List<Object?> get props => [
    name,
    bio,
    experienceYears,
    phone,
    location,
    imageUrl,
    email,
  ];
}
