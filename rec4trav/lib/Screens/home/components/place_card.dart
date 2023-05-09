import 'package:flutter/material.dart';
import 'package:rec4trav/models/Place.dart';
import '../../../Utils/utils.dart';
import 'liked_button.dart';

class PlaceCard extends StatelessWidget {
  const PlaceCard({Key? key, required this.place}) : super(key: key);

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 30),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
              image: AssetImage(place.image), fit: BoxFit.cover)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: double.infinity,
            height: 80,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            decoration: cardInfoDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      place.name,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                    Spacer(),
                    LikedButton()
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
