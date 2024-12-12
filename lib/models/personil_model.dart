class Personil {
  final int id;
  final int agendaId;
  final int userId;

  Personil({
    required this.id,
    required this.agendaId,
    required this.userId,
  });

  // Factory method untuk membuat instance dari JSON
factory Personil.fromJson(Map<String, dynamic> json) {
  return Personil(
    id: int.tryParse(json['id'].toString()) ?? 0,
    agendaId: int.tryParse(json['agenda_id'].toString()) ?? 0,
    userId: int.tryParse(json['user_id'].toString()) ?? 0,
  );
}


  // Method untuk mengonversi instance ke dalam bentuk JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'agenda_id': agendaId,
      'user_id': userId,
    };
  }
}
