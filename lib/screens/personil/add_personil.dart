import 'package:flutter/material.dart';
import 'package:notulen_meeting/services/api_service.dart';

class AddPersonilForm extends StatefulWidget {
  final String token;

  const AddPersonilForm({Key? key, required this.token}) : super(key: key);

  @override
  _AddPersonilFormState createState() => _AddPersonilFormState();
}

class _AddPersonilFormState extends State<AddPersonilForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _agendaIdController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final data = {
          'agenda_id': int.parse(_agendaIdController.text),
          'user_id': int.parse(_userIdController.text),
        };

        final response = await ApiService().addPersonil(widget.token, data);

        if (response != null && response['status'] == true) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Personil added successfully!")),
          );
        } else {
          throw Exception('Failed to add personil. The user might already added for this agenda.');
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
        title: Text("Tambah Personil"),
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
