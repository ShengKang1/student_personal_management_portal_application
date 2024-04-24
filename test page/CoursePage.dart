import 'package:flutter/material.dart';
import 'package:student_portal/components/homePageButton.dart';
import 'package:student_portal/pages/course_information.dart';
import 'package:student_portal/pages/course_register.dart';

class CoursePage extends StatefulWidget {
  CoursePage({super.key});

  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
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
            ],
          ),
        ),
      ),
    );
  }
}
