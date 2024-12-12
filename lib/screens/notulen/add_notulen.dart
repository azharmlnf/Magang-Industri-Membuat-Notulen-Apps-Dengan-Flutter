import 'package:flutter/material.dart';
import 'package:notulen_meeting/services/api_service.dart';

class AddNotulenForm extends StatefulWidget {
  final String token;

  AddNotulenForm({required this.token});

  @override
  _AddNotulenFormState createState() => _AddNotulenFormState();
}

class _AddNotulenFormState extends State<AddNotulenForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _agendaIdController = TextEditingController();
  final TextEditingController _isiNotulensController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final data = {
          'agenda_id': int.parse(_agendaIdController.text),
          'isi_notulens': _isiNotulensController.text,
        };

        final response = await ApiService().addNotulen(widget.token, data);

        if (response != null && response['status'] == true) {
          Navigator.pop(context, true); // Mengembalikan true jika berhasil
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Notulen added successfully!")),
          );
        } else {
          throw Exception('Unable to add notulen. The notulen already exists.');
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
        title: Text("Tambah Notulen"),
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
                  controller: _isiNotulensController,
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
                  child: Text("Submit"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
