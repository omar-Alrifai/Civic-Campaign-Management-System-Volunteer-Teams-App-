import 'package:graduationregistration/features/volunteer_profile/data/models/location_model.dart';
import 'package:graduationregistration/features/volunteer_profile/domain/entity/volunteer_profile_entity.dart';

class VolunteerProfileModel extends VolunteerProfileEntity {
  const VolunteerProfileModel({
    super.name,
    super.bio,
    super.experienceYears,
    super.phone,
    super.location,
    super.imageUrl,
    super.email,
  });

  factory VolunteerProfileModel.fromJson(Map<String, dynamic> json) {
    return VolunteerProfileModel(
      name: json['name'],
      bio: json['bio'],
      experienceYears: json['experience_years'],
      phone: json['phone'],
      location:
          json['location'] != null
              ? LocationModel.fromJson(json['location'])
              : null,
      imageUrl: json['image'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'bio': bio,
      'experience_years': experienceYears,
      'phone': phone,
      'location': (location as LocationModel?)?.toJson(),
      'image': imageUrl,
      'email': email,
    };
  }

  VolunteerProfileEntity toEntity() {
    return VolunteerProfileEntity(
      name: name,
      phone: phone,
      bio: bio,
      experienceYears: experienceYears,
      location: location,
      imageUrl: imageUrl,
      email: email,
    );
  }
}
