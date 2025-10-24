import 'package:anestesia/auth/login_or_register.dart';
import 'package:anestesia/pages/chatbot_page.dart';
import 'package:anestesia/pages/diary_page.dart';
import 'package:anestesia/pages/scoreboard_page.dart';
import 'package:anestesia/themes/light_mode.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //Root
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightMode,
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          body: TabBarView(
            children: [
              LoginOrRegister(),
              ChatbotPage(),
              DiaryPage(),
              ScoreboardPage(),
            ],
          ),
          bottomNavigationBar: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.directions_car)),
              Tab(icon: Icon(Icons.directions_transit)),
              Tab(icon: Icon(Icons.directions_bike)),
              Tab(icon: Icon(Icons.directions_bike)),
            ],
            labelColor: Colors.deepPurple,
            unselectedLabelColor: Colors.grey,
          ),
        ),
      ),
    );
  }
}
