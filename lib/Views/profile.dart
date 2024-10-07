import 'package:document_scanner/Components/button.dart';
import 'package:document_scanner/Views/login.dart';
import 'package:flutter/material.dart';

import '../JSON/users.dart';

class Profile extends StatelessWidget {
  final Users? profile;
  const Profile({super.key, this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 45, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  radius: 77,
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/no_user.jpg"),
                    radius: 65,
                  ),
                ),
                const SizedBox(height: 10,),
                Text(profile!.fullname??"", style: TextStyle(fontSize: 25, color: Colors.blueAccent),),
                Text(profile!.email??"", style: TextStyle(fontSize: 17, color: Colors.grey),),


                Button(label: "Log out", press: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                }),

                ListTile(
                  leading: Icon(Icons.person, size: 30,),
                  subtitle: Text("Họ và tên"),
                  title: Text(profile!.fullname??""),
                ),

                ListTile(
                  leading: Icon(Icons.email, size: 30,),
                  subtitle: Text("Email"),
                  title: Text(profile!.email??""),
                ),

                ListTile(
                  leading: Icon(Icons.account_circle, size: 30,),
                  subtitle: Text("Username"),
                  title: Text(profile!.username??""),
                ),
              ],
                        ),
            ),
        ),
      ),
    );
  }
}
