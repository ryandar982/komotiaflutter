import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:komotia/shared/models/barang_model.dart';
import 'package:komotia/shared/provider/cart_provider.dart';
import 'package:komotia/features/auth/presentation/pages/product_detail_page.dart';

class ProductCard extends StatelessWidget {
  final BarangModel barang;

  const ProductCard({
    super.key,
    required this.barang,
  });

  @override
  Widget build(BuildContext context) {
    // Siapkan data untuk ditampilkan
    String imageUrl = (barang.gambar != null && barang.gambar!.startsWith('http'))
        ? barang.gambar!
        : 'https://picsum.photos/seed/${barang.idProduct}/400/300';
    String tag = (barang.category ?? 'UMUM').toUpperCase();
    String title = barang.namaProduct;
    String price = 'Rp ${barang.harga ?? 0}';
    String rating = '4.8'; // Sementara hardcode
    String sold = '${barang.stok ?? 0} tersisa';
    
    const Color tagColor = Color(0xFFE5F0D3);
    const Color tagTextColor = Color(0xFF4B5320);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(barang: barang),
          ),
        );
      },
      child: Container(
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
            // Gambar Produk
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
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.eco, color: tagTextColor.withValues(alpha: 0.5), size: 40),
                          const SizedBox(height: 4),
                          Text(
                            tag,
                            style: TextStyle(
                              fontSize: 10,
                              color: tagTextColor.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Tombol Add to Cart
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      // Logika menambahkan barang ke keranjang
                      context.read<CartProvider>().addItem(barang);
                      
                      // Munculkan notifikasi sukses
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
                        Icons.add_shopping_cart,
                        size: 18,
                        color: Color(0xFF4B5320),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Info Produk
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
                      style: const TextStyle(
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
                      Flexible(
                        child: Text(
                          '| $sold',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}