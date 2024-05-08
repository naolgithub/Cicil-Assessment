import 'dart:convert';

import 'package:cicil_demo/borrower_home_page.dart';
import 'package:cicil_demo/home/home.dart';
import 'package:cicil_demo/lender_home_page.dart';
import 'package:cicil_demo/signinn.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      // home: SignUpScreen(),
      // home: SignInScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool hasInternet = false;
  @override
  void initState() {
    super.initState();

    checkInternetConnection();
    checkTokenStatus();
  }

  Future<void> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        hasInternet = false;
      });
    } else {
      setState(() {
        hasInternet = true;
      });
    }
  }

  void checkTokenStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    // Additional logic to check token validity can be added here
    String? userType = prefs.getString('userType');
    print(userType);
    print(token);
    if (token != null && userType == 'lender' && hasInternet) {
      navigateToLenderHome();
    } else if (token != null && userType == 'borrower' && hasInternet) {
      navigateToBorrowerHome();
    } else {
      navigateToLogin();
    }
  }

  void navigateToLogin() {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
      );
    });
  }

  void navigateToLenderHome() {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LenderHomePage()),
      );
    });
  }

  void navigateToBorrowerHome() {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BorrowerHomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(218, 236, 242, 1),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 250,
          left: 100,
          right: 100,
        ),
        child: Column(
          children: [
            SvgPicture.asset(
              'assets/Cicil_Logo.svg',
              // semanticsLabel: 'My SVG Image',
              height: 200,
              width: 200,
            ),
            const SizedBox(
              height: 250,
            ),
            const CircularProgressIndicator(
              strokeWidth: 5,
              color: Color.fromARGB(255, 194, 176, 13),
            ),
          ],
        ),
      ),
    );
  }
}

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _phoneController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _isLender = false;
//   String _errorMessage = '';
//   late String userType;

//   @override
//   void dispose() {
//     _phoneController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   void _login() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         final response = await http.post(
//           // Uri.parse('https://your-api-endpoint.com/login'),
//           Uri.parse(
//               'https://sapi.cicil.biz.id:8443/kancil/user/auth/apis/v2/user/login'),
//           headers: {
//             'authorization':
//                 'Basic YmFjay1vZmZpY2UtaW50ZXJuYWw6Smt0dzNYSDBHRW9ZQzlyWmtWSzE=',
//             'Content-Type': 'application/json',
//           },
//           body: jsonEncode({
//             'PhoneNumber': _phoneController.text,
//             'Password': _passwordController.text,
//             'Type': _isLender ? 'lender' : 'borrower',
//           }),
//         );

//         if (response.statusCode == 200) {
//           final responseData = json.decode(response.body);
//           final token = responseData['data']['token'];
//           final userTypeId = responseData['data']['userTypeId'];
//           print(token);
//           print(userTypeId);
//           // Save the token to shared preferences
//           final prefs = await SharedPreferences.getInstance();
//           await prefs.setString('token', token);
//           if (userTypeId == 2 || userTypeId == 3) {
//             await prefs.setString('userType', 'lender');
//           }
//           if (userTypeId == 1 || userTypeId == 4) {
//             await prefs.setString('userType', 'borrower');
//           }

//           // Navigate to the appropriate home page based on user type

//           if (_isLender) {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => const LenderHomePage()),
//             );
//           } else {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => const BorrowerHomePage()),
//             );
//           }
//         } else {
//           final data = json.decode(response.body);
//           setState(() {
//             _errorMessage = data['error_description'];
//           });
//         }
//       } catch (e) {
//         setState(() {
//           _errorMessage = 'An error occurred. Please try again later.';
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Login')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFormField(
//                 controller: _phoneController,
//                 keyboardType: TextInputType.phone,
//                 decoration: InputDecoration(
//                   labelText: 'Phone Number',
//                   errorText:
//                       _errorMessage.contains('phone') ? _errorMessage : null,
//                 ),
//                 validator: (value) {
//                   if (value!.isEmpty ||
//                       value.length < 8 ||
//                       value.length > 14 ||
//                       !RegExp(r'^\d+$').hasMatch(value)) {
//                     return 'Please enter a valid Indonesian phone number.';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16.0),
//               TextFormField(
//                 controller: _passwordController,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   errorText: _errorMessage.contains('kata sandi')
//                       ? _errorMessage
//                       : null,
//                 ),
//                 validator: (value) {
//                   if (value!.isEmpty ||
//                       value.length < 8 ||
//                       !RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)')
//                           .hasMatch(value)) {
//                     return 'Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one number.';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16.0),
//               Row(
//                 children: [
//                   // const Text('Login as:'),
//                   // const SizedBox(width: 8.0),
//                   Switch(
//                     value: _isLender,
//                     onChanged: (value) {
//                       setState(() {
//                         _isLender = value;
//                       });
//                     },
//                   ),
//                   const SizedBox(width: 8.0),
//                   Text(_isLender ? 'Lender' : 'Borrower'),
//                 ],
//               ),
//               const SizedBox(height: 16.0),
//               ElevatedButton(
//                 onPressed: () async {
//                   _login();
//                 },
//                 child: const Text('Login'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class LenderHomePage extends StatefulWidget {
//   const LenderHomePage({super.key});

//   @override
//   _LenderHomePageState createState() => _LenderHomePageState();
// }

// class _LenderHomePageState extends State<LenderHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Lender Home'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: _logout,
//           ),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'Welcome Lender!',
//               style: TextStyle(
//                 fontSize: 24.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: _showLogoutConfirmation,
//               child: const Text('Logout'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showLogoutConfirmation() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Logout'),
//           content: const Text('Are you sure you want to logout?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: _logout,
//               child: const Text('Logout'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // void _logout() async {
//   //   // Remove the token from shared preferences
//   //   final prefs = await SharedPreferences.getInstance();
//   //   await prefs.remove('token');

//   //   // Navigate back to the login screen
//   //   Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
//   // }
//   Future<void> _logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('token');
//     await prefs.remove('userType');
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const LoginScreen()),
//     );
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const LoginScreen()),
//     );
//   }
// }

// class BorrowerHomePage extends StatefulWidget {
//   const BorrowerHomePage({super.key});

//   @override
//   _BorrowerHomePageState createState() => _BorrowerHomePageState();
// }

// class _BorrowerHomePageState extends State<BorrowerHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Borrower Home'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: _logout,
//           ),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'Welcome Borrower!',
//               style: TextStyle(
//                 fontSize: 24.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: _showLogoutConfirmation,
//               child: const Text('Logout'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showLogoutConfirmation() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Logout'),
//           content: const Text('Are you sure you want to logout?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: _logout,
//               child: const Text('Logout'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // void _logout() async {
//   //   // Remove the token from shared preferences
//   //   final prefs = await SharedPreferences.getInstance();
//   //   await prefs.remove('token');

//   //   // Navigate back to the login screen
//   //   Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
//   // }
//   Future<void> _logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('token');
//     await prefs.remove('userType');
//     // Navigator.pushReplacement(
//     //   context,
//     //   MaterialPageRoute(builder: (context) => const LoginScreen()),
//     // );
//     Navigator.pop(context);
//   }
// }
