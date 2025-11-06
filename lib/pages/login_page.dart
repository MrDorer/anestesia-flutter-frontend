import 'package:anestesia/auth/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:anestesia/components/general_button.dart';
import 'package:anestesia/components/general_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  final void Function()? onTap;
  LoginPage({super.key, required this.onTap});

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
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 214, 137, 163),
                Color.fromARGB(255, 143, 86, 105),
               Color.fromARGB(255, 83, 43, 57),
              ], //De querer modificar solo los fondos, mover aqui
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
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

                GeneralTextfield(
                  hintText: "Correo",
                  obscureText: false,
                  controller: _emailController,
                  backgroundColor: Colors.white.withOpacity(0.06),
                ),
              const SizedBox(height: 25),

                GeneralTextfield(
                  hintText: "Contraseña",
                  obscureText: true,
                  controller: _pwController,
                  backgroundColor: Colors.white.withOpacity(0.06),
                ),
              const SizedBox(height: 25),

              GeneralButton(
                text: 'Iniciar sesión',
                onTap: () => login(context),
                // Use same gradient as the page background so the button "agarra"
                // los colores del bg.
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 214, 137, 163),
                    Color.fromARGB(255, 143, 86, 105),
                    Color.fromARGB(255, 83, 43, 57),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              const SizedBox(height: 25),

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
                    onTap: onTap,
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
        ),
      ],
    );
  }
}
