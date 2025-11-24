import 'package:anestesia/auth/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:anestesia/components/general_button.dart';
import 'package:anestesia/components/general_textfield.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  late VideoPlayerController _vController;
  bool _videoReady = false;

  @override
  void initState() {
    super.initState();

    _vController = VideoPlayerController.asset('images/login.mp4')
      ..initialize().then((_) {
        _vController.setLooping(true);
        _vController.setVolume(0.0);
        _vController.play();
        setState(() => _videoReady = true);
      });
  }

  @override
  void dispose() {
    _vController.dispose();
    super.dispose();
  }

  void register() async {
    final auth = AuthService();

    if (_pwController.text != _confirmPwController.text) {
      return showDialog(
        context: context,
        builder: (context) =>
            const AlertDialog(title: Text("Las contraseñas no coinciden")),
      );
    }

    try {
      await auth.signUpWithEmailPassword(
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
    final width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        // VIDEO BACKGROUND
        if (_videoReady)
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
          Container(color: Colors.black),

        // DARK OVERLAY
        Container(color: Colors.black.withOpacity(0.25)),

        // UI
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // LOGO
                  Image.asset(
                    'images/anestesiaLogo.png',
                    width: 200,
                    height: 200,
                  ),

                  Text(
                    'What you forget, the subconscious remembers',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),

                  const SizedBox(height: 25),

                  // CARD / CONTENT
                  Container(
                    width: width < 420 ? width * 0.9 : 420,
                    padding: const EdgeInsets.all(12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          Container(height: 360, color: Colors.transparent),
                          Container(
                            height: 360,
                            color: Colors.black.withOpacity(0.25),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 18,
                            ),
                            child: Column(
                              children: [
                                GeneralTextfield(
                                  hintText: "Correo",
                                  obscureText: false,
                                  controller: _emailController,
                                  backgroundColor: Colors.white.withOpacity(
                                    0.06,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                GeneralTextfield(
                                  hintText: "Contraseña",
                                  obscureText: _obscurePassword,
                                  controller: _pwController,
                                  backgroundColor: Colors.white.withOpacity(
                                    0.06,
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                    child: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                GeneralTextfield(
                                  hintText: "Confirmar contraseña",
                                  obscureText: _obscureConfirm,
                                  controller: _confirmPwController,
                                  backgroundColor: Colors.white.withOpacity(
                                    0.06,
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _obscureConfirm = !_obscureConfirm;
                                      });
                                    },
                                    child: Icon(
                                      _obscureConfirm
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // BOTÓN
                                GeneralButton(
                                  text: "Registrarse",
                                  onTap: register,
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 214, 137, 163),
                                      Color.fromARGB(255, 143, 86, 105),
                                      Color.fromARGB(255, 83, 43, 57),
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
                                      "¿Ya tienes cuenta?",
                                      style: GoogleFonts.overlock(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 18,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: widget.onTap,
                                      child: Text(
                                        " Inicia sesión",
                                        style: GoogleFonts.overlock(
                                          color: Colors.pink,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
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
