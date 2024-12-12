import 'package:flutter/material.dart';
import 'package:notulen_meeting/models/personil_model.dart';
import 'package:notulen_meeting/services/api_service.dart';

import 'add_personil.dart';
import 'edit_personil.dart';
import 'personil_list.dart';

class PersonilScreen extends StatefulWidget {
  final String token;

  PersonilScreen({required this.token});

  @override
  _PersonilScreenState createState() => _PersonilScreenState();
}

class _PersonilScreenState extends State<PersonilScreen> {
  late Future<List<Personil>> _personils = Future.value([]);
  final TextEditingController _agendaIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _agendaIdController.addListener(_loadPersonils);
  }

  Future<List<Personil>> _fetchPersonils() async {
    try {
      if (_agendaIdController.text.isEmpty) {
        throw Exception("Agenda ID tidak boleh kosong.");
      }

      final int agendaId = int.parse(_agendaIdController.text);
      final response = await ApiService().listPersonil(widget.token, agendaId);
      if (response != null && response['status'] == true) {
        return List<Personil>.from(
          response['data'].map((item) => Personil.fromJson(item)),
        );
      } else {
        throw Exception(response?['message'] ?? 'Personil tidak ditemukan');
      }
    } catch (e) {
      throw Exception("Error fetching personil: $e");
    }
  }

  void _loadPersonils() {
    setState(() {
      _personils = _fetchPersonils();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Daftar Personil",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPersonilForm(token: widget.token),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _agendaIdController,
              decoration: InputDecoration(
                labelText: 'Agenda ID',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _loadPersonils,
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Personil>>(
                future: _personils,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("Personil tidak ditemukan"));
                  } else {
                    return PersonilList(
                      personils: snapshot.data!,
                      onEdit: (id) {
                        final personil = snapshot.data!
                            .firstWhere((element) => element.id == id);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPersonilForm(
                              token: widget.token,
                              personil: personil.toJson(),
                            ),
                          ),
                        );
                      },
                      onDelete: (id) async {
                        int personilId =
                            int.tryParse(id.toString()) ?? 0; // Konversi ke int
                        if (personilId == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("ID tidak valid")),
                          );
                          return;
                        }

                        final isDeleted = await ApiService.deletePersonil(
                            personilId, widget.token);
                        if (isDeleted != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text("Personil berhasil dihapus")),
                          );
                          _loadPersonils(); // Pastikan _loadPersonils memperbarui daftar personil
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Gagal menghapus personil")),
                          );
                        }
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
