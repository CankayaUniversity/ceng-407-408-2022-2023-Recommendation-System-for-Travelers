// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names

import 'package:rec4trav/Models/Palette.dart';
import 'package:flutter/material.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity'),
        backgroundColor: Palette.color21,
      ),
      backgroundColor: Palette.color41,
    );
  }
}
