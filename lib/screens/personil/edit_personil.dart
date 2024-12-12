import 'package:flutter/material.dart';
import 'package:notulen_meeting/services/api_service.dart';

class EditPersonilForm extends StatefulWidget {
  final String token; // Token untuk otentikasi
  final Map<String, dynamic> personil;

  EditPersonilForm({required this.token, required this.personil});

  @override
  _EditPersonilFormState createState() => _EditPersonilFormState();
}

class _EditPersonilFormState extends State<EditPersonilForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _agendaIdController;
  late TextEditingController _userIdController;

  @override
  void initState() {
    super.initState();
    _agendaIdController = TextEditingController(
        text: widget.personil['agenda_id'].toString()); // ID Agenda
    _userIdController = TextEditingController(
        text: widget.personil['user_id'].toString()); // ID User
  }

 Future<void> _submitForm() async {
  if (_formKey.currentState!.validate()) {
    try {
      final data = {
        'user_id': int.parse(_userIdController.text),
        'agenda_id': int.parse(_agendaIdController.text),
      };

      int personilId = widget.personil['id'] is int
          ? widget.personil['id']
          : int.parse(widget.personil['id'].toString());

      final response =
          await ApiService().updatePersonil(widget.token, personilId, data);

      if (response != null && response['status'] == true) {
        // Menyegarkan daftar personil setelah berhasil update
        Navigator.pop(context, true); // Kembali ke halaman sebelumnya dengan status true
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Personil berhasil diperbarui")),
        );
      } else {
        throw Exception('Gagal memperbarui personil');
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
        title: Text("Edit Personil"),
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
                  readOnly: true,
                ),
                SizedBox(height: 16),
                Text(
                  "User ID",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _userIdController,
                  decoration: InputDecoration(
                    labelText: "User ID",
                    hintText: "Masukkan ID User",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "ID User tidak boleh kosong";
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
