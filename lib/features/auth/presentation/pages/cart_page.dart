import 'package:flutter/material.dart';
// Pastikan path import ini mengarah ke file widget yang baru dibuat di atas
import 'package:komotia/shared/widget/cart_content_widget.dart'; 

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF4B5320);
    const Color bgColor = Color(0xFFF9F9F6);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryGreen,
        elevation: 0,
        title: const Text('Keranjang Saya', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      // Memanggil widget konten
      body: const CartContentWidget(), 
    );
  }
}