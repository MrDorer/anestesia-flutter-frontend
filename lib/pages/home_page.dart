import 'package:anestesia/auth/auth_service.dart';
import 'package:anestesia/pages/bestiary_page.dart';
import 'package:anestesia/pages/chatbot_page.dart';
import 'package:anestesia/pages/diary_page.dart';
import 'package:anestesia/pages/scoreboard_page.dart';
import 'package:anestesia/pages/album_page.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
                        videoAsset: 'images/antigif.mp4',
                        route: ChatbotPage(),
                        isMain: true,
                      ),

                      const SizedBox(height: 12),

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

class _NavigationAsset extends StatefulWidget {
  final String title;
  final String imgUrl;
  final String? videoAsset;
  final Widget route;
  final bool isMain;

  const _NavigationAsset({
    Key? key,
    required this.title,
    required this.imgUrl,
    this.videoAsset,
    required this.route,
    this.isMain = false,
  }) : super(key: key);

  @override
  State<_NavigationAsset> createState() => _NavigationAssetState();
}

class _NavigationAssetState extends State<_NavigationAsset> {
  VideoPlayerController? _vController;

  @override
  void initState() {
    super.initState();
    if (widget.isMain && widget.videoAsset != null && widget.videoAsset!.isNotEmpty) {
      _vController = VideoPlayerController.asset(widget.videoAsset!);
      _vController!.initialize().then((_) {
        _vController!..setLooping(true)..play();
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _vController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMain = widget.isMain;
    final title = widget.title;
    final imgUrl = widget.imgUrl;

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => widget.route)),
  child: Container(
  margin: EdgeInsets.symmetric(vertical: isMain ? 8 : 6),
        width: isMain ? 300 : 120,
        height: isMain ? 300 : 120,
        decoration: BoxDecoration(
          shape: isMain ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isMain ? null : BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.pinkAccent.withOpacity(0.55),
              blurRadius: 16,
              spreadRadius: 4,
            ),
          ],
        ),
        child: isMain
            ? ClipOval(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (_vController != null && _vController!.value.isInitialized)
                      FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _vController!.value.size.width,
                          height: _vController!.value.size.height,
                          child: VideoPlayer(_vController!),
                        ),
                      )
                    else
                      (imgUrl.isNotEmpty
                          ? Image.asset(imgUrl, fit: BoxFit.cover)
                          : Container(
                              color: Colors.black26,
                              child: const Center(
                                child: Icon(Icons.image_not_supported, color: Colors.white70, size: 36),
                              ),
                            )),

                    Center(
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
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
                  ],
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    imgUrl.isNotEmpty
                        ? Image.asset(imgUrl, fit: BoxFit.cover)
                        : Container(
                            color: Colors.black26,
                            child: const Center(
                              child: Icon(Icons.image_not_supported, color: Colors.white70, size: 36),
                            ),
                          ),
                    Center(
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
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
                  ],
                ),
              ),
      ),
    );
  }
}
