import 'package:document_scanner/Views/login.dart';
import 'package:document_scanner/Views/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:document_scanner/Components/button.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
                    children: [
            const Text(
              "Authentication",
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent),
            ),
            const Text(
              "Login",
              style: TextStyle(color: Colors.grey),
            ),
            Expanded(child: Image.asset("asset/startup.jpg")),
            Button(label: "Login", press: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
            }),
            Button(label: "Sign up", press: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
            }),
                    ],
                  ),
          )),
    );
  }
}
