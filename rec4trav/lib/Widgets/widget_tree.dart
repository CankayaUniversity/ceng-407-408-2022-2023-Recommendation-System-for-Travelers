import 'package:flutter/material.dart';
import 'package:rec4trav/Screens/StartScreens/splashScreen.dart';
import 'package:rec4trav/resources/auth_methods.dart';
import '../Screens/AuthPages/AuthPage.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthMethods().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return AuthPage();
        } else {
          return const SplashPage();
        }
      },
    );
  }
}
