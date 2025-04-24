import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;
  bool _isInitialized = false;

  final _storage = const FlutterSecureStorage();
  
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _isLoading = true;
    notifyListeners();
    try {
      // Set the base URL for API service
      ApiService.setBaseUrl('http://localhost:5000/api');
      
      final token = await _storage.read(key: 'token');
      print("Token");
      print(token);
      if (token != null && token.isNotEmpty) {
        ApiService.setToken(token);
        final profile = await ApiService.getProfile();
        _user = User.fromJson(profile['data']['user']);
      } else {
        ApiService.setToken('');
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
      _user = null;
      await _storage.delete(key: 'token');
      ApiService.setToken('');
    } finally {
      _isLoading = false;
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.login(email, password);
      _user = User.fromJson(response['user']);
      ApiService.setToken(response['token']);
      await _storage.write(key: 'token', value: response['token']);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _user = null;
      ApiService.setToken('');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(User user, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.register(user, password);
      _user = User.fromJson(response['user']);
      ApiService.setToken(response['token']);
      await _storage.write(key: 'token', value: response['token']);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _user = null;
      ApiService.setToken('');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _user = null;
    _error = null;
    await _storage.delete(key: 'token');
    ApiService.setToken('');
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  Future<void> updateProfile({
    required String fullName,
    required String companyName,
    required String companySector,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedUser = User(
        id: _user!.id,
        fullName: fullName,
        email: _user!.email,
        role: _user!.role,
        companyName: companyName,
        companySector: companySector,
      );

      await ApiService.updateProfile(updatedUser);
      _user = updatedUser;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 