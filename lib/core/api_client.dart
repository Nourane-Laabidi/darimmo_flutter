import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

String get apiBaseUrl {
  if (kIsWeb) return 'http://localhost:5000/api';
  if (defaultTargetPlatform == TargetPlatform.android) {
    return 'http://10.0.2.2:5000/api'; // Android emulator
  }
  return 'http://localhost:5000/api';
}

class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'token';

  late final Dio dio = _build();

  Dio _build() {
    final d = Dio(BaseOptions(
      baseUrl: apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ));
    d.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: _tokenKey);
        if (token != null) options.headers['Authorization'] = 'Bearer $token';
        handler.next(options);
      },
    ));
    return d;
  }

  Future<void> saveToken(String token) =>
      _storage.write(key: _tokenKey, value: token);
  Future<String?> readToken() => _storage.read(key: _tokenKey);
  Future<void> clearToken() => _storage.delete(key: _tokenKey);
}

/// Turns any error into a message the user can read.
String apiError(Object e) {
  if (e is DioException) {
    final data = e.response?.data;
    if (data is Map && data['message'] is String) return data['message'];
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return 'Impossible de joindre le serveur';
    }
  }
  return 'Une erreur est survenue';
}