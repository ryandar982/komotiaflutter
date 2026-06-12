import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Tambahkan ini
import 'package:komotia/shared/provider/cart_provider.dart'; // Tambahkan ini
import 'package:komotia/shared/provider/auth_provider.dart'; // Tambahkan ini
import 'package:komotia/features/auth/presentation/pages/login_page.dart';
import 'package:komotia/features/auth/presentation/pages/cart_page.dart'; // Tambahkan ini
import 'package:komotia/features/auth/presentation/pages/explora_page.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 75, 83, 32),
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          );
        },
      ),
      leadingWidth: 56,
      titleSpacing: 0,
      title: Image.asset(
        'assets/images/komotia.png',
        height: 32,
        fit: BoxFit.contain,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        // --- BADGE NOTIFIKASI KERANJANG ---
        Consumer<CartProvider>(
          builder: (context, cart, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CartPage()),
                    );
                  },
                ),
                // Badge hanya muncul jika ada barang di keranjang
                if (cart.items.isNotEmpty)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color.fromARGB(255, 75, 83, 32),
                          width: 1.5,
                        ),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${cart.items.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        // ----------------------------------
        
        // --- TOMBOL LOGIN / USERNAME ---
        Consumer<AuthProvider>(
          builder: (context, auth, child) {
            if (auth.isLoggedIn && auth.username != null) {
              // Tampilkan username jika sudah login
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        auth.username!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              // Tampilkan tombol 'Masuk' jika belum login
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color.fromARGB(255, 75, 83, 32),
                    minimumSize: const Size(80, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Masuk'),
                ),
              );
            }
          },
        ),
        const SizedBox(width: 10),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: Text(
                            'Pencarian: $value',
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          backgroundColor: const Color.fromARGB(255, 75, 83, 32),
                          iconTheme: const IconThemeData(color: Colors.white),
                        ),
                        body: ExploraPage(initialQuery: value.trim()),
                      ),
                    ),
                  );
                }
              },
              decoration: InputDecoration(
                hintText: 'Cari produk, toko, atau kategori',
                hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 10.0),
                  child: Icon(Icons.search, color: Colors.grey, size: 26),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minHeight: 50,
                  minWidth: 50,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 70.0);
}