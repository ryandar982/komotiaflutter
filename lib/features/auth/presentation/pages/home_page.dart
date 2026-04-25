import 'package:flutter/material.dart';
import 'package:komotia/shared/widget/custom_app_bar.dart';
import 'package:komotia/shared/widget/custom_drawer.dart';
import 'package:komotia/shared/widget/promo_banner_section.dart';
import 'package:komotia/shared/widget/category_section.dart';
import 'package:komotia/shared/widget/free_shipping_product_section.dart'; 
import 'package:komotia/shared/widget/recommendation_section.dart';
import 'package:komotia/shared/widget/custom_bottom_nav_bar.dart';

// Import halaman dashboard yang baru dibuat (Sesuaikan path jika ada di folder pages)
import 'package:komotia/features/auth/presentation/pages/buyer_dashboard.dart'; // <-- Sesuaikan path file utamanya

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Pindahkan isi beranda ke fungsi ini agar kode 'build' utama tetap rapi
  Widget _buildHomeContent() {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PromoBannerSection(),
            SizedBox(height: 32),
            CategorySection(),
            SizedBox(height: 32),
            FreeShippingProductsSection(),
            SizedBox(height: 32),
            RecommendationSection(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFF2F3EC);

    // Daftar halaman yang akan ditampilkan berdasarkan index Bottom Nav
    final List<Widget> pages = [
      _buildHomeContent(), // Index 0: Beranda
      const Center(child: Text('Halaman Jelajahi (Coming Soon)')), // Index 1: Jelajahi
      const Center(child: Text('Halaman Keranjang (Coming Soon)')), // Index 2: Keranjang
      const Center(child: Text('Halaman Wishlist (Coming Soon)')), // Index 3: Wishlist
      const BuyerDashboardPage(), // Index 4: Profil / Dashboard
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      // AppBar dan Drawer tetap dipertahankan agar selalu muncul di setiap tab
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      // Body akan berubah secara dinamis berdasarkan tab yang diklik
      body: pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}