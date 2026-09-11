import 'package:graduationregistration/features/volunteer_management/domain/entities/location_entity.dart';

class LocationModel extends LocationEntity {
  const LocationModel({
    required String? name,
    required String? latitude,
    required String? longitude,
  }) : super(name: name, latitude: latitude, longitude: longitude);

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'latitude': latitude, 'longitude': longitude};
  }
}
