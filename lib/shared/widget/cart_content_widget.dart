import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:komotia/shared/provider/cart_provider.dart';
import 'package:komotia/shared/widget/cart_item_card.dart';
import 'package:komotia/features/auth/presentation/pages/checkout_page.dart';

class CartContentWidget extends StatelessWidget {
  const CartContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF4B5320);
    const Color bgColor = Color(0xFFF9F9F6);

    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        if (cart.items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.remove_shopping_cart, size: 80, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                const Text(
                  'Keranjang Anda kosong.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // Perhitungan Biaya
        double subtotal = cart.totalAmount.toDouble();
        double pengiriman = 25000;
        double pajak = subtotal * 0.11; // PPN 11%
        double totalAkhir = subtotal + pengiriman + pajak;

        return Container(
          color: bgColor,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // List Item 
                ...cart.items.values.map((item) => CartItemCard(item: item)).toList(),

                // Ringkasan Pesanan
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F5F0),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Ringkasan Pesanan', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      _buildSummaryRow('Subtotal', 'Rp ${subtotal.toInt()}'),
                      _buildSummaryRow('Pengiriman', 'Rp ${pengiriman.toInt()}'),
                      _buildSummaryRow('Pajak (PPN 11%)', 'Rp ${pajak.toInt()}'),
                      const SizedBox(height: 16),
                      
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Akhir', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('Rp ${totalAkhir.toInt()}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF2D2D2D))),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const CheckoutPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: primaryGreen, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                          child: const Text('Lanjut ke Pembayaran', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Center(
                        child: Text('Komotia Marketplace', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                      ),
                      const SizedBox(height: 16),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.credit_card, color: Colors.grey), SizedBox(width: 16),
                          Icon(Icons.account_balance_wallet, color: Colors.grey), SizedBox(width: 16),
                          Icon(Icons.lock_outline, color: Colors.grey), SizedBox(width: 16),
                          Icon(Icons.verified_user_outlined, color: Colors.grey),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  // Fungsi Helper
  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF4B5563))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}