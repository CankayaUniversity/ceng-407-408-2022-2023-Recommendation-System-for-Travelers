// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:rec4trav/Models/Palette.dart';

class PhotosPage extends StatefulWidget {
  const PhotosPage({super.key});

  @override
  State<PhotosPage> createState() => _PhotosPageState();
}

class _PhotosPageState extends State<PhotosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.color3,
      appBar: AppBar(
        backgroundColor: Palette.appBarColor,
        title: const Text("Photos"),
      ),
    );
  }
}
