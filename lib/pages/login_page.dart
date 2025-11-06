import 'package:anestesia/auth/auth_service.dart';
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
                Color(0xFFDD60BE),
                Color(0xFF1E1E1E),
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
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                SizedBox(height: 25),

                GeneralTextfield(
                  hintText: "Correo",
                  obscureText: false,
                  controller: _emailController,
                ),
                SizedBox(height: 25),

                GeneralTextfield(
                  hintText: "Contraseña",
                  obscureText: true,
                  controller: _pwController,
                ),
                SizedBox(height: 25),

                GeneralButton(
                  text: 'Iniciar sesión',
                  onTap: () => login(context),
                ),
                SizedBox(height: 25),

                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Aun no estas registrado?',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontSize: 15,
                      ),
                    ),
                    GestureDetector(
                      onTap: onTap,
                      child: Text(
                        ' Registrate aqui',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
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
