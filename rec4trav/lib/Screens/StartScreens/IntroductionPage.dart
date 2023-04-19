// ignore_for_file: file_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:intro_screen_onboarding_flutter/introduction.dart';
import 'package:intro_screen_onboarding_flutter/introscreenonboarding.dart';
import 'package:rec4trav/models/Palette.dart';
import 'package:rec4trav/Screens/AuthPages/AuthPage.dart';

class IntroductionPage extends StatelessWidget {
  final List<Introduction> list = [
    Introduction(
      title: 'What Is Near By',
      subTitle:
          'Set radius on the map and see what enjoyable place to visit is close to you',
      imageUrl: 'assets/images/intro1.jpg',
    ),
    Introduction(
      title: 'Invite Friend',
      subTitle:
          'Invite your friend to visit interactive places better together ',
      imageUrl: 'assets/images/intro3.jpg',
    ),
    Introduction(
      title: 'Share Experience',
      subTitle: 'Share it to show your friends your own experience',
      imageUrl: 'assets/images/intro2.jpg',
    ),
    Introduction(
      title: 'Find Travelers',
      subTitle: 'Talk to people who like to travel like you',
      imageUrl: 'assets/images/intro4.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return IntroScreenOnboarding(
      skipTextStyle: const TextStyle(
        color: Palette.lightBlue,
        fontSize: 25,
      ),
      foregroundColor: Palette.lightBlue,
      backgroudColor: Palette.normalBlue,
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
