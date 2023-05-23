class sayur{
  final int id;
  final String nama_sayur;
  final int harga_sayur;
  final int stock;
  final String deskripsi;
  final String gambar;

  const sayur({
    required this.id,
    required this.nama_sayur,
    required this.harga_sayur,
    required this.stock,
    required this.deskripsi,
    required this.gambar,
  });

  factory sayur.fromJson(Map<String,dynamic>json){
    return sayur(
      id: json['id'],
      nama_sayur: json['nama_sayur'],
      harga_sayur: json['harga_sayur'],
      stock: json['stock'],
      deskripsi: json['deskripsi'],
      gambar: json['gambar'],
    );
  }
}