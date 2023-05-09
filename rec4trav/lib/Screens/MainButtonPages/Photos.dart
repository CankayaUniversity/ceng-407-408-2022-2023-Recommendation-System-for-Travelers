// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:rec4trav/models/Palette.dart';

class PhotosPage extends StatefulWidget {
  const PhotosPage({super.key});

  @override
  State<PhotosPage> createState() => _PhotosPageState();
}

class _PhotosPageState extends State<PhotosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: AppBar(
        backgroundColor: Palette.normalBlue,
        title: const Text(
          "Photos",
          style: TextStyle(
            fontFamily: 'Muller',
          ),
        ),
      ),
    );
  }
}
