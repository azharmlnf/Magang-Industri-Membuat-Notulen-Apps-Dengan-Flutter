import 'package:flutter/material.dart';
import 'package:notulen_meeting/models/personil_model.dart';
import 'edit_personil.dart';

class PersonilList extends StatelessWidget {
  final List<Personil> personils;
  final Function(int id) onEdit;
  final Function(int id) onDelete;

  PersonilList({
    required this.personils,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Mengelompokkan personils berdasarkan agenda_id
    final groupedPersonils = <int, List<Personil>>{};
    for (var personil in personils) {
      groupedPersonils.putIfAbsent(personil.agendaId, () => []);
      groupedPersonils[personil.agendaId]!.add(personil);
    }

    return ListView.builder(
      itemCount: groupedPersonils.keys.length,
      itemBuilder: (context, index) {
        final agendaId = groupedPersonils.keys.elementAt(index);
        final users = groupedPersonils[agendaId]!;

        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Agenda ID: $agendaId",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                ...users.map((personil) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "User ID: ${personil.userId}",
                          style: TextStyle(fontSize: 14),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => onEdit(personil.id),
                              child: Column(
                                children: [
                                  Icon(Icons.edit, color: Colors.blue),
                                  SizedBox(height: 4),
                                  Text(
                                    'Edit',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 16),
                            GestureDetector(
                              onTap: () => onDelete(personil.id),
                              child: Column(
                                children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(height: 4),
                                  Text(
                                    'Delete',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }
}
