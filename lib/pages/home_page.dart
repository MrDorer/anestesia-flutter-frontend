import 'package:anestesia/auth/auth_service.dart';
import 'package:anestesia/components/navigation_asset.dart';
import 'package:anestesia/pages/chatbot_page.dart';
import 'package:anestesia/pages/diary_page.dart';
import 'package:anestesia/pages/scoreboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black.withAlpha(100),
        title: Text(
          'Anestesia - Menu',
          style: TextStyle(color: Colors.white70),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: auth.signOut,
            icon: Icon(Icons.logout, color: Colors.white70),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 80,
            padding: EdgeInsets.symmetric(horizontal: 12),
            width: double.infinity,
            color: Colors.transparent,
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 30,
                  color: Colors.white70,
                ),
                children: const [
                  TextSpan(text: 'Bienvenido, '),
                  TextSpan(
                    text: 'Usuario',
                    style: TextStyle(
                      color: Color.fromARGB(255, 228, 40, 181),
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
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Que te trae aqui hoy?',
                      style: TextStyle(color: Colors.white54, fontSize: 24),
                    ),
                  ),
                  NavigationAsset(
                    title: 'Diario de Anneth',
                    imgUrl: "images/diaryPage.png",
                    route: DiaryPage(),
                  ),
                  NavigationAsset(
                    title: 'El que no debe ser recordado',
                    imgUrl: "images/him.png",
                    route: ChatbotPage(),
                  ),
                  NavigationAsset(
                    title: 'Bestiario',
                    imgUrl: "images/bestiary.png",
                    route: DiaryPage(),
                  ),
                  NavigationAsset(
                    title: 'Tiempos de speedrun',
                    imgUrl: "images/speedrun.png",
                    route: ScoreboardPage(),
                  ),
                  SizedBox(height: 150),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
