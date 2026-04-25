import 'package:flutter/material.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
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
        // Barisan Ikon Kategori
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildCategoryItem(Icons.grass, 'Bibit'),
            _buildCategoryItem(Icons.eco, 'Pupuk'),
            _buildCategoryItem(Icons.build, 'Alat Tani'),
            _buildCategoryItem(Icons.pest_control, 'Pestisida'),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          height: 64,
          width: 64,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: const Color(0xFF4B5320), // Warna hijau gelap Komotia
            size: 32,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4A4A4A),
          ),
        ),
      ],
    );
  }
}