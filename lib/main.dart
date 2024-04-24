import "dart:io";
import 'package:flutter/material.dart';
import 'package:student_portal/pages/Profile.dart';
import 'package:student_portal/pages/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:student_portal/pages/create_account.dart';
import 'package:student_portal/pages/login.dart';

// import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyBaj-KkcAm01wD7Gm7cHyHM71QLw74l6js",
              appId: "1:696060256689:android:cdb86f991ab34f722edd90",
              messagingSenderId: "696060256689",
              projectId: "student-portal-2d8f1"))
      : await Firebase.initializeApp();

  // Make Application cannot be rotation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    double mobilescreenHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blue[200], // Set your desired color here
            toolbarHeight: mobilescreenHeight * 0.07,
          ),
          // primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color.fromRGBO(190, 221, 235, 1),
        ),
        // initialRoute: '/',
        // routes: {
        //   // '/': (context) => HomeScreen(), // Define your home route
        //   '/profile': (context) => ProfilePage(),
        // },
        home: const authPage());
  }
}

// import "dart:io";
// import 'dart:async';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:student_portal/pages/auth_page.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/services.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';

// // import 'firebase_options.dart';

// Future main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   Platform.isAndroid
//       ? await Firebase.initializeApp(
//           options: const FirebaseOptions(
//               apiKey: "AIzaSyBaj-KkcAm01wD7Gm7cHyHM71QLw74l6js",
//               appId: "1:696060256689:android:cdb86f991ab34f722edd90",
//               messagingSenderId: "696060256689",
//               projectId: "student-portal-2d8f1"))
//       : await Firebase.initializeApp();

//   // Make Application cannot be rotation
//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     double mobilescreenHeight = MediaQuery.of(context).size.height;
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         appBarTheme: AppBarTheme(
//           backgroundColor: Colors.blue[200], // Set your desired color here
//           toolbarHeight: mobilescreenHeight * 0.07,
//         ),
//         // primarySwatch: Colors.blue,
//         scaffoldBackgroundColor: const Color.fromRGBO(190, 221, 235, 1),
//       ),
//       // initialRoute: '/',
//       // routes: {
//       //   '/createaccount': (context) => const createAccount(),
//       //   '/login': (context) => const LoginPage(),
//       // },
//       home: const HomePage(),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late StreamSubscription subscription;
//   bool isDeviceConnected = false;
//   bool isAlertSet = false;

//   @override
//   void initState() {
//     getConnectivity();
//     super.initState();
//   }

//   getConnectivity() =>
//       subscription = Connectivity().onConnectivityChanged.listen(
//         (ConnectivityResult result) async {
//           isDeviceConnected = await InternetConnectionChecker().hasConnection;
//           if (!isDeviceConnected && isAlertSet == false) {
//             showDialogBox();
//             setState(() => isAlertSet = true);
//           }
//         },
//       );

//   @override
//   void dispose() {
//     subscription.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double mobilescreenHeight = MediaQuery.of(context).size.height;
//     return const Scaffold(body: authPage());
//   }

//   showDialogBox() => showCupertinoDialog<String>(
//         context: context,
//         builder: (BuildContext context) => CupertinoAlertDialog(
//           title: const Text('No Connection'),
//           content: const Text('Please check your internet connectivity'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () async {
//                 Navigator.pop(context, 'Cancel');
//                 setState(() => isAlertSet = false);
//                 isDeviceConnected =
//                     await InternetConnectionChecker().hasConnection;
//                 if (!isDeviceConnected && isAlertSet == false) {
//                   showDialogBox();
//                   setState(() => isAlertSet = true);
//                 }
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
// }
