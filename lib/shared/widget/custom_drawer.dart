import 'package:flutter/material.dart';
import 'package:komotia/features/auth/presentation/pages/barang_list_page.dart';
import 'package:komotia/features/auth/presentation/pages/transaction_page.dart';
import 'package:komotia/features/auth/presentation/pages/transaction_history_page.dart';
import 'package:komotia/features/auth/presentation/pages/login_page.dart';
import 'package:komotia/shared/service/api_service.dart';
import 'package:provider/provider.dart';
import 'package:komotia/shared/provider/auth_provider.dart';
import 'package:komotia/shared/provider/cart_provider.dart';
import 'package:komotia/features/auth/presentation/pages/register_store_page.dart';
import 'package:komotia/features/auth/presentation/pages/seller_dashboard_page.dart';

class CustomDrawer extends StatelessWidget {
  /// Callback untuk berpindah tab di bottom navigation bar dari drawer
  final void Function(int index)? onNavigateToTab;

  const CustomDrawer({super.key, this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isLoggedIn = auth.isLoggedIn;

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
                        Navigator.pop(context);
                        if (isLoggedIn) {
                          _showLogoutConfirmation(context);
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isLoggedIn ? Colors.red.shade400 : primaryGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        elevation: 0,
                      ),
                      icon: Icon(isLoggedIn ? Icons.logout : Icons.login, size: 20),
                      label: Text(
                        isLoggedIn ? 'Logout' : 'Login Atau Daftar',
                        style: const TextStyle(
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
            
            // ============================
            // Daftar Menu Navigasi
            // ============================
            _buildMenuItem(
              icon: Icons.home_filled,
              title: 'Beranda',
              textColor: textColor,
              onTap: () {
                Navigator.pop(context);
                onNavigateToTab?.call(0);
              },
            ),
            _buildMenuItem(
              icon: Icons.explore,
              title: 'Jelajahi / Cari Kategori',
              textColor: textColor,
              onTap: () {
                Navigator.pop(context);
                onNavigateToTab?.call(1);
              },
            ),
            _buildMenuItem(
              icon: Icons.shopping_cart,
              title: 'Keranjang Saya',
              textColor: textColor,
              onTap: () {
                Navigator.pop(context);
                onNavigateToTab?.call(2);
              },
            ),
            _buildMenuItem(
              icon: Icons.person,
              title: 'Profil / Dashboard',
              textColor: textColor,
              onTap: () {
                Navigator.pop(context);
                onNavigateToTab?.call(3);
              },
            ),
            _buildMenuItem(
              icon: Icons.receipt_long,
              title: 'Riwayat Transaksi',
              textColor: textColor,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TransactionHistoryPage()),
                );
              },
            ),

            // --- Garis Pemisah Fitur Admin ---
            if (isLoggedIn) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Divider(color: Color(0xFFE5E5DF), thickness: 1),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'BISNIS SAYA',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB0B8A0),
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 4),

              _buildMenuItem(
                icon: Icons.storefront,
                title: 'Toko Saya',
                textColor: primaryGreen,
                onTap: () {
                  Navigator.pop(context);
                  if (auth.role == 'penjual') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SellerDashboardPage()),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterStorePage()),
                    );
                  }
                },
              ),
            ],

            // --- Garis Pemisah Lainnya ---
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Divider(color: Color(0xFFE5E5DF), thickness: 1),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'LAINNYA',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB0B8A0),
                  letterSpacing: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 4),

            _buildMenuItem(
              icon: Icons.help_outline,
              title: 'Pusat Bantuan',
              textColor: textColor,
              onTap: () {
                Navigator.pop(context);
                _showHelpDialog(context);
              },
            ),
            _buildMenuItem(
              icon: Icons.info_outline,
              title: 'Tentang Komotia',
              textColor: textColor,
              onTap: () {
                Navigator.pop(context);
                _showAboutKomotiaDialog(context);
              },
            ),
            if (isLoggedIn)
              _buildMenuItem(
                icon: Icons.logout,
                title: 'Logout',
                textColor: Colors.red.shade400,
                onTap: () {
                  Navigator.pop(context);
                  _showLogoutConfirmation(context);
                },
              ),

            // Spacer mendorong footer ke paling bawah layar
            const Spacer(),
            
            // Bagian Footer
            const Padding(
              padding: EdgeInsets.only(left: 24, bottom: 24),
              child: Text(
                '© 2024 Komotia\nVersi 1.0.0',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================
  // Dialog: Pusat Bantuan
  // ============================
  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.help_outline, color: Color(0xFF4A5D23)),
            SizedBox(width: 8),
            Text('Pusat Bantuan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Butuh bantuan? Hubungi kami melalui:', style: TextStyle(fontSize: 14)),
            SizedBox(height: 16),
            _HelpInfoRow(icon: Icons.email_outlined, label: 'Email', value: 'support@komotia.com'),
            SizedBox(height: 10),
            _HelpInfoRow(icon: Icons.phone_outlined, label: 'Telepon', value: '+62 812-3456-7890'),
            SizedBox(height: 10),
            _HelpInfoRow(icon: Icons.access_time, label: 'Jam Operasional', value: 'Senin - Jumat, 08:00 - 17:00'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup', style: TextStyle(color: Color(0xFF4A5D23))),
          ),
        ],
      ),
    );
  }

  // ============================
  // Dialog: Tentang Komotia
  // ============================
  void _showAboutKomotiaDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Image.asset('assets/images/komotia.png', width: 28, height: 28),
            const SizedBox(width: 8),
            const Text('Tentang Komotia', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Komotia adalah platform e-commerce pertanian yang '
              'menghubungkan petani dengan pembeli secara langsung.',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            SizedBox(height: 16),
            Text('🌱  Produk berkualitas dari petani lokal', style: TextStyle(fontSize: 13)),
            SizedBox(height: 6),
            Text('🚚  Gratis ongkir untuk pembelian tertentu', style: TextStyle(fontSize: 13)),
            SizedBox(height: 6),
            Text('✅  Garansi kualitas 100%', style: TextStyle(fontSize: 13)),
            SizedBox(height: 6),
            Text('💰  Harga langsung dari petani', style: TextStyle(fontSize: 13)),
            SizedBox(height: 16),
            Text(
              'Versi 1.0.0',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup', style: TextStyle(color: Color(0xFF4A5D23))),
          ),
        ],
      ),
    );
  }

  // ============================
  // Dialog: Konfirmasi Logout
  // ============================
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Konfirmasi Logout', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Apakah Anda yakin ingin keluar dari akun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              // Hapus token API
              final apiService = ApiService();
              await apiService.logoutUser();

              if (!context.mounted) return;
              
              // Hapus state user dan keranjang dari memory
              await context.read<AuthProvider>().logout();
              context.read<CartProvider>().clearCart();

              if (!context.mounted) return;
              Navigator.pop(context); // Tutup dialog

              // Navigasi ke halaman login & hapus semua route sebelumnya
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Logout'),
          ),
        ],
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

// Widget helper untuk info di Pusat Bantuan
class _HelpInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _HelpInfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF4A5D23)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}