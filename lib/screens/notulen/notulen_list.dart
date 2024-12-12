import 'package:flutter/material.dart';
import 'package:notulen_meeting/models/notulen_model.dart';

class NotulenList extends StatelessWidget {
  final List<Notulen> notulens;
  final Function(int id) onEdit; // Callback untuk edit
  final Function(int id) onDelete; // Callback untuk delete

  NotulenList({
    required this.notulens,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notulens.length,
      itemBuilder: (context, index) {
        final notulen = notulens[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Agenda ID: ${notulen.agendaId}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                "Judul Agenda: ${notulen.judulAgenda}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                "Hasil Notulen:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                notulen.isiNotulens,
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => onEdit(notulen.id),
                    child: Column(
                      children: [
                        Icon(Icons.edit, color: Colors.blue),
                        SizedBox(height: 4),
                        Text(
                          'Edit',
                          style: TextStyle(fontSize: 12, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16), // Jarak antara tombol
                  GestureDetector(
                    onTap: () => onDelete(notulen.id),
                    child: Column(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(height: 4),
                        Text(
                          'Delete',
                          style: TextStyle(fontSize: 12, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ]),
          ),
        );
      },
    );
  }
}
