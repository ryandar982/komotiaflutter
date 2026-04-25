import 'package:flutter/material.dart';

class FreeShippingProductsSection extends StatelessWidget {
  const FreeShippingProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.local_shipping, color: Color(0xFF4B5320)),
                const SizedBox(width: 8),
                const Text(
                  'Gratis Ongkir',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D2D2D),
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                debugPrint("Lihat Semua Gratis Ongkir diklik");
              },
              child: const Text(
                'Lihat Semua',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // List Produk Horizontal
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: [
              _buildFreeShippingCard(
                imageUrl: 'https://picsum.photos/id/289/400/300', // Ganti dengan asset lokal nantinya
                tag: 'ORGANIK',
                tagColor: const Color(0xFFE5F0D3),
                tagTextColor: const Color(0xFF4B5320),
                title: 'Organic Liquid Fertilizer 1L',
                price: 'Rp 85.000',
                rating: '4.9',
                sold: '2k terjual',
                isFavorite: true,
              ),
              const SizedBox(width: 16),
              _buildFreeShippingCard(
                imageUrl: 'https://picsum.photos/id/225/400/300',
                tag: 'SINTETIS',
                tagColor: const Color(0xFFF3E5F5),
                tagTextColor: const Color(0xFF6A1B9A),
                title: 'Pupuk NPK Mutiara 16-16-16 (1 Kg)',
                price: 'Rp 22.000',
                rating: '4.8',
                sold: '5rb+ terjual',
                isFavorite: false,
              ),
              const SizedBox(width: 16),
              _buildFreeShippingCard(
                imageUrl: 'https://picsum.photos/id/111/400/300',
                tag: 'ALAT TANI',
                tagColor: const Color(0xFFE3F2FD),
                tagTextColor: const Color(0xFF1565C0),
                title: 'Polybag Tanaman 15x15 (Isi 100)',
                price: 'Rp 12.500',
                rating: '4.7',
                sold: '10rb+ terjual',
                isFavorite: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Fungsi untuk membangun kartu produk sesuai desain baru
  Widget _buildFreeShippingCard({
    required String imageUrl,
    required String tag,
    required Color tagColor,
    required Color tagTextColor,
    required String title,
    required String price,
    required String rating,
    required String sold,
    required bool isFavorite,
  }) {
    return Container(
      width: 160, // Lebar disesuaikan agar proporsional
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
          // Gambar Produk & Tombol Favorit (Hati)
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network( // Ubah ke Image.asset jika menggunakan gambar lokal
                  imageUrl,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // Tombol Bulat Favorit di Kanan Atas
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.85),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.favorite,
                    size: 20,
                    color: isFavorite ? const Color(0xFFF44336) : Colors.grey.shade400,
                  ),
                ),
              ),
            ],
          ),
          
          // Detail Produk
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tag Kategori (ORGANIK)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                
                // Nama Produk
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D2D2D),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Harga
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF4B5320), // Hijau gelap Komotia
                  ),
                ),
                const SizedBox(height: 8),
                
                // Rating dan Terjual
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      rating,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D2D2D),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '| $sold',
                      style: TextStyle(
                        fontSize: 12,
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