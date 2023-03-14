import 'package:flutter/material.dart';
import 'package:rec4trav/resources/auth_methods.dart';
import '../Screens/B_NavigatorBar/MainPage.dart';
import '../Screens/StartScreens/IntroductionPage.dart';

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
          return MainPage();
        } else {
          return IntroductionPage();
        }
      },
    );
  }
}
