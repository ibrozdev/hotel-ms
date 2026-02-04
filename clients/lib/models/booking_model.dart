import 'service_model.dart';
import 'user_model.dart';

class Booking {
  final String id;
  final User? user; // Can be object or ID depending on population
  final HotelService? service;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final String status; // e.g. 'Confirmed', 'Pending'
  final String bookingId;

  Booking({
    required this.id,
    this.user,
    this.service,
    required this.checkInDate,
    required this.checkOutDate,
    this.status = 'Confirmed',
    this.bookingId = '',
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['_id'] ?? '',
      user: json['user'] is Map<String, dynamic>
          ? User.fromJson(json['user'])
          : null,
      service: json['service'] is Map<String, dynamic>
          ? HotelService.fromJson(json['service'])
          : null,
      checkInDate: DateTime.parse(json['checkInDate']),
      checkOutDate: DateTime.parse(json['checkOutDate']),
      status: json['status'] ?? 'Confirmed',
      bookingId: json['bookingId'] ?? '',
    );
  }
}
