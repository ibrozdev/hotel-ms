import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthGuard {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  /// Check if user is authenticated by verifying JWT token existence
  static Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: 'jwt_token');
    return token != null && token.isNotEmpty;
  }

  /// Get the stored JWT token
  static Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  /// Get the stored user ID
  static Future<String?> getUserId() async {
    return await _storage.read(key: 'user_id');
  }

  /// Get the stored user role
  static Future<String?> getUserRole() async {
    return await _storage.read(key: 'user_role');
  }
}
