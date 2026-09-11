import 'dart:convert';
import 'package:graduationregistration/core/error/exceptions.dart';
import 'package:graduationregistration/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:graduationregistration/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:graduationregistration/features/volunteer_profile/data/models/volunteer_profile_model.dart';
import 'package:http/http.dart' as http;

abstract class ProfileRemoteDataSource {
  Future<VolunteerProfileModel> getVolunteerProfile();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final http.Client client;
  final AuthLocalDataSource authLocalDataSource;

  ProfileRemoteDataSourceImpl({
    required this.client,
    required this.authLocalDataSource,
  });

  Future<String?> _getToken() async {
    final token = await authLocalDataSource.getToken();
    return token;
  }

  @override
  Future<VolunteerProfileModel> getVolunteerProfile() async {
    final token = await _getToken();
    final uri = Uri.parse('$baseUrl/api/volunteer/show/profile');

    final response = await client.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body)['data'];
      print("response of profile :${response.body}");
      return VolunteerProfileModel.fromJson(responseData);
    } else {
      throw ServerException();
    }
  }
}
