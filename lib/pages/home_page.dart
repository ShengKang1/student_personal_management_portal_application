import 'package:flutter/material.dart';
import 'package:student_portal/components/homePageButton.dart';
import 'package:student_portal/pages/LoginOrRegister.dart';
import 'package:student_portal/pages/account_setting.dart';
// import 'package:student_portal/pages/pending_course.dart';
import 'package:student_portal/pages/course_information.dart';
import 'package:student_portal/pages/course_register.dart';
// import 'package:student_portal/pages/course_register1.dart';
import 'package:student_portal/pages/timetable.dart';
import 'package:student_portal/components/web_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:student_portal/pages/login.dart';

class ExternalLink {
  final String title;
  final String link;

  ExternalLink({required this.title, required this.link});
}

class homePage extends StatefulWidget {
  homePage({super.key});

  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool _isLoading = true;
  Map<String, dynamic>? userData;
  List<ExternalLink> thirdPartyLinks = [];

  @override
  void initState() {
    super.initState();
    _fetchAllData();
  }

  Future<void> _fetchAllData() async {
    final studentSnapshot = await FirebaseFirestore.instance
        .collection("students")
        .where('personal_email', isEqualTo: currentUser.email)
        .get();
    final List<DocumentSnapshot> studentDocuments = studentSnapshot.docs;
    if (studentDocuments.isNotEmpty) {
      userData = studentDocuments.first.data() as Map<String, dynamic>;
    }

    final thirdPartySnapshot =
        await FirebaseFirestore.instance.collection("third_party").get();
    final List<DocumentSnapshot> thirdPartyDocuments = thirdPartySnapshot.docs;
    thirdPartyLinks = thirdPartyDocuments
        .map((doc) => ExternalLink(
              title: doc['title'],
              link: doc['link'],
            ))
        .toList();

    setState(() {
      _isLoading = false;
    });
  }

  //Account Setting Function
  void accountSettingPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountSetting(),
      ),
    );
  }

  //Course Registration Function
  void courseRegistrationPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseRegister(),
      ),
    );
  }

  void courseDetailsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseInformation(),
      ),
    );
  }

  //Course Registration Function
  void timetablePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Timetable(),
      ),
    );
  }

  void navigateToWebView(String title, String link) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewPage(title: title, link: link),
      ),
    );
  }

  //Log Out Function
  void logOut() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Confirm Log Out"),
          content: Text("Are you sure you want to log out?"),
          actions: <Widget>[
            TextButton(
              child: Text("Log Out"),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement<void, void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => LoginOrRegister(),
                  ),
                );

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
              child: Text("Cancel"),
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
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  //Student Information
                  Container(
                    padding: EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset('images/Avatar Icon.png',
                                  width: 80, height: 80),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Name',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                      userData!['student_name'],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                    const SizedBox(height: 10),
                                    const Text('Student ID',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(userData!['student_id']),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        const Text('Programme',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(userData!['programme']),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Official Email',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(userData!['personal_email'])
                              ],
                            )),
                            GestureDetector(
                                onTap: accountSettingPage,
                                child: Image.asset(
                                    'images/Profile Setting Icon.png',
                                    width: 30,
                                    height: 30))
                          ],
                        ),
                      ],
                    ),
                  ),

                  Column(
                    children: [
                      //Course Registration Button
                      homePageButton(
                        imageAsset: 'images/course_register_icon.png',
                        buttonName: "Course Registration",
                        onTap: courseRegistrationPage,
                      ),

                      //Course Registration Button
                      homePageButton(
                        imageAsset: 'images/course_register_icon.png',
                        buttonName: "Course Details",
                        onTap: courseDetailsPage,
                      ),

                      //Class Timetable Button
                      homePageButton(
                        imageAsset: 'images/timetable_icon.png',
                        buttonName: "Class Timetable",
                        onTap: timetablePage,
                      ),

                      // //Online Result System Button
                      // homePageButton(
                      //   imageAsset: 'images/Setting Icon.png',
                      //   buttonName: "Online Result System",
                      //   onTap: onlineResultSystem,
                      // ),

                      // //SEP System Button
                      // homePageButton(
                      //   imageAsset: 'images/Setting Icon.png',
                      //   buttonName: "SEP System",
                      //   onTap: sepSystem,
                      // ),

                      // //SEGi Backboard Button
                      // homePageButton(
                      //   imageAsset: 'images/Setting Icon.png',
                      //   buttonName: "SEGi Blackboard",
                      //   onTap: segiBlackboard,
                      // ),

                      // //Online Exam Docket Button
                      // homePageButton(
                      //   imageAsset: 'images/Setting Icon.png',
                      //   buttonName: "Online Exam Docket",
                      //   onTap: onlineExamDocket,
                      // ),
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection("third_party")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }

                          List<ExternalLink> links = snapshot.data!.docs
                              .map((doc) => ExternalLink(
                                    title: doc['title'],
                                    link: doc['link'],
                                  ))
                              .toList();

                          return Column(
                            children: links.map((link) {
                              return homePageButton(
                                imageAsset: 'images/Setting Icon.png',
                                buttonName: link.title,
                                onTap: () {
                                  navigateToWebView(link.title, link.link);
                                },
                              );
                            }).toList(),
                          );
                        },
                      ),

                      //Account Setting Button
                      homePageButton(
                        imageAsset: 'images/log_out.png',
                        buttonName: "Log Out Account",
                        onTap: logOut,
                      )
                    ],
                  )
                ],
              ),
            ),
    );
  }
}
