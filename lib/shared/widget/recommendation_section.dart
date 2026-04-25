import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:komotia/shared/provider/barang_provider.dart';
import 'package:komotia/shared/provider/cart_provider.dart'; // Import CartProvider
import 'package:komotia/shared/models/barang_model.dart'; // Import BarangModel

class RecommendationSection extends StatefulWidget {
  const RecommendationSection({super.key});

  @override
  State<RecommendationSection> createState() => _RecommendationSectionState();
}

class _RecommendationSectionState extends State<RecommendationSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BarangProvider>().fetchBarang();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                'Rekomendasi untuk\nAnda',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D2D),
                  height: 1.2,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                debugPrint("Lihat Semua diklik");
              },
              child: const Text(
                'Lihat\nSemua',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Consumer<BarangProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: CircularProgressIndicator(color: Color(0xFF4B5320)),
                ),
              );
            }

            if (provider.listBarang.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Belum ada rekomendasi produk saat ini.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Row(
                children: provider.listBarang.map((barang) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: _buildProductCard(
                      context: context, // Oper context untuk Provider
                      barang: barang,   // Oper objek BarangModel utuh
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }

  // Modifikasi fungsi ini untuk menerima context dan BarangModel
  Widget _buildProductCard({
    required BuildContext context,
    required BarangModel barang,
  }) {
    // Siapkan data untuk ditampilkan
    String imageUrl = (barang.gambar != null && barang.gambar!.startsWith('http'))
        ? barang.gambar!
        : 'https://picsum.photos/seed/${barang.idProduct}/400/300';
    String tag = (barang.category ?? 'UMUM').toUpperCase();
    String title = barang.namaProduct;
    String price = 'Rp ${barang.harga ?? 0}';
    String rating = '4.8';
    String sold = '${barang.stok ?? 0} tersisa';
    const Color tagColor = Color(0xFFE5F0D3);
    const Color tagTextColor = Color(0xFF4B5320);

    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  imageUrl,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 140,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
                ),
              ),
              // --- GANTI IKON FAVORIT MENJADI TOMBOL ADD TO CART ---
              Positioned(
                top: 8,
                right: 8,
                child: InkWell(
                  onTap: () {
                    // Logika menambahkan barang ke keranjang
                    context.read<CartProvider>().addItem(barang);
                    
                    // (Opsional) Munculkan notifikasi kecil sukses di bawah layar
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${barang.namaProduct} ditambahkan ke keranjang!'),
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                        )
                      ],
                    ),
                    child: const Icon(
                      Icons.add_shopping_cart, // Ganti jadi ikon keranjang plus
                      size: 18,
                      color: Color(0xFF4B5320), // Gunakan warna hijau utama Komotia
                    ),
                  ),
                ),
              ),
              // -----------------------------------------------------
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: tagColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: tagTextColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D2D2D),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF4B5320),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      rating,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '| $sold',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}