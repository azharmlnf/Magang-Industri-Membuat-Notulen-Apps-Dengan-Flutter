// lib/screens/departemen/add_departemen.dart
import 'package:flutter/material.dart';
import 'package:notulen_meeting/services/api_service.dart';

class AddDepartemenForm extends StatefulWidget {
  final String token;

  AddDepartemenForm({required this.token});

  @override
  _AddDepartemenFormState createState() => _AddDepartemenFormState();
}

class _AddDepartemenFormState extends State<AddDepartemenForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaDepartemenController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final data = {
          'nama_departemen': _namaDepartemenController.text,
          'deskripsi': _deskripsiController.text,
        };

        final response = await ApiService().addDepartemen(widget.token, data);

        if (response != null && response['status'] == true) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Departemen added successfully!")),
          );
        } else {
          throw Exception('Failed to add departemen');
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
        title: Text("Add Departemen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _namaDepartemenController,
                decoration: InputDecoration(labelText: "Nama Departemen"),
                validator: (value) => value!.isEmpty ? "Please enter a department name" : null,
              ),
              TextFormField(
                controller: _deskripsiController,
                decoration: InputDecoration(labelText: "Deskripsi (Optional)"),
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
    );
  }
}
