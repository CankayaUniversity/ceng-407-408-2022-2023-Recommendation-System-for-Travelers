import 'package:flutter/material.dart';
import 'package:rec4trav/screens/home/components/place_card.dart';

import '../../../models/Place.dart';

class PopularPlaces extends StatefulWidget {
  const PopularPlaces({
    Key? key,
  }) : super(key: key);

  @override
  _PopularPlacesState createState() => _PopularPlacesState();
}

class _PopularPlacesState extends State<PopularPlaces> {
  int currentSlider = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 260,
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentSlider = value;
                  });
                },
                controller:
                    PageController(viewportFraction: 0.8, initialPage: 0),
                itemCount: demoPlaces.length,
                itemBuilder: (context, index) =>
                    PlaceCard(place: demoPlaces[index])),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  demoPlaces.length, (index) => buildDotNav(index: index)),
            ),
          )
        ],
      ),
    );
  }

  AnimatedContainer buildDotNav({required int index}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentSlider == index ? 24 : 6,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(3)),
    );
  }
}
