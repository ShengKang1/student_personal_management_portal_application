// import 'package:flutter/material.dart';
// import 'package:calendar_view/calendar_view.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class Timetable extends StatefulWidget {
//   const Timetable({Key? key}) : super(key: key);

//   @override
//   State<Timetable> createState() => _TimetableState();
// }

// class _TimetableState extends State<Timetable> {
//   final currentUser = FirebaseAuth.instance.currentUser!;

//   Future<Map<DateTime, List<String>>> fetchEventsFromFirebase() async {
//     final currentUser = FirebaseAuth.instance.currentUser!;

//     // Fetch student document
//     final studentSnapshot = await FirebaseFirestore.instance
//         .collection("students")
//         .where('personal_email', isEqualTo: currentUser.email)
//         .get();

//     // Get student ID
//     final List<DocumentSnapshot> studentDocuments = studentSnapshot.docs;
//     final studentData = studentDocuments.first.data() as Map<String, dynamic>;
//     final studentId = studentData['student_id'];

//     // Fetch student's registered courses
//     final studentRegistedCourseSnapshot = await FirebaseFirestore.instance
//         .collection("student_registed_course")
//         .where('student_id', isEqualTo: studentId)
//         .get();

//     // Extract registered course IDs
//     final registedCourseData = studentRegistedCourseSnapshot.docs.first.data();
//     final registedCourses =
//         List<String>.from(registedCourseData['registed_course']);

//     // Fetch course timetables for registered courses
//     Map<DateTime, List<String>> events = {};
//     for (String course in registedCourses) {
//       final courseTimetableSnapshot = await FirebaseFirestore.instance
//           .collection('course_timetable')
//           .where('courseCode', isEqualTo: course)
//           .get();

//       // Extract events for each course
//       courseTimetableSnapshot.docs.forEach((doc) {
//         String startDate = doc['startDate'];
//         String endDate = doc['endDate'];
//         String startTime = doc['startTime'];
//         String endTime = doc['endTime'];

//         DateTime startDateTime = DateTime.parse('$startDate $startTime');
//         DateTime endDateTime = DateTime.parse('$endDate $endTime');

//         // Add events for each Monday between start date and end date
//         for (DateTime date = startDateTime;
//             date.isBefore(endDateTime);
//             date = date.add(Duration(days: 1))) {
//           if (date.weekday == DateTime.monday) {
//             events[date] ??= [];
//             events[date]!.add(doc['class']);
//           }
//         }
//       });
//     }

//     return events;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Timetable"),
//       ),
//       body: FutureBuilder<Map<DateTime, List<String>>>(
//         future: fetchEventsFromFirebase(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }

//           if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           }

//           Map<DateTime, List<String>> eventsData = snapshot.data ?? {};

//           // Convert eventsData into List<CalendarEventData>
//           List<CalendarEventData> events = [];
//           eventsData.forEach((date, titles) {
//             for (String title in titles) {
//               events.add(CalendarEventData(
//                 date: date,
//                 title: title,
//               ));
//             }
//           });

//           return CalendarControllerProvider(
//             controller: EventController()..addAll(events),
//             child: WeekView(
//               startDay: WeekDays.sunday,
//               startHour: 5,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
