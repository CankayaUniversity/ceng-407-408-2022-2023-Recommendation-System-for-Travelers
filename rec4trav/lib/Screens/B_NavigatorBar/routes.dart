import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Pages/ActivityPage.dart';
import 'Pages/DiscoverPage.dart';
import 'Pages/MainHome.dart';
import 'Pages/PostPage.dart';
import 'Pages/ProfilePage.dart';

class Routes extends StatelessWidget {
  final int index;
  const Routes({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> pageList = [
      MainHomePage(),
      DiscoverPage(),
      const PostPage(),
      ActivityPage(),
      ProfilePage(
        uid: FirebaseAuth.instance.currentUser!.uid,
      ),
    ];
    return pageList[index];
  }
}
