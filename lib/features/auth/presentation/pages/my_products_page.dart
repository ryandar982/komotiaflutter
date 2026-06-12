import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:komotia/shared/provider/auth_provider.dart';
import 'package:komotia/shared/service/api_service.dart';
import 'package:komotia/features/auth/presentation/pages/add_product_page.dart';

class MyProductsPage extends StatefulWidget {
  const MyProductsPage({super.key});

  @override
  State<MyProductsPage> createState() => _MyProductsPageState();
}

class _MyProductsPageState extends State<MyProductsPage> {
  final ApiService _apiService = ApiService();
  List<dynamic> _myProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMyProducts();
  }

  Future<void> _fetchMyProducts() async {
    final userId = context.read<AuthProvider>().userId;
    if (userId == null) return;

    setState(() => _isLoading = true);
    final products = await _apiService.getProductsBySeller(userId);
    setState(() {
      _myProducts = products;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F6),
      appBar: AppBar(
        title: const Text('Produk Saya', style: TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: const Color(0xFF4B5320),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF4B5320)))
          : _myProducts.isEmpty
              ? _buildEmptyState()
              : _buildProductList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductPage()),
          );
          // Jika kembali dari halaman tambah produk dengan success = true
          if (result == true) {
            _fetchMyProducts();
          }
        },
        backgroundColor: const Color(0xFF4B5320),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Tambah Produk', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text(
            'Belum ada produk',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4A4A4A)),
          ),
          const SizedBox(height: 8),
          const Text(
            'Mulai tambahkan produk pertama Anda sekarang!',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return RefreshIndicator(
      onRefresh: _fetchMyProducts,
      color: const Color(0xFF4B5320),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _myProducts.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final product = _myProducts[index];
          final String imageUrl = (product['gambar'] != null && product['gambar'].toString().isNotEmpty && product['gambar'] != 'default.jpg')
              ? 'http://127.0.0.1:3000/uploads/${product['gambar']}'
              : 'assets/images/pupukkom.png'; // Fallback

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imageUrl.startsWith('http')
                    ? Image.network(imageUrl, width: 60, height: 60, fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Image.asset('assets/images/pupukkom.png', width: 60, height: 60, fit: BoxFit.cover))
                    : Image.asset(imageUrl, width: 60, height: 60, fit: BoxFit.cover),
              ),
              title: Text(
                product['nama_product'] ?? 'Tanpa Nama',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    'Rp ${double.parse(product['harga'].toString()).toStringAsFixed(0)}',
                    style: const TextStyle(color: Color(0xFF4B5320), fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text('Stok: ${product['stok']} ${product['satuan']}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur edit produk segera hadir!')),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
