import 'package:anestesia/auth/auth_service.dart';
import 'package:anestesia/pages/bestiary_page.dart';
import 'package:anestesia/pages/chatbot_page.dart';
import 'package:anestesia/pages/diary_page.dart';
import 'package:anestesia/pages/scoreboard_page.dart';
import 'package:anestesia/pages/album_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        // Translucent pink navbar
        backgroundColor: Colors.pink.withOpacity(0.28),
        elevation: 0,
        title: Text(
          'Anestesia - Menu',
          style: TextStyle(color: Colors.white.withOpacity(0.95)),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: auth.signOut,
            icon: Icon(Icons.logout, color: Colors.white.withOpacity(0.9)),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'images/homeback.jpg',
              fit: BoxFit.cover,
            ),
          ),

          Column(
            children: [
              Container(
                height: 80,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                width: double.infinity,
                color: Colors.transparent,
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 30,
                          color: const Color.fromARGB(179, 46, 14, 30),
                        ),
                    children: const [
                      TextSpan(text: 'Bienvenido, '),
                      TextSpan(
                        text: 'Usuario',
                        style: TextStyle(
                          color: Color.fromARGB(255, 70, 13, 42),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          '¿Qué te trae aquí hoy?',
                          style: TextStyle(
                            color: Color.fromARGB(255, 49, 16, 34),
                            fontSize: 24,
                          ),
                        ),
                      ),

                      // 🔹 PRIMER BOTÓN - CIRCULAR Y MÁS GRANDE
                      _NavigationAsset(
                        title: 'Anticristo',
                        imgUrl: 'images/AntiChrist.jpg',
                        route: ChatbotPage(),
                        isMain: true,
                      ),

                      const SizedBox(height: 30),

                      // 🔹 RESTO DE OPCIONES - EN FILA (responsive via Wrap)
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 20,
                        runSpacing: 20,
                        children: [
                          _NavigationAsset(
                            title: 'Diario de Anneth',
                            imgUrl: '',
                            route: DiaryPage(),
                          ),
                          _NavigationAsset(
                            title: 'Bestiario',
                            imgUrl: '',
                            route: BestiaryPage(),
                          ),
                          _NavigationAsset(
                            title: 'Scoreboard',
                            imgUrl: '',
                            route: ScoreboardPage(),
                          ),
                          _NavigationAsset(
                            title: 'Album',
                            imgUrl: '',
                            route: AlbumPage(),
                          ),
                        ],
                      ),

                      const SizedBox(height: 170),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavigationAsset extends StatelessWidget {
  final String title;
  final String imgUrl;
  final Widget route;
  final bool isMain;

  const _NavigationAsset({
    super.key,
    required this.title,
    required this.imgUrl,
    required this.route,
    this.isMain = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => route)),
      child: Container(
  margin: const EdgeInsets.symmetric(vertical: 10),
  width: isMain ? 220 : 120,
  height: isMain ? 220 : 120,
        decoration: BoxDecoration(
          shape: isMain ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isMain ? null : BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(imgUrl),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.pinkAccent.withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.black,
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
