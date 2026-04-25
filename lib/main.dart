import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:komotia/shared/provider/barang_provider.dart';
import 'package:komotia/shared/provider/cart_provider.dart'; // Import provider baru
import 'app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BarangProvider()),
        // Menambahkan CartProvider ke dalam daftar provider aplikasi
        ChangeNotifierProvider(create: (_) => CartProvider()), 
      ],
      child: const App(),
    ),
  );
}