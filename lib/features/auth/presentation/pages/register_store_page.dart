import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:komotia/shared/provider/auth_provider.dart';
import 'package:komotia/shared/service/api_service.dart';
import 'package:komotia/features/auth/presentation/pages/seller_dashboard_page.dart';

class RegisterStorePage extends StatefulWidget {
  const RegisterStorePage({super.key});

  @override
  State<RegisterStorePage> createState() => _RegisterStorePageState();
}

class _RegisterStorePageState extends State<RegisterStorePage> {
  bool _isLoading = false;

  Future<void> _handleRegisterStore() async {
    final auth = context.read<AuthProvider>();
    if (auth.userId == null) return;

    setState(() => _isLoading = true);

    final apiService = ApiService();
    final success = await apiService.upgradeToSeller(auth.userId!);

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      await auth.updateRole('penjual');
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selamat! Toko Anda berhasil dibuat.')),
      );

      // Ganti halaman ke Seller Dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SellerDashboardPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membuat toko. Silakan coba lagi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F6),
      appBar: AppBar(
        title: const Text('Buka Toko', style: TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: const Color(0xFF4B5320),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.storefront_outlined, size: 100, color: Colors.grey.shade400),
              const SizedBox(height: 24),
              const Text(
                'Anda Belum Memiliki Toko',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2D2D2D)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Mulai berjualan di Komotia dan jangkau lebih banyak pembeli di seluruh Indonesia.',
                style: TextStyle(fontSize: 14, color: Color(0xFF5A5A5A), height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegisterStore,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4B5320),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Buka Toko Gratis Sekarang', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
