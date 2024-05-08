import 'dart:convert';

import 'package:cicil_demo/borrower_home_page.dart';
import 'package:cicil_demo/lender_home_page.dart';
import 'package:cicil_demo/signuppp.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  static String verify = "";
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  var phone = "";
  var phoneCode = "";

  final TextEditingController phoneController = TextEditingController();
  // Country selectedCountry = Country(
  //   phoneCode: "91",
  //   countryCode: "IN",
  //   e164Sc: 0,
  //   geographic: true,
  //   level: 1,
  //   name: "India",
  //   example: "India",
  //   displayName: "India",
  //   displayNameNoCountryCode: "IN",
  //   e164Key: "",
  // );
  Country selectedCountry = Country(
    phoneCode: "62",
    countryCode: "ID",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "Indonesia",
    example: "Indonesia",
    displayName: "Indonesia",
    displayNameNoCountryCode: "ID",
    e164Key: "",
  );
  bool passToggle = true;
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLender = false;
  String _errorMessage = '';
  late String userType;
  bool phoneTextFieldFilled = false;
  bool passwordTextFieldFilled = false;
  bool isButtonEnabled = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await http.post(
          // Uri.parse('https://your-api-endpoint.com/login'),
          Uri.parse(
              'https://sapi.cicil.biz.id:8443/kancil/user/auth/apis/v2/user/login'),
          headers: {
            'authorization':
                'Basic YmFjay1vZmZpY2UtaW50ZXJuYWw6Smt0dzNYSDBHRW9ZQzlyWmtWSzE=',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'PhoneNumber': _phoneController.text,
            'Password': _passwordController.text,
            'Type': _isLender ? 'borrower' : 'lender',
          }),
        );

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          final token = responseData['data']['token'];
          final userTypeId = responseData['data']['userTypeId'];
          print(token);
          print(userTypeId);
          // Save the token to shared preferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          if (userTypeId == 2 || userTypeId == 3) {
            await prefs.setString('userType', 'lender');
          }
          if (userTypeId == 1 || userTypeId == 4) {
            await prefs.setString('userType', 'borrower');
          }

          // Navigate to the appropriate home page based on user type

          if (_isLender) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const BorrowerHomePage()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LenderHomePage()),
            );
          }
        } else {
          final responseData = json.decode(response.body);
          setState(() {
            _errorMessage = responseData['data']['error_description'];
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'An error occurred. Please try again later.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 249, 253, 1),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SvgPicture.asset(
                  'assets/Cicil_Logo.svg',
                  width: 100,
                  height: 60,
                  alignment: Alignment.center,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Material(
                    color: const Color.fromRGBO(255, 255, 255, 1),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            'assets/Login_Illustration.svg',
                            // width: 100,
                            // height: 100,
                            alignment: Alignment.center,
                          ),
                        ),
                        const SizedBox(height: 5),
                        // const Padding(
                        //   padding:
                        //       EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                        //   child: TextField(
                        //     decoration: InputDecoration(
                        //       labelText: "Phone Number",
                        //       border: OutlineInputBorder(),
                        //       prefixIcon: Icon(Icons.phone),
                        //     ),
                        //   ),
                        // ),
                        const Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Nomor Ponsel'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 15,
                          ),
                          child: TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            onChanged: (value) {
                              // setState(() {
                              //   phoneController.text = value;
                              // });
                              phone = value;
                              if (value != "") {
                                phoneTextFieldFilled = true;
                                if (phoneTextFieldFilled &&
                                    passwordTextFieldFilled) {
                                  setState(() {
                                    isButtonEnabled = true;
                                  });
                                }
                              } else {
                                phoneTextFieldFilled = false;
                                setState(() {
                                  isButtonEnabled = false;
                                });
                              }
                            },
                            validator: (value) {
                              if (value!.isEmpty ||
                                  value.length < 8 ||
                                  value.length > 14 ||
                                  !RegExp(r'^\d+$').hasMatch(value)) {
                                return 'Please enter a valid Indonesian phone number.';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Masukkan nomor ponsel",
                              labelText: "Masukkan nomor ponsel",
                              errorText: _errorMessage.contains('phone')
                                  ? _errorMessage
                                  : null,
                              border: const OutlineInputBorder(),
                              prefixIcon: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    showCountryPicker(
                                      context: context,
                                      countryListTheme:
                                          const CountryListThemeData(
                                        bottomSheetHeight: 550,
                                      ),
                                      onSelect: (value) {
                                        setState(() {
                                          selectedCountry = value;
                                          phoneCode = selectedCountry.phoneCode;
                                        });
                                      },
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 4.5),
                                    child: Text(
                                      "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              suffixIcon: phoneController.text.length > 9
                                  ? Container(
                                      height: 30,
                                      width: 30,
                                      margin: const EdgeInsets.all(10.0),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.green,
                                      ),
                                      child: const Icon(
                                        Icons.done,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Kata Sandi'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: passToggle ? true : false,
                            validator: (value) {
                              if (value!.isEmpty ||
                                  value.length < 8 ||
                                  !RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)')
                                      .hasMatch(value)) {
                                return 'Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one number.';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              if (value != "") {
                                passwordTextFieldFilled = true;
                                if (passwordTextFieldFilled &&
                                    phoneTextFieldFilled) {
                                  setState(() {
                                    isButtonEnabled = true;
                                  });
                                }
                              } else {
                                passwordTextFieldFilled = false;
                                setState(() {
                                  isButtonEnabled = false;
                                });
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Masukkan kata sandi',
                              border: const OutlineInputBorder(),
                              // label: const Text("Enter Password"),
                              errorText: _errorMessage.contains('kata sandi')
                                  ? _errorMessage
                                  : null,
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: InkWell(
                                onTap: () {
                                  if (passToggle == true) {
                                    passToggle = false;
                                  } else {
                                    passToggle = true;
                                  }
                                  setState(() {});
                                },
                                child: passToggle
                                    ? const Icon(CupertinoIcons.eye_slash_fill)
                                    : const Icon(CupertinoIcons.eye_fill),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Row(
                            children: [
                              // const Text('Login as:'),
                              // const SizedBox(width: 8.0),
                              Switch(
                                dragStartBehavior: DragStartBehavior.down,
                                value: _isLender,
                                activeColor: Colors.orange,
                                onChanged: (value) {
                                  setState(() {
                                    _isLender = value;
                                  });
                                },
                              ),
                              const SizedBox(width: 8.0),
                              Text(_isLender ? 'Borrower' : 'Lender'),
                            ],
                          ),
                        ),
                        const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Lupa Kata Sandi',
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: GestureDetector(
                            onTap: () async {
                              _login();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              width: 350,
                              decoration: BoxDecoration(
                                color: !isButtonEnabled
                                    ? const Color.fromRGBO(207, 213, 223, 1)
                                    : Colors.orange,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  "Masuk",
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Belum punya akun?",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SignUpScreen(),
                                    ));
                              },
                              child: const Text(
                                "Register",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Column(
                  children: [
                    const Text(
                        'Cicil aman serta sudah berizin dan digwasi oleh'),
                    const Text(
                      'Otoritas Jasa Keuangan',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: Image.asset(
                                'assets/iso-270012013-standard-certified-information-security-management-iso-27001-sign-eps-10-2A26MF3.jpg'),
                          ),
                        ),
                        const SizedBox(
                          width: 60,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 80),
                          child: SvgPicture.asset(
                            'assets/AFPI-Logo.svg',
                            width: 40,
                            height: 40,
                          ),
                        )
                      ],
                    )
                  ],
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: SvgPicture.asset(
                //     'assets/Login_Illustration.svg',
                //     // width: 100,
                //     // height: 100,
                //     alignment: Alignment.center,
                //   ),
                // ),
                // const SizedBox(height: 15),
                // const Padding(
                //   padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                //   child: TextField(
                //     decoration: InputDecoration(
                //       labelText: "Phone Number",
                //       border: OutlineInputBorder(),
                //       prefixIcon: Icon(Icons.phone),
                //     ),
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(12),
                //   child: TextField(
                //     obscureText: passToggle ? true : false,
                //     decoration: InputDecoration(
                //       border: const OutlineInputBorder(),
                //       //label: const Text("Enter Password"),
                //       prefixIcon: const Icon(Icons.lock),
                //       suffixIcon: InkWell(
                //         onTap: () {
                //           if (passToggle == true) {
                //             passToggle = false;
                //           } else {
                //             passToggle = true;
                //           }
                //           setState(() {});
                //         },
                //         child: passToggle
                //             ? const Icon(CupertinoIcons.eye_slash_fill)
                //             : const Icon(CupertinoIcons.eye_fill),
                //       ),
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 20),
                // InkWell(
                //   onTap: () {},
                //   child: Container(
                //     padding: const EdgeInsets.symmetric(vertical: 15),
                //     width: 350,
                //     decoration: BoxDecoration(
                //       color: const Color(0xFF7165D6),
                //       borderRadius: BorderRadius.circular(10),
                //       boxShadow: const [
                //         BoxShadow(
                //           color: Colors.black12,
                //           blurRadius: 4,
                //           spreadRadius: 2,
                //         ),
                //       ],
                //     ),
                //     child: const Center(
                //       child: Text(
                //         "Create Account",
                //         style: TextStyle(
                //           fontSize: 22,
                //           color: Colors.white,
                //           fontWeight: FontWeight.w600,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 10),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     const Text(
                //       "Already have account?",
                //       style: TextStyle(
                //         fontSize: 16,
                //         fontWeight: FontWeight.w500,
                //       ),
                //     ),
                //     TextButton(
                //       onPressed: () {
                //         // Navigator.push(
                //         //     context,
                //         //     MaterialPageRoute(
                //         //       builder: (context) => SignInScreen(),
                //         //     ));
                //       },
                //       child: const Text(
                //         "Log In",
                //         style: TextStyle(
                //           fontSize: 18,
                //           fontWeight: FontWeight.bold,
                //           color: Color(0xFF7165D6),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class LenderHomePage extends StatefulWidget {
//   const LenderHomePage({super.key});

//   @override
//   _LenderHomePageState createState() => _LenderHomePageState();
// }

// class _LenderHomePageState extends State<LenderHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
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
//       MaterialPageRoute(builder: (context) => const SignInScreen()),
//     );
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const SignInScreen()),
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
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const SignInScreen()),
//     );
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const SignInScreen()),
//     );
//   }


// }
