import 'package:flutter/material.dart';
import 'package:student_portal/pages/Bottom_Navigation_Bar.dart';
import 'package:student_portal/pages/pending_course.dart';
import 'package:student_portal/pages/registed_course.dart';

class CourseInformation extends StatelessWidget {
  const CourseInformation({super.key});

  @override
  Widget build(BuildContext context) {
    double mobilescreenHeight = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Course Details',
            style: TextStyle(fontSize: mobilescreenHeight * 0.028),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Navigator.popUntil(
              //   context,
              //   ModalRoute.withName(
              //       '/profile'), // Replace '/profile' with the route name of your profile page
              // );
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const BottomNavigationBarPage(initialIndex: 4)),
                  (route) => false);
            },
          ),
          bottom: TabBar(
              indicatorColor: Colors.black,
              labelColor: Colors.black,
              tabs: [
                Tab(
                  child: Text(
                    'Pending Course',
                    style: TextStyle(fontSize: mobilescreenHeight * 0.018),
                  ),
                ),
                Tab(
                  child: Text('Registered Course',
                      style: TextStyle(fontSize: mobilescreenHeight * 0.018)),
                )
              ]),
        ),
        body: const TabBarView(children: [PendingCourse(), RegistedCourse()]),
      ),
    );
  }
}
