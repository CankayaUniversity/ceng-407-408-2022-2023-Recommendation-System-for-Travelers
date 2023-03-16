// ignore_for_file: file_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:intro_screen_onboarding_flutter/introduction.dart';
import 'package:intro_screen_onboarding_flutter/introscreenonboarding.dart';
import 'package:rec4trav/Models/Palette.dart';
import 'package:rec4trav/Screens/AuthPages/AuthPage.dart';

class IntroductionPage extends StatelessWidget {
  final List<Introduction> list = [
    Introduction(
      title: 'Buy & Sell',
      subTitle: 'Browse the menu and order directly from the application',
      imageUrl: 'assets/images/intro1.jpg',
    ),
    Introduction(
      title: 'Delivery',
      subTitle: 'Your order will be immediately collected and',
      imageUrl: 'assets/images/intro2.jpg',
    ),
    Introduction(
      title: 'Receive Money',
      subTitle: 'Pick up delivery at your door and enjoy groceries',
      imageUrl: 'assets/images/intro3.jpg',
    ),
    Introduction(
      title: 'Finish',
      subTitle: 'Browse the menu and order directly from the application',
      imageUrl: 'assets/images/intro4.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return IntroScreenOnboarding(
      skipTextStyle: const TextStyle(
        color: Palette.color11,
        fontSize: 20,
      ),
      foregroundColor: Palette.color11,
      backgroudColor: Palette.color41,
      introductionList: list,
      onTapSkipButton: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AuthPage(),
          ),
        );
      },
    );
  }
}
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   String? errorMessage = '';
//   bool isLogin = true;

//   final TextEditingController _controllerEmail = TextEditingController();
//   final TextEditingController _controllerPassword = TextEditingController();
//   final TextEditingController _controllerUsername = TextEditingController();
//   final TextEditingController _controllerFullname = TextEditingController();
//   final TextEditingController _controllerImage = TextEditingController();

//   Future<void> signInWithEmailAndPassword() async {
//     try {
//       await Auth().signInWithEmailAndPassword(
//           email: _controllerEmail.text, password: _controllerPassword.text);
//       // ignore: use_build_context_synchronously
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => MainPage()),
//       );
//     } on FirebaseAuthException catch (e) {
//       setState(() {
//         errorMessage = e.message;
//       });
//     }
//   }

//   Future<void> createUserWithEmailAndPassword() async {
//     try {
//       await Auth().createUserWithEmailAndPassword(
//           email: _controllerEmail.text, password: _controllerPassword.text);
//     } on FirebaseAuthException catch (e) {
//       setState(() {
//         errorMessage = e.message;
//       });
//     }
//   }

//   Widget _title() {
//     return Center(child: const Text("Firebase Auth"));
//   }

//   Widget _submitButton() {
//     return ElevatedButton(
//       onPressed:
//           isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
//       child: Text(isLogin ? 'Login' : 'Register'),
//     );
//   }

//   Widget _loginOrRegisterButton() {
//     return TextButton(
//         onPressed: () {
//           setState(() {
//             isLogin = !isLogin;
//             if (isLogin) {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => MainPage()),
//               );
//             }
//           });
//         },
//         child: Text(isLogin ? 'Register instead' : 'Login instead'));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: _title(),
//         backgroundColor: Palette.appBarColor,
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(100),
//           child: Column(
//             children: [
//               SizedBox(
//                 width: 100,
//                 height: 100,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                       backgroundColor: Palette.baseColor,
//                       alignment: Alignment.center),
//                   onPressed: () {
//                     Get.offAll(const AuthPage());
//                   },
//                   child: const Text(
//                     'Login',
//                     style: TextStyle(
//                         color: Colors.black26, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 50,
//               ),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                     backgroundColor: Palette.baseColor,
//                     alignment: Alignment.center),
//                 onPressed: () {
//                   Get.offAll(const AuthPage());
//                 },
//                 child: const Text(
//                   'Register',
//                   style: TextStyle(
//                       color: Colors.black26, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class TestScreen extends StatelessWidget {
//   final List<Introduction> list = [
//     Introduction(
//       title: 'Buy & Sell',
//       subTitle: 'Browse the menu and order directly from the application',
//       imageUrl: 'assets/images/onboarding3.png',
//     ),
//     Introduction(
//       title: 'Delivery',
//       subTitle: 'Your order will be immediately collected and',
//       imageUrl: 'assets/images/onboarding4.png',
//     ),
//     Introduction(
//       title: 'Receive Money',
//       subTitle: 'Pick up delivery at your door and enjoy groceries',
//       imageUrl: 'assets/images/onboarding5.png',
//     ),
//     Introduction(
//       title: 'Finish',
//       subTitle: 'Browse the menu and order directly from the application',
//       imageUrl: 'assets/images/onboarding3.png',
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return IntroScreenOnboarding(
//       introductionList: list,
//       onTapSkipButton: () {
//         Get.offAll(MainPage());
//       },
//     );
//   }
// }
