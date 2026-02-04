import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/service_model.dart';
import 'data/hotel_service.dart';

class ServiceProvider extends ChangeNotifier {
  final HotelRepository _hotelRepository = HotelRepository();
  List<HotelService> _services = [];
  bool _isLoading = false;

  List<HotelService> get services => _services;
  bool get isLoading => _isLoading;

  Future<void> fetchServices({
    String search = '',
    String price = '',
    String? category,
    String? type,
    double? minPrice,
    double? maxPrice,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      _services = await _hotelRepository.getServices(
        search: search,
        price: price,
        category: category,
        type: type,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );
    } catch (e) {
      debugPrint("Error fetching services: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
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
    XFile image,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      final success = await _hotelRepository.createService(
        name,
        price,
        category,
        type,
        description,
        maxCapacity,
        amenities,
        image,
      );
      if (success) {
        await fetchServices(); // Refresh list
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error creating service: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateService(
    String id,
    Map<String, dynamic> fields, [
    XFile? image,
  ]) async {
    _isLoading = true;
    notifyListeners();
    try {
      final success = await _hotelRepository.updateService(id, fields, image);
      if (success) {
        await fetchServices(); // Refresh list to get updated data
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error updating service: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteService(String id) async {
    try {
      final success = await _hotelRepository.deleteService(id);
      if (success) {
        _services.removeWhere((s) => s.id == id);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error deleting service: $e");
      return false;
    }
  }
}
