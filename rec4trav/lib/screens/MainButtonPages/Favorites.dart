// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:rec4trav/Models/Palette.dart';

class WishListPage extends StatefulWidget {
  const WishListPage({super.key});

  @override
  State<WishListPage> createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.color3,
      appBar: AppBar(
        backgroundColor: Palette.appBarColor,
        title: const Text("Wishlist"),
      ),
    );
  }
}
