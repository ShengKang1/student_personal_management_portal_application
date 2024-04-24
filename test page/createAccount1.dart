// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:student_portal/components/create_account_dropdown.dart';
// import 'package:student_portal/components/create_account_textfield.dart';
// import 'package:student_portal/components/create_account_passwordtextfield.dart';
// import 'package:student_portal/components/dialog_ok.dart';
// import 'package:student_portal/components/my_button1.dart';
// import 'package:student_portal/pages/LoginOrRegister.dart';
// import 'package:student_portal/pages/auth_page.dart';
// import 'package:student_portal/pages/login.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class createAccount extends StatefulWidget {
//   final VoidCallback showLoginPage;
//   const createAccount({Key? key, required this.showLoginPage})
//       : super(key: key);
//   // const createAccount({super.key});

//   @override
//   _createAccountState createState() => _createAccountState();
// }

// class _createAccountState extends State<createAccount> {
//   @override
//   void setState(VoidCallback fn) {
//     if (mounted) {
//       super.setState(fn);
//     }
//   }

//   bool obscureText = true;
//   double mobilescreenHeight = 0;

// //Drop down meneu list
//   List<String> programme_dropdownItems = ['BIT'];
//   List<String> specialization_dropdownItems = [
//     'Software Engineering (SE)',
//     'Computer Networks (CN)',
//     'Business Systems Design (BSD)'
//   ];
//   List<String> intake_dropdownItems = [
//     'July 2021',
//     'September 2021',
//     'February 2022'
//   ];
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
//       barrierDismissible: false,
//       builder: (context) {
//         return const AlertDialog(
//           contentPadding: EdgeInsets.symmetric(vertical: 20),
//           content: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               CircularProgressIndicator(),
//               SizedBox(width: 20),
//               Text("Loading..."),
//             ],
//           ),
//         );
//       },
//     );
//     // Check if required fields are empty
//     if (_studentIdController.text.isEmpty ||
//         _nameController.text.isEmpty ||
//         _personalEmailController.text.isEmpty ||
//         _phoneNumberController.text.isEmpty ||
//         _programmeController.text.isEmpty ||
//         _specializationController.text.isEmpty ||
//         _intakeController.text.isEmpty ||
//         _passwordController.text.isEmpty ||
//         _confirmPasswordController.text.isEmpty) {
//       Navigator.pop(context); // Dismiss loading circle
//       showMissingInformationDialog();
//       return;
//     }

//     // Check if passwords match
//     if (_passwordController.text != _confirmPasswordController.text) {
//       Navigator.pop(context); // Dismiss loading circle
//       passwordNoMatch();
//       return;
//     }

//     // Check password length and presence of numbers and alphabets
//     if (_passwordController.text.length < 6 ||
//         !_containsUppercase(_passwordController.text) ||
//         !_containsLowercase(_passwordController.text) ||
//         !_containsNumber(_passwordController.text) ||
//         !_containsSpecialCharacter(_passwordController.text)) {
//       Navigator.pop(context); // Dismiss loading circle
//       showPasswordRequirementsDialog();
//       return;
//     }

//     if (!isValidPhoneNumber(_phoneNumberController.text)) {
//       Navigator.pop(context); // Dismiss loading circle
//       const Dialog_ok(
//               title: 'Phone number format is incorrect',
//               content: 'Please enter again your phone number.')
//           .show(context);
//       return;
//     }

//     try {
//       // Check if email already exists in the pending collection
//       QuerySnapshot pendingQuerySnapshot = await FirebaseFirestore.instance
//           .collection('pending')
//           .where('personal_email',
//               isEqualTo: _personalEmailController.text.trim())
//           .get();

//       if (pendingQuerySnapshot.docs.isNotEmpty) {
//         // Document with the provided email already exists in the pending collection
//         Navigator.pop(context); // Dismiss loading circle
//         showEmailAlreadyInPending();
//         return;
//       }
//     } catch (e) {
//       // print('Error checking or creating document: $e');
//       Navigator.pop(context); // Dismiss loading circle
//       genericErrorMessage(e.toString());
//       return;
//     }

//     // try {
//     //   await FirebaseAuth.instance.createUserWithEmailAndPassword(
//     //     email: _personalEmailController.text.trim(),
//     //     password: _passwordController.text.trim(),
//     //   );
//     // } on FirebaseAuthException catch (e) {
//     //   if (e.code == 'email-already-in-use') {
//     //     print('Email Already Inuse');
//     //     Navigator.pop(context);
//     //     showEmailAlreadyInuse();
//     //     return;
//     //   } else if (e.code == 'invalid-email') {
//     //     Navigator.pop(context);
//     //     showInvalidEmail();
//     //     return;
//     //   } else {
//     //     Navigator.pop(context);
//     //     genericErrorMessage(e.toString());
//     //     return;
//     //   }

//     //   // Navigator.pop(context);
//     // }

//     // try {
//     //   UserCredential userCredential = await FirebaseAuth.instance
//     //       .signInWithEmailAndPassword(
//     //           email: _personalEmailController.text.trim(),
//     //           password: _passwordController.text.trim());

//     //   //Delete User
//     //   await userCredential.user!.delete();
//     //   // print("User with email deleted successfully.");
//     // } on FirebaseAuthException catch (e) {
//     //   // print("Error deleting user: $e");
//     //   Navigator.pop(context);
//     //   genericErrorMessage(e.toString());
//     //   return;
//     // }

//     // Store additional user information in Cloud Firestore
//     String studentID = _studentIdController.text.trim().toUpperCase();
//     String studentName = _nameController.text.trim();
//     String personalEmail = _personalEmailController.text.trim().toLowerCase();
//     String phoneNumber = _phoneNumberController.text.trim();
//     String programme = _programmeController.text.trim();
//     String specialization = _specializationController.text.trim();
//     String intake = _intakeController.text.trim();
//     String password = _passwordController.text.trim();
//     DateTime now = DateTime.now();

//     try {
//       DocumentSnapshot pendingData = await FirebaseFirestore.instance
//           .collection('pending')
//           .doc(_studentIdController.text.trim())
//           .get();

//       if (pendingData.exists) {
//         // Document already exists, handle the error
//         // ignore: use_build_context_synchronously
//         Navigator.pop(context); // Dismiss loading circle
//         showIDInPending();
//         return;
//       }

//       DocumentSnapshot studentsData = await FirebaseFirestore.instance
//           .collection('students')
//           .doc(_studentIdController.text.trim())
//           .get();

//       if (studentsData.exists) {
//         // Document already exists, handle the error
//         // ignore: use_build_context_synchronously
//         Navigator.pop(context); // Dismiss loading circle
//         showIDAlreadyInuse();
//         return;
//       }

//       QuerySnapshot<
//           Map<String,
//               dynamic>> studentsSnapshot = await FirebaseFirestore.instance
//           .collection('students')
//           .where('personal_email',
//               isEqualTo: _personalEmailController.text.trim())
//           .limit(
//               1) // Limit to 1 document since you only need to check existence
//           .get();

//       if (studentsSnapshot.docs.isNotEmpty) {
//         // Document with the given email already exists, handle the error
//         Navigator.pop(context); // Dismiss loading circle
//         showEmailAlreadyInuse();
//         return;
//       }

//       QuerySnapshot<Map<String, dynamic>> adminSnapshot = await FirebaseFirestore
//           .instance
//           .collection('admin')
//           .where('personal_email',
//               isEqualTo: _personalEmailController.text.trim())
//           .limit(
//               1) // Limit to 1 document since you only need to check existence
//           .get();

//       if (adminSnapshot.docs.isNotEmpty) {
//         // Document with the given email already exists, handle the error
//         Navigator.pop(context); // Dismiss loading circle
//         showEmailAlreadyInuse();
//         return;
//       }

//       final pendingDB = FirebaseFirestore.instance;
//       final students = <String, dynamic>{
//         'student_id': studentID,
//         'student_name': studentName,
//         'personal_email': personalEmail,
//         'phone_number': phoneNumber,
//         'programme': programme,
//         'specialization': specialization,
//         'intake': intake,
//         'password': password,
//         'request_at': now,
//         'status': 'Pending Approve'
//       };

//       // Store user information in Firestore
//       await pendingDB
//           .collection('pending') //Collection
//           .doc(studentID) //Unique ID
//           .set(students); //Store data

//       // Dismiss loading circle
//       // ignore: use_build_context_synchronously
//       Navigator.pop(context);
//       // Successfully created account, now navigate to login page
//       showSuccessDialog();
//     } catch (e) {
//       // print('Error checking or creating document: $e');
//       // ignore: use_build_context_synchronously
//       Navigator.pop(context); // Dismiss loading circle
//       genericErrorMessage(e.toString());
//       return;
//     }
//   }

//   void showMissingInformationDialog() {
//     const Dialog_ok(
//             title: 'Missing Information',
//             content: 'Please fill in all the fields.')
//         .show(context);
//   }

//   void passwordNoMatch() {
//     const Dialog_ok(
//             title: 'Password No Match',
//             content:
//                 'Please ensure the password and confirm password field is same password.')
//         .show(context);
//   }

//   void showPasswordRequirementsDialog() {
//     const Dialog_ok(
//       title: 'Password Requirements',
//       content: '''
// ✔ Use lowercase and uppercase characters.
// ✔ Inclusion of at least one special character, e.g., !@#?
// ✔ Length of password should be at least 6 characters.
// ''',
//     ).show(context);
//   }

//   void showEmailAlreadyInuse() {
//     const Dialog_ok(
//             title: 'Email Already Inuse',
//             content: 'Please enter your email and password.')
//         .show(context);
//   }

//   void showIDAlreadyInuse() {
//     const Dialog_ok(
//             title: 'Student ID Already Inuse',
//             content: 'Please enter again your students id.')
//         .show(context);
//   }

//   void showEmailAlreadyInPending() {
//     const Dialog_ok(
//             title: 'Email Already Inuse',
//             content: 'Please enter again your email.')
//         .show(context);
//   }

//   void showIDInPending() {
//     const Dialog_ok(
//             title: 'Student ID in pending',
//             content: 'Please wait for admin approve, thank you.')
//         .show(context);
//   }

//   void showInvalidEmail() {
//     const Dialog_ok(
//             title: 'Email Invalid',
//             content: 'Please enter your email and password.')
//         .show(context);
//   }

//   void genericErrorMessage(String message) {
//     // Check if the widget is still mounted before showing the dialog

//     Dialog_ok(title: 'Error $message', content: 'Sorry, pease try again.')
//         .show(context);
//   }

//   void showSuccessDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(
//             'Account Creation Successful',
//             style: TextStyle(fontSize: mobilescreenHeight * 0.025),
//           ),
//           content: Text(
//             'Your account creation request has been submitted successfully. Please wait for admin approval. Thank you!',
//             style: TextStyle(fontSize: mobilescreenHeight * 0.018),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context); // Dismiss the success dialog
//                 navigateToLoginPage(); // Navigate to the login page
//               },
//               child: Text(
//                 'OK',
//                 style: TextStyle(fontSize: mobilescreenHeight * 0.018),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void navigateToLoginPage() {
//     // Navigator.push(
//     //   context,
//     //   MaterialPageRoute(
//     //     builder: (context) => const LoginPage(),
//     //   ),
//     // );
//     // Navigator.pushAndRemoveUntil(
//     //     context,
//     //     MaterialPageRoute(builder: (context) => const authPage()),
//     //     (route) => false);
//     Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => const LoginOrRegister()),
//         (route) => false);
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

//   bool isValidPhoneNumber(String phoneNumber) {
//     // Regular expression for a phone number format (10 digits)
//     RegExp regex = RegExp(r'^[0-9]+$');
//     return regex.hasMatch(phoneNumber);
//   }

//   void _showInfoDialog(BuildContext context) {
//     const Dialog_ok(
//             title: 'About Create Account',
//             content:
//                 'When you request to create an account, it needs to be approved by the admin before it becomes active. Thank you.')
//         .show(context);
//     // showDialog(
//     //   context: context,
//     //   builder: (BuildContext context) {
//     //     return AlertDialog(
//     //       title: Text('About Create Account',
//     //           style: TextStyle(fontSize: mobilescreenHeight * 0.025),),
//     //       content: Text(
//     //         // 'When you create an account on our platform, it undergoes a review process by our admin team to ensure security and compliance. After completing the initial steps, your account will be pending approval. Please be patient during this time. If approved, you\'ll receive an email notification allowing full access. If, unfortunately, your request is rejected, you will be notified, and your account won\'t be created. Thank you for your understanding as we work to maintain a secure environment for all users.'
//     //         "When you request to create an account, it needs to be approved by the admin before it becomes active. Thank you.",
//     //        style: TextStyle(fontSize: mobilescreenHeight * 0.018),
//     //         textAlign: TextAlign.justify,
//     //       ),
//     //       actions: [
//     //         TextButton(
//     //           onPressed: () {
//     //             Navigator.of(context).pop();
//     //           },
//     //           child: Text('OK', style: TextStyle(fontSize: mobilescreenHeight * 0.021),),
//     //         ),
//     //       ],
//     //     );
//     //   },
//     // );
//   }

//   @override
//   Widget build(BuildContext context) {
//     mobilescreenHeight = MediaQuery.of(context).size.height;
//     // double formHeightPercentage = 0.60;

//     return Scaffold(
//       appBar: AppBar(
//           title: Row(
//         children: [
//           Expanded(
//               child: Text(
//             "Create Account",
//             style: TextStyle(fontSize: mobilescreenHeight * 0.028),
//           )),
//           GestureDetector(
//             onTap: () {
//               _showInfoDialog(context);
//             },
//             child: Image.asset(
//               'images/Question Icon.png',
//               width: mobilescreenHeight * 0.030,
//               height: mobilescreenHeight * 0.030,
//             ),
//           ),
//         ],
//       )),
//       // backgroundColor: Color.fromRGBO(148, 204, 236, 1.0),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             //Form
//             Padding(
//               padding: EdgeInsets.symmetric(
//                   vertical: mobilescreenHeight * 0.015,
//                   horizontal: mobilescreenHeight * 0.015),
//               child: Container(
//                 // height: mobilescreenHeight * formHeightPercentage,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   color: Colors.white,
//                 ),
//                 child: Padding(
//                   padding:
//                       EdgeInsets.symmetric(vertical: mobilescreenHeight * 0.02),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       color: Colors.white,
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: mobilescreenHeight * 0.02),
//                       child: Column(
//                         children: [
//                           createAccountTextfield(
//                               controller: _studentIdController,
//                               labelText: 'Student ID (e.g., SUKD0000000)',
//                               hintText: 'Student ID'),
//                           createAccountTextfield(
//                               controller: _nameController,
//                               labelText: 'Name',
//                               hintText: 'Name'),
//                           createAccountTextfield(
//                               controller: _personalEmailController,
//                               labelText: 'Student Email',
//                               hintText: 'Student Email'),
//                           createAccountTextfield(
//                               controller: _phoneNumberController,
//                               labelText: 'Phone Number (e.g., 0123456789)',
//                               hintText: 'Phone Number'),
//                           CreateAccountDropdown(
//                             labelText: 'Programme',
//                             hintText:
//                                 'Choose from the list', // Hint text for the dropdown
//                             controller: _programmeController,
//                             dropdownItems: programme_dropdownItems,
//                           ),
//                           CreateAccountDropdown(
//                             labelText: 'Specialization',
//                             hintText:
//                                 'Choose from the list', // Hint text for the dropdown
//                             controller: _specializationController,
//                             dropdownItems: specialization_dropdownItems,
//                           ),
//                           CreateAccountDropdown(
//                             labelText: 'Intake',
//                             hintText:
//                                 'Choose from the list', // Hint text for the dropdown
//                             controller: _intakeController,
//                             dropdownItems: intake_dropdownItems,
//                           ),
//                           createAccountPasswordTextfield(
//                             controller: _passwordController,
//                             labelText: 'Password',
//                             hintText: 'Password',
//                             obscureText: true,
//                             onPressed: (bool isObscured) {
//                               setState(() {
//                                 obscureText = isObscured;
//                               });
//                             },
//                           ),
//                           createAccountPasswordTextfield(
//                             controller: _confirmPasswordController,
//                             labelText: 'Confirm Password',
//                             hintText: 'Confirm Password',
//                             obscureText: true,
//                             onPressed: (bool isObscured) {
//                               setState(() {
//                                 obscureText = isObscured;
//                               });
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             //Request to Create Account Button
//             // GestureDetector(
//             //   onTap: createAccount,
//             //   child: Container(
//             //     padding: const EdgeInsets.all(15),
//             //     margin: const EdgeInsets.symmetric(horizontal: 35),
//             //     decoration: BoxDecoration(
//             //       color: Color.fromARGB(255, 25, 50, 70),
//             //       borderRadius: BorderRadius.circular(30),
//             //     ),
//             //     child: const Center(
//             //       child: Text(
//             //         'Request to Create Account',
//             //         style: TextStyle(
//             //           color: Colors.white,
//             //           fontWeight: FontWeight.bold,
//             //           fontSize: 16,
//             //         ),
//             //       ),
//             //     ),
//             //   ),
//             // ),

//             Padding(
//               padding:
//                   EdgeInsets.symmetric(vertical: mobilescreenHeight * 0.01),
//               child: my_button1(
//                 onTap: createAccount,
//                 buttonName: "Request to Create Account",
//               ),
//             ),

//             //Navigate to login page
//             Padding(
//               padding:
//                   EdgeInsets.symmetric(vertical: mobilescreenHeight * 0.025),
//               child: Center(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Already have account?',
//                       style: TextStyle(
//                         fontSize: mobilescreenHeight * 0.021,
//                         fontWeight: FontWeight.bold,
//                         fontStyle: FontStyle.italic,
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: widget.showLoginPage,
//                       child: Text(
//                         'Login Here',
//                         style: TextStyle(
//                           color: Colors.blue,
//                           fontSize: mobilescreenHeight * 0.021,
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
