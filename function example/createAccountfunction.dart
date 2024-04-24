// import 'package:cloud_firestore/cloud_firestore.dart';

// class AuthenticationHelper {
//   Future<void> createAccount(String studentID, String password) async {
//     try {
//       // Check if the student ID already exists
//       QuerySnapshot<Map<String, dynamic>> existingStudent = await FirebaseFirestore.instance
//           .collection('students')
//           .where('studentID', isEqualTo: studentID)
//           .limit(1)
//           .get();

//       if (existingStudent.docs.isNotEmpty) {
//         // Student ID already exists, handle accordingly (maybe show an error)
//         print('Student ID already exists');
//         return;
//       }

//       // If student ID doesn't exist, create a new document in the 'students' collection
//       await FirebaseFirestore.instance.collection('students').add({
//         'studentID': studentID,
//         'password': password,
//         // Add other fields as needed
//       });

//       // Account creation successful
//       print('Account created successfully');
//     } catch (e) {
//       // Handle errors (e.g., Firebase-related errors)
//       print('Error creating account: $e');
//     }
//   }
// }
