import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:komotia/shared/provider/auth_provider.dart';
import 'package:komotia/shared/service/api_service.dart';

// Path disesuaikan mengarah ke sub-folder dashboard_widget
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
    
    if (auth.userId != null) {
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
    // Ambil username dari state
    final auth = context.watch<AuthProvider>();
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
}