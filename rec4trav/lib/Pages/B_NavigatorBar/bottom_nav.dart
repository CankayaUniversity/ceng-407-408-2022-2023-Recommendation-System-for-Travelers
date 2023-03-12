import 'package:flutter/material.dart';
import 'package:rec4trav/Models/colors.dart';

class BNavigator extends StatefulWidget {
  final Function currentIndex;
  const BNavigator({super.key, required this.currentIndex});

  @override
  BNavigatorState createState() => BNavigatorState();
}

class BNavigatorState extends State<BNavigator> {
  var pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Palette.color1,
      currentIndex: _currentIndex,
      onTap: (i) {
        setState(() {
          _currentIndex = i;
          widget.currentIndex(i);
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_sharp),
          label: 'Home',
          backgroundColor: Palette.color11,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search_rounded),
          label: 'Discover',
          backgroundColor: Palette.color11,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.post_add),
          label: 'Post',
          backgroundColor: Palette.color11,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_activity),
          label: 'Activity',
          backgroundColor: Palette.color11,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
          backgroundColor: Palette.color11,
        )
      ],
    );
  }
}
