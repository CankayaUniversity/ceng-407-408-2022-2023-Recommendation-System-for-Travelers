import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Admin Page',
          style: TextStyle(
            fontFamily: 'Muller',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
