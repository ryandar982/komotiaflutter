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
  /// Mengembalikan Map dengan key 'success' (bool), 'nama' (String?), dan 'userId' (int?)
  Future<Map<String, dynamic>> loginUser({
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
        // ✅ Ekstrak token dan nama dari respons JSON dan simpan ke memori lokal
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', data['token']);
          print('Token berhasil disimpan!');
        }
        // Ambil nama user, id_user, dan role dari respons
        final String? nama = data['nama'] ?? data['user']?['nama'] ?? data['username'];
        final int? userId = data['user']?['id'];
        final String? role = data['user']?['role'];

        // Simpan userId ke SharedPreferences
        if (userId != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt('userId', userId);
        }

        return {'success': true, 'nama': nama, 'userId': userId, 'role': role};
      } else {
        return {'success': false, 'nama': null, 'userId': null};
      }
    } catch (e) {
      print('Error Login API Catch: $e');
      return {'success': false, 'nama': null, 'userId': null};
    }
  }


  // ==========================================
  // UPGRADE TO SELLER
  // ==========================================
  Future<bool> upgradeToSeller(int userId) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/users/$userId/upgrade-seller'),
        headers: await _getHeaders(),
      );

      print('Upgrade Seller Status: ${response.statusCode}');
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print('Error Upgrade Seller API: $e');
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

  // B. Mengambil Daftar Barang Khusus Penjual
  Future<List<dynamic>> getProductsBySeller(int userId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/products/seller/$userId'),
        headers: headers,
      );

      print('Get Products By Seller Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print('Error Get Products By Seller: $e');
      return [];
    }
  }

  // C. Menambah Produk Baru
  Future<bool> addProduct(Map<String, dynamic> data) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/products'),
        headers: headers,
        body: jsonEncode(data),
      );

      print('Add Product Status: ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      print('Error Add Product API: $e');
      return false;
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
  // 4. FUNGSI TRANSAKSI
  // ==========================================

  /// Membuat transaksi baru → return id_transaction atau null
  Future<int?> createTransaction({
    required int idUser,
    required double totalHarga,
    String? alamatPengiriman,
    String? metodePembayaran,
    String? catatan,
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/transactions'),
        headers: headers,
        body: jsonEncode({
          'id_user': idUser,
          'total_harga': totalHarga,
          'status': 'pending',
          'alamat_pengiriman': alamatPengiriman,
          'metode_pembayaran': metodePembayaran,
          'catatan': catatan,
        }),
      );

      print('Create Transaction Status: ${response.statusCode}');
      print('Create Transaction Body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['id_transaction'];
      }
      return null;
    } catch (e) {
      print('Error Create Transaction: $e');
      return null;
    }
  }

  /// Membuat detail transaksi (per item)
  Future<bool> createTransactionDetail({
    required int idTransaction,
    required int idProduct,
    required int jumlah,
    required double hargaSatuan,
    required double subtotal,
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/transaction-details'),
        headers: headers,
        body: jsonEncode({
          'id_transaction': idTransaction,
          'id_product': idProduct,
          'jumlah': jumlah,
          'harga_satuan': hargaSatuan,
          'subtotal': subtotal,
        }),
      );

      print('Create Transaction Detail Status: ${response.statusCode}');
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print('Error Create Transaction Detail: $e');
      return false;
    }
  }

  /// Mengambil daftar transaksi berdasarkan user
  Future<List<dynamic>> getTransactionsByUser(int idUser) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/transactions/user/$idUser'),
        headers: headers,
      );

      print('Get Transactions Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print('Error Get Transactions: $e');
      return [];
    }
  }

  /// Mengambil detail transaksi berdasarkan id_transaction
  Future<List<dynamic>> getTransactionDetails(int idTransaction) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/transaction-details/transaction/$idTransaction'),
        headers: headers,
      );

      print('Get Transaction Details Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print('Error Get Transaction Details: $e');
      return [];
    }
  }


  // ==========================================
  // 5. FUNGSI PEMBAYARAN (FIKTIF)
  // ==========================================

  /// Membuat pembayaran fiktif → return id_payment atau null
  Future<int?> createPayment({
    required int idTransaction,
    required double jumlahBayar,
    String? buktiTransfer,
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/payments'),
        headers: headers,
        body: jsonEncode({
          'id_transaction': idTransaction,
          'jumlah_bayar': jumlahBayar,
          'bukti_transfer': buktiTransfer ?? 'fiktif_bukti_${DateTime.now().millisecondsSinceEpoch}.jpg',
          'status_verifikasi': 'menunggu',
        }),
      );

      print('Create Payment Status: ${response.statusCode}');
      print('Create Payment Body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['id_payment'];
      }
      return null;
    } catch (e) {
      print('Error Create Payment: $e');
      return null;
    }
  }

  /// Update status transaksi menjadi 'dibayar' setelah payment dibuat
  Future<bool> updateTransactionStatus(int idTransaction, String status) async {
    try {
      final headers = await _getHeaders();
      final response = await http.patch(
        Uri.parse('$baseUrl/transactions/$idTransaction/status'),
        headers: headers,
        body: jsonEncode({'status': status}),
      );

      print('Update Transaction Status: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('Error Update Transaction Status: $e');
      return false;
    }
  }

  /// Mengambil payment berdasarkan id_transaction
  Future<Map<String, dynamic>?> getPaymentByTransaction(int idTransaction) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/payments/transaction/$idTransaction'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List && data.isNotEmpty) {
          return data[0];
        }
      }
      return null;
    } catch (e) {
      print('Error Get Payment: $e');
      return null;
    }
  }


  // ==========================================
  // 6. FUNGSI LOGOUT (Opsional tapi Penting)
  // ==========================================
  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Hapus token saat logout
  }
}