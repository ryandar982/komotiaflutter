import 'package:flutter/material.dart';
import 'package:komotia/shared/models/barang_model.dart';
import 'package:komotia/shared/service/api_service.dart';

class BarangProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<BarangModel> _listBarang = [];
  List<BarangModel> get listBarang => _listBarang;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // READ
  Future<void> fetchBarang() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _apiService.getBarang();
      _listBarang = data.map((json) => BarangModel.fromJson(json)).toList();
    } catch (e) {
      print("Error memproses data barang: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // CREATE
  Future<bool> tambahBarang(Map<String, dynamic> dataBarang) async {
    bool success = await _apiService.addBarang(dataBarang);
    if (success) {
      await fetchBarang(); // Refresh UI setelah sukses
    }
    return success;
  }

  // UPDATE
  Future<bool> editBarang(int idProduct, Map<String, dynamic> dataBarang) async {
    bool success = await _apiService.updateBarang(idProduct, dataBarang);
    if (success) {
      await fetchBarang(); // Refresh UI setelah sukses
    }
    return success;
  }

  // DELETE
  Future<bool> hapusBarang(int idProduct) async {
    bool success = await _apiService.deleteBarang(idProduct);
    if (success) {
      await fetchBarang(); // Refresh UI setelah sukses
    }
    return success;
  }
}