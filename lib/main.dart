import 'package:flutter/material.dart';
import 'package:notulen_meeting/screens/departemen/departemen_screen.dart';
import 'package:notulen_meeting/screens/notulen/notulen_screen.dart';

import 'screens/agenda/agenda_screen.dart'; // Import AgendaScreen
import 'screens/personil/personil_screen.dart'; 

import 'screens/auth/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notulen Apps Flutter',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      // Declare routes
      routes: {
        '/agenda': (context) => AgendaScreen(
            token: ModalRoute.of(context)?.settings.arguments as String? ??
                'default_token'),
        '/departemen': (context) => DepartemenScreen(
            token: ModalRoute.of(context)?.settings.arguments as String? ??
                'default_token'),
        '/notulen': (context) => NotulenScreen(
            token: ModalRoute.of(context)?.settings.arguments as String? ??
                'default_token'),
                 '/personil': (context) => PersonilScreen(
            token: ModalRoute.of(context)?.settings.arguments as String? ??
                'default_token'),
                
      },
      home: LoginScreen(), // First screen displayed
    );
  }
}
