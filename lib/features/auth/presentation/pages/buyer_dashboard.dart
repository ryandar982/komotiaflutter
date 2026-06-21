import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:komotia/shared/provider/auth_provider.dart';
import 'package:komotia/shared/service/api_service.dart';
import 'package:komotia/features/auth/presentation/pages/login_page.dart';

import 'package:komotia/shared/widget/dashboard_widget/dashboard_header.dart';
import 'package:komotia/shared/widget/dashboard_widget/balance_points_section.dart';
import 'package:komotia/shared/widget/dashboard_widget/order_status_section.dart';
import 'package:komotia/shared/widget/dashboard_widget/quick_links_section.dart';

class BuyerDashboardPage extends StatefulWidget {
  const BuyerDashboardPage({super.key});

  @override
  State<BuyerDashboardPage> createState() => _BuyerDashboardPageState();
}

class _BuyerDashboardPageState extends State<BuyerDashboardPage> {
  bool _isLoading = true;
  int _countDikemas = 0;
  int _countDikirim = 0;
  int _countSelesai = 0;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);

    // Dapatkan data user dari AuthProvider
    final auth = context.read<AuthProvider>();
    
    if (auth.isLoggedIn && auth.userId != null) {
      final apiService = ApiService();
      // Ambil transaksi user untuk menghitung badge status
      final transactions = await apiService.getTransactionsByUser(auth.userId!);
      
      int dikemas = 0;
      int dikirim = 0;
      int selesai = 0;

      for (var trx in transactions) {
        final status = trx['status']?.toString();
        // Kita gabungkan status pending, dibayar, dikemas ke badge "Dikemas"
        if (status == 'pending' || status == 'dibayar' || status == 'dikemas') {
          dikemas++;
        } else if (status == 'dikirim') {
          dikirim++;
        } else if (status == 'selesai') {
          selesai++;
        }
      }

      if (mounted) {
        setState(() {
          _countDikemas = dikemas;
          _countDikirim = dikirim;
          _countSelesai = selesai;
        });
      }
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    // ============================
    // Jika user BELUM LOGIN → tampilkan layar ajakan login
    // ============================
    if (!auth.isLoggedIn) {
      return _buildLoginRequiredView(context);
    }

    // ============================
    // User sudah login → tampilkan dashboard normal
    // ============================
    final username = auth.username ?? 'Tamu';

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF4B5320)));
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardHeader(username: username),
            const SizedBox(height: 24),
            const BalancePointsSection(),
            const SizedBox(height: 24),
            OrderStatusSection(
              countDikemas: _countDikemas,
              countDikirim: _countDikirim,
              countSelesai: _countSelesai,
            ),
            const SizedBox(height: 24),
            const QuickLinksSection(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  /// Widget yang ditampilkan saat user belum login
  Widget _buildLoginRequiredView(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ilustrasi ikon besar
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF4B5320).withValues(alpha: 0.1),
                    const Color(0xFF6B8E23).withValues(alpha: 0.15),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_person_outlined,
                size: 56,
                color: Color(0xFF4B5320),
              ),
            ),
            const SizedBox(height: 28),

            // Judul
            const Text(
              'Masuk untuk Melanjutkan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D2D2D),
              ),
            ),
            const SizedBox(height: 12),

            // Deskripsi
            Text(
              'Silakan login terlebih dahulu untuk mengakses dashboard, melihat saldo, status pesanan, dan fitur lainnya.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 12),

            // Fitur yang bisa diakses setelah login
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE5F0D3).withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _buildFeatureRow(Icons.account_balance_wallet, 'Cek & top up saldo Komotia'),
                  const SizedBox(height: 10),
                  _buildFeatureRow(Icons.local_shipping, 'Lacak status pesanan Anda'),
                  const SizedBox(height: 10),
                  _buildFeatureRow(Icons.history, 'Lihat riwayat transaksi'),
                  const SizedBox(height: 10),
                  _buildFeatureRow(Icons.favorite, 'Kelola wishlist produk'),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Tombol Login
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                icon: const Icon(Icons.login, color: Colors.white, size: 20),
                label: const Text(
                  'Masuk Sekarang',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4B5320),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Link Daftar
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Belum punya akun? ',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigasi ke halaman register (bisa ditambahkan nanti)
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  child: const Text(
                    'Daftar Sekarang',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B5320),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF4B5320)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF3D3D3D),
            ),
          ),
        ),
      ],
    );
  }
}