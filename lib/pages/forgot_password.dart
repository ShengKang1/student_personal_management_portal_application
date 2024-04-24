import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/dialog_ok.dart';

class forgotPassword extends StatefulWidget {
  final String email;

  const forgotPassword({Key? key, this.email = ""}) : super(key: key);

  @override
  State<forgotPassword> createState() => _forgotPasswordState();
}

class _forgotPasswordState extends State<forgotPassword> {
  final _emailController = TextEditingController();

  double mobilescreenHeight = 0;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      const Dialog_ok(
              title: 'Missing Information',
              content: 'Please enter your email and password.')
          .show(context);
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Dialog_ok(
              title: 'Password link sent',
              content: 'Password reset link sent! Check your email $email')
          .show(context);

      // showDialog(
      //     context: context,
      //     builder: (context) {
      //       return AlertDialog(
      //         content: Text('Password reset link sent! Check your email'),
      //       );
      //     });
      return;
    } on FirebaseAuthException catch (e) {
      // print(e);
      // showDialog(
      //     context: context,
      //     builder: (context) {
      //       return AlertDialog(
      //         content: Text(e.message.toString()),
      //       );
      //     });
      Dialog_ok(title: e.code, content: e.message.toString()).show(context);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    mobilescreenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Reset Password",
          style: TextStyle(fontSize: mobilescreenHeight * 0.028),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: mobilescreenHeight * 0.025),
            child: Text(
              'Enter Your Email and we will send you a reset password link',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: mobilescreenHeight * 0.023),
            ),
          ),

          SizedBox(height: mobilescreenHeight * 0.01),

          //email text field
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: mobilescreenHeight * 0.03),
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: 'Email',
                hintStyle: TextStyle(fontSize: mobilescreenHeight * 0.021),
                fillColor: Colors.grey[200],
                filled: true,
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: mobilescreenHeight * 0.02),
            child: MaterialButton(
              padding: EdgeInsets.all(mobilescreenHeight * 0.015),
              onPressed: passwordReset,
              color: const Color(0xff7cacd4),
              child: Text(
                'Reset Password',
                style: TextStyle(fontSize: mobilescreenHeight * 0.02),
              ),
            ),
          )
        ],
      ),
    );
  }
}
