// models/agenda.dart
class Agenda {
  final int id;
  final String judul;
  final String namaPelanggan;
  final String lokasi;
  final String tanggalKegiatan;
  final String jamKegiatan;
  final String? lampiran;
  final String? link;
  final String tglReminder;

  Agenda({
    required this.id,
    required this.judul,
    required this.namaPelanggan,
    required this.lokasi,
    required this.tanggalKegiatan,
    required this.jamKegiatan,
    this.lampiran,
    this.link,
    required this.tglReminder,
  });

  factory Agenda.fromJson(Map<String, dynamic> json) {
    return Agenda(
      id: json['id'],
      judul: json['judul'],
      namaPelanggan: json['nama_pelanggan'],
      lokasi: json['lokasi'],
      tanggalKegiatan: json['tanggal_kegiatan'],
      jamKegiatan: json['jam_kegiatan'],
      lampiran: json['lampiran'],
      link: json['link'],
      tglReminder: json['tgl_reminder'],
    );
  }
}
