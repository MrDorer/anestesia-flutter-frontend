import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BestiaryPage extends StatefulWidget {
  const BestiaryPage({super.key});

  @override
  State<BestiaryPage> createState() => _BestiaryPageState();
}

class _BestiaryPageState extends State<BestiaryPage> {
  Future<List<DocumentSnapshot<Map<String, dynamic>>>> _getBeasts() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('beasts')
        .orderBy('beastId')
        .get();
    return snapshot.docs;
  }

  Widget _buildImageWidget(String? img) {
    if (img != null && img.isNotEmpty && img.startsWith('http')) {
      return Image.network(img, fit: BoxFit.cover, width: double.infinity);
    }

    // Fallback: simple icon placeholder to avoid broken asset references
    return Container(
      color: Colors.black26,
      child: const Center(
        child: Icon(
          Icons.bug_report,
          size: 48,
          color: Colors.white70,
        ),
      ),
    );
  }

  void _openDetail(BuildContext context, Map<String, dynamic> data) {
    final title = data['title'] ?? 'Sin título';
    final area = data['area'] ?? 'Sin área';
    final body = data['body'] ?? 'Sin contenido';
    final img = data['image'] as String?;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.white70),
            title: Text(title),
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 300,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _buildImageWidget(img),
                  ),
                ),
                const SizedBox(height: 16),
                Text(title,
                    style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70)),
                const SizedBox(height: 8),
                Text(area, style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 16),
                Text(body,
                    style: const TextStyle(
                        fontSize: 18, color: Colors.white70)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'images/homeback.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.white70),
            title: const Text('Bestiario'),
          ),
          body: FutureBuilder<List<DocumentSnapshot<Map<String, dynamic>>>>(
            future: _getBeasts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white70),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'No se encontraron enemigos',
                    style: TextStyle(fontSize: 22, color: Colors.white70),
                  ),
                );
              }

              final beasts = snapshot.data!;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isWide ? 4 : 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: beasts.length,
                  itemBuilder: (context, index) {
                    final data = beasts[index].data()!;
                    final title = data['title'] ?? '';
                    final area = data['area'] ?? '';
                    final img = data['image'] as String?;

                    return GestureDetector(
                      onTap: () => _openDetail(context, data),
                      child: Card(
                        color: Colors.black54,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12)),
                                child: _buildImageWidget(img),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(title,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white70)),
                                  const SizedBox(height: 4),
                                  Text(area,
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.white60)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
