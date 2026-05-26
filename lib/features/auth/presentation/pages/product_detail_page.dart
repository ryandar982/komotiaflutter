import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:komotia/shared/models/barang_model.dart';
import 'package:komotia/shared/provider/cart_provider.dart';

class ProductDetailPage extends StatefulWidget {
  final BarangModel barang;

  const ProductDetailPage({super.key, required this.barang});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 1;

  // Warna tema Komotia
  static const Color _primaryGreen = Color(0xFF4B5320);
  static const Color _lightGreen = Color(0xFFE5F0D3);
  static const Color _bgColor = Color(0xFFF2F3EC);

  String get _imageUrl {
    final gambar = widget.barang.gambar;
    return (gambar != null && gambar.startsWith('http'))
        ? gambar
        : 'https://picsum.photos/seed/${widget.barang.idProduct}/800/600';
  }

  String get _price => 'Rp ${_formatNumber(widget.barang.harga ?? 0)}';
  String get _totalPrice =>
      'Rp ${_formatNumber((widget.barang.harga ?? 0) * _quantity)}';

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
        );
  }

  void _incrementQuantity() {
    final maxStock = widget.barang.stok ?? 99;
    if (_quantity < maxStock) {
      setState(() => _quantity++);
    }
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() => _quantity--);
    }
  }

  void _addToCart() {
    final cart = context.read<CartProvider>();
    for (int i = 0; i < _quantity; i++) {
      cart.addItem(widget.barang);
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$_quantity x ${widget.barang.namaProduct} ditambahkan ke keranjang!',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: _primaryGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final barang = widget.barang;
    final tag = (barang.category ?? 'UMUM').toUpperCase();
    final stok = barang.stok ?? 0;

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D2D2D)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Detail Produk',
          style: const TextStyle(
            color: Color(0xFF2D2D2D),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Color(0xFF2D2D2D)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur bagikan segera hadir!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ============================
          // Scrollable Content
          // ============================
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Gambar Produk ---
                  Container(
                    width: double.infinity,
                    height: 280,
                    color: Colors.grey.shade100,
                    child: Image.network(
                      _imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 280,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: _primaryGreen,
                                strokeWidth: 2,
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Memuat gambar...',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: double.infinity,
                        height: 280,
                        color: _lightGreen.withValues(alpha: 0.5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.eco, size: 64, color: _primaryGreen.withValues(alpha: 0.4)),
                            const SizedBox(height: 8),
                            Text(
                              barang.namaProduct,
                              style: TextStyle(
                                color: _primaryGreen.withValues(alpha: 0.6),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // --- Info Utama Produk ---
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Kategori Tag
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _lightGreen,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: _primaryGreen,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Nama Produk
                        Text(
                          barang.namaProduct,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2D2D2D),
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Harga
                        Text(
                          _price,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: _primaryGreen,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Rating dan Stok
                        Wrap(
                          spacing: 12,
                          runSpacing: 8,
                          children: [
                            _buildBadge(
                              color: Colors.amber.shade50,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                                  const SizedBox(width: 4),
                                  const Text('4.8',
                                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF2D2D2D))),
                                  const SizedBox(width: 2),
                                  Text('(128 ulasan)',
                                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                                ],
                              ),
                            ),
                            _buildBadge(
                              color: stok > 0 ? _lightGreen : Colors.red.shade50,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    stok > 0 ? Icons.inventory_2_outlined : Icons.remove_shopping_cart,
                                    size: 16,
                                    color: stok > 0 ? _primaryGreen : Colors.red,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    stok > 0 ? 'Stok: $stok ${barang.satuan ?? 'pcs'}' : 'Stok Habis',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: stok > 0 ? _primaryGreen : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // --- Deskripsi Produk ---
                  _buildSection(
                    icon: Icons.description_outlined,
                    title: 'Deskripsi Produk',
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _bgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        barang.deskripsi ??
                            'Produk pertanian berkualitas tinggi dari Komotia. '
                                'Dipilih dan dikurasi langsung dari petani terbaik '
                                'untuk memastikan kualitas terjamin. Cocok untuk '
                                'kebutuhan pertanian Anda sehari-hari.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // --- Info Pengiriman ---
                  _buildSection(
                    icon: Icons.local_shipping_outlined,
                    title: 'Informasi Pengiriman',
                    child: Column(
                      children: [
                        _buildInfoRow(Icons.local_shipping_outlined, 'Gratis Ongkir', 'Untuk pembelian min. Rp 100.000'),
                        _buildDivider(),
                        _buildInfoRow(Icons.access_time_outlined, 'Estimasi Tiba', '2-4 hari kerja'),
                        _buildDivider(),
                        _buildInfoRow(Icons.verified_user_outlined, 'Garansi Produk', 'Jaminan kualitas 100%'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // ============================
          // Bottom Bar: Quantity + Buttons (FIXED)
          // ============================
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  // Quantity Selector
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildQtyButton(Icons.remove, _decrementQuantity),
                        Container(
                          constraints: const BoxConstraints(minWidth: 32),
                          alignment: Alignment.center,
                          child: Text(
                            '$_quantity',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        _buildQtyButton(Icons.add, _incrementQuantity),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Tombol Keranjang
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: OutlinedButton(
                        onPressed: stok > 0 ? _addToCart : null,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _primaryGreen,
                          side: const BorderSide(color: _primaryGreen, width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.add_shopping_cart, size: 16),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                _totalPrice,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Tombol Beli Sekarang
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: ElevatedButton(
                        onPressed: stok > 0 ? _addToCart : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryGreen,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        child: const Text(
                          'Beli Sekarang',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================
  // Helper Widgets
  // ============================

  Widget _buildBadge({required Color color, required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }

  Widget _buildSection({required IconData icon, required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: _primaryGreen),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D2D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildQtyButton(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: 18, color: _primaryGreen),
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Divider(height: 1),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _lightGreen,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: _primaryGreen),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D2D2D),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
