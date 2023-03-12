import 'package:flutter/material.dart';
import '../Pages/AuthPages/auth.dart';
import '../Pages/B_NavigatorBar/Main_Page_Classes/MainPage.dart';
import '../Pages/StartScreens/IntroductionPage.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
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
