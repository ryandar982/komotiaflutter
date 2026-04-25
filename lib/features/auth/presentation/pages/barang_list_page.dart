import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:komotia/shared/provider/barang_provider.dart';
import 'barang_form_page.dart';

class BarangListPage extends StatefulWidget {
  const BarangListPage({super.key});

  @override
  State<BarangListPage> createState() => _BarangListPageState();
}

class _BarangListPageState extends State<BarangListPage> {
  @override
  void initState() {
    super.initState();
    // Memanggil API fetchBarang saat halaman pertama kali dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BarangProvider>().fetchBarang();
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF4B5320);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F6),
      appBar: AppBar(
        title: const Text('Master Data Barang', style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: primaryGreen,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      // Tombol Tambah Barang
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryGreen,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BarangFormPage()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      // Mendengarkan perubahan data dari Provider
      body: Consumer<BarangProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator(color: primaryGreen));
          }

          if (provider.listBarang.isEmpty) {
            return const Center(child: Text('Belum ada data barang.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.listBarang.length,
            itemBuilder: (context, index) {
              final barang = provider.listBarang[index];
              return Card(
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    barang.namaProduct,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text('Harga: Rp ${barang.harga} | Stok: ${barang.stok} ${barang.satuan ?? ''}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Tombol Edit
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BarangFormPage(barang: barang), // Kirim data untuk di-edit
                            ),
                          );
                        },
                      ),
                      // Tombol Hapus
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _konfirmasiHapus(context, provider, barang.idProduct),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Dialog Konfirmasi Hapus
  void _konfirmasiHapus(BuildContext context, BarangProvider provider, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Barang?'),
        content: const Text('Apakah Anda yakin ingin menghapus barang ini secara permanen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              bool success = await provider.hapusBarang(id);
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Barang berhasil dihapus!')),
                );
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}