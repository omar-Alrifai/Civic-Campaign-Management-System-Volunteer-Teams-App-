class ServerException implements Exception {}

class EmptyCacheException implements Exception {}

class OfflineException implements Exception {}

class InvalidResetCodeException implements Exception {}

// new

class CacheException implements Exception {}

class ServerException1 implements Exception {
  final int? statusCode;
  final String? message;
  ServerException1({this.statusCode, this.message});
}
