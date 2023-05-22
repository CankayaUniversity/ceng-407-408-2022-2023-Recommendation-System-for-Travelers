import 'package:flutter/material.dart';

AppBar buildAppBar(BuildContext context,
    {required String title,
    required List<Widget> actions,
    required Widget leading}) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: Text(
      title,
    ),
    leading: leading,
    actions: actions,
  );
}
