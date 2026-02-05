import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';

class ReviewService {
  final ApiClient _apiClient = ApiClient();

  Future<List<dynamic>> getReviews(String serviceId) async {
    try {
      final response = await _apiClient.dio.get('/reviews/$serviceId');
      return response.data['data'];
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> addReview(
    String serviceId,
    double rating,
    String comment,
  ) async {
    try {
      final response = await _apiClient.dio.post(
        '/reviews/$serviceId',
        data: {"rating": rating, "comment": comment},
      );
      return response.statusCode == 201;
    } catch (e) {
      rethrow;
    }
  }
}
