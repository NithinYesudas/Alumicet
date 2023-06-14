

import 'package:alumni_connect/screens/auth/signup_screen.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class AuthPages extends StatelessWidget {
  const AuthPages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: const [
        LoginScreen(),
        SignUpScreen(),

      ],
    );
  }
}
