import 'package:flutter/material.dart';

import '../screens/auth/login_screen.dart';
import '../services/api_service.dart';
import '../widgets/custom_drawer.dart';

class DashboardScreen extends StatefulWidget {
  final String token;

  DashboardScreen({required this.token});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService apiService = ApiService();
  Map<String, dynamic>? agendas;
  int notificationCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchAgendas();
  }

  Future<void> _fetchAgendas() async {
    try {
      final response = await apiService.getAgendas(widget.token);
      if (!mounted) return;
      setState(() {
        agendas = response;
        notificationCount = agendas?['upcomingAgendas']?.length ?? 0;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data: $e')),
      );
    }
  }

  void _logout() async {
    final response = await apiService.logout(widget.token);
    if (!mounted) return;
    if (response != null && response['status'] == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  void _showAgendaDetails(Map<String, dynamic> agenda) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(agenda['judul']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('id: ${agenda['id']}'),
            Text('Pelanggan: ${agenda['nama_pelanggan']}'),
            Text('Lokasi: ${agenda['lokasi']}'),
            Text('Tanggal: ${agenda['tanggal_kegiatan']}'),
            Text('Jam: ${agenda['jam_kegiatan']}'),
            Text('Link: ${agenda['link'] ?? '-'}'),
            Text('Reminder: ${agenda['tgl_reminder']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _buildAgendaSection(String title, List<dynamic> agendas, Color color) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: color,
            width: double.infinity,
            padding: EdgeInsets.all(12),
            child: Text(
              title,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            color: Colors.white,
            child: Column(
              children: agendas.map((agenda) {
                return ListTile(
                  title: Text(agenda['judul']),
                  subtitle: Text(agenda['tanggal_kegiatan']),
                  onTap: () => _showAgendaDetails(agenda),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final monthAgendas = agendas?['monthAgendas'] ?? [];
    final upcomingAgendas = agendas?['upcomingAgendas'] ?? [];
    final finishedAgendas = agendas?['finishedAgendas'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text('Notifikasi'),
                      content: Text('Agenda besok berjumlah $notificationCount'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Tutup'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              if (notificationCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$notificationCount',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      drawer: CustomDrawer(
        onLogout: _logout,
        user: agendas,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchAgendas,
        child: agendas == null
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildAgendaSection(
                        'Rekap Bulan Ini', monthAgendas, Colors.blueAccent),
                    _buildAgendaSection('Agenda Akan Datang', upcomingAgendas,
                        Colors.greenAccent),
                    _buildAgendaSection(
                        'Agenda Selesai', finishedAgendas, Colors.orangeAccent),
                  ],
                ),
              ),
      ),
    );
  }
}
