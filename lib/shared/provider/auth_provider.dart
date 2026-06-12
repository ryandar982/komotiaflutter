import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String? _username;
  int? _userId;
  String? _role;
  bool _isLoggedIn = false;

  String? get username => _username;
  int? get userId => _userId;
  String? get role => _role;
  bool get isLoggedIn => _isLoggedIn;

  /// Memuat status login dari SharedPreferences saat aplikasi pertama kali dibuka
  Future<void> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final nama = prefs.getString('username');
    final id = prefs.getInt('userId');
    final roleUser = prefs.getString('role');

    if (token != null && nama != null) {
      _isLoggedIn = true;
      _username = nama;
      _userId = id;
      _role = roleUser;
      notifyListeners();
    }
  }

  /// Menyimpan data user setelah login berhasil
  Future<void> setLoggedIn(String username, {int? userId, String? role}) async {
    _isLoggedIn = true;
    _username = username;
    _userId = userId;
    _role = role;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    if (userId != null) {
      await prefs.setInt('userId', userId);
    }
    if (role != null) {
      await prefs.setString('role', role);
    }

    notifyListeners();
  }

  /// Update role (misal: saat upgrade jadi penjual)
  Future<void> updateRole(String newRole) async {
    _role = newRole;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('role', newRole);
    notifyListeners();
  }

  /// Menghapus data user saat logout
  Future<void> logout() async {
    _isLoggedIn = false;
    _username = null;
    _userId = null;
    _role = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('username');
    await prefs.remove('userId');
    await prefs.remove('role');

    notifyListeners();
  }
}
