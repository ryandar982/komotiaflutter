import 'package:flutter/material.dart';
import 'package:komotia/shared/service/api_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Tambahkan TextEditingController untuk menangkap inputan
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _noTelpController = TextEditingController();
  final _alamatController = TextEditingController();

  bool _isObscured = true;
  bool _isConfirmObscured = true;
  bool _isLoading = false;

  @override
  void dispose() {
    // jangan lupa dispose controller untuk mencegah memory leak
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _noTelpController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  // Fungsi untuk memproses pendaftaran
  Future<void> _handleRegister() async {
    // Validasi konfirmasi password
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password dan Konfirmasi Password tidak cocok!')),
      );
      return;
    }

    // Validasi field kosong
    if (_namaController.text.isEmpty || 
        _emailController.text.isEmpty || 
        _passwordController.text.isEmpty || 
        _noTelpController.text.isEmpty || 
        _alamatController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap lengkapi semua data!')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final apiService = ApiService();
    final isSuccess = await apiService.registerUser(
      nama: _namaController.text,
      email: _emailController.text,
      password: _passwordController.text,
      noTelp: _noTelpController.text,
      alamat: _alamatController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;

    if (isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registrasi Komotia berhasil! Silakan masuk.')),
      );
      Navigator.pop(context); // Kembali ke halaman Login setelah sukses
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registrasi gagal, silakan coba lagi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Buat Akun Baru",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text("Lengkapi data di bawah ini untuk mendaftar di Komotia."),
            const SizedBox(height: 32),

            // Input Nama Lengkap
            const Text("Username / Nama Lengkap", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _namaController,
              decoration: InputDecoration(
                hintText: "masukkan nama anda",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 20),

            // Input Email
            const Text("Email", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "example@email.com",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 20),

            // Input No Telepon (Baru ditambahkan sesuai API)
            const Text("No. Telepon", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _noTelpController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: "081234567890",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.phone_outlined),
              ),
            ),
            const SizedBox(height: 20),

            // Input Alamat (Baru ditambahkan sesuai API)
            const Text("Alamat", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _alamatController,
              decoration: InputDecoration(
                hintText: "Masukkan kota / alamat anda",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.location_on_outlined),
              ),
            ),
            const SizedBox(height: 20),

            // Input Password
            const Text("Password", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              obscureText: _isObscured,
              decoration: InputDecoration(
                hintText: "Buat password",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(_isObscured ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _isObscured = !_isObscured),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Input Konfirmasi Password
            const Text("Konfirmasi Password", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _confirmPasswordController,
              obscureText: _isConfirmObscured,
              decoration: InputDecoration(
                hintText: "Ulangi password",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.lock_reset_outlined),
                suffixIcon: IconButton(
                  icon: Icon(_isConfirmObscured ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _isConfirmObscured = !_isConfirmObscured),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Tombol Daftar
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 75, 83, 32),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Daftar Sekarang", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 24),

            // Sudah punya akun? Login
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Sudah punya akun?"),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Kembali ke halaman Login
                  },
                  child: const Text(
                    "Masuk",
                    style: TextStyle(color: Color.fromARGB(255, 75, 83, 32), fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}