import 'package:flutter/material.dart';
import 'package:notulen_meeting/services/api_service.dart';

class EditNotulenForm extends StatefulWidget {
  final String token; // Token untuk otentikasi
  final Map<String, dynamic> notulen;

  EditNotulenForm({required this.token, required this.notulen});

  @override
  _EditNotulenFormState createState() => _EditNotulenFormState();
}

class _EditNotulenFormState extends State<EditNotulenForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _agendaIdController;
  late TextEditingController _isiNotulenController;

  @override
  void initState() {
    super.initState();
    _agendaIdController = TextEditingController(
        text: widget.notulen['agenda_id'].toString()); // Agenda ID
    _isiNotulenController = TextEditingController(
        text: widget.notulen['isi_notulens']); // Isi notulen
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final data = {
          'agenda_id': int.parse(_agendaIdController.text),
          'isi_notulens': _isiNotulenController.text,
        };

        int notulenId = widget.notulen['id'] is int
            ? widget.notulen['id']
            : int.parse(widget.notulen['id'].toString());

        final response = await ApiService()
            .updateNotulen(widget.token, notulenId, data);

        if (response != null && response['status'] == true) {
          Navigator.pop(context, true); // Mengembalikan tanda berhasil
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Notulen berhasil diperbarui")),
          );
        } else {
          throw Exception('Gagal memperbarui notulen');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Notulen"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Agenda ID",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _agendaIdController,
                  decoration: InputDecoration(
                    labelText: "Agenda ID",
                    hintText: "Masukkan ID Agenda",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "ID Agenda tidak boleh kosong";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Text(
                  "Hasil Notulen",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _isiNotulenController,
                  decoration: InputDecoration(
                    labelText: "Isi Notulen",
                    hintText: "Masukkan hasil notulen, seperti bullet points",
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Isi notulen tidak boleh kosong";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text("Update"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
