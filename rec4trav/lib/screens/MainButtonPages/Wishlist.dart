// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:rec4trav/models/Palette.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishListPage extends StatefulWidget {
  const WishListPage({super.key});

  @override
  State<WishListPage> createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  List<String> myList = [];
  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    myList = prefs.getStringList('wishlist') ?? [];
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: AppBar(
        backgroundColor: Palette.normalBlue,
        title: const Text(
          "Wishlist",
          style: TextStyle(
            fontFamily: 'Muller',
          ),
        ),
      ),
      body: Text(myList.toString()),
    );
  }
}
