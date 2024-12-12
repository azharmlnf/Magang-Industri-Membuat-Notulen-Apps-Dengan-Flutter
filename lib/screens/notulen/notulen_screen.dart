import 'package:flutter/material.dart';
import 'package:notulen_meeting/models/notulen_model.dart';
import 'package:notulen_meeting/services/api_service.dart';

import 'add_notulen.dart';
import 'edit_notulen.dart';
import 'notulen_list.dart';

class NotulenScreen extends StatefulWidget {
  final String token;

  NotulenScreen({required this.token});

  @override
  _NotulenScreenState createState() => _NotulenScreenState();
}

class _NotulenScreenState extends State<NotulenScreen> {
  late Future<List<Notulen>> _notulens;

  @override
  void initState() {
    super.initState();
    _loadNotulens();
  }

  void _loadNotulens() {
    setState(() {
      _notulens = _fetchNotulens();
    });
  }

  Future<List<Notulen>> _fetchNotulens() async {
    final response = await ApiService().listNotulen(widget.token);
    if (response != null && response['status'] == true) {
      return List<Notulen>.from(
        response['data'].map((item) => Notulen.fromJson(item)),
      );
    } else {
      throw Exception('Failed to load notulens');
    }
  }

  void _showAddNotulenForm() async {
    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Tambah Notulen"),
        content: AddNotulenForm(token: widget.token),
      ),
    );

    if (result == true) {
      _loadNotulens(); // Refresh setelah berhasil menambah
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Notulen berhasil ditambahkan")),
      );
    }
  }

  Future<void> _showEditNotulenForm(int notulenId) async {
    try {
      final notulens = await _notulens;
      final notulen = notulens.firstWhere(
        (n) => n.id == notulenId,
        orElse: () => throw Exception('Notulen not found'),
      );

      final result = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Edit Notulen"),
          content: EditNotulenForm(
            token: widget.token,
            notulen: notulen.toJson(),
          ),
        ),
      );

      if (result == true) {
        _loadNotulens(); // Refresh setelah berhasil mengedit
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Notulen berhasil diperbarui")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memuat notulen: $e")),
      );
    }
  }

  Future<void> _deleteNotulen(int id) async {
    try {
      final response = await ApiService.deleteNotulen(id);

      if (response != null && response['status'] == true) {
        _loadNotulens(); // Refresh setelah berhasil menghapus
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Notulen berhasil dihapus")),
        );
      } else {
        throw Exception(response?['message'] ?? 'Gagal menghapus notulen');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notulen List",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddNotulenForm,
            tooltip: 'Tambah Notulen',
            color: Colors.white,
          ),
        ],
      ),
      body: FutureBuilder<List<Notulen>>(
        future: _notulens,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No notulens found"));
          }

          return NotulenList(
            notulens: snapshot.data!,
            onEdit: _showEditNotulenForm,
            onDelete: _deleteNotulen,
          );
        },
      ),
    );
  }
}
