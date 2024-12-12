import 'package:flutter/material.dart';
import 'package:notulen_meeting/services/api_service.dart';

class EditAgendaForm extends StatefulWidget {
  final String token;
  final Map<String, dynamic> agenda;

  EditAgendaForm({required this.token, required this.agenda});

  @override
  _EditAgendaFormState createState() => _EditAgendaFormState();
}

class _EditAgendaFormState extends State<EditAgendaForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _judulController;
  late TextEditingController _namaPelangganController;
  late TextEditingController _lokasiController;
  late TextEditingController _tanggalKegiatanController;
  late TextEditingController _jamKegiatanController;
  late TextEditingController _linkController; // Controller untuk link

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.agenda['judul']);
    _namaPelangganController = TextEditingController(text: widget.agenda['nama_pelanggan']);
    _lokasiController = TextEditingController(text: widget.agenda['lokasi']);
    _tanggalKegiatanController = TextEditingController(text: widget.agenda['tanggal_kegiatan']);
    _jamKegiatanController = TextEditingController(text: widget.agenda['jam_kegiatan']);
    _linkController = TextEditingController(text: widget.agenda['link']); // Inisialisasi controller link
  }

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        controller.text = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _selectTime(TextEditingController controller) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        controller.text = pickedTime.format(context);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Mengonversi tanggal dan jam ke format yang sesuai
        DateTime tanggalKegiatan = DateTime.parse(_tanggalKegiatanController.text);
        TimeOfDay jamKegiatan = TimeOfDay.fromDateTime(DateTime.parse("1970-01-01 " + _jamKegiatanController.text));

        final data = {
          'judul': _judulController.text,
          'nama_pelanggan': _namaPelangganController.text,
          'lokasi': _lokasiController.text,
          // Kirim tanggal sebagai string dalam format YYYY-MM-DD
          'tanggal_kegiatan': "${tanggalKegiatan.year}-${tanggalKegiatan.month.toString().padLeft(2, '0')}-${tanggalKegiatan.day.toString().padLeft(2, '0')}",
          // Kirim jam sebagai string dalam format HH:MM:SS
          'jam_kegiatan': "${jamKegiatan.hour.toString().padLeft(2, '0')}:${jamKegiatan.minute.toString().padLeft(2, '0')}:00",
          'link': _linkController.text, // Mengirim data link
        };

        // Pastikan agendaId adalah int
        int agendaId = widget.agenda['id'] is int ? widget.agenda['id'] : int.parse(widget.agenda['id'].toString());

        final response = await ApiService().updateAgenda(widget.token, agendaId, data);

        if (response != null && response['status'] == true) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Agenda updated successfully!")),
          );
        } else {
          throw Exception('Failed to update agenda');
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
            decoration: InputDecoration(
              labelText: "Tanggal Kegiatan",
              suffixIcon: Icon(Icons.calendar_today),
            ),
            onTap: () => _selectDate(_tanggalKegiatanController),
            validator: (value) => value!.isEmpty ? "Please select a date" : null,
          ),
          TextFormField(
            controller: _jamKegiatanController,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Jam Kegiatan",
              suffixIcon: Icon(Icons.access_time),
            ),
            onTap: () => _selectTime(_jamKegiatanController),
            validator: (value) => value!.isEmpty ? "Please select a time" : null,
          ),
          // Menghapus input untuk tgl_reminder karena sudah otomatis dihitung di backend
          TextFormField(
            controller: _linkController, // Input untuk link
            decoration: InputDecoration(labelText: "Link (Optional)"),
            validator: (value) => value!.isEmpty ? null : null, // Optional field, no validation needed
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
