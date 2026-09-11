import 'dart:convert';
import 'package:graduationregistration/core/error/exceptions.dart';
import 'package:graduationregistration/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:graduationregistration/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:http/http.dart' as http;
import '../model/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final http.Client client;
  final AuthLocalDataSource authLocalDataSource;

  NotificationRemoteDataSourceImpl({
    required this.client,
    required this.authLocalDataSource,
  });

  Future<String?> _getToken() async {
    final token = await authLocalDataSource.getToken();
    return token;
  }

  @override
  Future<List<NotificationModel>> getNotifications() async {
    final url = Uri.parse('$baseUrl/api/notifications');
    final token = await _getToken();
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> decodedJson = json.decode(response.body);

        final List<dynamic> notificationListJson = decodedJson['data'];
        return notificationListJson
            .map((jsonItem) => NotificationModel.fromJson(jsonItem))
            .toList();
      } catch (e) {
        throw ServerException();
      }
    } else {
      throw ServerException();
    }
  }
}
