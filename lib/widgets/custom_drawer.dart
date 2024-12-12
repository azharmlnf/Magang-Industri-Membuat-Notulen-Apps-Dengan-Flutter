import 'package:flutter/material.dart';
import 'package:notulen_meeting/screens/departemen/departemen_screen.dart';

import '../screens/agenda/agenda_screen.dart';
import '../screens/notulen/notulen_screen.dart';
import '../screens/personil/personil_screen.dart';

class CustomDrawer extends StatelessWidget {
  final VoidCallback onLogout;
  final Map<String, dynamic>? user; // Tambahkan user sebagai parameter

  CustomDrawer({required this.onLogout, this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                SizedBox(height: 10),
                user != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('@${user!['username']}',
                              style: TextStyle(color: Colors.white)),
                        ],
                      )
                    : Text('Loading...', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_month),
            title: Text("Agenda"),
            onTap: () {
              // Navigate to AgendaScreen and pass the token
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AgendaScreen(
                      token: 'your_token_here'), // Pass the token here
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.people_outlined),
            title: Text('Personil Agenda'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PersonilScreen(
                      token: 'your_token_here'), // Pass the token here
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.note),
            title: Text("Notulen"),
            onTap: () {
              // Navigate to AgendaScreen and pass the token
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotulenScreen(
                      token: 'your_token_here'), // Pass the token here
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.people_alt_rounded),
            title: Text("Departemen"),
            onTap: () {
              // Navigate to AgendaScreen and pass the token
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DepartemenScreen(
                      token: 'your_token_here'), // Pass the token here
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}
