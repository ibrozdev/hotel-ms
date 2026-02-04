import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_constants.dart';
import '../../../models/user_model.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<User?> login(String email, String password) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        // Verify response structure based on README: { message: "...", user: { ... }, token: "..." }
        print("Login Response Data: $data"); // DEBUG: Print full response

        // Try to find token in multiple places
        String? token = data['token'];
        if (token == null && data['user'] != null && data['user'] is Map) {
          token = data['user']['token'];
        }
        if (token == null && data['accessToken'] != null) {
          token = data['accessToken'];
        }

        final user = User.fromJson(data['user']);
        print("AuthService: Parsed User ID: '${user.id}'"); // DEBUG

        if (token != null) {
          print("AuthService: Token found and saved.");
          await _storage.write(key: 'jwt_token', value: token);
          await _storage.write(key: 'user_role', value: user.role);
          await _storage.write(key: 'user_id', value: user.id);
          await _storage.write(key: 'user_name', value: user.name);
          await _storage.write(key: 'user_email', value: user.email);
        } else {
          print(
            "CUSTOM_ERROR: Token is NULL in login response! Response keys: ${data.keys}",
          );
        }

        return user;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<User?> register(String name, String email, String password) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'role': 'customer', // Default role to match backend enum
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        print("Register Response Data: $data");

        // Extract data object from response
        final userData = data['data'];

        if (userData != null && userData is Map<String, dynamic>) {
          String? token = userData['token'];

          if (token != null) {
            await _storage.write(key: 'jwt_token', value: token);

            final user = User.fromJson(userData);
            await _storage.write(key: 'user_role', value: user.role);
            await _storage.write(key: 'user_id', value: user.id);
            await _storage.write(key: 'user_name', value: user.name);
            await _storage.write(key: 'user_email', value: user.email);
            return user;
          }
        }
        return null;
      }
    } catch (e) {
      if (e is DioException) {
        print(
          "Register DioError: ${e.response?.statusCode} - ${e.response?.data}",
        );
      }
      rethrow;
    }
    return null;
  }

  Future<void> logout() async {
    await _storage.deleteAll();
  }

  Future<User?> getUserFromStorage() async {
    final token = await _storage.read(key: 'jwt_token');
    if (token == null) return null;

    final id = await _storage.read(key: 'user_id');
    final name = await _storage.read(key: 'user_name');
    final email = await _storage.read(key: 'user_email');
    final role = await _storage.read(key: 'user_role');

    if (id != null && name != null && email != null && role != null) {
      return User(id: id, name: name, email: email, role: role);
    }
    return null;
  }

  Future<List<User>> getUsers() async {
    try {
      final response = await _apiClient.dio.get(ApiConstants.getUsers);
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((json) => User.fromJson(json)).toList();
      }
    } catch (e) {
      rethrow;
    }
    return [];
  }

  Future<bool> updateUser(String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.put(
        '${ApiConstants.updateUserData}/$id',
        data: data,
      );
      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteUser(String id) async {
    try {
      final response = await _apiClient.dio.delete(
        '${ApiConstants.deleteUser}/$id',
      );
      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }
}
