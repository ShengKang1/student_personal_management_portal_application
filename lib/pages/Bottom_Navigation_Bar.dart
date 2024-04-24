import 'package:flutter/material.dart';
import 'package:student_portal/pages/News.dart';
import 'package:student_portal/pages/Profile.dart';
import 'package:student_portal/pages/WebPage.dart';
import 'package:student_portal/pages/course_register.dart';
import 'package:student_portal/pages/home_page.dart';
import 'package:student_portal/pages/timetable.dart';

class BottomNavigationBarPage extends StatefulWidget {
  final int initialIndex;
  const BottomNavigationBarPage({Key? key, this.initialIndex = 0})
      : super(key: key);

  @override
  State<BottomNavigationBarPage> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<BottomNavigationBarPage> {
  int _currentIndex = 0;

  final List<Widget> _widgetOptions = const [
    News(),
    CourseRegister(),
    Timetable(),
    WebPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    double mobilescreenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: _widgetOptions[_currentIndex],
      ),
      bottomNavigationBar: SizedBox(
        height: mobilescreenHeight * 0.075,
        child: BottomNavigationBar(
          // showUnselectedLabels: true,
          currentIndex: _currentIndex,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black38,
          backgroundColor: const Color(0xff7cacd4),
          iconSize: mobilescreenHeight * 0.03,
          selectedFontSize: mobilescreenHeight * 0.018,
          onTap: (int newIndex) {
            setState(() {
              _currentIndex = newIndex;
            });
          },
          items: const [
            BottomNavigationBarItem(
                backgroundColor: Color(0xff7cacd4),
                label: "News",
                icon: Icon(Icons.newspaper_outlined)),
            BottomNavigationBarItem(
                backgroundColor: Color(0xff7cacd4),
                label: "Registration",
                icon: Icon(Icons.app_registration)),
            BottomNavigationBarItem(
                backgroundColor: Color(0xff7cacd4),
                label: "Timetable",
                icon: Icon(Icons.calendar_today_outlined)),
            BottomNavigationBarItem(
                backgroundColor: Color(0xff7cacd4),
                label: "Web",
                icon: Icon(Icons.web_rounded)),
            BottomNavigationBarItem(
                backgroundColor: Color(0xff7cacd4),
                label: "Profile",
                icon: Icon(Icons.account_circle_outlined))
          ],
        ),
      ),
    );
  }
}
