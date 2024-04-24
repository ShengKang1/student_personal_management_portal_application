import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_portal/components/dialog_ok.dart';
import 'package:student_portal/components/my_button1.dart';
import 'package:student_portal/pages/LoginOrRegister.dart';
import 'package:student_portal/pages/login.dart';

import '../components/my_snackbar.dart';

class UpdateEmailPage extends StatefulWidget {
  const UpdateEmailPage({super.key});

  @override
  State<UpdateEmailPage> createState() => _UpdateEmailPageState();
}

class _UpdateEmailPageState extends State<UpdateEmailPage> {
  bool _obscureText = true;
  final currentUser = FirebaseAuth.instance.currentUser!;

  final _emailController = TextEditingController();
  final _newemailController = TextEditingController();
  final _passwordController = TextEditingController();

  void updateEmailBtn() async {
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
    if (_emailController.text.trim() != currentUser.email) {
      // throw Exception('Email does not match current user');
      Navigator.pop(context);
      const Dialog_ok(
              title: 'Email is incorrect',
              content: 'Please enter again your email.')
          .show(context);
      return;
    }

    QuerySnapshot pendingQuerySnapshot = await FirebaseFirestore.instance
        .collection('pending')
        .where('personal_email', isEqualTo: _newemailController.text.trim())
        .get();

    if (pendingQuerySnapshot.docs.isNotEmpty) {
      // Document with the provided email already exists in the pending collection
      Navigator.pop(context); // Dismiss loading circle
      showEmailAlreadyInuse();
      return;
    }

    // QuerySnapshot adminQuerySnapshot = await FirebaseFirestore.instance
    //     .collection('admin')
    //     .where('personal_email', isEqualTo: _newemailController.text.trim())
    //     .get();

    // if (adminQuerySnapshot.docs.isNotEmpty) {
    //   // Document with the provided email already exists in the pending collection
    //   Navigator.pop(context); // Dismiss loading circle
    //   showEmailAlreadyInuse();
    //   return;
    // }

    // QuerySnapshot studentsQuerySnapshot = await FirebaseFirestore.instance
    //     .collection('students')
    //     .where('personal_email', isEqualTo: _newemailController.text.trim())
    //     .get();

    // if (studentsQuerySnapshot.docs.isNotEmpty) {
    //   // Document with the provided email already exists in the pending collection
    //   Navigator.pop(context); // Dismiss loading circle
    //   showEmailAlreadyInuse();
    //   return;
    // }

    try {
      final studentSnapshot = await FirebaseFirestore.instance
          .collection("students")
          .where('personal_email', isEqualTo: currentUser.email)
          .get();
      if (studentSnapshot.docs.isNotEmpty) {
        final doc = studentSnapshot.docs.first;

        AuthCredential credential = EmailAuthProvider.credential(
            email: currentUser.email!,
            password: _passwordController.text.trim());
        await currentUser.reauthenticateWithCredential(credential);

        await currentUser.updateEmail(_newemailController.text.trim());
        await doc.reference
            .update({'personal_email': _newemailController.text.trim()});

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const LoginPage()),
        // );
        // Navigator.of(context).popUntil(ModalRoute.withName('/'));
        await FirebaseAuth.instance.signOut();

        Navigator.pop(context);

        const my_snackbar(
          text: 'Update Successfully! Please Login Again',
        ).show(context);

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginOrRegister()),
            (route) => false);
      } else {
        throw Exception('Document not found');
      }
    } catch (error) {
      Navigator.pop(context);
      Dialog_ok(
              title: 'Update email failed',
              content: 'Failed to update email $error')
          .show(context);
    }
  }

  void showEmailAlreadyInuse() {
    const Dialog_ok(
            title: 'Email Already Inuse',
            content: 'Please enter your email and password.')
        .show(context);
  }

  @override
  Widget build(BuildContext context) {
    double mobilescreenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update New Email"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: mobilescreenHeight * 0.03,
                      right: mobilescreenHeight * 0.03,
                      bottom: mobilescreenHeight * 0.015),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Current Email",
                        style: TextStyle(fontSize: mobilescreenHeight * 0.021),
                      ),
                      TextField(
                        style: TextStyle(fontSize: mobilescreenHeight * 0.02),
                        controller: _emailController,
                        obscureText: false,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15.0),
                          isDense: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black38),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: "Email",
                          fillColor: Colors.grey[100],
                          filled: true,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: mobilescreenHeight * 0.03,
                      right: mobilescreenHeight * 0.03,
                      bottom: mobilescreenHeight * 0.015),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "New Email",
                        style: TextStyle(fontSize: mobilescreenHeight * 0.021),
                      ),
                      TextField(
                        style: TextStyle(fontSize: mobilescreenHeight * 0.02),
                        controller: _newemailController,
                        obscureText: false,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15.0),
                          isDense: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black38),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: "New Email",
                          fillColor: Colors.grey[100],
                          filled: true,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: mobilescreenHeight * 0.03,
                      right: mobilescreenHeight * 0.03,
                      bottom: mobilescreenHeight * 0.015),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Password",
                        style: TextStyle(fontSize: mobilescreenHeight * 0.021),
                      ),
                      TextField(
                        style: TextStyle(fontSize: mobilescreenHeight * 0.02),
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(15.0),
                          isDense: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black38),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: "Password",
                          fillColor: Colors.grey[100],
                          filled: true,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                my_button1(
                  onTap: updateEmailBtn,
                  buttonName: "Update Email",
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
