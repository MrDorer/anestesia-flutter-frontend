import 'package:anestesia/auth/auth_gate.dart';
import 'package:anestesia/consts.dart';
import 'package:anestesia/firebase_options.dart';
import 'package:anestesia/pages/chatbot_page.dart';
import 'package:anestesia/pages/diary_page.dart';
import 'package:anestesia/pages/home_page.dart';
import 'package:anestesia/pages/scoreboard_page.dart';
import 'package:anestesia/themes/light_mode.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseMessaging.instance.subscribeToTopic("news");
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final androidImplementation = flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  await androidImplementation?.requestNotificationsPermission();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //Root
  @override
  Widget build(BuildContext context) {
    Gemini.init(apiKey: GEMINI_API_KEY);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightMode,
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          body: AuthGate(
            navigationWidget: TabBarView(
              children: [
                HomePage(),
                ChatbotPage(),
                DiaryPage(),
                ScoreboardPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
