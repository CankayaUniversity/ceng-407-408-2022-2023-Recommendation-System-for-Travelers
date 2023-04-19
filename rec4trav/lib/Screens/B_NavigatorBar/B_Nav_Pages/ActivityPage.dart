// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names

import 'package:rec4trav/models/Palette.dart';
import 'package:flutter/material.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Activity',
          style: TextStyle(
            fontFamily: 'Muller',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Palette.normalBlue,
      ),
      backgroundColor: Palette.white,
    );
  }
}
