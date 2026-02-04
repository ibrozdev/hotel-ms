import 'package:dio/dio.dart';
// import 'dart:io';
import 'package:http_parser/http_parser.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_constants.dart';
import '../../../models/service_model.dart';
import 'package:image_picker/image_picker.dart';

class HotelRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<HotelService>> getServices({
    String search = '',
    String price = '',
    String? category,
    String? type,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      final Map<String, dynamic> params = {};
      if (search.isNotEmpty) params['search'] = search;
      if (price.isNotEmpty) params['price'] = price;
      if (category != null && category.isNotEmpty) {
        params['category'] = category;
      }
      if (type != null && type.isNotEmpty) params['type'] = type;
      if (minPrice != null) params['price[gte]'] = minPrice;
      if (maxPrice != null) params['price[lte]'] = maxPrice;

      final response = await _apiClient.dio.get(
        ApiConstants.getServices,
        queryParameters: params,
      );
      print("Services Response: ${response.data}"); // Debug log

      // Handle if response.data is not directly a List (e.g. wrapped in object)
      final dynamic data = response.data;
      List listData = [];
      if (data is List) {
        listData = data;
      } else if (data is Map && data['services'] is List) {
        listData = data['services'];
      } else if (data is Map && data['data'] is List) {
        listData = data['data'];
      }

      return listData.map((e) => HotelService.fromJson(e)).toList();
    } catch (e) {
      print("Get Services Exception: $e");
      rethrow;
    }
  }

  Future<bool> createService(
    String name,
    String price,
    String category,
    String type,
    String description,
    int maxCapacity,
    List<String> amenities,
    XFile imageFile,
  ) async {
    try {
      FormData formData = FormData.fromMap({
        "serviceName": name,
        "price": price,
        "category": category,
        "type": type,
        "description": description,
        "maxCapacity": maxCapacity,
        "amenities":
            amenities, // Dio handles list as multiple form-data entries or array depending on server expect
        "image": MultipartFile.fromBytes(
          await imageFile.readAsBytes(),
          filename: imageFile.name,
          contentType: MediaType('image', 'jpeg'),
        ),
      });

      final response = await _apiClient.dio.post(
        ApiConstants.createService,
        data: formData,
      );

      print(
        "Create Service Response: ${response.statusCode} - ${response.data}",
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Create Service Error: $e");
      if (e is DioException) {
        print("Dio Error Data: ${e.response?.data}");
      }
      rethrow;
    }
  }

  Future<bool> updateService(
    String id,
    Map<String, dynamic> fields, [
    XFile? imageFile,
  ]) async {
    try {
      dynamic data;
      if (imageFile != null) {
        FormData formData = FormData.fromMap({
          ...fields,
          "image": MultipartFile.fromBytes(
            await imageFile.readAsBytes(),
            filename: imageFile.name,
            contentType: MediaType('image', 'jpeg'),
          ),
        });
        data = formData;
      } else {
        data = fields;
      }

      final response = await _apiClient.dio.put(
        '${ApiConstants.updateService}/$id',
        data: data,
      );

      print(
        "Update Service Response: ${response.statusCode} - ${response.data}",
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Update Service Error: $e");
      if (e is DioException) {
        print("Dio Error Data: ${e.response?.data}");
      }
      return false;
    }
  }

  Future<bool> deleteService(String id) async {
    try {
      final response = await _apiClient.dio.delete(
        '${ApiConstants.deleteService}/$id',
      );
      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }
}
