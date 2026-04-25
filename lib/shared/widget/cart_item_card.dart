import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:komotia/shared/provider/cart_provider.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;

  const CartItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Produk
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            // child: Image.network(
            //   item.product.gambar ?? 'https://picsum.photos/seed/${item.product.idProduct}/400/200',
            //   height: 180,
            //   width: double.infinity,
            //   fit: BoxFit.cover,
            // ),
          ),
          const SizedBox(height: 16),
          // Detail Nama & Harga
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.namaProduct,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.product.category ?? "Koleksi"} • ${item.product.satuan ?? "Unit"}',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Text(
                'Rp ${item.product.harga}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Kontrol Jumlah & Tombol Hapus
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Stepper (Kurang - Angka - Tambah)
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 18),
                      onPressed: () {
                        // Di CartProvider, Anda bisa tambah fungsi decrease quantity
                        // Untuk sekarang kita asumsikan pakai addItem lagi atau fungsi khusus
                      },
                    ),
                    Text(
                      '${item.quantity}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 18),
                      onPressed: () => cart.addItem(item.product),
                    ),
                  ],
                ),
              ),
              // Tombol Hapus
              TextButton.icon(
                onPressed: () => cart.removeItem(item.product.idProduct),
                icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                label: const Text('Hapus', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}