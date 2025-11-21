import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:anestesia/components/typewriter_text.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  int pageNumber = 1;

  Future<DocumentSnapshot<Map<String, dynamic>>?> _getPage(int page) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("pages")
        .where("page", isEqualTo: page)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.first;
  }

  void _previousPage() {
    if (pageNumber > 1) {
      setState(() {
        pageNumber--;
      });
    }
  }

  void _nextPage() {
    if (pageNumber < 4) {
      setState(() {
        pageNumber++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'images/2.jpg',
            fit: BoxFit.cover,
          ), // diary page background
        ),
        Scaffold(
          backgroundColor: const Color.fromARGB(88, 83, 75, 75),
          appBar: AppBar(backgroundColor: Colors.transparent),
          body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
            future: _getPage(pageNumber),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.black),
                );
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return Center(
                  child: Text(
                    "No se encontró esta página",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 22, color: Colors.black),
                  ),
                );
              }

              final data = snapshot.data!.data()!;
              final title = data['title'] ?? 'Sin título';
              final date = data['date'] ?? 'Sin fecha';
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
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(date, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 23)),
                    ),
                    const SizedBox(height: 15),
                    TypewriterText(
                      text: body,
                      textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 24),
                      durationPerChar: const Duration(milliseconds: 20),
                      cursor: '▌',
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
                    color: Colors.black,
                    onPressed: _previousPage,
                  ),
                  Text(
                    "$pageNumber / 4",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.black, fontSize: 30),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_circle_right),
                    iconSize: 30,
                    color: Colors.black,
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
