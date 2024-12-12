import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Pastikan untuk menambahkan package ini di pubspec.yaml

class AgendaList extends StatelessWidget {
  final Future<List<dynamic>> agendas;
  final Function(int) onEditAgenda;
  final Function(int) onDeleteAgenda;

  AgendaList({
    required this.agendas,
    required this.onEditAgenda,
    required this.onDeleteAgenda,
  });

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: agendas,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No agendas available'));
        }

        final agendas = snapshot.data!;
        return ListView.builder(
          itemCount: agendas.length,
          itemBuilder: (context, index) {
            final agenda = agendas[index];
            final int agendaId = int.tryParse(agenda['id'].toString()) ?? 0;

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                title: Text(
                  agenda['judul'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.blueAccent,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lokasi: ${agenda['lokasi']}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Tanggal: ${agenda['tanggal_kegiatan']} at ${agenda['jam_kegiatan']}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    if (agenda['link'] != null &&
                        agenda['link'].isNotEmpty) ...[
                      SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => _launchURL(agenda['link']),
                        child: Text(
                          'Link: ${agenda['link']}',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    
                    GestureDetector(
                      onTap: () {
                        onEditAgenda(agendaId);
                      },
                      child: Column(
                        children: [
                          Icon(Icons.edit, color: Colors.blueAccent),
                          SizedBox(height: 4),
                          Text('Edit', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        onDeleteAgenda(agendaId);
                      },
                      child: Column(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(height: 4),
                          Text('Delete', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
