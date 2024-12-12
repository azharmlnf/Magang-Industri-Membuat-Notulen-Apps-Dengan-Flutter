import 'package:flutter/material.dart';
import 'package:notulen_meeting/services/api_service.dart';
import 'agenda_list.dart';
import 'add_agenda.dart';
import 'edit_agenda.dart';

class AgendaScreen extends StatefulWidget {
  final String token;
  AgendaScreen({required this.token});

  @override
  _AgendaScreenState createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  late Future<List<dynamic>> _agendas;

  @override
  void initState() {
    super.initState();
    _agendas = _fetchAgendas();
  }

  Future<List<dynamic>> _fetchAgendas() async {
    final response = await ApiService().listAgenda(widget.token);
    if (response != null && response['status'] == true) {
      return List<dynamic>.from(response['data']);
    } else {
      throw Exception('Failed to load agendas');
    }
  }

void _refreshAgendaList() {
  setState(() {
    _agendas = _fetchAgendas(); // Memuat ulang daftar agenda dari API
  });
}

void _showAddAgendaForm() {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Tambah Agenda"),
        content: AddAgendaForm(
          token: widget.token,
          refreshData: _refreshAgendaList, // Memanggil fungsi refresh
        ),
      );
    },
  );
}


  Future<void> _showEditAgendaForm(int agendaId) async {
    try {
      final agendas = await _agendas;
      final agenda = agendas.firstWhere(
        (agenda) => agenda['id'].toString() == agendaId.toString(),
        orElse: () => null,
      );

      if (agenda != null) {
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Edit Agenda"),
              content: EditAgendaForm(
                token: widget.token,
                agenda: agenda,
              ),
            );
          },
        );

        setState(() {
          _agendas = _fetchAgendas();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Agenda tidak ditemukan")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memuat data agenda: $e")),
      );
    }
  }

  Future<void> _deleteAgenda(int id) async {
    try {
      final response = await ApiService().deleteAgenda(widget.token, id);
      if (response != null && response['status'] == true) {
        setState(() {
          _agendas = _fetchAgendas();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Agenda deleted successfully!")),
        );
      } else {
        throw Exception('Failed to delete agenda');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Agenda List",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddAgendaForm,
            tooltip: 'Tambah Agenda',
            color: Colors.white,
          ),
        ],
      ),
      body: AgendaList(
        agendas: _agendas,
        onEditAgenda: _showEditAgendaForm,
        onDeleteAgenda: _deleteAgenda,
      ),
    );
  }
}
