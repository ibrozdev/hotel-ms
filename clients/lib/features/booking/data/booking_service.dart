import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_constants.dart';
import '../../../models/booking_model.dart';

class BookingService {
  final ApiClient _apiClient = ApiClient();

  Future<List<Booking>> getMyBookings() async {
    try {
      final response = await _apiClient.dio.get(ApiConstants.myBookings);
      final List data = response.data;
      return data.map((e) => Booking.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Booking>> getAllBookings() async {
    try {
      final response = await _apiClient.dio.get(ApiConstants.getAllBookings);
      // Backend returns { success: true, count: ..., data: [...] }
      final data = response.data;
      List listData = [];

      if (data is List) {
        listData = data;
      } else if (data is Map && data['data'] is List) {
        listData = data['data'];
      }

      return listData.map((e) => Booking.fromJson(e)).toList();
    } catch (e) {
      print("Get All Bookings Error: $e");
      rethrow;
    }
  }

  Future<bool> createBooking(
    String userId,
    String serviceId,
    DateTime checkIn,
    DateTime checkOut,
    String paymentMethod,
  ) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.createBooking,
        data: {
          "user": userId,
          "service": serviceId,
          "checkInDate": checkIn.toIso8601String().split('T')[0],
          "checkOutDate": checkOut.toIso8601String().split('T')[0],
          "paymentMethod": paymentMethod,
        },
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Create Booking Error: $e");
      if (e is DioException) {
        if (e.response?.data != null && e.response?.data is Map) {
          final data = e.response!.data as Map;
          if (data.containsKey('message')) {
            throw data['message']; // Throw the server message
          }
        }
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getStats() async {
    try {
      final response = await _apiClient.dio.get(ApiConstants.bookingStats);
      // Backend: { success: true, data: { totalRevenue: ... } }
      final data = response.data;
      if (data is Map && data.containsKey('data')) {
        return data['data'];
      }
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteBooking(String id) async {
    try {
      final response = await _apiClient.dio.delete(
        '${ApiConstants.deleteBooking}/$id',
      );
      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateBooking(String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.put(
        '${ApiConstants.updateBooking}/$id',
        data: data,
      );
      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }
}
