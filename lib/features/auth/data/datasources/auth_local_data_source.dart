import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:graduationregistration/features/auth/data/models/user_login_model.dart';
import 'package:graduationregistration/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  // for login
  Future<Unit> cacheUser(UserLoginModel user);
  Future<Unit> clearCache();
  Future<UserLoginModel?> getCachedUser();
  Future<String?> getToken();

  Future<Unit> setLoggedIn(bool isLoggedIn);
  Future<bool> isLoggedIn();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String cachedUserKey = 'CACHED_USER';
  static const String tokenUserKey = 'TOKEN';

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<Unit> cacheUser(UserLoginModel user) async {
    await sharedPreferences.setString(
      cachedUserKey,
      json.encode(user.toJson()),
    );
    if (user.token != null) {
      await sharedPreferences.setString(tokenUserKey, user.token!);
    }
    return Future.value(unit);
  }

  @override
  Future<Unit> clearCache() async {
    await sharedPreferences.remove(cachedUserKey);
    await sharedPreferences.remove(tokenUserKey);
    return Future.value(unit);
  }

  @override
  Future<UserLoginModel?> getCachedUser() async {
    final jsonString = sharedPreferences.getString(cachedUserKey);
    if (jsonString != null) {
      return UserLoginModel.fromJson(json.decode(jsonString));
    }
    return null;
  }

  @override
  Future<String?> getToken() async {
    return sharedPreferences.getString(tokenUserKey);
  }

  @override
  Future<Unit> setLoggedIn(bool isLoggedIn) async {
    await sharedPreferences.setBool('is_logged_in', isLoggedIn);
    return Future.value(unit);
  }

  @override
  Future<bool> isLoggedIn() async {
    return sharedPreferences.getBool('is_logged_in') ?? false;
  }
}
