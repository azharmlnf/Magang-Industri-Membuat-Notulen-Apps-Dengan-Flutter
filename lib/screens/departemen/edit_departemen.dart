import 'package:flutter/material.dart';
import 'package:notulen_meeting/services/api_service.dart';

class EditDepartemenForm extends StatefulWidget {
  final String token;
  final Map<String, dynamic> departemen;

  EditDepartemenForm({required this.token, required this.departemen});

  @override
  _EditDepartemenFormState createState() => _EditDepartemenFormState();
}

class _EditDepartemenFormState extends State<EditDepartemenForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaDepartemenController;
  late TextEditingController _deskripsiController;

  @override
  void initState() {
    super.initState();
    _namaDepartemenController =
        TextEditingController(text: widget.departemen['nama_departemen']);
    _deskripsiController =
        TextEditingController(text: widget.departemen['deskripsi']);
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final data = {
          'nama_departemen': _namaDepartemenController.text,
          'deskripsi': _deskripsiController.text,
        };

        // Pastikan departemenId adalah int
        int departemenId = widget.departemen['id'] is int
            ? widget.departemen['id']
            : int.parse(widget.departemen['id'].toString());

        final response = await ApiService()
            .updateDepartemen(widget.token, departemenId, data);

        if (response != null && response['status'] == true) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Departemen updated successfully!")),
          );
        } else {
          throw Exception('Failed to update departemen');
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
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _namaDepartemenController,
            decoration: InputDecoration(labelText: "Nama Departemen"),
            validator: (value) =>
                value!.isEmpty ? "Nama departemen tidak boleh kosong" : null,
          ),
          TextFormField(
            controller: _deskripsiController,
            decoration: InputDecoration(labelText: "Deskripsi Departemen"),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text("Update"),
          ),
        ],
      ),
    );
  }
}
