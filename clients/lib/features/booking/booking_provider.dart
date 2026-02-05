import 'package:flutter/material.dart';
import '../../models/booking_model.dart';
import 'data/booking_service.dart';

class BookingProvider extends ChangeNotifier {
  final BookingService _bookingService = BookingService();
  List<Booking> _myBookings = [];
  List<Booking> _allBookings = [];
  Map<String, dynamic> _stats = {};
  bool _isLoading = false;

  List<Booking> get myBookings => _myBookings;
  List<Booking> get allBookings => _allBookings;
  Map<String, dynamic> get stats => _stats;
  bool get isLoading => _isLoading;

  Future<void> fetchMyBookings() async {
    _isLoading = true;
    notifyListeners();
    try {
      _myBookings = await _bookingService.getMyBookings();
    } catch (e) {
      debugPrint("Error fetching my bookings: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllBookings() async {
    _isLoading = true;
    notifyListeners();
    try {
      _allBookings = await _bookingService.getAllBookings();
    } catch (e) {
      debugPrint("Error fetching all bookings: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchStats() async {
    try {
      _stats = await _bookingService.getStats();
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching stats: $e");
    }
  }

  Future<String?> createBooking(
    String userId,
    String serviceId,
    DateTime checkIn,
    DateTime checkOut,
    String paymentMethod,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      final success = await _bookingService.createBooking(
        userId,
        serviceId,
        checkIn,
        checkOut,
        paymentMethod,
      );
      if (success) {
        // Optionally refresh bookings
        return null; // Success
      }
      return "Unknown error occurred";
    } catch (e) {
      debugPrint("Error creating booking: $e");
      if (e.toString().contains("DioException")) {
        // We know catch in service rethrows.
        return e.toString(); // Simplify for now, service should parse data
      }
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteBooking(String id) async {
    try {
      final success = await _bookingService.deleteBooking(id);
      if (success) {
        _myBookings.removeWhere((b) => b.id == id);
        _allBookings.removeWhere((b) => b.id == id);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateBooking(String id, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      final success = await _bookingService.updateBooking(id, data);
      if (success) {
        await fetchAllBookings(); // Refresh all bookings
        await fetchMyBookings(); // Refresh my bookings if relevant
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error updating booking: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
