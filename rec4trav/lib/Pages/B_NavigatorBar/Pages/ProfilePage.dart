import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool uploading = false;
  double val = 0;
  late CollectionReference imgRef;
  late firebase_storage.Reference ref;

  List<File> _image = [];
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Image'),
          actions: [
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    uploading = true;
                  });
                  uploadFile().whenComplete(() => Navigator.of(context).pop());
                },
                child: Text(
                  'upload',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(4),
              child: GridView.builder(
                  itemCount: _image.length + 1,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return index == 0
                        ? Center(
                            child: IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () =>
                                    !uploading ? chooseImage() : null),
                          )
                        : Container(
                            margin: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(_image[index - 1]),
                                    fit: BoxFit.cover)),
                          );
                  }),
            ),
            uploading
                ? Center(
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        child: Text(
                          'uploading...',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CircularProgressIndicator(
                        value: val,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      )
                    ],
                  ))
                : Container(),
          ],
        ));
  }

  chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image.add(File(pickedFile!.path));
    });
    if (pickedFile!.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image.add(File(response.file!.path));
      });
    } else {
      print(response.file);
    }
  }

  Future uploadFile() async {
    int i = 1;

    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profile_images/${Path.basename(img.path)}');
      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          imgRef.add({'url': value});
          i++;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    imgRef = FirebaseFirestore.instance.collection('profile_images');
  }
}
// // ignore: duplicate_ignore
// // ignore: file_names
// // ignore_for_file: file_names
// import 'dart:async';
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import '../../../Models/colors.dart';
// import '../../AuthPages/auth.dart';
// import '../../AuthPages/AuthPage.dart';

// class ProfilePage extends StatefulWidget {
//   // ignore: use_key_in_widget_constructors
//   ProfilePage();

//   final User? user = Auth().currentUser;
//   final TextEditingController path = TextEditingController();

//   Future<void> signOut() async {
//     await Auth().signOut();
//   }

//   Widget _userId() {
//     return Text(
//       user?.email ?? 'User Email',
//       style: const TextStyle(fontFamily: 'WorkSans', fontSize: 20),
//     );
//   }

//   Widget _signOutButton() {
//     return ElevatedButton(
//       onPressed: () {
//         signOut;
//         Get.offAll(AuthPage());
//       },
//       child: const Text('Sign Out'),
//     );
//   }

//   @override
//   ProfilePageState createState() => ProfilePageState();
// }

// class ProfilePageState extends State<ProfilePage> {
//   bool uploading = false;
//   double val = 0;
//   late CollectionReference imgRef;
//   late firebase_storage.Reference ref;

//   List<File> _image = [];
//   final picker = ImagePicker();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Palette.color31,
//       body: Stack(
//         alignment: Alignment.center,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(30.0),
//             child: Column(
//               children: [
//                 const SizedBox(
//                   height: 50,
//                 ),
//                 Row(
//                   children: [
//                     const Icon(
//                       Icons.person,
//                       size: 50,
//                     ),
//                     const SizedBox(
//                       width: 30,
//                     ),
//                     const Text(
//                       'E-mail :',
//                       style: TextStyle(
//                           fontFamily: 'WorkSans',
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20),
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     ProfilePage()._userId(),
//                   ],
//                 ),
//                 ProfilePage()._signOutButton(),
//                 Container(
//                   padding: EdgeInsets.all(4),
//                   child: GridView.builder(
//                       itemCount: _image.length + 1,
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 3),
//                       itemBuilder: (context, index) {
//                         return index == 0
//                             ? Center(
//                                 child: IconButton(
//                                     icon: Icon(Icons.add),
//                                     onPressed: () =>
//                                         !uploading ? chooseImage() : null),
//                               )
//                             : Container(
//                                 margin: EdgeInsets.all(3),
//                                 decoration: BoxDecoration(
//                                     image: DecorationImage(
//                                         image: FileImage(_image[index - 1]),
//                                         fit: BoxFit.cover)),
//                               );
//                       }),
//                 ),
//                 uploading
//                     ? Center(
//                         child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Container(
//                             child: Text(
//                               'uploading...',
//                               style: TextStyle(fontSize: 20),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           CircularProgressIndicator(
//                             value: val,
//                             valueColor:
//                                 AlwaysStoppedAnimation<Color>(Colors.green),
//                           )
//                         ],
//                       ))
//                     : Container(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   chooseImage() async {
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);
//     setState(() {
//       _image.add(File(pickedFile!.path));
//     });
//     if (pickedFile!.path == null) {
//       retrieveLostData();
//     }
//   }

//   Future<void> retrieveLostData() async {
//     final LostData response = await picker.getLostData();
//     if (response.isEmpty) {
//       return;
//     }
//     if (response.file != null) {
//       setState(() {
//         _image.add(File(response.file!.path));
//       });
//     } else {
//       print(response.file);
//     }
//   }
// }


// // Padding(
// //                   padding: const EdgeInsets.all(8.0),
// //                   child: ElevatedButton(
// //                     // ignore: sort_child_properties_last
// //                     child: const Text('Upload Image'),
// //                     style: ElevatedButton.styleFrom(
// //                         // ignore: deprecated_member_use
// //                         primary: Palette.appBarColor,
// //                         shape: RoundedRectangleBorder(
// //                             borderRadius: BorderRadius.circular(20)),
// //                         textStyle: const TextStyle(
// //                             fontSize: 15, fontWeight: FontWeight.bold)),
// //                     onPressed: () async {
// //                       final results = await FilePicker.platform.pickFiles(
// //                         allowMultiple: false,
// //                         type: FileType.custom,
// //                         allowedExtensions: ['png', 'jpg'],
// //                       );

// //                       if (results == null) {
// //                         ScaffoldMessenger.of(context)
// //                             .showSnackBar(const SnackBar(
// //                           content: Text('No File Selected'),
// //                         ));
// //                       }
// //                       final path = results!.files.single.path;
// //                       final fileName = results.files.single.name;

// //                       storage
// //                           .uploadFile(path!, fileName)
// //                           .then((value) => print('Done'));
// //                     },
// //                   ),
// //                 ),