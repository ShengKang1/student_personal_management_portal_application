import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:student_portal/components/homePageButton.dart';
import 'package:student_portal/pages/LoginOrRegister.dart';
import 'package:student_portal/pages/Update_Email.dart';
import 'package:student_portal/pages/account_setting.dart';
import 'package:student_portal/pages/course_information.dart';
import 'package:student_portal/pages/course_taken_history.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool _isLoading = true;
  Map<String, dynamic>? userData;
  double mobilescreenHeight = 0;

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

    //update student course taken history

    final List<DocumentSnapshot> courseTakenDocuments = studentSnapshot.docs;
    final studentData =
        courseTakenDocuments.first.data() as Map<String, dynamic>;
    final studentId = studentData['student_id'];

    final courseTakenHistorySnapshot = await FirebaseFirestore.instance
        .collection("course_taken_history")
        .where('student_id', isEqualTo: studentId)
        .get();

    final List<DocumentSnapshot> courseTakenHistoryDocuments =
        courseTakenHistorySnapshot.docs;

    Map<String, dynamic> courseTakenHistoryData;
    Map<String, dynamic> registedCoursesData;

    if (courseTakenHistoryDocuments.isNotEmpty) {
      courseTakenHistoryData =
          courseTakenHistoryDocuments.first.data() as Map<String, dynamic>;
      registedCoursesData =
          courseTakenHistoryData['registed_courses'] as Map<String, dynamic>;
    } else {
      // Handle the case when courseTakenHistoryDocuments is empty
      // For example, set courseTakenHistoryData and registedCoursesData to empty Maps
      courseTakenHistoryData = {};
      registedCoursesData = {};
    }
    // final List<Map<String, dynamic>> courses = [];

    int totalCreditHours = 0;

    registedCoursesData.forEach((key, value) {
      final creditHours = int.tryParse(value['credit_hours']);
      if (creditHours != null) {
        totalCreditHours += creditHours;
      }
    });

    // Update total credit hours in the student's document
    final studentDocRef =
        FirebaseFirestore.instance.collection("students").doc(studentId);
    await studentDocRef.update({'credit_hours': totalCreditHours});

    userData!['credit_hours'] = totalCreditHours;

    setState(() {
      _isLoading = false;
    });
  }

  //Account Setting Function
  void accountSettingPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AccountSetting(),
      ),
    );
  }

  void courseDetailsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CourseInformation(),
      ),
    );
  }

  void courseTakenHistoryPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CourseTakenHistory(),
      ),
    );
  }

  void updateEmailPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UpdateEmailPage(),
      ),
    );
  }

  //Log Out Function
  void logOut() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            "Confirm Log Out",
            style: TextStyle(fontSize: mobilescreenHeight * 0.025),
          ),
          content: Text(
            "Are you sure you want to log out?",
            style: TextStyle(fontSize: mobilescreenHeight * 0.018),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Log Out",
                style: TextStyle(fontSize: mobilescreenHeight * 0.018),
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                // Navigator.pushReplacement<void, void>(
                //   context,
                //   MaterialPageRoute<void>(
                //     builder: (BuildContext context) => LoginPage(),
                //   ),
                // );
                //     Navigator.of(context).pushAndRemoveUntil(
                //   MaterialPageRoute(builder: (context) => LoginPage()),
                //   ModalRoute.withName('/'),
                // );

                // ignore: use_build_context_synchronously
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginOrRegister()),
                    (route) => false);

                // Show Log Out Successful Snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Log Out Successful',
                      style: TextStyle(color: Colors.black),
                    ),
                    duration: Duration(seconds: 1),
                    backgroundColor: Colors.white,
                  ),
                );
              },
            ),
            TextButton(
              child: Text("Cancel",
                  style: TextStyle(fontSize: mobilescreenHeight * 0.018)),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    mobilescreenHeight = MediaQuery.of(context).size.height;

    double profileTextStyle = mobilescreenHeight * 0.018;

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  //Student Information
                  Container(
                    padding: EdgeInsets.all(mobilescreenHeight * 0.025),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: mobilescreenHeight * 0.025,
                              bottom: mobilescreenHeight * 0.008),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset('images/Avatar Icon.png',
                                  width: mobilescreenHeight * 0.095,
                                  height: mobilescreenHeight * 0.095),
                              SizedBox(width: mobilescreenHeight * 0.025),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Name',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: profileTextStyle)),
                                    Text(
                                      userData!['student_name'],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style:
                                          TextStyle(fontSize: profileTextStyle),
                                    ),
                                    SizedBox(
                                        height: mobilescreenHeight * 0.015),
                                    Text('Student ID',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: profileTextStyle)),
                                    Text(
                                      userData!['student_id'],
                                      style:
                                          TextStyle(fontSize: profileTextStyle),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Text('Programme',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: profileTextStyle)),
                        Text(
                          userData!['programme'],
                          style: TextStyle(fontSize: profileTextStyle),
                        ),
                        SizedBox(height: mobilescreenHeight * 0.015),
                        Text('Student Email',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: profileTextStyle)),
                        Text(
                          userData!['personal_email'],
                          style: TextStyle(fontSize: profileTextStyle),
                        ),
                        SizedBox(height: mobilescreenHeight * 0.015),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Credit Hours',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: profileTextStyle),
                                ),
                                // Text(userData!['total_credit_hours'])
                                // Text(userData!['credit_hours'].toString() +
                                //     "/120")
                                Text(
                                  "${userData!['credit_hours']}/120",
                                  style: TextStyle(fontSize: profileTextStyle),
                                )
                              ],
                            ),
                            GestureDetector(
                                onTap: accountSettingPage,
                                child: Image.asset(
                                    'images/Profile Setting Icon.png',
                                    width: mobilescreenHeight * 0.042,
                                    height: mobilescreenHeight * 0.042))
                          ],
                        ),
                      ],
                    ),
                  ),

                  //Course Details Button
                  homePageButton(
                    imageAsset: 'images/course_register_icon.png',
                    buttonName: "Course Details",
                    onTap: courseDetailsPage,
                  ),

                  //Course Taken History Button
                  homePageButton(
                    imageAsset: 'images/History_Icon.png',
                    buttonName: "Course Taken History",
                    onTap: courseTakenHistoryPage,
                  ),

                  //Update Email Button
                  homePageButton(
                    imageAsset: 'images/History_Icon.png',
                    buttonName: "Update Email",
                    onTap: updateEmailPage,
                  ),

                  //Account Setting Button
                  homePageButton(
                    imageAsset: 'images/log_out.png',
                    buttonName: "Log Out Account",
                    onTap: logOut,
                  )
                ],
              ),
            ),
    );
  }
}
