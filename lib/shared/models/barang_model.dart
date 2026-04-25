class BarangModel {
  final int idProduct;
  final String namaProduct;
  final String? deskripsi;
  final int? price;
  final String? category;
  final int? harga;
  final int? stok;
  final String? satuan;
  final String? gambar;
  final int? idUser;
  final int? idCategory;

  BarangModel({
    required this.idProduct,
    required this.namaProduct,
    this.deskripsi,
    this.price,
    this.category,
    this.harga,
    this.stok,
    this.satuan,
    this.gambar,
    this.idUser,
    this.idCategory,
  });

  factory BarangModel.fromJson(Map<String, dynamic> json) {
    // Fungsi bantuan agar aman mengubah String/Double dari MySQL menjadi Int di Flutter
    int? parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) {
        // Jika teks berisi "75000.00", ubah ke desimal dulu, baru bulatkan ke int (75000)
        return double.tryParse(value)?.toInt();
      }
      return null;
    }

    return BarangModel(
      idProduct: parseInt(json['id_product']) ?? 0, 
      namaProduct: json['nama_product']?.toString() ?? 'Tanpa Nama',
      deskripsi: json['deskripsi']?.toString(),
      price: parseInt(json['price']),
      category: json['category']?.toString(),
      harga: parseInt(json['harga']),
      stok: parseInt(json['stok']),
      satuan: json['satuan']?.toString(),
      gambar: json['gambar']?.toString(),
      idUser: parseInt(json['id_user']),
      idCategory: parseInt(json['id_category']),
    );
  }
}