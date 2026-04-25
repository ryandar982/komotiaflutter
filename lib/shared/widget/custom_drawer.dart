import 'package:flutter/material.dart';
// Sesuaikan path import ini jika berbeda
import 'package:komotia/features/auth/presentation/pages/barang_list_page.dart';
import 'package:komotia/features/auth/presentation/pages/transaction_page.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisi warna yang mendekati gambar
    const Color primaryGreen = Color(0xFF4A5D23); 
    const Color bgColor = Color(0xFFF9F9F6); 
    const Color textColor = Color(0xFF7A8262); 

    return Drawer(
      backgroundColor: bgColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Header & Tombol Login
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/komotiahijau.png',
                    width: 120,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Tambahkan aksi navigasi ke halaman login
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.login, size: 20),
                      label: const Text(
                        'Login Atau Daftar',
                        style: TextStyle(
                          letterSpacing: 1.0,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Garis Pembatas
            const Divider(color: Color(0xFFE5E5DF), thickness: 1, height: 1),
            const SizedBox(height: 16),
            
            // Daftar Menu
            _buildMenuItem(
              icon: Icons.category,
              title: 'Cari Kategori',
              textColor: textColor,
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.help,
              title: 'Pusat Bantuan',
              textColor: textColor,
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.info,
              title: 'Tentang Komotia',
              textColor: textColor,
              onTap: () {},
            ),

            // --- MENU MASTER DATA BARANG ---
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Divider(color: Color(0xFFE5E5DF), thickness: 1),
            ),
            _buildMenuItem(
              icon: Icons.inventory_2,
              title: 'Master Data Barang',
              textColor: primaryGreen, // Warna dibuat menonjol
              onTap: () {
                // Tutup drawer terlebih dahulu
                Navigator.pop(context);
                // Navigasi ke halaman Barang List Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BarangListPage()),
                );
              },
            ),
            _buildMenuItem(
              icon: Icons.point_of_sale,
              title: 'Keranjang', // Gunakan istilah kasir
              textColor: primaryGreen, 
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TransactionPage()),
                );
              },
            ),
            // -------------------------------

            // Spacer mendorong footer ke paling bawah layar
            const Spacer(),
            
            // Bagian Footer
            const Padding(
              padding: EdgeInsets.only(left: 24, bottom: 24),
              child: Text(
                '© 2024 Komotia',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      leading: Icon(icon, color: textColor, size: 22),
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }
}