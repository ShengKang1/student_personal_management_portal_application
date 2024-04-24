// Future<void> logIn(BuildContext context) async {
//   try {
//     // Get the values from the controllers
//     String studentID = _studentIdController.text;
//     String password = _passwordController.text;

//     // Reference to the Firestore collection
//     CollectionReference students =
//         FirebaseFirestore.instance.collection('students');

//     // Query Firestore for the student with the given ID and password
//     QuerySnapshot querySnapshot = await students
//         .where('studentID', isEqualTo: studentID)
//         .where('password', isEqualTo: password)
//         .get();

//     // Check if a student with the given ID and password exists
//     if (querySnapshot.docs.isEmpty) {
//       // Student not found or incorrect password
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Login Failed'),
//             content: Text('Invalid student ID or password'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//       return;
//     }

//     // Successfully logged in
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => HomePage(),
//       ),
//     );
//   } catch (e) {
//     print("Error: $e");
//   }
// }