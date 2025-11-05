import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScoreboardPage extends StatefulWidget {
  const ScoreboardPage({super.key});

  @override
  State<ScoreboardPage> createState() => _ScoreboardPageState();
}

class _ScoreboardPageState extends State<ScoreboardPage> {
  String selectedCategory = 'Any%';
  final categories = ['Any%', '100%', 'Low%'];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFDD60BE), Color(0xFF1E1E1E)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        Scaffold(
          appBar: AppBar(backgroundColor: Colors.transparent),
          backgroundColor: Colors.transparent,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Ranking por tiempo",
                    style: TextStyle(fontSize: 35, color: Colors.white),
                  ),
                  const SizedBox(height: 15),

                  DropdownButton(
                    value: selectedCategory,
                    dropdownColor: Colors.grey.shade800,
                    items: categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(
                          category,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedCategory = newValue!;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("scores")
                          .where("Category", isEqualTo: selectedCategory)
                          .orderBy("Time")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Text(
                            "No hay registros aún",
                            style: TextStyle(color: Colors.white),
                          );
                        }

                        final docs = snapshot.data!.docs;

                        final rows = docs.map((doc) {
                          print(doc);
                          final data = doc.data() as Map<String, dynamic>;
                          return TableRow(
                            children: [
                              _buildCell(data['time'].toString()),
                              _buildCell(data['player'] ?? ''),
                              _buildCell(data['progress'] ?? ''),
                            ],
                          );
                        }).toList();

                        return SingleChildScrollView(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(70),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Table(
                              border: TableBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              children: [
                                TableRow(
                                  children: [
                                    _buildHeader("Tiempo"),
                                    _buildHeader("Jugador"),
                                    _buildHeader("Avance"),
                                  ],
                                ),
                                ...rows,
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
