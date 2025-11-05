import 'package:anestesia/auth/login_or_register.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  final Widget navigationWidget;
  const AuthGate({super.key, required this.navigationWidget});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return navigationWidget;
          } else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
