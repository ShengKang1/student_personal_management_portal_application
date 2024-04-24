import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:student_portal/components/dialog_ok.dart';
import 'package:student_portal/components/my_button1.dart';
import 'package:student_portal/components/profile_showdata.dart';
import 'package:student_portal/pages/Bottom_Navigation_Bar.dart';
import 'package:student_portal/pages/ForgotPasswor_User.dart';
import 'package:student_portal/pages/forgot_password.dart';

class AccountSetting extends StatefulWidget {
  const AccountSetting({super.key});

  @override
  State<AccountSetting> createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  Map<String, dynamic>? userData;
  final _phoneNumberController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllData();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> _fetchAllData() async {
    final studentSnapshot = await FirebaseFirestore.instance
        .collection("students")
        .where('personal_email', isEqualTo: currentUser.email)
        .get();

    // get information
    final List<DocumentSnapshot> studentDocuments = studentSnapshot.docs;
    if (studentDocuments.isNotEmpty) {
      userData = studentDocuments.first.data() as Map<String, dynamic>;
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _updateInformation() async {
    final String newPhoneNumber = _phoneNumberController.text.trim();

    if (newPhoneNumber.isEmpty) {
      const Dialog_ok(title: 'Error', content: 'Please enter a phone number')
          .show(context);
      return;
    }

    if (!isValidPhoneNumber(_phoneNumberController.text)) {
      const Dialog_ok(
              title: 'Phone number format is incorrect',
              content: 'Please enter again your phone number.')
          .show(context);
      return;
    }
    setState(() {
      _isLoading = true;
    });

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection("students")
          .where('personal_email', isEqualTo: currentUser.email)
          .get();

      final doc = querySnapshot.docs.first;
      await doc.reference.update({'phone_number': newPhoneNumber});

      setState(() {
        // Update the phone number in the userData map
        userData!['phone_number'] = newPhoneNumber;
      });

      const Dialog_ok(
              title: 'Phone number updated',
              content: 'Phone number updated successfully')
          .show(context);

      // Clear the phone number field after successful update
      _phoneNumberController.clear();

      // Refresh the page
      setState(() {});
    } catch (e) {
      const Dialog_ok(title: 'Error', content: 'Failed to update phone number')
          .show(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool isValidPhoneNumber(String phoneNumber) {
    // Regular expression for a phone number format (10 digits)
    RegExp regex = RegExp(r'^[0-9]+$');
    return regex.hasMatch(phoneNumber);
  }

  void forgotPasswordPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ForgotPasswordUser(
                email: currentUser.email!,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    double mobilescreenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account Setting',
          style: TextStyle(fontSize: mobilescreenHeight * 0.028),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(mobilescreenHeight * 0.015),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: mobilescreenHeight * 0.003,
                            ),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 5,
                                    offset: Offset(0, 0),
                                  ),
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ProfileData(
                                      textlabel: "Student ID",
                                      userData: userData!['student_id']),
                                  ProfileData(
                                      textlabel: "Student Name",
                                      userData: userData!['student_name']),
                                  ProfileData(
                                      textlabel: "Student Email",
                                      userData: userData!['personal_email']),
                                  ProfileData(
                                      textlabel: "Intake",
                                      userData: userData!['intake']),
                                  ProfileData(
                                      textlabel: "Programme",
                                      userData: userData!['programme']),
                                  ProfileData(
                                      textlabel: "Specialization",
                                      userData: userData!['specialization']),
                                  ProfileData(
                                      textlabel: "Completed Credit Hours",
                                      userData:
                                          userData!['credit_hours'].toString()),
                                  ProfileData(
                                      textlabel: "Phone Number",
                                      userData: userData!['phone_number']),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: mobilescreenHeight * 0.008,
                                horizontal: mobilescreenHeight * 0.01),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Student ID Text
                                Text(
                                  "Update Your Phone Number",
                                  style: TextStyle(
                                      fontSize: mobilescreenHeight * 0.021),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: mobilescreenHeight * 0.01),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.black38, // Outline color
                                      ),
                                    ),
                                    child: TextField(
                                      controller: _phoneNumberController,
                                      decoration: InputDecoration(
                                        hintText: userData!['phone_number'],
                                        hintStyle: TextStyle(
                                            color: Colors.black26,
                                            fontSize:
                                                mobilescreenHeight * 0.021),
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: mobilescreenHeight * 0.015,
                                          horizontal:
                                              mobilescreenHeight * 0.015,
                                        ),
                                        border: InputBorder
                                            .none, // Hide the default border of TextField
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        GestureDetector(
                            onTap: forgotPasswordPage,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                'Click here reset password',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: mobilescreenHeight * 0.018),
                              ),
                            )),
                        my_button1(
                            buttonName: "Update Information",
                            onTap: _updateInformation),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
