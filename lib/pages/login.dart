import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_portal/components/dialog_ok.dart';
import 'package:student_portal/components/my_button1.dart';
import 'package:student_portal/components/my_snackbar.dart';
import 'package:student_portal/components/my_textfield.dart';
import 'package:student_portal/components/my_passwordtextfield.dart';
import 'package:student_portal/pages/auth_page.dart';
import 'package:student_portal/pages/create_account.dart';
import 'package:student_portal/pages/forgot_password.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginPage({Key? key, required this.showRegisterPage}) : super(key: key);
  // const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obscureText = true;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  //text controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // logIn function
  void logIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const AlertDialog(
          contentPadding: EdgeInsets.symmetric(vertical: 20),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Loading..."),
            ],
          ),
        );
      },
    );

    //check if email and password fields are empty
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      Navigator.pop(context);
      showMissingInformationDialog();
      return;
    }

    //check email have in database or not
    QuerySnapshot pendingQuerySnapshot = await FirebaseFirestore.instance
        .collection('pending')
        .where('personal_email', isEqualTo: _emailController.text.trim())
        .get();

    if (pendingQuerySnapshot.docs.isNotEmpty) {
      // Document with the provided email already exists in the pending collection
      Navigator.pop(context); // Dismiss loading circle
      showEmailAlreadyInPending();
      return;
    }

    QuerySnapshot adminQuerySnapshot = await FirebaseFirestore.instance
        .collection('admin')
        .where('personal_email', isEqualTo: _emailController.text.trim())
        .get();

    if (adminQuerySnapshot.docs.isNotEmpty) {
      // Document with the provided email already exists in the pending collection
      Navigator.pop(context); // Dismiss loading circle
      invalidCredentialMessage();
      return;
    }
    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // pop the loading circle
      Navigator.of(context).pop();

      //Show Login Successfull Snackbar
      const my_snackbar(
        text: 'Login Successfully',
      ).show(context);

      navigateToHomePage();
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.of(context).pop();

      //Wrong Email
      if (e.code == 'invalid-credential') {
        // show error to user
        invalidCredentialMessage();

        // Wrong Password
      } else if (e.code == 'invalid-email') {
        invalidEmailMessage();
      } else {
        genericErrorMessage(e.code, "Please try again.");
      }
    }
  }

  void navigateForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => forgotPassword(),
      ),
    );
  }

  void showEmailAlreadyInPending() {
    const Dialog_ok(
            title: 'Email In Pending',
            content: 'Please wait for admin approve. Thank you.')
        .show(context);
  }

  void navigateToHomePage() {
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const authPage(),
      ),
    );

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => const authPage(),
    //   ),
    // );
  }

  void showMissingInformationDialog() {
    const Dialog_ok(
            title: 'Missing Information',
            content: 'Please enter your email and password.')
        .show(context);
    // showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertDialog(
    //         title: Text('Missing Information'),
    //         content: Text('Please enter your email and password.'),
    //       );
    //     });
  }

  //Invalid Credential Message popup
  void invalidCredentialMessage() {
    const Dialog_ok(
            title: 'Invalid Credentials',
            content:
                'The provided credentials are not valid. Please check your email and password again, thank you.')
        .show(context);
  }

  //Invalid Email Message popup
  void invalidEmailMessage() {
    const Dialog_ok(
            title: 'Invalid Email',
            content:
                'The provided email are not valid. Please check your email again, thank you.')
        .show(context);
  }

  void genericErrorMessage(String messageTitle, String message) {
    Dialog_ok(title: messageTitle, content: message).show(context);
  }

  @override
  Widget build(BuildContext context) {
    double mobilescreenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Logo
            // SizedBox(height: mobilescreenHeight * 0.15),
            Padding(
              padding: EdgeInsets.only(
                  top: mobilescreenHeight * 0.15,
                  bottom: mobilescreenHeight * 0.03),
              child: SizedBox(
                height: mobilescreenHeight * 0.1,
                width: mobilescreenHeight * 0.4,
                child: Image.asset('images/segi_logo.png'),
              ),
            ),

            //SEGi Student Personal Management Portal Text
            SizedBox(
                width: double.infinity,
                child: Center(
                    child: Padding(
                  padding: EdgeInsets.all(mobilescreenHeight * 0.02),
                  child: Text(
                    'SEGi Student Personal Manage Portal',
                    style: TextStyle(
                        fontFamily: 'Texturina',
                        fontSize: mobilescreenHeight * 0.035),
                    textAlign: TextAlign.center,
                  ),
                ))),

            SizedBox(height: mobilescreenHeight * 0.025),

            //Login Text
            Container(
                color: Colors.white,
                width: double.infinity,
                child: Center(
                    child: Padding(
                  padding: EdgeInsets.all(mobilescreenHeight * 0.02),
                  child: Text('Login',
                      style: TextStyle(fontSize: mobilescreenHeight * 0.025)),
                ))),

            SizedBox(height: mobilescreenHeight * 0.025),

            //Email Text Field
            MyTextField(
              controller: _emailController,
              hintText: "Student Email",
              obscureText: false,
            ),

            SizedBox(height: mobilescreenHeight * 0.015),

            //Password Text Field
            MyPasswordTextField(
              controller: _passwordController,
              hintText: "Password",
              obscureText: true,
              onPressed: (bool isObscured) {
                setState(() {
                  obscureText = isObscured;
                });
              },
            ),

            SizedBox(height: mobilescreenHeight * 0.015),

            //Forget Password
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: mobilescreenHeight * 0.035),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      navigateForgotPassword();
                    },
                    child: Text(
                      "Forgot Password ?",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: mobilescreenHeight * 0.018),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: mobilescreenHeight * 0.025),

            //Login button
            my_button1(
              onTap: logIn,
              buttonName: "Login",
            ),

            SizedBox(height: mobilescreenHeight * 0.025),

            //Navigate to create account page
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'New Student?',
                  style: TextStyle(
                    fontSize: mobilescreenHeight * 0.021,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(
                  width: mobilescreenHeight * 0.005,
                ),
                GestureDetector(
                  // onTap: () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const createAccount()),
                  //   );
                  //   // Navigator.pushReplacementNamed(context, '/createaccount');
                  // },
                  onTap: widget.showRegisterPage,
                  child: Text(
                    'Create New Account',
                    style: TextStyle(
                      fontSize: mobilescreenHeight * 0.021,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
