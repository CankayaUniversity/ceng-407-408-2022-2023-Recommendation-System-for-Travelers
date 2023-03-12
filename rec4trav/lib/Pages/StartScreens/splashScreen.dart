// ignore: duplicate_ignore
// ignore: file_names

// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:rec4trav/Pages/AuthPages/AuthPage.dart';
import '../../Models/colors.dart';

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
      logo: Image.asset(
        'assets/Rec4TravBcPng.png',
        width: 700,
        height: 1500,
      ),
      backgroundColor: Palette.color11,
      showLoader: true,
      loadingText: const Text("Loading..."),
      navigator: AuthPage(),
      durationInSeconds: 5,
    );
  }
}
