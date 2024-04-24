import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_portal/pages/login.dart';

class accountSetting extends StatelessWidget {
  accountSetting({super.key});

  final user = FirebaseAuth.instance.currentUser!;
  //Log Out Function
  void logOut(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                logOut(context);
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text("Account Setting Page"),
            Text("Logged in as " + user.email!)
          ],
        ),
      ),
    );
  }
}
