// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:rec4trav/Models/Palette.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.color31,
      appBar: AppBar(
        backgroundColor: Palette.appBarColor,
        title: const Text("Maps"),
      ),
    );
  }
}
