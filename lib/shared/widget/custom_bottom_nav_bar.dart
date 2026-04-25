import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      // Penting: gunakan 'fixed' agar semua 5 ikon dan teks tetap muncul
      type: BottomNavigationBarType.fixed, 
      backgroundColor: Colors.white,
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      // Warna biru keunguan sesuai dengan referensi gambar Anda
      selectedItemColor: const Color(0xFF3C5A99), 
      unselectedItemColor: Colors.grey.shade400,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      elevation: 10,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore), // Bisa juga pakai Icons.compass_calibration
          label: 'Jelajahi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Keranjang',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Wishlist',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }
}