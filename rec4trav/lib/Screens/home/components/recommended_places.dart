import 'package:flutter/material.dart';

import '../../../models/Place.dart';
import '../../../responsive.dart';
import 'grid_place_card.dart';

class RecommendedPlaces extends StatelessWidget {
  const RecommendedPlaces({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GridView.count(
        crossAxisCount: isLandscape(context) ? 3 : 2,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(20),
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 1.2,
        children: List.generate(demoPlaces.length, (index) {
          return GridPlaceCard(
            place: demoPlaces[index],
            tapEvent: () {},
          );
        }),
      ),
    );
  }
}
