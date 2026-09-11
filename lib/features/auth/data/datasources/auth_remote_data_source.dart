import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:graduationregistration/core/error/exceptions.dart';
import 'package:graduationregistration/features/auth/data/models/user_login_model.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

const baseUrl = "https://thecommunity2-sy.xyz"; // للــ Hosting

abstract class AuthRemoteDataSource {
  Future<Unit> registerUser({
    required String name,
    required String email,
    required String password,
    required String phone,
    required int age,
    required String gender,
    String? bio,
    double? latitude,
    double? longitude,
    String? area,
    List<String>? skills,
    List<String>? volunteerFields,
    String? imagePath,
  });
  Future<Unit> confirmRegistration({
    required String email,
    required String code,
  });
  Future<Unit> resendCode(String email);

  Future<Unit> requestPasswordReset(String email);

  Future<Unit> confirmPasswordReset({
    required String email,
    required String code,
    required String newPassword,
    required String confirmPassword,
  });

  Future<UserLoginModel> login({
    required String email,
    required String password,
    required String deviceToken,
  });

  Future<Unit> logout(String token);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  static const Map<String, int> skillsMap = {
    'تمريض': 1,
    'طبخ': 2,
    'جمع تبرعات': 3,
    'تصوير': 4,
    'مهنية': 5,
  };

  static const Map<String, int> volunteerFieldsMap = {
    'ترميم بيوت': 1,
    'توزيع مساعدات': 2,
    'تنظيم فعالية': 3,
    'إغاثة الكوارث': 4,
    'مساعدات الطريق': 5,
    'تنظيف البيئة': 6,
  };

  @override
  Future<Unit> registerUser({
    required String name,
    required String email,
    required String password,
    required String phone,
    required int age,
    required String gender,
    String? bio,
    double? latitude,
    double? longitude,
    String? area,
    List<String>? skills,
    List<String>? volunteerFields,
    String? imagePath,
  }) async {
    final uri = Uri.parse('$baseUrl/api/client/initiate_registration');

    var request = http.MultipartRequest('POST', uri);

    final skillsIds = skills?.map((skill) => skillsMap[skill]!).toList();

    final volunteerFieldsIds = volunteerFields
        ?.map((field) => volunteerFieldsMap[field]!)
        .toList();

    request.fields.addAll({
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'age': age.toString(),
      'gender': gender,
      if (bio != null) 'bio': bio,
      if (latitude != null) 'latitude': latitude.toString(),
      if (longitude != null) 'longitude': longitude.toString(),
      if (area != null) 'area': area,
      if (skillsIds != null) 'skills': jsonEncode(skillsIds),
      if (volunteerFieldsIds != null)
        'volunteer_fields': jsonEncode(volunteerFieldsIds),
    });

    if (imagePath != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imagePath,
          filename: basename(imagePath),
        ),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      throw Exception('Failed to register user: ${response.body}');
    }

    return Future.value(unit);
  }

  @override
  Future<Unit> confirmRegistration({
    required String email,
    required String code,
  }) async {
    final uri = Uri.parse('$baseUrl/api/client/confirm_registration');
    final response = await http.post(uri, body: {'email': email, 'code': code});

    if (response.statusCode != 200) {
      throw ServerException();
    }
    return Future.value(unit);
  }

  @override
  Future<Unit> resendCode(String email) async {
    final uri = Uri.parse('$baseUrl/api/client/resend_code');
    final response = await client.post(uri, body: {'email': email});

    if (response.statusCode != 200) {
      throw Exception('Failed to resend code: ${response.body}');
    }

    return Future.value(unit);
  }

  @override
  Future<Unit> requestPasswordReset(String email) async {
    final uri = Uri.parse('$baseUrl/api/client/reset_password');
    final response = await client.post(uri, body: {'email': email});

    if (response.statusCode != 200) {
      throw Exception('Failed to request password reset: ${response.body}');
    }

    return Future.value(unit);
  }

  @override
  Future<Unit> confirmPasswordReset({
    required String email,
    required String code,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final uri = Uri.parse('$baseUrl/api/client/confirm_reset_password');
    final response = await client.post(
      uri,
      body: {
        'email': email,
        'reset_code': code,
        'new_password': newPassword,
        'new_password_confirmation': confirmPassword,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to confirm password reset: ${response.body}');
    }

    return Future.value(unit);
  }

  @override
  Future<UserLoginModel> login({
    required String email,
    required String password,
    required String deviceToken,
  }) async {
    final uri = Uri.parse('$baseUrl/api/client/login');
    final response = await client.post(
      uri,
      body: {'email': email, 'password': password, 'device_token': deviceToken},
    );

    if (response.statusCode != 200) {
      throw ServerException();
    }

    final responseData = json.decode(response.body);
    return UserLoginModel.fromJson(responseData['data']);
  }

  @override
  Future<Unit> logout(String token) async {
    final uri = Uri.parse('$baseUrl/api/client/logout');
    final response = await client.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw ServerException();
    }

    return unit;
  }
}
