import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_constants.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Public endpoints that don't require authentication
  static const List<String> publicEndpoints = [
    ApiConstants.getServices,
    ApiConstants.login,
    ApiConstants.register,
  ];

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Check if this is a public endpoint
          final isPublicEndpoint = publicEndpoints.any(
            (endpoint) => options.path.contains(endpoint),
          );

          if (!isPublicEndpoint) {
            final token = await _storage.read(key: 'jwt_token');
            print(
              "ApiClient: Token from storage: ${token != null ? 'Present' : 'NULL'}",
            );
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
              print("ApiClient: Added Authorization header");
            } else {
              print("ApiClient: No token for protected endpoint!");
            }
          } else {
            print("ApiClient: Public endpoint, skipping auth");
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // Handle global errors (e.g. 401 Unauthorized -> Logout)
          if (e.response?.statusCode == 401) {
            // TODO: Trigger logout logic
            
          }
          return handler.next(e);
        },
      ),
    );
  }
}
