import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:komotia/shared/provider/barang_provider.dart';
import 'package:komotia/shared/widget/product_card.dart'; // Import ProductCard

class FreeShippingProductsSection extends StatefulWidget {
  const FreeShippingProductsSection({super.key});

  @override
  State<FreeShippingProductsSection> createState() => _FreeShippingProductsSectionState();
}

class _FreeShippingProductsSectionState extends State<FreeShippingProductsSection> {
  
  @override
  void initState() {
    super.initState();
    // Meminta data dari backend saat widget ini dimuat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BarangProvider>().fetchBarang();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Section (Tetap sama)
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
        
        // List Produk Horizontal menggunakan Consumer & ProductCard
        Consumer<BarangProvider>(
          builder: (context, provider, child) {
            // Tampilkan loading jika data sedang diambil
            if (provider.isLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: CircularProgressIndicator(color: Color(0xFF4B5320)),
                ),
              );
            }

            // Tampilkan pesan kosong jika tidak ada data
            if (provider.listBarang.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Belum ada produk gratis ongkir saat ini.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            // Tampilkan list produk menggunakan ProductCard
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Row(
                children: provider.listBarang.map((barang) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: ProductCard(barang: barang), // Memanggil widget yang sudah di-refactor
                  );
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }
}