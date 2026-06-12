import 'package:flutter/material.dart';
import 'package:komotia/shared/models/barang_model.dart';

class CartItem {
  final BarangModel product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartProvider with ChangeNotifier {
  // Map untuk menyimpan barang (Key: ID Product, Value: CartItem)
  final Map<int, CartItem> _items = {};

  Map<int, CartItem> get items => _items;

  // Hitung jumlah total item
  int get itemCount {
    var count = 0;
    _items.forEach((key, item) {
      count += item.quantity;
    });
    return count;
  }

  // Hitung Total Harga
  int get totalAmount {
    var total = 0;
    _items.forEach((key, cartItem) {
      total += (cartItem.product.harga ?? 0) * cartItem.quantity;
    });
    return total;
  }

  // Tambah Barang ke Keranjang
  void addItem(BarangModel product) {
    if (_items.containsKey(product.idProduct)) {
      _items.update(product.idProduct, (existing) => CartItem(
        product: existing.product,
        quantity: existing.quantity + 1,
      ));
    } else {
      _items.putIfAbsent(product.idProduct, () => CartItem(product: product));
    }
    notifyListeners();
  }

  // Kurangi jumlah item (hapus jika 0)
  void decreaseQuantity(int productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId]!.quantity > 1) {
      _items.update(productId, (existing) => CartItem(
        product: existing.product,
        quantity: existing.quantity - 1,
      ));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  // Hapus Barang dari Keranjang
  void removeItem(int productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}