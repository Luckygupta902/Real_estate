import 'package:dio/dio.dart';
import 'api_client.dart';

class AuthService {
  final Dio _dio = ApiClient.instance.dio;

  // POST /api/auth/user
  Future<String> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String city,
    required String state,
    String? profileImage,
  }) async {
    final response = await _dio.post(
      '/api/auth/user',
      data: {
        'roleId': 1, // regular USER
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'city': city,
        'state': state,
        if (profileImage != null && profileImage.isNotEmpty)
          'profileImage': profileImage,
      },
      options: Options(
        headers: {'Authorization': null},
      ),
    );

    return response.data.toString();
  }

  // POST /api/auth/login
  Future<String> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      '/api/auth/login',
      data: {
        'email': email,
        'password': password,
      },
      options: Options(
        headers: {'Authorization': null},
      ),
    );

    final data = response.data;
    String token;

    if (data is String) {
      token = data.trim();
    } else if (data is Map && data['token'] != null) {
      token = data['token'].toString();
    } else {
      throw Exception(
        'JWT token was not found in the login response',
      );
    }

    // Handle login error messages returned as strings.
    if (token.isEmpty ||
        token == 'Email not found' ||
        token == 'Invalid password' ||
        token == 'Please activate your account first') {
      throw Exception(token.isEmpty ? 'Login failed' : token);
    }

    await ApiClient.instance.saveToken(token);

    return token;
  }

  // POST /api/auth/activate
  Future<String> activateAccount(String email) async {
    final response = await _dio.post(
      '/api/auth/activate',
      queryParameters: {'email': email},
      options: Options(
        headers: {'Authorization': null},
      ),
    );

    if (response.data is Map<String, dynamic>) {
      return response.data['message']?.toString() ??
          'Activation request completed';
    }

    return response.data.toString();
  }

  // Check whether a token is stored.
  Future<bool> isLoggedIn() async {
    final token = await ApiClient.instance.getToken();

    return token != null && token.isNotEmpty;
  }

  // Log out and remove the stored token.
  Future<void> logout() async {
    await ApiClient.instance.logout();
  }
}