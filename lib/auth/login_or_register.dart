import 'package:anestesia/pages/login_page.dart';
import 'package:anestesia/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Wrap the login/register pages in a Theme that applies the Overlock
    // Google Font only to this subtree. We also scale the font sizes a bit.
    final ThemeData subtreeTheme = Theme.of(context).copyWith(
      textTheme: GoogleFonts.overlockTextTheme(Theme.of(context).textTheme)
          .apply(fontSizeFactor: 1.20),
      primaryTextTheme: GoogleFonts.overlockTextTheme(
        Theme.of(context).primaryTextTheme,
      ).apply(fontSizeFactor: 1.20),
    );

    if (showLoginPage) {
      return Theme(data: subtreeTheme, child: LoginPage(onTap: togglePages));
    } else {
      return Theme(data: subtreeTheme, child: RegisterPage(onTap: togglePages));
    }
  }
}
