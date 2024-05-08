// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'borrower_home_page.dart'; // Import your BorrowerHomePage
// import 'lender_home_page.dart'; // Import your LenderHomePage
// import 'login_screen.dart'; // Import your LoginScreen

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     checkTokenStatus();
//   }

//   void checkTokenStatus() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String token = prefs.getString('token');

//     // Additional logic to check token validity can be added here
//     String userType = prefs.getString('userType');
//     if (userType == 'lender') {
//       navigateToLenderHome();
//     } else {
//       navigateToBorrowerHome();
//     }
//   }

//   void navigateToLogin() {
//     Future.delayed(const Duration(seconds: 2), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const LoginScreen()),
//       );
//     });
//   }

//   void navigateToLenderHome() {
//     Future.delayed(const Duration(seconds: 2), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => LenderHomePage()),
//       );
//     });
//   }

//   void navigateToBorrowerHome() {
//     Future.delayed(const Duration(seconds: 2), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => BorrowerHomePage()),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: CircularProgressIndicator(), // Display a loading indicator
//       ),
//     );
//   }
// }
