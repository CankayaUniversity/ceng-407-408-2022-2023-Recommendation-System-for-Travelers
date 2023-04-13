// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:rec4trav/models/Palette.dart';

class RecentPlacesPage extends StatefulWidget {
  const RecentPlacesPage({super.key});

  @override
  State<RecentPlacesPage> createState() => _RecentPlacesPageState();
}

class _RecentPlacesPageState extends State<RecentPlacesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.color3,
      appBar: AppBar(
        backgroundColor: Palette.appBarColor,
        title: const Text(
          "Recent Places",
          style: TextStyle(
            fontFamily: 'Muller',
          ),
        ),
      ),
    );
  }
}
