import 'package:flutter/foundation.dart';

class ApiConstants {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:5000/api';
    }
    // Use the local IP address for mobile devices
    return 'http://192.168.100.18:5000/api';
  }

  static String get imageBaseUrl => baseUrl.replaceAll('/api', '');

  // Auth
  static const String login = '/auth/login';
  static const String register = '/users/register';
  static const String getUsers = '/users/getUsers';
  static const String updateUserData = '/users/updateUser'; // /:id
  static const String deleteUser = '/users/deleteUser'; // /:id

  // Services
  static const String createService = '/services/create';
  static const String getServices =
      '/services/getservice'; // Note: query params ?search=&price=
  static const String updateService = '/services/update'; // /:id
  static const String deleteService = '/services/delete'; // /:id

  // Bookings
  static const String createBooking = '/booking/create';
  static const String myBookings = '/booking/mybooking';
  static const String getAllBookings = '/booking/getbooking';
  static const String updateBooking = '/booking/update'; // /:id
  static const String deleteBooking = '/booking/delete'; // /:id
  static const String bookingStats = '/booking/stats';
}
