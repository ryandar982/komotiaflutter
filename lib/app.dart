import 'package:flutter/material.dart';
// Pastikan path ini mengarah ke file SplashScreen Anda dengan benar
import 'package:komotia/features/auth/presentation/pages/splash_screen.dart'; 

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Komotia', // Disesuaikan dengan nama aplikasi
      debugShowCheckedModeBanner: false, // Menghilangkan pita debug di kanan atas
      theme: ThemeData(
        // Menyesuaikan warna dasar aplikasi dengan hijau gelap khas Komotia
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4B5320)),
        useMaterial3: true,
      ),
      home: const SplashScreen(), // Menambahkan const untuk optimasi performa
    );
  }
}