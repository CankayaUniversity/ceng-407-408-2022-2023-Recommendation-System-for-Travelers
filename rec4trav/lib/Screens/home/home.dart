import 'package:flutter/material.dart';

import '../../components/app_bar.dart';
import '../../components/bottom_nav_bar.dart';
import '../../components/hamburger_menu.dart';
import '../../components/user_avatar.dart';
import 'components/places_categoris.dart';
import 'components/popular_places.dart';
import 'components/recommended.dart';
import 'components/recommended_places.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            PlacesCategories(),
            PopularPlaces(),
            Recommended(),
            RecommendedPlaces()
          ],
        ),
      ),
    );
  }
}
