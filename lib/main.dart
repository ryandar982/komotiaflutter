import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:komotia/shared/provider/barang_provider.dart';
import 'package:komotia/shared/provider/cart_provider.dart'; // Import provider baru
import 'package:komotia/shared/provider/auth_provider.dart'; // Import auth provider
import 'app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BarangProvider()),
        // Menambahkan CartProvider ke dalam daftar provider aplikasi
        ChangeNotifierProvider(create: (_) => CartProvider()), 
        // Menambahkan AuthProvider untuk mengelola status login
        ChangeNotifierProvider(create: (_) => AuthProvider()..loadUserFromPrefs()),
      ],
      child: const App(),
    ),
  );
}