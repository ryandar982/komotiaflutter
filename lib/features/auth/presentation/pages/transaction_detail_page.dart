import 'package:flutter/material.dart';
import 'package:komotia/shared/service/api_service.dart';

class TransactionDetailPage extends StatefulWidget {
  final Map<String, dynamic> transaction;

  const TransactionDetailPage({super.key, required this.transaction});

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  static const Color primaryGreen = Color(0xFF4B5320);

  List<dynamic> _details = [];
  Map<String, dynamic>? _payment;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    setState(() => _isLoading = true);

    final apiService = ApiService();
    final idTransaction = widget.transaction['id_transaction'];

    final details = await apiService.getTransactionDetails(idTransaction);
    final payment = await apiService.getPaymentByTransaction(idTransaction);

    if (mounted) {
      setState(() {
        _details = details;
        _payment = payment;
        _isLoading = false;
      });
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'pending': return Colors.orange;
      case 'dibayar': return Colors.blue;
      case 'dikemas': return Colors.indigo;
      case 'dikirim': return Colors.teal;
      case 'selesai': return const Color(0xFF4B5320);
      case 'dibatalkan': return Colors.red;
      default: return Colors.grey;
    }
  }

  String _getStatusLabel(String? status) {
    switch (status) {
      case 'pending': return 'Menunggu';
      case 'dibayar': return 'Dibayar';
      case 'dikemas': return 'Dikemas';
      case 'dikirim': return 'Dikirim';
      case 'selesai': return 'Selesai';
      case 'dibatalkan': return 'Dibatalkan';
      default: return status ?? '-';
    }
  }

  String _getPaymentLabel(String? method) {
    const labels = {
      'transfer_bank': 'Transfer Bank',
      'gopay': 'GoPay',
      'ovo': 'OVO',
      'dana': 'DANA',
      'cod': 'COD',
    };
    return labels[method] ?? method ?? '-';
  }

  String _getVerifLabel(String? status) {
    switch (status) {
      case 'menunggu': return 'Menunggu Verifikasi';
      case 'diterima': return 'Diterima';
      case 'ditolak': return 'Ditolak';
      default: return status ?? '-';
    }
  }

  Color _getVerifColor(String? status) {
    switch (status) {
      case 'menunggu': return Colors.orange;
      case 'diterima': return const Color(0xFF4B5320);
      case 'ditolak': return Colors.red;
      default: return Colors.grey;
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '-';
    final date = DateTime.tryParse(dateStr);
    if (date == null) return dateStr;
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${date.day} ${months[date.month]} ${date.year}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatCurrency(dynamic value) {
    if (value == null) return 'Rp 0';
    final num = double.tryParse(value.toString()) ?? 0;
    return 'Rp ${num.toInt()}';
  }

  @override
  Widget build(BuildContext context) {
    final trx = widget.transaction;
    final status = trx['status']?.toString();
    final statusColor = _getStatusColor(status);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F6),
      appBar: AppBar(
        backgroundColor: primaryGreen,
        elevation: 0,
        title: Text(
          '#TRX-${(trx['id_transaction'] ?? 0).toString().padLeft(5, '0')}',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryGreen))
          : RefreshIndicator(
              color: primaryGreen,
              onRefresh: _loadDetails,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // ========== STATUS CARD ==========
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [statusColor.withOpacity(0.15), statusColor.withOpacity(0.05)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: statusColor.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              _getStatusIcon(status),
                              color: statusColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Status Pesanan',
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _getStatusLabel(status),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: statusColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ========== INFO TRANSAKSI ==========
                    _buildSectionCard(
                      title: 'Informasi Transaksi',
                      icon: Icons.info_outline,
                      child: Column(
                        children: [
                          _buildInfoRow('Tanggal', _formatDate(trx['tanggal_transaksi']?.toString())),
                          _buildInfoRow('Metode Bayar', _getPaymentLabel(trx['metode_pembayaran']?.toString())),
                          _buildInfoRow('Total', _formatCurrency(trx['total_harga'])),
                          if (trx['alamat_pengiriman'] != null)
                            _buildInfoRow('Alamat', trx['alamat_pengiriman'].toString()),
                          if (trx['catatan'] != null && trx['catatan'].toString().isNotEmpty)
                            _buildInfoRow('Catatan', trx['catatan'].toString()),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ========== ITEM YANG DIBELI ==========
                    _buildSectionCard(
                      title: 'Item Pesanan (${_details.length})',
                      icon: Icons.shopping_bag_outlined,
                      child: Column(
                        children: _details.isEmpty
                            ? [
                                const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text('Tidak ada detail item', style: TextStyle(color: Colors.grey)),
                                )
                              ]
                            : _details.map((detail) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE5F0D3),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Icon(Icons.inventory_2, color: primaryGreen, size: 18),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Product #${detail['id_product']}',
                                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                            ),
                                            Text(
                                              '${detail['jumlah']}x  ×  ${_formatCurrency(detail['harga_satuan'])}',
                                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        _formatCurrency(detail['subtotal']),
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ========== INFO PEMBAYARAN ==========
                    if (_payment != null)
                      _buildSectionCard(
                        title: 'Informasi Pembayaran',
                        icon: Icons.payment_outlined,
                        child: Column(
                          children: [
                            _buildInfoRow('Tanggal Bayar', _formatDate(_payment!['tanggal_bayar']?.toString())),
                            _buildInfoRow('Jumlah Bayar', _formatCurrency(_payment!['jumlah_bayar'])),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Status Verifikasi', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _getVerifColor(_payment!['status_verifikasi']?.toString()).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      _getVerifLabel(_payment!['status_verifikasi']?.toString()),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: _getVerifColor(_payment!['status_verifikasi']?.toString()),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_payment!['catatan_admin'] != null && _payment!['catatan_admin'].toString().isNotEmpty)
                              _buildInfoRow('Catatan Admin', _payment!['catatan_admin'].toString()),
                          ],
                        ),
                      ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }

  IconData _getStatusIcon(String? status) {
    switch (status) {
      case 'pending': return Icons.schedule;
      case 'dibayar': return Icons.payment;
      case 'dikemas': return Icons.inventory_2;
      case 'dikirim': return Icons.local_shipping;
      case 'selesai': return Icons.check_circle;
      case 'dibatalkan': return Icons.cancel;
      default: return Icons.help_outline;
    }
  }

  Widget _buildSectionCard({required String title, required IconData icon, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primaryGreen, size: 20),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
