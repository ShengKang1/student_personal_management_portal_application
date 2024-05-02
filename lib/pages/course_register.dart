import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_portal/components/dialog_ok.dart';
import 'package:student_portal/pages/Bottom_Navigation_Bar.dart';
import 'package:intl/intl.dart';
import 'package:student_portal/pages/course_information.dart';
import 'package:student_portal/pages/pending_course.dart';
import '../components/my_button1.dart';

class CourseRegister extends StatefulWidget {
  const CourseRegister({super.key});

  @override
  State<CourseRegister> createState() => _CourseRegisterState();
}

class _CourseRegisterState extends State<CourseRegister> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  String studentId = "";
  String studentName = "";
  bool _showNoCoursesMessage = false;
  bool _showFillOneTimes = false;
  bool _noRegsiterForm = false;
  List<String> _availableCourses = [];
  bool _isLoading = true;
  String _formTitle = '';
  String _formNote = '';
  String _formendDate = '';
  final List<String> _selectedCourses = [];
  bool _formSubmitted = false;
  double mobilescreenHeight = 0;

  @override
  void initState() {
    super.initState();
    _fetchAvailableCourses();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> _fetchAvailableCourses() async {
    Timer? timer;
    timer = Timer(const Duration(seconds: 20), () {
      // Show a message if the timer expires
      if (mounted && _isLoading) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Loading Timeout',
                  style: TextStyle(fontSize: mobilescreenHeight * 0.025)),
              content: Text(
                'Please try again.',
                style: TextStyle(fontSize: mobilescreenHeight * 0.018),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    setState(() {
                      _isLoading = false;
                    });
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(fontSize: mobilescreenHeight * 0.018),
                  ),
                ),
              ],
            );
          },
        );
      }
      timer?.cancel();
    });

    final studentSnapshot = await FirebaseFirestore.instance
        .collection("students")
        .where('personal_email', isEqualTo: currentUser.email)
        .get();
    final List<DocumentSnapshot> studentDocuments = studentSnapshot.docs;
    final studentData = studentDocuments.first.data() as Map<String, dynamic>;
    studentId = studentData['student_id'];
    studentName = studentData['student_name'];
    final studentIntake = studentData['intake'];
    final specialization = getAbbreviation(studentData['specialization']);

    final pendingregistercourseSnapshot = await FirebaseFirestore.instance
        .collection("pending_register_course")
        .where('student_id', isEqualTo: studentId)
        .get();

    if (pendingregistercourseSnapshot.size > 0) {
      setState(() {
        _showFillOneTimes = true;
        _isLoading = false; // Stop loading
      });

      return;
    }

    final studentregistedcourseSnapshot = await FirebaseFirestore.instance
        .collection("student_registed_course")
        .where('student_id', isEqualTo: studentId)
        .get();

    if (studentregistedcourseSnapshot.size > 0) {
      setState(() {
        _noRegsiterForm = true;
        _isLoading = false; // Stop loading
      });

      return;
    }

    final intakeSnapshot = await FirebaseFirestore.instance
        .collection("course")
        .where('intake', arrayContains: studentIntake)
        .get();

    final classificationSnapshot = await FirebaseFirestore.instance
        .collection("course")
        .where('classification', arrayContains: specialization)
        .get();

    final List<String> intakeCourseIds =
        intakeSnapshot.docs.map((doc) => doc.id).toList();
    final List<String> classificationCourseIds =
        classificationSnapshot.docs.map((doc) => doc.id).toList();

    final courseIds = intakeCourseIds
        .where((id) => classificationCourseIds.contains(id))
        .toList();

    final List<String> availableCourses = [];

    for (String courseId in courseIds) {
      final courseDoc = await FirebaseFirestore.instance
          .collection("course")
          .doc(courseId)
          .get();

      final courseData = courseDoc.data() as Map<String, dynamic>;
      final courseCode = courseData['course_code'];
      final courseName = courseData['course_name'];
      final group = courseData['group'];

      final List<String> courses = [];
      if (group == 'none') {
        courses.add('$courseCode $courseName');
      } else {
        courses.add('$courseCode $courseName ($group)');
      }

      final formSnapshot = await FirebaseFirestore.instance
          .collection("course_register_form")
          .where('selectedCourses', arrayContains: courses[0])
          .get();

      final List<DocumentSnapshot> registerForms = formSnapshot.docs;
      DateTime now = DateTime.now();
      bool isRegistrationAvailable = false;

      for (DocumentSnapshot registerForm in registerForms) {
        final registerFormData = registerForm.data() as Map<String, dynamic>;
        final startDate = DateTime.parse(registerFormData['startDate']);
        final endDate = DateTime.parse(registerFormData['endDate']);

        if (now.isAfter(startDate) && now.isBefore(endDate)) {
          isRegistrationAvailable = true;
          _formTitle = registerFormData['title']; // Set the page title
          _formNote = registerFormData['note'];
          _formendDate = DateFormat('dd/MM/yyyy')
              .format(DateTime.parse(registerFormData['endDate']));
          break;
        }
      }

      if (isRegistrationAvailable) {
        availableCourses.addAll(courses);
      }
    }

    if (timer.isActive) {
      timer.cancel();
    }

    setState(() {
      _availableCourses = availableCourses;
      _showNoCoursesMessage = availableCourses.isEmpty;
      _isLoading = false; // Stop loading
    });
  }

  // Future<void> _fetchAvailableCourses() async {
  //   Timer? timer;
  //   timer = Timer(const Duration(seconds: 10), () {
  //     // Show a message if the timer expires
  //     if (mounted && _isLoading) {
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: const Text('Loading Timeout'),
  //             content: const Text('Please try again.'),
  //             actions: [
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.pop(context); // Close the dialog
  //                   setState(() {
  //                     _isLoading = false;
  //                   });
  //                 },
  //                 child: const Text('OK'),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     }
  //     timer?.cancel();
  //   });

  //   final studentSnapshot = await FirebaseFirestore.instance
  //       .collection("students")
  //       .where('personal_email', isEqualTo: currentUser.email)
  //       .get();
  //   final List<DocumentSnapshot> studentDocuments = studentSnapshot.docs;
  //   final studentData = studentDocuments.first.data() as Map<String, dynamic>;
  //   studentId = studentData['student_id'];
  //   studentName = studentData['student_name'];
  //   final studentIntake = studentData['intake'];
  //   final specialization = getAbbreviation(studentData['specialization']);

  //   final pendingregistercourseSnapshot = await FirebaseFirestore.instance
  //       .collection("pending_register_course")
  //       .where('student_id', isEqualTo: studentId)
  //       .get();

  //   if (pendingregistercourseSnapshot.size > 0) {
  //     setState(() {
  //       _showFillOneTimes = true;
  //       _isLoading = false; // Stop loading
  //     });

  //     return;
  //   }

  //   final studentregistedcourseSnapshot = await FirebaseFirestore.instance
  //       .collection("student_registed_course")
  //       .where('student_id', isEqualTo: studentId)
  //       .get();

  //   if (studentregistedcourseSnapshot.size > 0) {
  //     setState(() {
  //       _noRegsiterForm = true;
  //       _isLoading = false; // Stop loading
  //     });

  //     return;
  //   }

  //   final courseSnapshot = await FirebaseFirestore.instance
  //       .collection("course")
  //       .where('intake', arrayContains: studentIntake)
  //       .where('classification', arrayContains: specialization)
  //       .get();
  //   final List<DocumentSnapshot> courseDocuments = courseSnapshot.docs;
  //   final List<String> courses = courseDocuments.map((courseDoc) {
  //     final courseData = courseDoc.data() as Map<String, dynamic>;
  //     final courseCode = courseData['course_code'];
  //     final courseName = courseData['course_name'];
  //     final group = courseData['group'];

  //     if (group == 'none') {
  //       return '$courseCode $courseName';
  //     } else {
  //       return '$courseCode $courseName ($group)';
  //     }
  //   }).toList();

  //   List<String> availableCourses = [];
  //   for (String course in courses) {
  //     final formSnapshot = await FirebaseFirestore.instance
  //         .collection("course_register_form")
  //         .where('selectedCourses', arrayContains: course)
  //         .get();
  //     final List<DocumentSnapshot> registerForms = formSnapshot.docs;
  //     DateTime now = DateTime.now();
  //     bool isRegistrationAvailable = false;

  //     for (DocumentSnapshot registerForm in registerForms) {
  //       final registerFormData = registerForm.data() as Map<String, dynamic>;
  //       final startDate = DateTime.parse(registerFormData['startDate']);
  //       final endDate = DateTime.parse(registerFormData['endDate']);

  //       if (now.isAfter(startDate) && now.isBefore(endDate)) {
  //         isRegistrationAvailable = true;
  //         _formTitle = registerFormData['title']; // Set the page title
  //         _formNote = registerFormData['note'];
  //         _formendDate = DateFormat('dd/MM/yyyy')
  //             .format(DateTime.parse(registerFormData['endDate']));
  //         break;
  //       }
  //     }

  //     if (isRegistrationAvailable) {
  //       availableCourses.add(course);
  //     }
  //   }

  //   if (timer.isActive) {
  //     timer.cancel();
  //   }

  //   setState(() {
  //     _availableCourses = availableCourses;
  //     _showNoCoursesMessage = availableCourses.isEmpty;
  //     _isLoading = false; // Stop loading
  //   });
  // }

  String getAbbreviation(String specialization) {
    switch (specialization) {
      case "Software Engineering (SE)":
        return "SE";
      case "Computer Networks (CN)":
        return "CN";
      case "Business System Design (BSD)":
        return "BSD";
      default:
        return specialization; // Return original if no match
    }
  }

  void submitCourseRegister() {
    if (_formSubmitted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Form Already Submitted',
              style: TextStyle(fontSize: mobilescreenHeight * 0.025),
            ),
            content: Text(
              'You have already submitted the form.',
              style: TextStyle(fontSize: mobilescreenHeight * 0.018),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const BottomNavigationBarPage(initialIndex: 4),
                    ),
                  );
                },
                child: Text(
                  'OK',
                  style: TextStyle(fontSize: mobilescreenHeight * 0.018),
                ),
              ),
            ],
          );
        },
      );
    } else {
      // Store the selected courses and student information in Firestore
      FirebaseFirestore.instance
          .collection("pending_register_course")
          .doc(studentId)
          .set({
        'student_id': studentId,
        'student_name': studentName,
        'selected_courses': _selectedCourses,
        // Add other relevant information here
      });

      // Show a success message or navigate to a different screen
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Registration Submitted',
              style: TextStyle(fontSize: mobilescreenHeight * 0.025),
            ),
            content: Text(
              'Your registration has been submitted.',
              style: TextStyle(fontSize: mobilescreenHeight * 0.018),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  // Navigator.pushAndRemoveUntil(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) =>
                  //             const BottomNavigationBarPage(initialIndex: 4)),
                  //     (route) => false);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CourseInformation()),
                      (route) => false);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => CourseInformation(),
                  //   ),
                  // );
                },
                child: Text(
                  'OK',
                  style: TextStyle(fontSize: mobilescreenHeight * 0.018),
                ),
              ),
            ],
          );
        },
      );
      setState(() {
        _formSubmitted = true; // Update _formSubmitted to true
      });
    }
  }

  void _showInfoDialog(context) {
    const Dialog_ok(
            title: 'About Course Registration',
            content:
                "Please note that course registration can only be submitted once. After submission, your selected courses will require approval from the admin. You can view your pending registered course in (Profile -> Course Details -> Pending Course). Once approved, your registered courses will appear in your timetable. Thank you for your understanding.")
        .show(context);
  }

  @override
  Widget build(BuildContext context) {
    mobilescreenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
                child: Text(
              "Course Registration",
              style: TextStyle(fontSize: mobilescreenHeight * 0.028),
            )),
            GestureDetector(
              onTap: () {
                _showInfoDialog(context);
              },
              child: Image.asset(
                'images/Question Icon.png',
                width: mobilescreenHeight * 0.030,
                height: mobilescreenHeight * 0.030,
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _showNoCoursesMessage
              ? Center(
                  child: Text(
                    'No registration form available.',
                    style: TextStyle(fontSize: mobilescreenHeight * 0.018),
                  ),
                )
              : _showFillOneTimes
                  ? Center(
                      child: Text(
                        'Just can fill in one times.',
                        style: TextStyle(fontSize: mobilescreenHeight * 0.018),
                      ),
                    )
                  : _noRegsiterForm
                      ? Center(
                          child: Text(
                            'No registration form available.',
                            style:
                                TextStyle(fontSize: mobilescreenHeight * 0.018),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(10),
                          child: ListView.builder(
                            itemCount: _availableCourses.length,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (index == 0)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Form Expire Date : $_formendDate",
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                mobilescreenHeight * 0.018),
                                      ),
                                    ),
                                  if (index == 0)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          _formTitle,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  mobilescreenHeight * 0.025),
                                        ),
                                      ),
                                    ),
                                  if (index == 0)
                                    Padding(
                                      padding: EdgeInsets.all(
                                          mobilescreenHeight * 0.01),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            _formNote,
                                            // "ssa",
                                            style: TextStyle(
                                                fontSize:
                                                    mobilescreenHeight * 0.018),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ),
                                    ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: mobilescreenHeight * 0.008,
                                        horizontal: mobilescreenHeight * 0.01),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: CheckboxListTile(
                                        title: Text(
                                          _availableCourses[index],
                                          style: TextStyle(
                                              fontSize:
                                                  mobilescreenHeight * 0.016),
                                        ),
                                        value: _selectedCourses
                                            .contains(_availableCourses[index]),
                                        onChanged: (value) {
                                          setState(() {
                                            if (value!) {
                                              _selectedCourses.add(
                                                  _availableCourses[index]);
                                            } else {
                                              _selectedCourses.remove(
                                                  _availableCourses[index]);
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  if (index == _availableCourses.length - 1)
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: mobilescreenHeight * 0.01,
                                          horizontal:
                                              mobilescreenHeight * 0.008),
                                      child: Column(
                                        children: [
                                          Text(
                                            "By clicking the submit button, I agree to abide by the rules and regulations.",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize:
                                                    mobilescreenHeight * 0.018),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical:
                                                    mobilescreenHeight * 0.008),
                                            child: my_button1(
                                              onTap: submitCourseRegister,
                                              buttonName: "Submit",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  // GestureDetector(
                                  //   onTap: submitCourseRegister,
                                  //   child: Padding(
                                  //     padding: EdgeInsets.all(10),
                                  //     child: Container(
                                  //       child: Text("Submit"),
                                  //     ),
                                  //   ),
                                  // )
                                ],
                              );
                            },
                          ),
                        ),
    );
  }
}
