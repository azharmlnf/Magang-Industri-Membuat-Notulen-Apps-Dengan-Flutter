import 'package:flutter/material.dart';

class DepartemenList extends StatelessWidget {
  final Future<List<dynamic>> departemens;
  final Function(int) onEditDepartemen;
  final Function(int) onDeleteDepartemen;

  DepartemenList({
    required this.departemens,
    required this.onEditDepartemen,
    required this.onDeleteDepartemen,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: departemens,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No departemens available'));
          }

          final departemens = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: departemens.length,
            itemBuilder: (context, index) {
              final departemen = departemens[index];
              final int departemenId =
                  int.tryParse(departemen['id'].toString()) ?? 0;

              return GestureDetector(
                onTap: () {
                  // Detail view functionality
                  print('Tapped on ${departemen['nama_departemen']}');
                },
                child: Container(
                  height: 150,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                departemen['nama_departemen'],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                departemen['deskripsi'] ?? 'No description',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blueAccent),
                              onPressed: () {
                                onEditDepartemen(departemenId);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () {
                                onDeleteDepartemen(departemenId);
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
