import 'package:document_scanner/Components/textfield.dart';
import 'package:document_scanner/JSON/users.dart';
import 'package:document_scanner/Views/login.dart';
import 'package:flutter/material.dart';

import '../Components/button.dart';
import '../SQLite/database_helper.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final fullName = TextEditingController();
  final email = TextEditingController();
  final usrName = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final db = DatabaseHelper();

  signup() async{
    var res = await db.createUser(Users(fullname: fullName.text, email: email.text,username: usrName.text, password: password.text));
    if(res > 0) {
      if(!mounted) return;
      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    } else {

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Đăng ký tài khoản",
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 55,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10,),
              InputField(
                  hint: "Họ và tên", icon: Icons.person, controller: fullName),
              InputField(hint: "Email", icon: Icons.email, controller: email),
              InputField(
                  hint: "Username",
                  icon: Icons.account_circle,
                  controller: usrName),
              InputField(
                  hint: "Mật khẩu", icon: Icons.lock, controller: password, passwordInvisible: true,),
              InputField(
                  hint: "Nhập lại mật khẩu",
                  icon: Icons.lock,
                  controller: confirmPassword, passwordInvisible: true,),
              Button(label: "Đăng ký", press: () {
                signup();
              }),
              Row(
                children: [
                  Text(
                    "Đã có tài khoản?",
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },
                      child: Text("Đăng nhập"))
                ],
              )
            ],
          )),
        ),
      ),
    );
  }
}
