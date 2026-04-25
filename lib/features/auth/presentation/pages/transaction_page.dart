import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:komotia/shared/provider/barang_provider.dart';
import 'package:komotia/shared/provider/cart_provider.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  void initState() {
    super.initState();
    // Refresh data barang dari database saat masuk halaman transaksi
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BarangProvider>().fetchBarang();
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF4B5320);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F6),
      appBar: AppBar(
        title: const Text('Keranjang Saya', style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: primaryGreen,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () => context.read<CartProvider>().clearCart(),
            tooltip: 'Kosongkan Keranjang',
          )
        ],
      ),
      body: Column(
        children: [
          // SEKSI 1: DAFTAR BARANG (INPUT)
          Expanded(
            flex: 3,
            child: Consumer<BarangProvider>(
              builder: (context, barangProv, _) {
                if (barangProv.isLoading) {
                  return const Center(child: CircularProgressIndicator(color: primaryGreen));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: barangProv.listBarang.length,
                  itemBuilder: (context, index) {
                    final barang = barangProv.listBarang[index];
                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFE5F0D3),
                          child: Icon(Icons.inventory_2, color: primaryGreen, size: 20),
                        ),
                        title: Text(barang.namaProduct, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Rp ${barang.harga}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.add_circle, color: primaryGreen, size: 30),
                          onPressed: () {
                            context.read<CartProvider>().addItem(barang);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${barang.namaProduct} ditambah'),
                                duration: const Duration(milliseconds: 500),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // SEKSI 2: RINGKASAN KERANJANG & TOTAL (DINAMIS)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
              ],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Consumer<CartProvider>(
              builder: (context, cart, _) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // List Item di Keranjang (Dinamis)
                    if (cart.items.isNotEmpty)
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 120),
                        child: ListView(
                          shrinkWrap: true,
                          children: cart.items.values.map((item) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${item.product.namaProduct} (x${item.quantity})', 
                                      style: const TextStyle(fontSize: 13, color: Colors.grey)),
                                  Text('Rp ${ (item.product.harga ?? 0) * item.quantity }', 
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    
                    const Divider(height: 24),
                    
                    // Total Harga Dinamis
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Bayar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(
                          'Rp ${cart.totalAmount}',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: primaryGreen),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Tombol Konfirmasi
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        onPressed: cart.items.isEmpty ? null : () {
                          // Logika transaksi akan dikerjakan di bagian output minggu depan
                          _showSuccessDialog(context);
                        },
                        child: const Text(
                          'KONFIRMASI TRANSAKSI', 
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Berhasil'),
        content: const Text('Komposisi transaksi telah dibuat di memori.'),
        actions: [
          TextButton(
            onPressed: () {
              context.read<CartProvider>().clearCart();
              Navigator.pop(context);
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }
}