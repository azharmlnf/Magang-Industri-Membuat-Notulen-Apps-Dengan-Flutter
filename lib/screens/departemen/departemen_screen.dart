// lib/screens/departmen/departemen_screen.dart
import 'package:flutter/material.dart';
import 'package:notulen_meeting/services/api_service.dart';
import 'departemen_list.dart';
import 'add_departemen.dart';
import 'edit_departemen.dart';

class DepartemenScreen extends StatefulWidget {
  final String token;

  DepartemenScreen({required this.token});

  @override
  _DepartemenScreenState createState() => _DepartemenScreenState();
}

class _DepartemenScreenState extends State<DepartemenScreen> {
  late Future<List<dynamic>> _departemens;

  @override
  void initState() {
    super.initState();
    _departemens = _fetchDepartemens();
  }

  Future<List<dynamic>> _fetchDepartemens() async {
    final response = await ApiService().listDepartemen(widget.token);
    if (response != null && response['status'] == true) {
      return List<dynamic>.from(response['data']);
    } else {
      throw Exception('Failed to load departemens');
    }
  }

  void _showAddDepartemenForm() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Tambah Departemen"),
          content: AddDepartemenForm(token: widget.token),
        );
      },
    );
  }

  Future<void> _showEditDepartemenForm(int departemenId) async {
    try {
      final departemens = await _departemens;
      final departemen = departemens.firstWhere(
        (d) => d['id'].toString() == departemenId.toString(),
        orElse: () => null,
      );

      if (departemen != null) {
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Edit Departemen"),
              content: EditDepartemenForm(
                token: widget.token,
                departemen: departemen,
              ),
            );
          },
        );

        setState(() {
          _departemens = _fetchDepartemens();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Departemen tidak ditemukan")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memuat data departemen: $e")),
      );
    }
  }

  Future<void> _deleteDepartemen(int id) async {
    try {
      final response = await ApiService().deleteDepartemen(widget.token, id);
      if (response != null && response['status'] == true) {
        setState(() {
          _departemens = _fetchDepartemens();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Departemen deleted successfully!")),
        );
      } else {
        throw Exception('Failed to delete departemen');
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
          "Departemen List",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddDepartemenForm,
            tooltip: 'Tambah Departemen',
            color: Colors.white,
          ),
        ],
      ),
      body: DepartemenList(
        departemens: _departemens,
        onEditDepartemen: _showEditDepartemenForm,
        onDeleteDepartemen: _deleteDepartemen,
      ),
    );
  }
}
