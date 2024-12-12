import 'package:flutter/material.dart';
import 'package:notulen_meeting/services/api_service.dart';

class AddAgendaForm extends StatefulWidget {
  final String token;
  final Function refreshData; // Callback function untuk refresh data

  AddAgendaForm({required this.token, required this.refreshData});

  @override
  _AddAgendaFormState createState() => _AddAgendaFormState();
}

class _AddAgendaFormState extends State<AddAgendaForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _namaPelangganController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();
  final TextEditingController _tanggalKegiatanController = TextEditingController();
  final TextEditingController _jamKegiatanController = TextEditingController();
  final TextEditingController _linkController = TextEditingController(); // Controller untuk link

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        controller.text = picked.format(context);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final data = {
          'judul': _judulController.text,
          'nama_pelanggan': _namaPelangganController.text,
          'lokasi': _lokasiController.text,
          'tanggal_kegiatan': _tanggalKegiatanController.text,
          'jam_kegiatan': _jamKegiatanController.text,
          'link': _linkController.text, // Mengirim data link
        };

        final response = await ApiService().addAgenda(widget.token, data);

        if (response != null && response['status'] == true) {
          widget.refreshData(); // Memanggil callback function
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Agenda added successfully!")),
          );
        } else {
          throw Exception('Failed to add agenda');
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
        children: [
          TextFormField(
            controller: _judulController,
            decoration: InputDecoration(labelText: "Judul Agenda"),
            validator: (value) => value!.isEmpty ? "Please enter a title" : null,
          ),
          TextFormField(
            controller: _namaPelangganController,
            decoration: InputDecoration(labelText: "Nama Pelanggan"),
            validator: (value) => value!.isEmpty ? "Please enter the customer name" : null,
          ),
          TextFormField(
            controller: _lokasiController,
            decoration: InputDecoration(labelText: "Lokasi"),
            validator: (value) => value!.isEmpty ? "Please enter location" : null,
          ),
          TextFormField(
            controller: _tanggalKegiatanController,
            readOnly: true,
            decoration: InputDecoration(labelText: "Tanggal Kegiatan"),
            onTap: () => _selectDate(context, _tanggalKegiatanController),
            validator: (value) => value!.isEmpty ? "Please select event date" : null,
          ),
          TextFormField(
            controller: _jamKegiatanController,
            readOnly: true,
            decoration: InputDecoration(labelText: "Jam Kegiatan"),
            onTap: () => _selectTime(context, _jamKegiatanController),
            validator: (value) => value!.isEmpty ? "Please select event time" : null,
          ),
          TextFormField(
            controller: _linkController, // Input untuk link
            decoration: InputDecoration(labelText: "Link (Optional)"),
          ),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text("Submit"),
          ),
        ],
      ),
    );
  }
}
