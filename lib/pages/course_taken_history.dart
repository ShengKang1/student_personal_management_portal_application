import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CourseTakenHistory extends StatefulWidget {
  const CourseTakenHistory({super.key});

  @override
  State<CourseTakenHistory> createState() => _CourseTakenHistoryState();
}

class _CourseTakenHistoryState extends State<CourseTakenHistory> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  List<dynamic> courseHistoryData = [];
  bool _isLoading = true;
  int creditHours = 0;

  @override
  void initState() {
    super.initState();
    _fetchStudentCourseTakenHistory();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> _fetchStudentCourseTakenHistory() async {
    final studentSnapshot = await FirebaseFirestore.instance
        .collection("students")
        .where('personal_email', isEqualTo: currentUser.email)
        .get();
    final List<DocumentSnapshot> studentDocuments = studentSnapshot.docs;
    final studentData = studentDocuments.first.data() as Map<String, dynamic>;
    final studentId = studentData['student_id'];
    creditHours = studentData['credit_hours'];

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
    final List<Map<String, dynamic>> courses = [];

    registedCoursesData.forEach((key, value) {
      final courseData = {
        'course': value['course'],
        'credit_hours': value['credit_hours'],
      };
      courses.add(courseData);
    });
    setState(() {
      courseHistoryData = courses;
      _isLoading = false;
    });
  }

  // int totalCreditHours = 0;
  @override
  Widget build(BuildContext context) {
    double mobilescreenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Course Taken History",
          style: TextStyle(fontSize: mobilescreenHeight * 0.028),
        ),
      ),
      body: Center(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : courseHistoryData.isEmpty
                ? Center(
                    child: Text('No course taken history found.',
                        style: TextStyle(fontSize: mobilescreenHeight * 0.018)))
                : Padding(
                    padding: EdgeInsets.all(mobilescreenHeight * 0.01),
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: SizedBox(
                              width: double.infinity,
                              child: DataTable(
                                // dataRowHeight: 60,
                                dataRowMaxHeight: mobilescreenHeight * 0.13,
                                columns: [
                                  DataColumn(
                                      label: Text(
                                    'Course',
                                    style: TextStyle(
                                        fontSize: mobilescreenHeight * 0.02),
                                  )),
                                  DataColumn(
                                      label: Text(
                                    'Credit Hours',
                                    style: TextStyle(
                                        fontSize: mobilescreenHeight * 0.02),
                                  )),
                                ],
                                rows: courseHistoryData.map<DataRow>((course) {
                                  return DataRow(cells: [
                                    DataCell(SizedBox(
                                        width: mobilescreenHeight * 0.18,
                                        child: Text(
                                          course['course'],
                                          style: TextStyle(
                                              fontSize:
                                                  mobilescreenHeight * 0.018),
                                        ))),
                                    DataCell(
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          course['credit_hours'],
                                          style: TextStyle(
                                              fontSize:
                                                  mobilescreenHeight * 0.018),
                                        ),
                                      ),
                                    ),
                                  ]);
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: mobilescreenHeight * 0.01),
                          child: Text(
                            'Total Credit Hours: $creditHours /120',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: mobilescreenHeight * 0.02),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
