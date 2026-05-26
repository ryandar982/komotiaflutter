import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:komotia/shared/provider/barang_provider.dart';
// Pastikan path import ini sesuai dengan lokasi file ProductCard-mu
import 'package:komotia/shared/widget/product_card.dart'; 

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
                    // Memanggil widget ProductCard yang baru
                    child: ProductCard(barang: barang), 
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