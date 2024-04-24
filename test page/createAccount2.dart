// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:student_portal/components/create_account_textfield.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:student_portal/pages/auth_page.dart';

// class createAccount extends StatefulWidget {
//   final Function()? onTap;
//   const createAccount({super.key, required this.onTap});

//   @override
//   _createAccountState createState() => _createAccountState();
// }

// class _createAccountState extends State<createAccount> {
//   //text controller
//   final _studentIdController = TextEditingController();
//   final _nameController = TextEditingController();
//   final _personalEmailController = TextEditingController();
//   final _phoneNumberController = TextEditingController();
//   final _programmeController = TextEditingController();
//   final _specializationController = TextEditingController();
//   final _intakeController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();

//   //Create Account Function
//   Future<void> createAccount() async {
//     // Show loading circle
//     showDialog(
//       context: context,
//       builder: (context) {
//         return const Center(child: CircularProgressIndicator());
//       },
//     );

//     try {
//       // Check if required fields are empty
//       if (_studentIdController.text.isEmpty ||
//           _nameController.text.isEmpty ||
//           _personalEmailController.text.isEmpty ||
//           _phoneNumberController.text.isEmpty ||
//           _specializationController.text.isEmpty ||
//           _intakeController.text.isEmpty ||
//           _passwordController.text.isEmpty ||
//           _confirmPasswordController.text.isEmpty) {
//         Navigator.pop(context); // Dismiss loading circle
//         showMissingInformationDialog();
//         return;
//       }

//       // Check if passwords match
//       if (_passwordController.text != _confirmPasswordController.text) {
//         Navigator.pop(context); // Dismiss loading circle
//         passwordNoMatch();
//         return;
//       }

//       // Check password length and presence of numbers and alphabets
//       if (_passwordController.text.length < 6 ||
//           !_containsUppercase(_passwordController.text) ||
//           !_containsLowercase(_passwordController.text) ||
//           !_containsNumber(_passwordController.text) ||
//           !_containsSpecialCharacter(_passwordController.text)) {
//         Navigator.pop(context); // Dismiss loading circle
//         showPasswordRequirementsDialog();
//         return;
//       }

//       // Create user in Firebase Authentication
      
//         await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: _personalEmailController.text,
//         password: _passwordController.text,
//       );

//       // Store additional user information in Cloud Firestore
//       String studentID = _studentIdController.text.trim();
//       String name = _nameController.text.trim();
//       String personalEmail = _personalEmailController.text.trim();
//       String phoneNumber = _phoneNumberController.text.trim();
//       String programme = _programmeController.text.trim();
//       String specialization = _specializationController.text.trim();
//       String intake = _intakeController.text.trim();
//       DateTime now = DateTime.now();

//       final pendingDB = FirebaseFirestore.instance;
//       final students = <String, dynamic>{
//         'Student ID': studentID,
//         'Name': name,
//         'Personal Email': personalEmail,
//         'Phone Number': phoneNumber,
//         'Programme': programme,
//         'Specialization': specialization,
//         'Intake': intake,
//         'Request_at': now,
//         'Status': 'Pending Approve'
//       };

//       // Store user information in Firestore
//       await pendingDB
//           .collection('pending') //Collection
//           .doc(studentID) //Unique ID
//           .set(students); //Store data

//       // Dismiss loading circle
//       Navigator.pop(context);

//       // Successfully created account, now navigate to login page
//       navigateToLoginPage();
//     } on FirebaseAuthException catch (e) {
//       // Handle Firebase Authentication exceptions
//       Navigator.pop(context); // Dismiss loading circle

//       if (e.code == 'email-already-in-use') {
//         // Email is already in use
//         showDialog(
//           context: context,
//           builder: (context) {
//             return AlertDialog(
//               title: Text('Error'),
//               content: Text('The email address is already in use.'),
//             );
//           },
//         );
//       } else {
//         // Other Firebase Authentication errors
//         genericErrorMessage();
//       }
//     } catch (e) {
//       // Handle other exceptions
//       if (mounted) {
//         Navigator.pop(context); // Dismiss loading circle
//       }
//       genericErrorMessage();
//     }
//   }

//   void navigateToLoginPage() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => authPage(),
//       ),
//     );
//   }

//   void showMissingInformationDialog() {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text('Missing Information'),
//             content: Text('Please enter your email and password.'),
//           );
//         });
//   }

//   bool _containsNumber(String value) {
//     return RegExp(r'\d').hasMatch(value);
//   }

//   bool _containsUppercase(String value) {
//     return RegExp(r'[A-Z]').hasMatch(value);
//   }

//   bool _containsLowercase(String value) {
//     return RegExp(r'[a-z]').hasMatch(value);
//   }

//   bool _containsSpecialCharacter(String value) {
//     return RegExp(r'[!@#\$%^&*()_+{}\[\]:;<>,.?~\\/-]').hasMatch(value);
//   }

//   void showPasswordRequirementsDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Password Requirements'),
//           content: Text(
//             'Password must be at least 6 characters long and contain both numbers and alphabets.',
//           ),
//         );
//       },
//     );
//   }

//   void genericErrorMessage() {
//     // Check if the widget is still mounted before showing the dialog
//     if (mounted) {
//       showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(title: Text('Error'));
//         },
//       );
//     }
//   }

//   void passwordNoMatch() {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return const AlertDialog(title: Text('Password No Match'));
//         });
//   }

//   void _showInfoDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('About Create Account', style: TextStyle(fontSize: 18)),
//           content: Text(
//             'When you create an account on our platform, it undergoes a review process by our admin team to ensure security and compliance. After completing the initial steps, your account will be pending approval. Please be patient during this time. If approved, you\'ll receive an email notification allowing full access. If, unfortunately, your request is rejected, you will be notified, and your account won\'t be created. Thank you for your understanding as we work to maintain a secure environment for all users.',
//             style: TextStyle(fontSize: 14),
//             textAlign: TextAlign.justify,
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     double mobilescreenHeight = MediaQuery.of(context).size.height;
//     double formHeightPercentage = 0.60;

//     return Scaffold(
//       backgroundColor: Color.fromRGBO(148, 204, 236, 1.0),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(height: 45),
//             Text(
//               'SEGi Student Personal Management Portal',
//               style: TextStyle(
//                 fontFamily: 'Texturina',
//                 fontSize: 28.0,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 10),
//             Padding(
//               padding: const EdgeInsets.only(left: 10, right: 10),
//               child: Center(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     //Create Account Text
//                     Text(
//                       'Create Account',
//                       style: TextStyle(
//                         fontSize: 20,
//                         decoration: TextDecoration.underline,
//                       ),
//                     ),
//                     SizedBox(width: 150),
//                     //Question Icon
//                     GestureDetector(
//                       onTap: () {
//                         _showInfoDialog(context);
//                       },
//                       child: Padding(
//                         padding: EdgeInsets.only(left: 5),
//                         child: Image.asset(
//                           'images/Question Icon.png',
//                           width: 24,
//                           height: 24,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             //Form
//             Padding(
//               padding:
//                   EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
//               child: Container(
//                 height: mobilescreenHeight * formHeightPercentage,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   color: Colors.white,
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.only(top: 10, bottom: 10),
//                   child: SingleChildScrollView(
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         color: Colors.white,
//                       ),
//                       child: Padding(
//                         padding: EdgeInsets.only(left: 15, right: 15),
//                         child: Column(
//                           children: [
//                             createAccountTextfield(
//                                 controller: _studentIdController,
//                                 labelText: 'Student ID',
//                                 hintText: 'Student ID'),
//                             createAccountTextfield(
//                                 controller: _nameController,
//                                 labelText: 'Name',
//                                 hintText: 'Name'),
//                             createAccountTextfield(
//                                 controller: _personalEmailController,
//                                 labelText: 'Personal Email',
//                                 hintText: 'Personal Email'),
//                             createAccountTextfield(
//                                 controller: _phoneNumberController,
//                                 labelText: 'Phone Number',
//                                 hintText: 'Phone Number'),
//                             createAccountTextfield(
//                                 controller: _programmeController,
//                                 labelText: 'Programme',
//                                 hintText: 'Programme'),
//                             createAccountTextfield(
//                                 controller: _specializationController,
//                                 labelText: 'Specialization',
//                                 hintText: 'Specialization'),
//                             createAccountTextfield(
//                                 controller: _intakeController,
//                                 labelText: 'Intake',
//                                 hintText: 'Intake'),
//                             createAccountTextfield(
//                                 controller: _passwordController,
//                                 labelText: 'Password',
//                                 hintText: 'Password'),
//                             createAccountTextfield(
//                                 controller: _confirmPasswordController,
//                                 labelText: 'Confirm Password',
//                                 hintText: 'Confirm Password'),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             //Request to Create Account Button
//             GestureDetector(
//               onTap: createAccount,
//               child: Container(
//                 padding: const EdgeInsets.all(15),
//                 margin: EdgeInsets.symmetric(horizontal: 35),
//                 decoration: BoxDecoration(
//                   color: Color.fromARGB(255, 25, 50, 70),
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 child: const Center(
//                   child: Text(
//                     'Request to Create Account',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             //Navigate to login page
//             Padding(
//               padding: const EdgeInsets.only(top: 20, bottom: 20),
//               child: Center(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Already have account?',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         fontStyle: FontStyle.italic,
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: widget.onTap,
//                       child: Text(
//                         'Login Here',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           fontStyle: FontStyle.italic,
//                           decoration: TextDecoration.underline,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
