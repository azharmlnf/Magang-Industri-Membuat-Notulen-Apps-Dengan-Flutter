// models/departemen_model.dart

class Departemen {
  final int id;
  final String namaDepartemen;
  final String? deskripsi;

  Departemen({
    required this.id,
    required this.namaDepartemen,
    this.deskripsi,
  });

  // Factory method untuk membuat instance dari JSON
  factory Departemen.fromJson(Map<String, dynamic> json) {
    return Departemen(
      id: json['id'],
      namaDepartemen: json['nama_departemen'],
      deskripsi: json['deskripsi'], // Bisa null
    );
  }

  // Method untuk mengonversi instance menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_departemen': namaDepartemen,
      'deskripsi': deskripsi,
    };
  }
}
