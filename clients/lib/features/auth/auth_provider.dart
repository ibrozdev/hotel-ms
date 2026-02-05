import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'data/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _currentUser;
  List<User> _users = [];
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  List<User> get users => _users;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  bool get isAdmin => _currentUser?.role == 'admin';

  AuthProvider() {
    _loadUser();
  }

  Future<void> fetchUsers() async {
    _isLoading = true;
    notifyListeners();
    try {
      _users = await _authService.getUsers();
    } catch (e) {
      debugPrint("Error fetching users: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateUserRole(String id, String newRole) async {
    _isLoading = true;
    notifyListeners();
    try {
      final success = await _authService.updateUser(id, {'role': newRole});
      if (success) {
        await fetchUsers(); // Refresh list
      }
      return success;
    } catch (e) {
      debugPrint("Update user role error: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteUser(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      final success = await _authService.deleteUser(id);
      if (success) {
        _users.removeWhere((u) => u.id == id);
        notifyListeners();
      }
      return success;
    } catch (e) {
      debugPrint("Delete user error: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadUser() async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentUser = await _authService.getUserFromStorage();
    } catch (e) {
      debugPrint("Error loading user: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentUser = await _authService.login(email, password);
      notifyListeners();
      return null; // Success
    } catch (e) {
      debugPrint("Login error: $e");
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final user = await _authService.register(name, email, password);
      if (user != null) {
        _currentUser = user;
      }
      notifyListeners();
      return null; // Success
    } catch (e) {
      debugPrint("Register error: $e");
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    notifyListeners();
  }
}
