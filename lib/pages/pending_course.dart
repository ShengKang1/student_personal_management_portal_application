import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PendingCourse extends StatefulWidget {
  const PendingCourse({Key? key}) : super(key: key);

  @override
  State<PendingCourse> createState() => _PendingCourseState();
}

class _PendingCourseState extends State<PendingCourse> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  List<dynamic> pendingCourseData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPendingCourseRegister();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> _fetchPendingCourseRegister() async {
    final studentSnapshot = await FirebaseFirestore.instance
        .collection("students")
        .where('personal_email', isEqualTo: currentUser.email)
        .get();
    final List<DocumentSnapshot> studentDocuments = studentSnapshot.docs;
    final studentData = studentDocuments.first.data() as Map<String, dynamic>;
    final studentId = studentData['student_id'];

    final pendingregistercourseSnapshot = await FirebaseFirestore.instance
        .collection("pending_register_course")
        .where('student_id', isEqualTo: studentId)
        .get();

    if (pendingregistercourseSnapshot.size > 0) {
      final List<DocumentSnapshot> pendingregistercourseDocuments =
          pendingregistercourseSnapshot.docs;
      final pendingregistercourseData =
          pendingregistercourseDocuments.first.data() as Map<String, dynamic>;
      setState(() {
        pendingCourseData = pendingregistercourseData['selected_courses'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading =
            false; // Stop showing loading indicator even if no courses found
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double mobilescreenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.all(mobilescreenHeight * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pending Courses:',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: mobilescreenHeight * 0.025),
          ),
          _isLoading
              ? const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : pendingCourseData.isEmpty
                  ? Expanded(
                      child: Center(
                          child: Text(
                      'No pending courses found.',
                      style: TextStyle(fontSize: mobilescreenHeight * 0.018),
                    )))
                  : Padding(
                      padding: EdgeInsets.all(mobilescreenHeight * 0.01),
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: pendingCourseData
                            .map<Widget>((course) => Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: mobilescreenHeight * 0.012),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          mobilescreenHeight * 0.008),
                                      child: Text(
                                        course,
                                        style: TextStyle(
                                            fontSize:
                                                mobilescreenHeight * 0.018),
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
        ],
      ),
    );
  }
}
