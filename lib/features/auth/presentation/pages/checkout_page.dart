import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:komotia/shared/provider/cart_provider.dart';
import 'package:komotia/shared/provider/auth_provider.dart';
import 'package:komotia/shared/service/api_service.dart';
import 'package:komotia/features/auth/presentation/pages/payment_success_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();
  String _selectedPayment = 'bca';
  bool _isProcessing = false;

  static const Color primaryGreen = Color(0xFF4B5320);
  static const Color bgColor = Color(0xFFF9F9F6);

  final List<Map<String, dynamic>> _paymentMethods = [
    {'id': 'bca', 'label': 'BCA', 'image': 'assets/images/BCA.png'},
    {'id': 'bri', 'label': 'BRI', 'image': 'assets/images/BRI.png'},
    {'id': 'mandiri', 'label': 'Mandiri', 'image': 'assets/images/Mandiri.png'},
    {'id': 'gopay', 'label': 'GoPay', 'image': 'assets/images/GOPAY.png'},
    {'id': 'dana', 'label': 'DANA', 'image': 'assets/images/DANA.png'},
    {'id': 'spay', 'label': 'ShopeePay', 'image': 'assets/images/SPAY.png'},
    {'id': 'qris', 'label': 'QRIS', 'image': 'assets/images/QRIS.png'},
    {'id': 'cod', 'label': 'COD (Bayar di Tempat)', 'image': 'assets/images/GOSEND.png'},
  ];

  @override
  void initState() {
    super.initState();
    // Pre-fill alamat dari data user jika tersedia
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.username != null) {
        // Alamat bisa diisi manual oleh user
      }
    });
  }

  @override
  void dispose() {
    _alamatController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  Future<void> _processCheckout() async {
    final cart = context.read<CartProvider>();
    final auth = context.read<AuthProvider>();

    if (cart.items.isEmpty) return;

    if (auth.userId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan login terlebih dahulu!')),
      );
      return;
    }

    if (_alamatController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alamat pengiriman wajib diisi!')),
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final apiService = ApiService();

      // Hitung total
      double subtotal = cart.totalAmount.toDouble();
      double pengiriman = 25000;
      double pajak = subtotal * 0.11;
      double totalAkhir = subtotal + pengiriman + pajak;

      // 1. Buat Transaksi
      final idTransaction = await apiService.createTransaction(
        idUser: auth.userId!,
        totalHarga: totalAkhir,
        alamatPengiriman: _alamatController.text.trim(),
        metodePembayaran: _selectedPayment,
        catatan: _catatanController.text.trim().isEmpty ? null : _catatanController.text.trim(),
      );

      if (idTransaction == null) {
        throw Exception('Gagal membuat transaksi');
      }

      // 2. Buat Transaction Details untuk setiap item
      for (final entry in cart.items.entries) {
        final item = entry.value;
        final hargaSatuan = (item.product.harga ?? 0).toDouble();
        final itemSubtotal = hargaSatuan * item.quantity;

        final success = await apiService.createTransactionDetail(
          idTransaction: idTransaction,
          idProduct: item.product.idProduct,
          jumlah: item.quantity,
          hargaSatuan: hargaSatuan,
          subtotal: itemSubtotal,
        );

        if (!success) {
          throw Exception('Gagal menyimpan detail untuk ${item.product.namaProduct}');
        }
      }

      // 3. Buat Payment (Fiktif)
      final idPayment = await apiService.createPayment(
        idTransaction: idTransaction,
        jumlahBayar: totalAkhir,
      );

      if (idPayment == null) {
        throw Exception('Gagal membuat pembayaran');
      }

      // 4. Update status transaksi → dibayar
      await apiService.updateTransactionStatus(idTransaction, 'dibayar');

      // 5. Kosongkan keranjang
      cart.clearCart();

      if (!mounted) return;

      // 6. Navigasi ke halaman sukses
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentSuccessPage(
            idTransaction: idTransaction,
            totalBayar: totalAkhir,
            metodePembayaran: _selectedPayment,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryGreen,
        elevation: 0,
        title: const Text('Checkout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          if (cart.items.isEmpty) {
            return const Center(
              child: Text('Keranjang kosong', style: TextStyle(color: Colors.grey)),
            );
          }

          double subtotal = cart.totalAmount.toDouble();
          double pengiriman = 25000;
          double pajak = subtotal * 0.11;
          double totalAkhir = subtotal + pengiriman + pajak;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ========== RINGKASAN PESANAN ==========
                _buildSectionCard(
                  title: 'Ringkasan Pesanan',
                  icon: Icons.shopping_bag_outlined,
                  child: Column(
                    children: [
                      ...cart.items.values.map((item) => Padding(
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
                              child: const Icon(Icons.inventory_2, color: primaryGreen, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.namaProduct,
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                  ),
                                  Text(
                                    '${item.quantity}x  ×  Rp ${item.product.harga}',
                                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Rp ${(item.product.harga ?? 0) * item.quantity}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )),
                      const Divider(height: 24),
                      _buildPriceRow('Subtotal', 'Rp ${subtotal.toInt()}'),
                      _buildPriceRow('Pengiriman', 'Rp ${pengiriman.toInt()}'),
                      _buildPriceRow('Pajak (PPN 11%)', 'Rp ${pajak.toInt()}'),
                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(
                            'Rp ${totalAkhir.toInt()}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: primaryGreen),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ========== ALAMAT PENGIRIMAN ==========
                _buildSectionCard(
                  title: 'Alamat Pengiriman',
                  icon: Icons.location_on_outlined,
                  child: TextField(
                    controller: _alamatController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Masukkan alamat lengkap pengiriman...',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      filled: true,
                      fillColor: const Color(0xFFF4F5F0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ========== CATATAN (OPSIONAL) ==========
                _buildSectionCard(
                  title: 'Catatan (Opsional)',
                  icon: Icons.note_alt_outlined,
                  child: TextField(
                    controller: _catatanController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'Contoh: Tolong packing rapi ya...',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      filled: true,
                      fillColor: const Color(0xFFF4F5F0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ========== METODE PEMBAYARAN ==========
                _buildSectionCard(
                  title: 'Metode Pembayaran',
                  icon: Icons.payment_outlined,
                  child: Column(
                    children: _paymentMethods.map((method) {
                      final isSelected = _selectedPayment == method['id'];
                      return GestureDetector(
                        onTap: () => setState(() => _selectedPayment = method['id']),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: isSelected ? primaryGreen.withOpacity(0.08) : const Color(0xFFF4F5F0),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? primaryGreen : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    method['image'],
                                    width: 36,
                                    height: 36,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  method['label'],
                                  style: TextStyle(
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                    color: isSelected ? primaryGreen : Colors.black87,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                const Icon(Icons.check_circle, color: primaryGreen, size: 22),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 24),

                // ========== TOMBOL BAYAR ==========
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : _processCheckout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: _isProcessing
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.lock_outline, color: Colors.white, size: 20),
                              const SizedBox(width: 10),
                              Text(
                                'Bayar Sekarang  •  Rp ${totalAkhir.toInt()}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                // Footer keamanan
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.verified_user_outlined, size: 14, color: Colors.grey),
                    SizedBox(width: 6),
                    Text(
                      'Pembayaran dijamin aman oleh Komotia',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
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

  Widget _buildPriceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }
}
