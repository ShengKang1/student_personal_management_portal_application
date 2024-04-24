// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class Timetable extends StatefulWidget {
//   const Timetable({Key? key}) : super(key: key);

//   @override
//   State<Timetable> createState() => _TimetableState();
// }

// class _TimetableState extends State<Timetable> {
//   final currentUser = FirebaseAuth.instance.currentUser!;
//   late CalendarController _calendarController;
//   double mobilescreenHeight = 0;

//   @override
//   void initState() {
//     super.initState();
//     _calendarController = CalendarController();
//   }

//   Color hexToColor(String code) {
//     return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
//   }

//   Future<List<Appointment>> fetchEventsFromFirebase() async {
//     final studentSnapshot = await FirebaseFirestore.instance
//         .collection("students")
//         .where('personal_email', isEqualTo: currentUser.email)
//         .get();
//     final List<DocumentSnapshot> studentDocuments = studentSnapshot.docs;
//     final studentData = studentDocuments.first.data() as Map<String, dynamic>;
//     final studentId = studentData['student_id'];

//     final studentRegistedCourseSnapshot = await FirebaseFirestore.instance
//         .collection("student_registed_course")
//         .where('student_id', isEqualTo: studentId)
//         .get();

//     List<Appointment> allEvents = [];

//     final registedCourseData = studentRegistedCourseSnapshot.docs.first.data();
//     final registedCourses =
//         List<String>.from(registedCourseData['registed_courses']);

//     for (String course in registedCourses) {
//       final courseTimetableSnapshot = await FirebaseFirestore.instance
//           .collection('course_timetable')
//           .where('course', isEqualTo: course)
//           .get();

//       // List<Appointment> events = courseTimetableSnapshot.docs.map((doc) {
//       //   Map<String, dynamic> data = doc.data();
//       //   // Split the 'studentAmount' string into individual numbers

//       //   return Appointment(
//       //     subject: data['courseCode'],
//       //     notes: data['studentAmount'] +
//       //         ", " +
//       //         data['lecturer'] +
//       //         ", " +
//       //         data['class'],
//       //     startTime:
//       //         DateTime.parse("${data['startDate']} ${data['startTime']}"),
//       //     endTime: DateTime.parse("${data['startDate']} ${data['endTime']}"),
//       //     color: hexToColor(data['eventColor']),
//       //     recurrenceRule:
//       //         'FREQ=WEEKLY;BYDAY=${_dayOfWeekAbbreviation(int.parse(data['dayOfWeek']))};UNTIL=${_formatUntilDate(data['endDate'])}',
//       //   );
//       // }).toList();

//       List<Appointment> events = courseTimetableSnapshot.docs.map((doc) {
//         Map<String, dynamic> data = doc.data();

//         List<String> studentAmounts = data['studentAmount'].split(', ');
//         int sum = studentAmounts.length == 1
//             ? int.parse(studentAmounts[0])
//             : studentAmounts
//                 .map((amount) => int.parse(amount))
//                 .reduce((a, b) => a + b);

//         return Appointment(
//           subject: data['course'],
//           notes: studentAmounts.length == 1
//               ? '${studentAmounts[0]}, ${data['lecturer']}, ${data['endDate']}'
//               : '(${studentAmounts.join('+')})$sum, ${data['lecturer']}, ${data['endDate']}',
//           location: data['class'],
//           startTime:
//               DateTime.parse("${data['startDate']} ${data['startTime']}"),
//           endTime: DateTime.parse("${data['startDate']} ${data['endTime']}"),
//           color: hexToColor(data['eventColor']),
//           recurrenceRule:
//               'FREQ=WEEKLY;BYDAY=${_dayOfWeekAbbreviation(int.parse(data['dayOfWeek']))};UNTIL=${_formatUntilDate(data['endDate'])}',
//         );
//       }).toList();

//       allEvents.addAll(events);
//     }
//     return allEvents;
//   }

//   String _formatUntilDate(String endDate) {
//     DateTime parsedEndDate = DateTime.parse(endDate);
//     String formattedEndDate =
//         "${parsedEndDate.year}${_twoDigits(parsedEndDate.month)}${_twoDigits(parsedEndDate.day)}T235959Z";
//     return formattedEndDate;
//   }

//   String _twoDigits(int n) {
//     if (n >= 10) return "$n";
//     return "0$n";
//   }

//   String _dayOfWeekAbbreviation(int n) {
//     switch (n) {
//       case 1:
//         return "MO";
//       case 2:
//         return "TU";
//       case 3:
//         return "WE";
//       case 4:
//         return "TH";
//       case 5:
//         return "FR";
//       case 6:
//         return "SA";
//       case 7:
//         return "SU";
//       default:
//         return ""; // Handle invalid values
//     }
//   }

//   void switchToScheduleView() {
//     _calendarController.view = CalendarView.schedule;
//   }

//   void switchToDayView() {
//     _calendarController.view = CalendarView.day;
//   }

//   void switchToWeekView() {
//     _calendarController.view = CalendarView.week;
//   }

//   void switchToMonthView() {
//     _calendarController.view = CalendarView.month;
//   }

//   void _showAppointmentDetails(Appointment appointment) {
//     // print("${appointment}");
//     double textSize = mobilescreenHeight * 0.018;
//     String notes = appointment.notes ?? "";
//     List<String> noteParts = notes.split(', ');
//     String studentAmount = noteParts[0]; // "(1+3)4"
//     String lecturer = noteParts[1]; // "lecturer1"
//     String endDate = noteParts[2]; // "2024-04-06"

//     String formattedStartDate =
//         DateFormat('dd/MM/yyyy').format(appointment.startTime);
//     String formattedEndDate =
//         DateFormat('dd/MM/yyyy').format(DateTime.parse(endDate));
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(appointment.subject),
//         content: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text('Date: $formattedStartDate - $formattedEndDate',
//                 style: TextStyle(fontSize: textSize)),
//             Text(
//                 'Time: ${DateFormat.jm().format(appointment.startTime)} - ${DateFormat.jm().format(appointment.endTime)}',
//                 style: TextStyle(fontSize: textSize)),
//             // Text('End Date: ${DateFormat.yMd().format(appointment.endTime)}'),
//             Text(
//               'Lecturer: $lecturer',
//               style: TextStyle(fontSize: textSize),
//             ),
//             Text('Classroom: ${appointment.location}',
//                 style: TextStyle(fontSize: textSize)),
//             Text('Student Amount: $studentAmount',
//                 style: TextStyle(fontSize: textSize))
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text(
//               'Close',
//               style: TextStyle(fontSize: mobilescreenHeight * 0.018),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // void _showAppointmentDetails(Appointment appointment) {
//   //   print("${appointment}");

//   //   String notes = appointment.notes ?? "";
//   //   List<String> noteParts = notes.split(', ');
//   //   String studentAmount = noteParts[0]; // "(1+3)4"
//   //   String lecturer = noteParts[1]; // "lecturer1"
//   //   String endDate = noteParts[2]; // "2024-04-06"

//   //   String formattedStartDate =
//   //       DateFormat('dd/MM/yyyy').format(appointment.startTime);
//   //   String formattedEndDate =
//   //       DateFormat('dd/MM/yyyy').format(DateTime.parse(endDate));
//   //   showDialog(
//   //     context: context,
//   //     builder: (context) => AlertDialog(
//   //       title: Text(appointment.subject),
//   //       content: SingleChildScrollView(
//   //         child: DataTable(
//   //           columns: const [
//   //             DataColumn(label: Text('Attribute')),
//   //             DataColumn(label: Center(child: Text('Value'))),
//   //           ],
//   //           rows: [
//   //             DataRow(cells: [
//   //               DataCell(Text('Start Date')),
//   //               DataCell(Center(child: Text(formattedStartDate))),
//   //             ]),
//   //             DataRow(cells: [
//   //               DataCell(Text('End Date')),
//   //               DataCell(Center(child: Text(formattedEndDate))),
//   //             ]),
//   //             DataRow(cells: [
//   //               DataCell(Text('Start Time')),
//   //               DataCell(Center(
//   //                   child:
//   //                       Text(DateFormat.jm().format(appointment.startTime)))),
//   //             ]),
//   //             DataRow(cells: [
//   //               DataCell(Text('End Time')),
//   //               DataCell(Center(
//   //                   child: Text(DateFormat.jm().format(appointment.endTime)))),
//   //             ]),
//   //             DataRow(cells: [
//   //               DataCell(Text('Classroom')),
//   //               DataCell(Center(child: Text(appointment.location ?? ''))),
//   //             ]),
//   //             DataRow(cells: [
//   //               DataCell(Text('Lecturer')),
//   //               DataCell(Center(child: Text(lecturer))),
//   //             ]),
//   //             DataRow(cells: [
//   //               DataCell(Text('Student Amount')),
//   //               DataCell(Center(child: Text(studentAmount))),
//   //             ]),
//   //           ],
//   //         ),
//   //       ),
//   //       actions: [
//   //         TextButton(
//   //           onPressed: () => Navigator.pop(context),
//   //           child: Text('Close'),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     mobilescreenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       body: SafeArea(
//         child: FutureBuilder<List<Appointment>>(
//           future: fetchEventsFromFirebase(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }

//             // if (snapshot.hasError) {
//             //   return Center(
//             //     child: Text('Error: ${snapshot.error}'),
//             //   );
//             // }

//             List<Appointment> events = snapshot.data ?? [];

//             return SfCalendar(
//               controller: _calendarController,
//               view: CalendarView.week,
//               dataSource: _getCalendarDataSource(events),
//               showCurrentTimeIndicator: false,
//               timeSlotViewSettings: const TimeSlotViewSettings(
//                 timeIntervalHeight:
//                     80, // Set the desired height of each time slot
//               ),
//               appointmentBuilder:
//                   (BuildContext context, CalendarAppointmentDetails details) {
//                 final Appointment appointment = details.appointments.first;
//                 return GestureDetector(
//                   onTap: () {
//                     _showAppointmentDetails(appointment);
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: appointment.color,
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         appointment.subject,
//                         style: TextStyle(color: Colors.white, fontSize: 10),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//       floatingActionButton: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           FloatingActionButton(
//             onPressed: switchToDayView,
//             child: Icon(Icons.calendar_view_day),
//             tooltip: 'Switch to Day View',
//           ),
//           SizedBox(width: 16),
//           FloatingActionButton(
//             onPressed: switchToWeekView,
//             child: Icon(Icons.calendar_view_week),
//             tooltip: 'Switch to Week View',
//           ),
//           SizedBox(width: 16),
//           FloatingActionButton(
//             onPressed: switchToMonthView,
//             child: Icon(Icons.calendar_month),
//             tooltip: 'Switch to Week View',
//           ),
//           SizedBox(width: 16),
//           FloatingActionButton(
//             onPressed: switchToScheduleView,
//             child: Icon(Icons.schedule),
//             tooltip: 'Switch to Schedule View',
//           ),
//         ],
//       ),
//     );
//   }

//   _DataSource _getCalendarDataSource(List<Appointment> events) {
//     return _DataSource(events);
//   }
// }

// class _DataSource extends CalendarDataSource {
//   _DataSource(List<Appointment> source) {
//     appointments = source;
//   }
// }
