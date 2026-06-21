import 'package:flutter/material.dart';
import 'package:komotia/features/auth/presentation/pages/explora_page.dart';
import 'package:komotia/shared/widget/custom_app_bar.dart';
import 'package:komotia/shared/widget/custom_bottom_nav_bar.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> categories = [
      {'name': 'Bibit', 'image': 'assets/images/kategori-bibit.jpg'},
      {'name': 'Pupuk', 'image': 'assets/images/kategori-pupuk.jpg'},
      {'name': 'Alat Tani', 'image': 'assets/images/kategori-alat.jpg'},
      {'name': 'Pestisida', 'image': 'assets/images/kategori-pestisida.jpg'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul Kategori dengan Garis
        Row(
          children: [
            const Text(
              'Kategori Unggulan Minggu Ini',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A4A4A),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Divider(
                color: Colors.grey.shade400,
                thickness: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Horizontal Scrollable Category Cards
        SizedBox(
          height: 280,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              return _CategoryCard(
                categoryName: categories[index]['name']!,
                imagePath: categories[index]['image']!,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String categoryName;
  final String imagePath;

  const _CategoryCard({
    required this.categoryName,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToCategory(context),
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),

              // "Cari Produk" Button at the bottom (leaf shape)
              Positioned(
                bottom: 20,
                left: 24,
                right: 24,
                child: GestureDetector(
                  onTap: () => _navigateToCategory(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4B5320).withValues(alpha: 0.80),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4B5320).withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Cari Produk',
                        style: TextStyle(
                          fontFamily: 'Prata',
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToCategory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: const Color(0xFFF2F3EC),
          appBar: const CustomAppBar(),
          body: ExploraPage(initialQuery: categoryName),
          bottomNavigationBar: CustomBottomNavBar(
            selectedIndex: 1,
            onItemTapped: (index) {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}