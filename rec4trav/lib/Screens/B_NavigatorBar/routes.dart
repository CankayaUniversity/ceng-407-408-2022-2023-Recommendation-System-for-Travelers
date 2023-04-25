import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'B_Nav_Pages/DiscoverPage.dart';
import 'B_Nav_Pages/MainHome.dart';
import 'B_Nav_Pages/PostPage.dart';
import 'B_Nav_Pages/ProfilePage.dart';

class Routes extends StatelessWidget {
  final int index;
  const Routes({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> pageList = [
      const MainHomePage(),
      const DiscoverPage(),
      const PostPage(),
      ProfilePage(
        uid: FirebaseAuth.instance.currentUser!.uid,
      ),
    ];
    return pageList[index];
  }
}
