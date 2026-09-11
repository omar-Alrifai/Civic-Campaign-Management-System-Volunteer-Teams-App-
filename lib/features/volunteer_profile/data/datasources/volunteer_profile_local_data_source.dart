import 'dart:convert';

import 'package:graduationregistration/features/volunteer_profile/data/models/volunteer_profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class VolunteerProfileLocalDataSource {
  Future<void> cacheProfile(VolunteerProfileModel volunteerProfile);
  Future<VolunteerProfileModel?> getCachedProfile();
  Future<void> clearCachedProfile();
}

const CACHED_PROFILE_KEY = 'VOLUNTEER_CACHED_PROFILE';

class VolunteerProfileLocalDataSourceImpl
    implements VolunteerProfileLocalDataSource {
  final SharedPreferences sharedPreferences;

  VolunteerProfileLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheProfile(VolunteerProfileModel volunteerProfile) async {
    await sharedPreferences.setString(
      CACHED_PROFILE_KEY,
      json.encode(volunteerProfile.toJson()),
    );
  }

  @override
  Future<void> clearCachedProfile() async {
    await sharedPreferences.remove(CACHED_PROFILE_KEY);
  }

  @override
  Future<VolunteerProfileModel?> getCachedProfile() async {
    final jsonString = sharedPreferences.getString(CACHED_PROFILE_KEY);
    if (jsonString != null) {
      return VolunteerProfileModel.fromJson(json.decode(jsonString));
    }
    return null;
  }
}
