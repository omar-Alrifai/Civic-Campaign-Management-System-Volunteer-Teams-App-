import 'package:graduationregistration/features/volunteer_profile/domain/entity/location_entity.dart';

class LocationModel extends LocationEntity {
  const LocationModel({
    required String? name,
    required String? latitude,
    required String? longitude,
  }) : super(name: name, latitude: latitude, longitude: longitude);

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      name: json['area'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'area': name, 'latitude': latitude, 'longitude': longitude};
  }
}
