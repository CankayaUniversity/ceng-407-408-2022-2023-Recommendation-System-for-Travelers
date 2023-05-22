import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// for picking up image from gallery
pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
  // ignore: avoid_print
  print('No Image Selected');
}

// for displaying snackbars
showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

final cardInfoDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(15),
  // color: kCardInfoBG.withOpacity(0.6),
);

final likedWidgetDecoration =
    BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.white);
