import 'package:document_scanner/Components/button.dart';
import 'package:document_scanner/Components/textfield.dart';
import 'package:document_scanner/HomeScreen.dart';
import 'package:document_scanner/JSON/users.dart';
import 'package:document_scanner/Views/profile.dart';
import 'package:document_scanner/Views/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../SQLite/database_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //controller to take value from user and pass to database
  final userName = TextEditingController();
  final passWord = TextEditingController();

  bool isChecked = false;
  bool isLoginTrue = false;
  final db = DatabaseHelper();

  login() async{
    Users? userDetails = await db.getUser(userName.text);
    var res = await db.authenticate(Users(username: userName.text, password: passWord.text));
    if(res == true){
      Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      //Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(profile: userDetails)));
    } else {
      setState(() {
        isLoginTrue = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(child: Column(
            children: [
              Text('LOGIN', style: TextStyle(color: Colors.blueAccent, fontSize: 40),),
              Image.asset("assets/background.jpg"),
              InputField(hint: "Username", icon: Icons.account_circle, controller: userName),
              InputField(hint: "Password", icon: Icons.lock, controller: passWord, passwordInvisible: true),

              ListTile(
                horizontalTitleGap: 2,
                title: const Text('Remember me'),
                leading: Checkbox(
                  value: isChecked,
                  onChanged: (value){
                    setState(() {
                      isChecked = !isChecked;
                    });
                  },
                ),
              ),
              Button(label: "LOGIN", press: () {
                login();
              }),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?", style: TextStyle(color: Colors.grey),),
                  TextButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
                      },
                      child: const Text("Contact your local institution"))
                ],
              ),
              isLoginTrue? Text("Username or Password is incorrect", style: TextStyle(color: Colors.red),) : const SizedBox(),
            ],
          )),
        ),
      ),
    );
  }
}
