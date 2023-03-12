// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Models/colors.dart';
import '../../AuthPages/auth.dart';
import '../../AuthPages/AuthPage.dart';

class ProfilePage extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  ProfilePage();

  final User? user = Auth().currentUser;
  final TextEditingController path = TextEditingController();

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _userId() {
    return Text(
      user?.email ?? 'User Email',
      style: const TextStyle(fontFamily: 'WorkSans', fontSize: 20),
    );
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: () {
        signOut;
        Get.offAll(AuthPage());
      },
      child: const Text('Sign Out'),
    );
  }

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  String? path;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.color31,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.person,
                      size: 50,
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    const Text(
                      'E-mail :',
                      style: TextStyle(
                          fontFamily: 'WorkSans',
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ProfilePage()._userId(),
                  ],
                ),
                ProfilePage()._signOutButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: ElevatedButton(
//                     // ignore: sort_child_properties_last
//                     child: const Text('Upload Image'),
//                     style: ElevatedButton.styleFrom(
//                         // ignore: deprecated_member_use
//                         primary: Palette.appBarColor,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20)),
//                         textStyle: const TextStyle(
//                             fontSize: 15, fontWeight: FontWeight.bold)),
//                     onPressed: () async {
//                       final results = await FilePicker.platform.pickFiles(
//                         allowMultiple: false,
//                         type: FileType.custom,
//                         allowedExtensions: ['png', 'jpg'],
//                       );

//                       if (results == null) {
//                         ScaffoldMessenger.of(context)
//                             .showSnackBar(const SnackBar(
//                           content: Text('No File Selected'),
//                         ));
//                       }
//                       final path = results!.files.single.path;
//                       final fileName = results.files.single.name;

//                       storage
//                           .uploadFile(path!, fileName)
//                           .then((value) => print('Done'));
//                     },
//                   ),
//                 ),