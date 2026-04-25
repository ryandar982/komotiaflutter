import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // Digunakan untuk kIsWeb

class ApiService {
  // Menyesuaikan IP secara otomatis: Web Browser vs Emulator Android
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000'; // URL untuk Chrome/Edge (Web)
    } else {
      return 'http://10.0.2.2:3000'; // URL khusus Emulator Android
    }
  }

  Future<bool> registerUser({
    required String nama,
    required String email,
    required String password,
    required String noTelp,
    required String alamat,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users'), // Mengarah ke router.post("/") di users.js
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nama': nama,
          'email': email,
          'password': password,
          'no_telp': noTelp,
          'alamat': alamat,
          'role': 'pembeli', // Pastikan role ini sesuai dengan enum di database
        }),
      );

      print('Register Status Code: ${response.statusCode}');
      print('Register Response Body: ${response.body}');

      // Jika berhasil menambah data, Express biasanya mengirim status 201 (Created) atau 200 (OK)
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
      // Mengarah ke router.post("/login") di dalam router users.js
      final response = await http.post(
        Uri.parse('$baseUrl/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print('Login Status Code: ${response.statusCode}');
      print('Login Response Body: ${response.body}');

      // Jika backend mengirim status 200, berarti email & password cocok
      if (response.statusCode == 200) {
        return true;
      } else {
        // Jika status 401 atau lainnya, berarti gagal login
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
      final response = await http.get(Uri.parse('$baseUrl/products'));
      
      if (response.statusCode == 200) {
        // Backend Anda mereturn array langsung: res.json(results)
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
      final response = await http.post(
        Uri.parse('$baseUrl/products'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dataBarang),
      );
      // Backend mengembalikan status 201 saat berhasil POST
      return response.statusCode == 201; 
    } catch (e) {
      print('Error Add Barang: $e');
      return false;
    }
  }

  // C. Memperbarui Barang (PUT)
  Future<bool> updateBarang(int idProduct, Map<String, dynamic> dataBarang) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/products/$idProduct'),
        headers: {'Content-Type': 'application/json'},
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
      final response = await http.delete(Uri.parse('$baseUrl/products/$idProduct'));
      return response.statusCode == 200;
    } catch (e) {
      print('Error Delete Barang: $e');
      return false;
    }
  }
}