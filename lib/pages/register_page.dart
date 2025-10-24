import 'package:flutter/material.dart';
import '../components/general_button.dart';
import '../components/general_textfield.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

  final void Function()? onTap;

  RegisterPage({super.key, required this.onTap});
  void register() {}

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

            Text('Registro'),
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

            GeneralButton(text: 'Registrarse', onTap: register),
            SizedBox(height: 25),

            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Ya tienes con una cuenta?',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    ' Inicia sesión aquí',
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
