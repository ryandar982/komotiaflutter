import 'package:flutter/material.dart';
import 'package:komotia/shared/widget/custom_app_bar.dart';
import 'package:komotia/shared/widget/custom_drawer.dart';
import 'package:komotia/shared/widget/promo_banner_section.dart';
import 'package:komotia/shared/widget/category_section.dart';
import 'package:komotia/shared/widget/free_shipping_product_section.dart'; 
import 'package:komotia/shared/widget/recommendation_section.dart';
import 'package:komotia/shared/widget/custom_bottom_nav_bar.dart';
import 'package:komotia/shared/widget/cart_content_widget.dart'; // ✅ Import Widget Keranjang

import 'package:komotia/features/auth/presentation/pages/buyer_dashboard.dart';
import 'package:komotia/features/auth/presentation/pages/explora_page.dart'; // ✅ Import Explora Page

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

    // Daftar halaman yang diupdate dengan CartContentWidget
    final List<Widget> pages = [
      _buildHomeContent(),                                     // Index 0: Beranda
      const ExploraPage(),                                        // Index 1: Jelajahi (Explora)
      const CartContentWidget(),                               // Index 2: Keranjang (TERINTEGRASI)
      const BuyerDashboardPage(),                              // Index 3: Profil / Dashboard
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const CustomAppBar(),
      drawer: CustomDrawer(
        onNavigateToTab: _onItemTapped,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}