import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:komotia/shared/provider/auth_provider.dart';
import 'package:komotia/shared/service/api_service.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  final _namaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _hargaController = TextEditingController();
  final _stokController = TextEditingController();
  
  String _selectedSatuan = 'Kg';
  int _selectedCategoryId = 1; // Default to 'Pupuk'
  
  bool _isLoading = false;

  final List<String> _satuanOptions = ['Kg', 'Liter', 'Karung', 'Pcs', 'Gram'];
  
  // Mapping kategori statis sesuai dengan komotia-baru.sql
  final List<Map<String, dynamic>> _kategoriOptions = [
    {'id': 1, 'name': 'Pupuk'},
    {'id': 2, 'name': 'Pupuk Organik'},
    {'id': 3, 'name': 'Bibit'},
    {'id': 4, 'name': 'Elektronik'},
    {'id': 5, 'name': 'Alat Pertanian'},
  ];

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    _hargaController.dispose();
    _stokController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final userId = context.read<AuthProvider>().userId;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anda harus login terlebih dahulu')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final Map<String, dynamic> productData = {
      'nama_product': _namaController.text,
      'deskripsi': _deskripsiController.text,
      'harga': int.parse(_hargaController.text),
      'stok': int.parse(_stokController.text),
      'satuan': _selectedSatuan,
      'gambar': 'default.jpg', // Gambar default
      'id_user': userId,
      'id_category': _selectedCategoryId,
    };

    final success = await _apiService.addProduct(productData);

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk berhasil ditambahkan!')),
      );
      Navigator.pop(context, true); // true indicates success
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menambahkan produk')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Tambah Produk', style: TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: const Color(0xFF4B5320),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Color(0xFF4B5320)))
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Informasi Produk', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  
                  // Nama Produk
                  TextFormField(
                    controller: _namaController,
                    decoration: InputDecoration(
                      labelText: 'Nama Produk',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.inventory_2_outlined),
                    ),
                    validator: (value) => value!.isEmpty ? 'Nama produk wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),

                  // Deskripsi
                  TextFormField(
                    controller: _deskripsiController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Deskripsi Produk',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      // Harga
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _hargaController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Harga (Rp)',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            prefixIcon: const Icon(Icons.attach_money),
                          ),
                          validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      // Stok
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: _stokController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Stok',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      // Kategori
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<int>(
                          value: _selectedCategoryId,
                          decoration: InputDecoration(
                            labelText: 'Kategori',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            prefixIcon: const Icon(Icons.category_outlined),
                          ),
                          items: _kategoriOptions.map((kategori) {
                            return DropdownMenuItem<int>(
                              value: kategori['id'],
                              child: Text(kategori['name']),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategoryId = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      // Satuan
                      Expanded(
                        flex: 1,
                        child: DropdownButtonFormField<String>(
                          value: _selectedSatuan,
                          decoration: InputDecoration(
                            labelText: 'Satuan',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          items: _satuanOptions.map((satuan) {
                            return DropdownMenuItem<String>(
                              value: satuan,
                              child: Text(satuan),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedSatuan = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Tombol Simpan
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4B5320),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Simpan Produk', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
