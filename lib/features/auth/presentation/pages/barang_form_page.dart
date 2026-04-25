import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:komotia/shared/provider/barang_provider.dart';
import 'package:komotia/shared/models/barang_model.dart'; // Sesuaikan path

class BarangFormPage extends StatefulWidget {
  final BarangModel? barang; // Jika null berarti Tambah, jika ada berarti Edit

  const BarangFormPage({super.key, this.barang});

  @override
  State<BarangFormPage> createState() => _BarangFormPageState();
}

class _BarangFormPageState extends State<BarangFormPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers untuk input teks
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();
  final TextEditingController _kategoriController = TextEditingController();
  final TextEditingController _satuanController = TextEditingController();

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Jika sedang dalam mode Edit, isi form dengan data yang sudah ada
    if (widget.barang != null) {
      _namaController.text = widget.barang!.namaProduct;
      _deskripsiController.text = widget.barang!.deskripsi ?? '';
      _hargaController.text = widget.barang!.harga?.toString() ?? '0';
      _stokController.text = widget.barang!.stok?.toString() ?? '0';
      _kategoriController.text = widget.barang!.category ?? '';
      _satuanController.text = widget.barang!.satuan ?? '';
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    _hargaController.dispose();
    _stokController.dispose();
    _kategoriController.dispose();
    _satuanController.dispose();
    super.dispose();
  }

  Future<void> _simpanData() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);

      // Susun data sesuai dengan expected req.body di Express.js
      Map<String, dynamic> dataBarang = {
        'nama_product': _namaController.text,
        'deskripsi': _deskripsiController.text,
        'price': int.parse(_hargaController.text), 
        'harga': int.parse(_hargaController.text), // Mengisi harga dan price dengan nilai yang sama
        'category': _kategoriController.text,
        'stok': int.parse(_stokController.text),
        'satuan': _satuanController.text,
        'gambar': 'default.jpg', // Dummy gambar sementara
        'id_user': 1, // Dummy ID User (bisa diganti dengan session login nanti)
        'id_category': 1, 
      };

      bool success;
      if (widget.barang == null) {
        // Mode Tambah (CREATE)
        success = await context.read<BarangProvider>().tambahBarang(dataBarang);
      } else {
        // Mode Edit (UPDATE)
        success = await context.read<BarangProvider>().editBarang(widget.barang!.idProduct, dataBarang);
      }

      setState(() => _isSaving = false);

      if (success && mounted) {
        Navigator.pop(context); // Kembali ke list jika sukses
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.barang == null ? 'Berhasil menambah barang!' : 'Berhasil mengubah barang!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menyimpan data barang.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF4B5320);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.barang == null ? 'Tambah Barang' : 'Ubah Barang', style: const TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: primaryGreen,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isSaving 
        ? const Center(child: CircularProgressIndicator(color: primaryGreen))
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(_namaController, 'Nama Produk', TextInputType.text),
                  _buildTextField(_deskripsiController, 'Deskripsi', TextInputType.text),
                  _buildTextField(_hargaController, 'Harga (Rp)', TextInputType.number),
                  _buildTextField(_stokController, 'Stok', TextInputType.number),
                  _buildTextField(_satuanController, 'Satuan (cth: Kg, Liter)', TextInputType.text),
                  _buildTextField(_kategoriController, 'Kategori (cth: Pupuk)', TextInputType.text),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: _simpanData,
                      child: const Text('Simpan Data', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),
        ),
    );
  }

  // Widget bantuan untuk membuat Form Input agar rapi
  Widget _buildTextField(TextEditingController controller, String label, TextInputType type) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label tidak boleh kosong';
          }
          return null;
        },
      ),
    );
  }
}