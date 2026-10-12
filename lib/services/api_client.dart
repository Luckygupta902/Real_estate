
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  ApiClient._();

  static final ApiClient instance = ApiClient._();

  final FlutterSecureStorage _storage =
      const FlutterSecureStorage();

  // Android emulator reaches the host computer via 10.0.2.2.
  // Web, Windows and iOS simulator use localhost.
  // On a real phone, set this to your computer's LAN IP
  // (e.g. http://192.168.1.5:8080).
  static String baseUrlOverride = '';

  static String get baseUrl {
    if (baseUrlOverride.isNotEmpty) return baseUrlOverride;
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8080';
    }
    return 'http://localhost:8080';
  }

  // Turns a DioException into a readable message for the UI.
  static String errorMessage(Object e) {
    if (e is DioException) {
      final data = e.response?.data;

      if (data is Map) {
        final msg = data['error'] ?? data['message'];
        if (msg != null) return msg.toString();
      }
      if (data is String && data.trim().isNotEmpty) {
        return data.trim();
      }

      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return 'Server took too long to respond ($baseUrl)';
        case DioExceptionType.connectionError:
        case DioExceptionType.unknown:
          return 'Cannot connect to server at $baseUrl. '
              'Make sure the backend is running'
              '${kIsWeb ? ' and CORS is enabled' : ''}.';
        default:
          break;
      }

      final code = e.response?.statusCode;
      if (code == 401 || code == 403) {
        return 'Not authorized ($code). Please log in again.';
      }
      if (code != null) return 'Request failed ($code)';
      return e.message ?? 'Network error';
    }

    return e.toString().replaceFirst('Exception: ', '');
  }

  late final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Public calls pass `Authorization: null`; don't attach a
          // (possibly expired) stored token to them.
          if (options.headers.containsKey('Authorization')) {
            options.headers.remove('Authorization');
            return handler.next(options);
          }

          final token = await _storage.read(key: 'token');

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          handler.next(options);
        },
      ),
    );

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  Future<String?> getToken() async {
    return _storage.read(key: 'token');
  }

  // The backend uses the JWT subject as the user ID.
  Future<int?> getCurrentUserId() async {
    final token = await getToken();
    if (token == null || token.isEmpty) return null;

    final parts = token.split('.');
    if (parts.length != 3) return null;

    try {
      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      ) as Map<String, dynamic>;

      final id = payload['sub'] ?? payload['userId'] ?? payload['id'];
      return int.tryParse(id.toString());
    } catch (_) {
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
  }
}
