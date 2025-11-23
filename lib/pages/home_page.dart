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
  late PageController _smallController;

  @override
  void initState() {
    super.initState();
    _smallController = PageController(viewportFraction: 0.42);
  }

  @override
  void dispose() {
    _smallController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.pink.withOpacity(0.28),
        elevation: 0,
        title: Text(
          'Anestesia - Menu',
          style: TextStyle(
            color: Colors.white.withOpacity(0.95),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.pinkAccent.withOpacity(0.30),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.pinkAccent.withOpacity(0.45),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: GestureDetector(
              onTap: auth.signOut,
              child: Row(
                children: [
                  const Icon(Icons.logout, color: Colors.white, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    "Cerrar sesión",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.95),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('images/homeback.jpg', fit: BoxFit.cover),
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
                    children: [
                      const TextSpan(
                        text: 'Bienvenido, ',
                        style: TextStyle(
                          color: Color.fromARGB(200, 80, 20, 60),
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                        ),
                      ),
                      TextSpan(
                        text: 'Usuario',
                        style: TextStyle(
                          color: Color(0xFF9C2F63),
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                          shadows: [
                            Shadow(
                              color: Colors.pink.withOpacity(0.6),
                              blurRadius: 12,
                            ),
                          ],
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        alignment: Alignment.center,
                        child: Stack(
                          children: [
                            // Outline rosa
                            Text(
                              '¿Qué te trae aquí hoy?',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = 4
                                      ..color = Color(0xFF9C2F63),
                                  ),
                            ),

                            // Texto principal (tu estilo original)
                            Text(
                              '¿Qué te trae aquí hoy?',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
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

                      const SizedBox(height: 32),

                      // 🔹 RESTO DE OPCIONES - CAROUSEL HORIZONTAL
                      SizedBox(
                        height: 160,
                        child: PageView.builder(
                          controller: _smallController,
                          itemCount: 4,
                          padEnds: false,
                          itemBuilder: (context, index) {
                            final items = [
                              {
                                'title': 'Diario de Anneth',
                                'img':
                                    'images/closed-holy-bible-xdajkbifj68n6fo1.png',
                                'route': DiaryPage(),
                              },
                              {
                                'title': 'Bestiario',
                                'img': 'images/bear.png',
                                'route': BestiaryPage(),
                              },
                              {
                                'title': 'Scoreboard',
                                'img': 'images/rank.png',
                                'route': ScoreboardPage(),
                              },
                              {
                                'title': 'Album',
                                'img': 'images/album.png',
                                'route': AlbumPage(),
                              },
                            ];

                            final item = items[index];

                            return AnimatedBuilder(
                              animation: _smallController,
                              builder: (context, child) {
                                double value = 0;
                                if (_smallController.hasClients &&
                                    _smallController.position.haveDimensions) {
                                  value = _smallController.page! - index;
                                } else {
                                  value = (_smallController.initialPage - index)
                                      .toDouble();
                                }
                                final rotation = (value * 0.25).clamp(
                                  -0.5,
                                  0.5,
                                );

                                return Transform.rotate(
                                  angle: rotation,
                                  child: child,
                                );
                              },
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => item['route'] as Widget,
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      item['img'] as String,
                                      width: 150,
                                      height: 120,
                                      fit: BoxFit.contain,
                                    ),
                                    const SizedBox(height: 8),
                                    Stack(
                                      children: [
                                        Text(
                                          item['title'] as String,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w900,
                                            foreground: Paint()
                                              ..style = PaintingStyle.stroke
                                              ..strokeWidth = 3
                                              ..color = Colors.white,
                                          ),
                                        ),
                                        Text(
                                          item['title'] as String,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFF9C2F63),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
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
    if (widget.isMain &&
        widget.videoAsset != null &&
        widget.videoAsset!.isNotEmpty) {
      _vController = VideoPlayerController.asset(widget.videoAsset!);
      _vController!.initialize().then((_) {
        _vController!
          ..setLooping(true)
          ..play();
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
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => widget.route),
      ),
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
                    if (_vController != null &&
                        _vController!.value.isInitialized)
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
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: Colors.white70,
                                  size: 36,
                                ),
                              ),
                            )),

                    Center(
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              shadows: const [
                                Shadow(color: Colors.black, blurRadius: 8),
                              ],
                            ) ??
                            TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(color: Colors.black, blurRadius: 8),
                              ],
                            ),
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: imgUrl.isNotEmpty
                    ? Image.asset(
                        imgUrl,
                        fit: BoxFit.contain,
                        width: isMain ? 300 : 120,
                        height: isMain ? 300 : 120,
                      )
                    : Container(
                        width: isMain ? 300 : 120,
                        height: isMain ? 300 : 120,
                        color: Colors.black26,
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.white70,
                            size: 36,
                          ),
                        ),
                      ),
              ),
      ),
    );
  }
}
