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
        Positioned.fill(child: Image.asset('images/3.jpg', fit: BoxFit.cover)),

        Scaffold(
          appBar: AppBar(backgroundColor: Colors.transparent),
          backgroundColor: Colors.transparent,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Header
                  Text(
                    "Ranking por tiempo",
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 35,
                      color: Colors.white,
                      shadows: [
                        const Shadow(color: Colors.black54, blurRadius: 6),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Category selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownButton<String>(
                        value: selectedCategory,
                        dropdownColor: Colors.grey.shade900,
                        underline: Container(height: 0),
                        items: categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(
                              category,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedCategory = newValue!;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("scores")
                          .where("Category", isEqualTo: selectedCategory)
                          .orderBy("Time")
                          .limit(50)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Text(
                              "No hay registros aún",
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                          );
                        }

                        final docs = snapshot.data!.docs;

                        // derive quick stats
                        final best = docs.first.data() as Map<String, dynamic>;
                        final bestTime = best['time']?.toString() ?? '--:--';
                        final players = docs.length.toString();
                        double avg = 0;
                        try {
                          final times = docs
                              .map(
                                (d) =>
                                    (d.data() as Map<String, dynamic>)['time']
                                        as num,
                              )
                              .toList();
                          avg =
                              times.fold<double>(
                                0,
                                (p, e) => p + e.toDouble(),
                              ) /
                              times.length;
                        } catch (_) {}

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Stats row derived from data
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _statCard(
                                  context,
                                  'Mejor',
                                  bestTime,
                                  Icons.emoji_events,
                                ),
                                const SizedBox(width: 11),
                                _statCard(
                                  context,
                                  'Jugadores',
                                  players,
                                  Icons.people,
                                ),
                                const SizedBox(width: 11),
                                _statCard(
                                  context,
                                  'Promedio',
                                  avg.isNaN ? '--:--' : avg.toStringAsFixed(1),
                                  Icons.speed,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Top 5 highlighted
                            SizedBox(
                              height: 140,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: docs.length >= 5 ? 5 : docs.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 12),
                                itemBuilder: (context, index) {
                                  final data =
                                      docs[index].data()
                                          as Map<String, dynamic>;
                                  return _topCard(
                                    context,
                                    index + 1,
                                    data['player'] ?? 'Anon',
                                    data['time']?.toString() ?? '--:--',
                                    data['progress']?.toString() ?? '',
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Full list
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.45),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListView.separated(
                                  itemCount: docs.length,
                                  separatorBuilder: (_, __) =>
                                      const Divider(color: Colors.white24),
                                  itemBuilder: (context, idx) {
                                    final data =
                                        docs[idx].data()
                                            as Map<String, dynamic>;
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.pink.shade200
                                            .withOpacity(0.2),
                                        child: Text(
                                          (idx + 1).toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        data['player'] ?? 'Anon',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(color: Colors.white),
                                      ),
                                      subtitle: Text(
                                        'Progreso: ${data['progress'] ?? '-'}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(color: Colors.white70),
                                      ),
                                      trailing: Text(
                                        data['time']?.toString() ?? '--:--',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(color: Colors.white),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
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

  Widget _statCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Container(
      width: 120,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.pink.shade100),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _topCard(
    BuildContext context,
    int rank,
    String player,
    String time,
    String progress,
  ) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.6),
            Colors.black.withOpacity(0.35),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.pink.shade200.withOpacity(0.25),
                child: Text(
                  rank.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  player,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            'Tiempo: $time',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 6),
          Text(
            'Avance: $progress',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
