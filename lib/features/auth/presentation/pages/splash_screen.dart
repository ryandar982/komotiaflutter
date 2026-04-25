import 'package:flutter/material.dart';
import 'dart:async';
// Pastikan path import home_page.dart ini sesuai dengan struktur folder Anda
import 'home_page.dart'; 

class SplashScreen extends StatefulWidget {
  // 1. Ini adalah solusi untuk error "The constructor being called isn't a const constructor" di app.dart
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 2. Menambahkan const pada Duration untuk optimasi
    Timer(const Duration(seconds: 3), () {
      // 3. Mengecek apakah widget masih aktif sebelum melakukan navigasi (Best Practice)
      if (mounted) {
        Navigator.of(context).pushReplacement(
          // Gunakan const HomePage() jika HomePage memiliki const constructor
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF4B5320), // Warna background hijau Komotia
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo
            Image(
              image: AssetImage('assets/images/komotia.png'), 
              width: 150, 
            ),
            SizedBox(height: 24), 
            // loading icon
            CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}