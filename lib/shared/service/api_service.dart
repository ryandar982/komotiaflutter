import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // Digunakan untuk kIsWeb
import 'package:shared_preferences/shared_preferences.dart'; // Untuk menyimpan token JWT

class ApiService {
  // ==========================================
  // ⚙️ KONFIGURASI URL & HEADERS
  // ==========================================

  // Menyesuaikan IP secara otomatis: Web Browser vs Emulator Android
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000/api'; // ✅ Sudah ditambahkan /api
    } else {
      return 'http://10.0.2.2:3000/api';  // ✅ Sudah ditambahkan /api
    }
  }

  // Helper untuk mengambil header otomatis beserta Token JWT jika sudah login
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // Ambil token yang tersimpan

    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token', // Sisipkan token ke header
    };
  }


  // ==========================================
  // 1. FUNGSI REGISTER
  // ==========================================
  Future<bool> registerUser({
    required String nama,
    required String email,
    required String password,
    required String noTelp,
    required String alamat,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users'),
        headers: {'Content-Type': 'application/json'}, // Register belum butuh token
        body: jsonEncode({
          'nama': nama,
          'email': email,
          'password': password,
          'no_telp': noTelp,
          'alamat': alamat,
          'role': 'pembeli', 
        }),
      );

      print('Register Status Code: ${response.statusCode}');
      print('Register Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      print('Error Register API Catch: $e');
      return false;
    }
  }


  // ==========================================
  // 2. FUNGSI LOGIN
  // ==========================================
  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/login'),
        headers: {'Content-Type': 'application/json'}, // Login belum butuh token
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print('Login Status Code: ${response.statusCode}');
      print('Login Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // ✅ Ekstrak token dari respons JSON dan simpan ke memori lokal
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', data['token']);
          print('Token berhasil disimpan!');
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error Login API Catch: $e');
      return false;
    }
  }


  // ==========================================
  // 3. FUNGSI MASTER DATA BARANG (CRUD)
  // ==========================================
  
  // A. Mengambil Daftar Barang (GET)
  Future<List<dynamic>> getBarang() async {
    try {
      // ✅ Gunakan _getHeaders() agar membawa Token JWT
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
        headers: headers, 
      );
      
      print('Get Barang Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body); 
      }
      return [];
    } catch (e) {
      print('Error Get Barang: $e');
      return [];
    }
  }

  // B. Menambah Barang (POST)
  Future<bool> addBarang(Map<String, dynamic> dataBarang) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/products'),
        headers: headers,
        body: jsonEncode(dataBarang),
      );
      return response.statusCode == 201 || response.statusCode == 200; 
    } catch (e) {
      print('Error Add Barang: $e');
      return false;
    }
  }

  // C. Memperbarui Barang (PUT)
  Future<bool> updateBarang(int idProduct, Map<String, dynamic> dataBarang) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/products/$idProduct'),
        headers: headers,
        body: jsonEncode(dataBarang),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error Update Barang: $e');
      return false;
    }
  }

  // D. Menghapus Barang (DELETE)
  Future<bool> deleteBarang(int idProduct) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/products/$idProduct'),
        headers: headers,
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error Delete Barang: $e');
      return false;
    }
  }
  
  // ==========================================
  // 4. FUNGSI LOGOUT (Opsional tapi Penting)
  // ==========================================
  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Hapus token saat logout
  }
}