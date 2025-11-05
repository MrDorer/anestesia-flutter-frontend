import 'package:anestesia/auth/auth_service.dart';
import 'package:flutter/material.dart';
import '../components/general_button.dart';
import '../components/general_textfield.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

  final void Function()? onTap;

  RegisterPage({super.key, required this.onTap});
  void register(BuildContext context) {
    final _auth = AuthService();

    if (_pwController.text == _confirmPwController.text) {
      try {
        _auth.signUpWithEmailPassword(
          _emailController.text,
          _pwController.text,
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(title: Text(e.toString())),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text("Las contraseñas no coinciden")),
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
              colors: [Color(0xFFDD60BE), Color(0xFF1E1E1E)],
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
                  'Be careful for what you wish for',
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

                GeneralTextfield(
                  hintText: "Confirmar contraseña",
                  obscureText: true,
                  controller: _confirmPwController,
                ),
                SizedBox(height: 25),

                GeneralButton(
                  text: 'Registrarse',
                  onTap: () => register(context),
                ),
                SizedBox(height: 25),

                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Ya tienes con una cuenta?',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontSize: 15,
                      ),
                    ),
                    GestureDetector(
                      onTap: onTap,
                      child: Text(
                        ' Inicia sesión aquí',
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
