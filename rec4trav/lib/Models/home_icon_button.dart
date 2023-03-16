import 'package:flutter/material.dart';
import 'package:rec4trav/Screens/MainButtonPages/Favorites.dart';
import 'package:rec4trav/Screens/MainButtonPages/Maps.dart';
import 'package:rec4trav/Screens/MainButtonPages/Photos.dart';
import 'package:rec4trav/Screens/MainButtonPages/RecentPlaces.dart';

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
          color: const Color(0x9F3D416E),
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
              style: TextStyle(color: color, fontSize: 18),
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
