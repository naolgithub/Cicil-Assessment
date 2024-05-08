// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

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
//     navigateToHome(); // Navigate to Home Page if token is valid
//   }

//   void navigateToLogin() {
//     Future.delayed(const Duration(seconds: 2), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => LoginScreen()),
//       );
//     });
//   }

//   void navigateToHome() {
//     Future.delayed(const Duration(seconds: 2), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => HomeScreen()),
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
