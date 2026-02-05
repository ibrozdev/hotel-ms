import 'package:flutter/material.dart';
import '../data/review_service.dart';

class ReviewProvider extends ChangeNotifier {
  final ReviewService _reviewService = ReviewService();
  List<dynamic> _reviews = [];
  bool _isLoading = false;

  List<dynamic> get reviews => _reviews;
  bool get isLoading => _isLoading;

  Future<void> fetchReviews(String serviceId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _reviews = await _reviewService.getReviews(serviceId);
    } catch (e) {
      print("Error fetching reviews: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addReview(
    String serviceId,
    double rating,
    String comment,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      final success = await _reviewService.addReview(
        serviceId,
        rating,
        comment,
      );
      if (success) {
        await fetchReviews(serviceId);
      }
      return success;
    } catch (e) {
      print("Error adding review: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
