import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BestiaryPage extends StatefulWidget {
  const BestiaryPage({super.key});

  @override
  State<BestiaryPage> createState() => _BestiaryPageState();
}

class _BestiaryPageState extends State<BestiaryPage> {
  int currentBeastId = 1;

  Future<DocumentSnapshot<Map<String, dynamic>>?> _getPage(int beastId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("beasts")
        .where("beastId", isEqualTo: beastId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.first;
  }

  void _previousPage() {
    if (currentBeastId > 1) {
      setState(() {
        currentBeastId--;
      });
    }
  }

  void _nextPage() {
    if (currentBeastId < 1) {
      setState(() {
        currentBeastId++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.black87,
        ), //De querer modificar solo los fondos, mover aqui
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.white70),
          ),
          body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
            future: _getPage(currentBeastId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white70),
                );
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(
                  child: Text(
                    "No se encontró esta página",
                    style: TextStyle(fontSize: 22, color: Colors.white70),
                  ),
                );
              }

              final data = snapshot.data!.data()!;
              final title = data['title'] ?? 'Sin título';
              final area = data['area'] ?? 'Sin Area';
              final body = data['body'] ?? 'Sin contenido';

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "“$title”",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        area,
                        style: const TextStyle(
                          fontSize: 23,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      body,
                      style: const TextStyle(
                        fontSize: 24,
                        fontFamily: "Nanum",
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_circle_left),
                    iconSize: 30,
                    color: Colors.white70,
                    onPressed: _previousPage,
                  ),
                  Text(
                    "$currentBeastId / 1",
                    style: const TextStyle(color: Colors.white70, fontSize: 30),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_circle_right),
                    iconSize: 30,
                    color: Colors.white70,
                    onPressed: _nextPage,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
