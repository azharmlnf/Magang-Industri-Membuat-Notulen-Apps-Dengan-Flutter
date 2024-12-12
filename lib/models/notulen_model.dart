class Notulen {
  final int id;
  final String isiNotulens;
  final int agendaId;
  final String judulAgenda; // Tambahkan field judulAgenda
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Notulen({
    required this.id,
    required this.isiNotulens,
    required this.agendaId,
    required this.judulAgenda, // Tambahkan ke konstruktor
    this.createdAt,
    this.updatedAt,
  });

  // Factory method untuk membuat instance dari JSON
  factory Notulen.fromJson(Map<String, dynamic> json) {
    return Notulen(
      id: int.parse(json['id'].toString()),
      isiNotulens: json['isi_notulens'] ?? '',
      agendaId: int.parse(json['agenda_id'].toString()),
      judulAgenda: json['judulAgenda'] ?? '', // Ambil field judulAgenda dari JSON
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  // Konversi kembali ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isi_notulens': isiNotulens,
      'agenda_id': agendaId,
      'judulAgenda': judulAgenda, // Pastikan field ini termasuk dalam toJson
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
