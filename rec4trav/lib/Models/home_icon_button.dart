import 'package:flutter/material.dart';
import 'package:rec4trav/Screens/MainButtonPages/Wishlist.dart';
import 'package:rec4trav/Screens/MainButtonPages/Maps.dart';
import 'package:rec4trav/Screens/MainButtonPages/Photos.dart';
import 'package:rec4trav/Screens/MainButtonPages/RecentPlaces.dart';

import 'Palette.dart';

// ignore: must_be_immutable
class CatigoryW extends StatelessWidget {
  String image;
  String text;
  Color color;

  // ignore: use_key_in_widget_constructors
  CatigoryW({
    required this.image,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 177,
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color.fromARGB(153, 247, 247, 247),
        ),
        child: Column(
          children: [
            Image.asset(
              image,
              width: 120,
              height: 120,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              text,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Muller',
                  color: Palette.normalBlue,
                  fontSize: 20),
            ),
          ],
        ),
      ),
      onTap: () {
        if (text == 'Wishlist') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WishListPage()),
          );
        }
        if (text == 'Recent Places') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RecentPlacesPage()),
          );
        }
        if (text == 'Maps') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MapPage()),
          );
        }
        if (text == 'Photos') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PhotosPage()),
          );
        }
      },
    );
  }
}
