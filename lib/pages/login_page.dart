import 'package:anestesia/auth/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:anestesia/components/general_button.dart';
import 'package:anestesia/components/general_textfield.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  late VideoPlayerController _vController;
  bool _videoInitialized = false;

  @override
  void initState() {
    super.initState();
    _vController = VideoPlayerController.asset('images/login.mp4')
      ..initialize().then((_) {
        _vController.setLooping(true);
        _vController.setVolume(0.0);
        _vController.play();
        setState(() => _videoInitialized = true);
      });
  }

  @override
  void dispose() {
    _vController.dispose();
    _emailController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  void login(BuildContext context) async {
    final authService = AuthService();

    try {
      await authService.signInWithEmailPassword(
        _emailController.text,
        _pwController.text,
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(title: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        // fullscreen video background (fallback to gradient while initializing)
        if (_videoInitialized)
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _vController.value.size.width,
                height: _vController.value.size.height,
                child: VideoPlayer(_vController),
              ),
            ),
          )
        else
          // while the video initializes show a plain black background (no gradient)
          SizedBox.expand(child: Container(color: Colors.black)),

        // dark overlay to increase contrast for content
        Container(color: Colors.black.withOpacity(0.25)),

        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/anestesiaLogo.png',
                    width: 200,
                    height: 200,
                  ),

                  Text(
                    'Iniciar sesión',
                    style: GoogleFonts.overlock(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Inputs area with video background
                  Container(
                    width: mediaW < 420 ? mediaW * 0.9 : 420,
                    padding: const EdgeInsets.all(12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          // space reserved for card background (video is shown behind entire page)
                          Container(
                            height: 300,
                            color: Colors.transparent,
                          ),

                          // translucent overlay to increase contrast
                          Container(
                            height: 300,
                            color: Colors.black.withOpacity(0.25),
                          ),

                          // inputs and button
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GeneralTextfield(
                                  hintText: "Correo",
                                  obscureText: false,
                                  controller: _emailController,
                                  backgroundColor: Colors.white.withOpacity(0.06),
                                ),
                                const SizedBox(height: 16),
                                GeneralTextfield(
                                  hintText: "Contraseña",
                                  obscureText: true,
                                  controller: _pwController,
                                  backgroundColor: Colors.white.withOpacity(0.06),
                                ),
                                const SizedBox(height: 18),
                                GeneralButton(
                                  text: 'Iniciar sesión',
                                  onTap: () => login(context),
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color.fromARGB(255, 214, 137, 163),
                                      const Color.fromARGB(255, 143, 86, 105),
                                      const Color.fromARGB(255, 83, 43, 57),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '¿Aún no estás registrado?',
                                      style: GoogleFonts.overlock(
                                        color: Theme.of(context).colorScheme.tertiary,
                                        fontSize: 15,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: widget.onTap,
                                      child: Text(
                                        ' Regístrate aquí',
                                        style: GoogleFonts.overlock(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepPurpleAccent,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
}
