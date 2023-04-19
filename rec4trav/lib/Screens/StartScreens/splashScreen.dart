// ignore: duplicate_ignore
// ignore: file_names

// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:rec4trav/Screens/StartScreens/IntroductionPage.dart';
import '../../models/Palette.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      loadingTextPadding: EdgeInsets.all(10),
      loaderColor: Colors.white,
      logoWidth: MediaQuery.of(context).size.width * 0.4,
      logo: Image.asset(
        'assets/Rec4TravBcPng.png',
      ),
      backgroundColor: Palette.normalBlue,
      showLoader: true,
      loadingText: const Text(
        "Loading...",
        style: TextStyle(
          fontFamily: 'Muller',
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      navigator: IntroductionPage(),
      durationInSeconds: 5,
    );
  }
}
