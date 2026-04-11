import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/token_storage.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _token;
  UserModel? _user;
  int? _userId;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;
  UserModel? get user => _user;
  String? get token => _token;
  int? get userId => _userId;

  AuthProvider() {
    _initAutoLogin();
  }

  Future<void> _initAutoLogin() async {
    final savedToken = await TokenStorage.getToken();
    if (savedToken != null && savedToken.isNotEmpty) {
      _token = savedToken;
      _userId = await TokenStorage.getUserId();
      notifyListeners();
    }
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await ApiService().login(username, password);
      if (result['success'] == true) {
        _token = result['token'];
        _userId = result['userId'];
        _user = UserModel.fromJson(result['user'] ?? {});
        
        await TokenStorage.saveToken(_token!, _userId!);
        
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    _userId = null;
    await TokenStorage.clearToken();
    notifyListeners();
  }
}