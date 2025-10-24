import 'package:anestesia/components/general_button.dart';
import 'package:anestesia/components/general_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  final void Function()? onTap;
  LoginPage({super.key, required this.onTap});

  void login() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.anchor, size: 60),
            SizedBox(height: 50),

            Text('Iniciar sesión'),
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

            GeneralButton(text: 'Iniciar sesión', onTap: login),
            SizedBox(height: 25),

            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Aun no estas registrado?',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    ' Registrate aqui',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
