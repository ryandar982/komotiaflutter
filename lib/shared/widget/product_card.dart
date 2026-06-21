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

  // Format harga ke Rupiah (e.g. 773400 -> "773.400")
  String _formatRupiah(int value) {
    String text = value.toString();
    String result = '';
    int count = 0;
    for (int i = text.length - 1; i >= 0; i--) {
      result = text[i] + result;
      count++;
      if (count == 3 && i != 0) {
        result = '.$result';
        count = 0;
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    // Data produk
    final String imageUrl =
        (barang.gambar != null && barang.gambar!.startsWith('http'))
            ? barang.gambar!
            : 'https://picsum.photos/seed/${barang.idProduct}/400/300';
    final String category = barang.category ?? 'Umum';
    final String title = barang.namaProduct;
    final int harga = barang.harga ?? 0;
    final String deskripsi = barang.deskripsi ?? '';
    final int stok = barang.stok ?? 0;

    // Simulasi diskon (15% off)
    const int diskonPersen = 15;
    final int hargaAsli = (harga / (1 - diskonPersen / 100)).round();

    // Hardcode rating & terjual
    const String rating = '4.8';
    final String terjual = '$stok tersisa';

    const Color komotiaGreen = Color(0xFF4B5320);
    const Color komotiaLightGreen = Color(0xFFE5F0D3);

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
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ============================
            // Gambar Produk + Category Badge + Cart Button
            // ============================
            SizedBox(
              height: 150,
              child: Stack(
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.network(
                      imageUrl,
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.eco,
                                color: komotiaGreen.withValues(alpha: 0.4),
                                size: 40),
                            const SizedBox(height: 4),
                            Text(
                              category,
                              style: TextStyle(
                                fontSize: 10,
                                color: komotiaGreen.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Category Badge (bottom-left, overlapping image)
                  Positioned(
                    bottom: 8,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: komotiaGreen,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.eco,
                            color: Colors.white,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            category,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Add to Cart Button (top-right)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        context.read<CartProvider>().addItem(barang);
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                '${barang.namaProduct} ditambahkan ke keranjang!'),
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
                          size: 16,
                          color: komotiaGreen,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ============================
            // Info Produk
            // ============================
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 16, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Produk
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D2D2D),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Deskripsi singkat
                  if (deskripsi.isNotEmpty)
                    Text(
                      deskripsi,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),

                  const SizedBox(height: 8),

                  // Diskon Badge + Harga Asli (coret)
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: komotiaLightGreen,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          '$diskonPersen%',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: komotiaGreen,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Rp ${_formatRupiah(hargaAsli)}',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade400,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Colors.grey.shade400,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),

                  // Harga Final
                  Text(
                    'Rp ${_formatRupiah(harga)}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: komotiaGreen,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Rating + Terjual
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          terjual,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                        size: 14,
                      ),
                      const SizedBox(width: 2),
                      const Text(
                        rating,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF4A4A4A),
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