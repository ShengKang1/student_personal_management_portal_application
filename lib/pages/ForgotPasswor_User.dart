import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/dialog_ok.dart';

class ForgotPasswordUser extends StatefulWidget {
  final String email;

  const ForgotPasswordUser({Key? key, required this.email}) : super(key: key);

  @override
  State<ForgotPasswordUser> createState() => _ForgotPasswordUserState();
}

class _ForgotPasswordUserState extends State<ForgotPasswordUser> {
  double mobilescreenHeight = 0;
  late final email = widget.email.trim();

  Future passwordReset() async {
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
              'Click the "Reset Password" button, we will send you a reset password link to ($email), thank you.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: mobilescreenHeight * 0.023),
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
