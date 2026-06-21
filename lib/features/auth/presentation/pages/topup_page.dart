import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TopUpPage extends StatefulWidget {
  const TopUpPage({super.key});

  @override
  State<TopUpPage> createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> with SingleTickerProviderStateMixin {
  final TextEditingController _nominalController = TextEditingController();
  String? _selectedPayment;
  bool _isProcessing = false;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  // Nominal preset yang bisa dipilih cepat
  final List<int> _presetNominals = [
    10000, 20000, 50000, 100000, 200000, 500000,
  ];

  // Daftar metode pembayaran
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'group': 'E-Wallet',
      'methods': [
        {'id': 'gopay', 'name': 'GoPay', 'icon': 'assets/images/GOPAY.png'},
        {'id': 'dana', 'name': 'DANA', 'icon': 'assets/images/DANA.png'},
        {'id': 'shopeepay', 'name': 'ShopeePay', 'icon': 'assets/images/SPAY.png'},
      ],
    },
    {
      'group': 'Transfer Bank',
      'methods': [
        {'id': 'bca', 'name': 'BCA', 'icon': 'assets/images/BCA.png'},
        {'id': 'bri', 'name': 'BRI', 'icon': 'assets/images/BRI.png'},
        {'id': 'mandiri', 'name': 'Mandiri', 'icon': 'assets/images/Mandiri.png'},
      ],
    },
    {
      'group': 'Lainnya',
      'methods': [
        {'id': 'qris', 'name': 'QRIS', 'icon': 'assets/images/QRIS.png'},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _nominalController.dispose();
    _animController.dispose();
    super.dispose();
  }

  /// Format angka menjadi format rupiah manual (tanpa dependency intl)
  String _formatRupiah(int value) {
    if (value == 0) return 'Rp0';
    String result = '';
    String numStr = value.toString();
    int count = 0;
    for (int i = numStr.length - 1; i >= 0; i--) {
      count++;
      result = numStr[i] + result;
      if (count % 3 == 0 && i > 0) {
        result = '.$result';
      }
    }
    return 'Rp$result';
  }

  /// Format angka dengan titik sebagai separator ribuan
  String _formatThousands(int value) {
    if (value == 0) return '0';
    String result = '';
    String numStr = value.toString();
    int count = 0;
    for (int i = numStr.length - 1; i >= 0; i--) {
      count++;
      result = numStr[i] + result;
      if (count % 3 == 0 && i > 0) {
        result = '.$result';
      }
    }
    return result;
  }

  int get _enteredNominal {
    final text = _nominalController.text.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(text) ?? 0;
  }

  void _selectPresetNominal(int nominal) {
    _nominalController.text = _formatThousands(nominal);
    setState(() {});
  }

  Future<void> _processTopUp() async {
    final nominal = _enteredNominal;

    if (nominal < 10000) {
      _showSnackBar('Minimal top up Rp10.000', isError: true);
      return;
    }

    if (_selectedPayment == null) {
      _showSnackBar('Pilih metode pembayaran terlebih dahulu', isError: true);
      return;
    }

    setState(() => _isProcessing = true);

    // Simulasi proses top up (karena ini fiktif)
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() => _isProcessing = false);

    // Tampilkan dialog sukses
    _showSuccessDialog(nominal);
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? Colors.red.shade600 : const Color(0xFF4B5320),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showSuccessDialog(int nominal) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animasi checkmark
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6B8E23), Color(0xFF4B5320)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4B5320).withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 44),
              ),
              const SizedBox(height: 24),
              const Text(
                'Top Up Berhasil!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D2D),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Saldo ${_formatRupiah(nominal)} telah ditambahkan ke akun Komotia Anda.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5F0D3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.access_time, size: 16, color: Color(0xFF4B5320)),
                    const SizedBox(width: 6),
                    Text(
                      'Diproses dalam 1-5 menit',
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color(0xFF4B5320).withValues(alpha: 0.8),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // tutup dialog
                    Navigator.pop(context); // kembali ke dashboard
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4B5320),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Kembali ke Dashboard',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3EC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Color(0xFF2D2D2D)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Top Up Saldo',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D2D2D),
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey.shade200,
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ============================
              // Bagian Input Nominal
              // ============================
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF5A6B2F), Color(0xFF4B5320)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4B5320).withValues(alpha: 0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Masukkan Nominal',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            'Rp',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _nominalController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                _ThousandSeparatorFormatter(),
                              ],
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: '0',
                                hintStyle: TextStyle(
                                  color: Colors.white38,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Minimal top up Rp10.000',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // ============================
              // Preset Nominal Cepat
              // ============================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _presetNominals.map((nominal) {
                    final isSelected = _enteredNominal == nominal;
                    return GestureDetector(
                      onTap: () => _selectPresetNominal(nominal),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF4B5320) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF4B5320)
                                : Colors.grey.shade300,
                            width: 1.5,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF4B5320).withValues(alpha: 0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                              : [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                        ),
                        child: Text(
                          _formatRupiah(nominal),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.white : const Color(0xFF3D3D3D),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 28),

              // ============================
              // Pilihan Metode Pembayaran
              // ============================
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Pilih Metode Pembayaran',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D2D2D),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              ..._paymentMethods.map((group) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: Text(
                        group['group'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade500,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: (group['methods'] as List).asMap().entries.map((entry) {
                          final method = entry.value;
                          final isLast = entry.key == (group['methods'] as List).length - 1;
                          final isSelected = _selectedPayment == method['id'];

                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() => _selectedPayment = method['id']);
                                },
                                borderRadius: BorderRadius.circular(14),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFFE5F0D3).withValues(alpha: 0.6)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Row(
                                    children: [
                                      // Icon pembayaran
                                      Container(
                                        width: 44,
                                        height: 44,
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF5F5F5),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Image.asset(
                                          method['icon'],
                                          fit: BoxFit.contain,
                                          errorBuilder: (_, __, ___) => Icon(
                                            Icons.payment,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      // Nama metode pembayaran
                                      Expanded(
                                        child: Text(
                                          method['name'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: isSelected
                                                ? FontWeight.w700
                                                : FontWeight.w500,
                                            color: const Color(0xFF2D2D2D),
                                          ),
                                        ),
                                      ),
                                      // Indikator terpilih
                                      AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        width: 22,
                                        height: 22,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: isSelected
                                                ? const Color(0xFF4B5320)
                                                : Colors.grey.shade300,
                                            width: 2,
                                          ),
                                          color: isSelected
                                              ? const Color(0xFF4B5320)
                                              : Colors.transparent,
                                        ),
                                        child: isSelected
                                            ? const Icon(Icons.check, size: 14, color: Colors.white)
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (!isLast)
                                Divider(
                                  height: 1,
                                  indent: 74,
                                  color: Colors.grey.shade200,
                                ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                );
              }),

              const SizedBox(height: 24),

              // ============================
              // Ringkasan & Tombol Konfirmasi
              // ============================
              if (_enteredNominal > 0 && _selectedPayment != null) ...[
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE5F0D3), width: 1.5),
                  ),
                  child: Column(
                    children: [
                      _buildSummaryRow('Nominal Top Up', _formatRupiah(_enteredNominal)),
                      const SizedBox(height: 8),
                      _buildSummaryRow('Biaya Layanan', 'Gratis'),
                      const Divider(height: 20),
                      _buildSummaryRow(
                        'Total',
                        _formatRupiah(_enteredNominal),
                        isBold: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Tombol konfirmasi
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : _processTopUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4B5320),
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: _isProcessing
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.bolt, color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Konfirmasi Top Up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: isBold ? const Color(0xFF2D2D2D) : Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 16 : 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: isBold ? const Color(0xFF4B5320) : const Color(0xFF2D2D2D),
          ),
        ),
      ],
    );
  }
}

/// Formatter untuk menambahkan separator ribuan saat mengetik
class _ThousandSeparatorFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    final number = int.tryParse(newValue.text.replaceAll('.', ''));
    if (number == null) return oldValue;

    // Format manual dengan titik sebagai separator ribuan
    String numStr = number.toString();
    String result = '';
    int count = 0;
    for (int i = numStr.length - 1; i >= 0; i--) {
      count++;
      result = numStr[i] + result;
      if (count % 3 == 0 && i > 0) {
        result = '.$result';
      }
    }

    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}
