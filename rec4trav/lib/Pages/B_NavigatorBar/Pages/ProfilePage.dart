import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = '/profile_images/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('/profile_images');
      await ref.putFile(_photo!);
    } catch (e) {
      print('error occured');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 32,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                _showPicker(context);
              },
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Color(0xffFDCF09),
                child: _photo != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.file(
                          _photo!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.fitHeight,
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(50)),
                        width: 100,
                        height: 100,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                        ),
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}

// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:path/path.dart' as Path;

// class ProfilePage extends StatefulWidget {
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   bool uploading = false;
//   double val = 0;
//   late CollectionReference imgRef;
//   late firebase_storage.Reference ref;

//   List<File> _image = [];
//   final picker = ImagePicker();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Add Image'),
//           actions: [
//             ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     uploading = true;
//                   });
//                   uploadFile().whenComplete(() => print('loaded'));
//                 },
//                 child: const Text(
//                   'upload',
//                   style: TextStyle(color: Colors.white),
//                 ))
//           ],
//         ),
//         body: Stack(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(4),
//               child: GridView.builder(
//                   itemCount: _image.length + 1,
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 3),
//                   itemBuilder: (context, index) {
//                     return index == 0
//                         ? Center(
//                             child: IconButton(
//                                 icon: const Icon(Icons.add),
//                                 onPressed: () =>
//                                     !uploading ? chooseImage() : null),
//                           )
//                         : Container(
//                             margin: const EdgeInsets.all(3),
//                             decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                     image: FileImage(_image[index - 1]),
//                                     fit: BoxFit.cover)),
//                           );
//                   }),
//             ),
//             uploading
//                 ? Center(
//                     child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       // ignore: avoid_unnecessary_containers
//                       Container(
//                         child: const Text(
//                           'uploading...',
//                           style: TextStyle(fontSize: 20),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       CircularProgressIndicator(
//                         value: val,
//                         valueColor:
//                             const AlwaysStoppedAnimation<Color>(Colors.green),
//                       )
//                     ],
//                   ))
//                 : Container(),
//           ],
//         ));
//   }

//   chooseImage() async {
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);
//     setState(() {
//       _image.add(File(pickedFile!.path));
//     });
//     if (pickedFile!.path == null) retrieveLostData();
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

//   Future uploadFile() async {
//     int i = 1;

//     for (var img in _image) {
//       setState(() {
//         val = i / _image.length;
//       });
//       ref = firebase_storage.FirebaseStorage.instance
//           .ref()
//           .child('profile_images/${Path.basename(img.path)}');
//       print('url : ' + 'profile_images/${Path.basename(img.path)}');
//       await ref.putFile(img).whenComplete(() async {
//         await ref.getDownloadURL().then((value) {
//           imgRef.add({'url': value});
//           i++;
//           imgRef = FirebaseFirestore.instance.collection('profile_images');
//         });
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     imgRef = FirebaseFirestore.instance.collection('/profile_images');
//   }
// }
// // // ignore: duplicate_ignore
// // // ignore: file_names
// // // ignore_for_file: file_names
// // import 'dart:async';
// // import 'dart:io';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:image_picker/image_picker.dart';
// // import '../../../Models/colors.dart';
// // import '../../AuthPages/auth.dart';
// // import '../../AuthPages/AuthPage.dart';

// // class ProfilePage extends StatefulWidget {
// //   // ignore: use_key_in_widget_constructors
// //   ProfilePage();

// //   final User? user = Auth().currentUser;
// //   final TextEditingController path = TextEditingController();

// //   Future<void> signOut() async {
// //     await Auth().signOut();
// //   }

// //   Widget _userId() {
// //     return Text(
// //       user?.email ?? 'User Email',
// //       style: const TextStyle(fontFamily: 'WorkSans', fontSize: 20),
// //     );
// //   }

// //   Widget _signOutButton() {
// //     return ElevatedButton(
// //       onPressed: () {
// //         signOut;
// //         Get.offAll(AuthPage());
// //       },
// //       child: const Text('Sign Out'),
// //     );
// //   }

// //   @override
// //   ProfilePageState createState() => ProfilePageState();
// // }

// // class ProfilePageState extends State<ProfilePage> {
// //   bool uploading = false;
// //   double val = 0;
// //   late CollectionReference imgRef;
// //   late firebase_storage.Reference ref;

// //   List<File> _image = [];
// //   final picker = ImagePicker();
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Palette.color31,
// //       body: Stack(
// //         alignment: Alignment.center,
// //         children: [
// //           Padding(
// //             padding: const EdgeInsets.all(30.0),
// //             child: Column(
// //               children: [
// //                 const SizedBox(
// //                   height: 50,
// //                 ),
// //                 Row(
// //                   children: [
// //                     const Icon(
// //                       Icons.person,
// //                       size: 50,
// //                     ),
// //                     const SizedBox(
// //                       width: 30,
// //                     ),
// //                     const Text(
// //                       'E-mail :',
// //                       style: TextStyle(
// //                           fontFamily: 'WorkSans',
// //                           fontWeight: FontWeight.bold,
// //                           fontSize: 20),
// //                     ),
// //                     const SizedBox(
// //                       width: 10,
// //                     ),
// //                     ProfilePage()._userId(),
// //                   ],
// //                 ),
// //                 ProfilePage()._signOutButton(),
// //                 Container(
// //                   padding: EdgeInsets.all(4),
// //                   child: GridView.builder(
// //                       itemCount: _image.length + 1,
// //                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// //                           crossAxisCount: 3),
// //                       itemBuilder: (context, index) {
// //                         return index == 0
// //                             ? Center(
// //                                 child: IconButton(
// //                                     icon: Icon(Icons.add),
// //                                     onPressed: () =>
// //                                         !uploading ? chooseImage() : null),
// //                               )
// //                             : Container(
// //                                 margin: EdgeInsets.all(3),
// //                                 decoration: BoxDecoration(
// //                                     image: DecorationImage(
// //                                         image: FileImage(_image[index - 1]),
// //                                         fit: BoxFit.cover)),
// //                               );
// //                       }),
// //                 ),
// //                 uploading
// //                     ? Center(
// //                         child: Column(
// //                         mainAxisSize: MainAxisSize.min,
// //                         children: [
// //                           Container(
// //                             child: Text(
// //                               'uploading...',
// //                               style: TextStyle(fontSize: 20),
// //                             ),
// //                           ),
// //                           SizedBox(
// //                             height: 10,
// //                           ),
// //                           CircularProgressIndicator(
// //                             value: val,
// //                             valueColor:
// //                                 AlwaysStoppedAnimation<Color>(Colors.green),
// //                           )
// //                         ],
// //                       ))
// //                     : Container(),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   chooseImage() async {
// //     final pickedFile = await picker.getImage(source: ImageSource.gallery);
// //     setState(() {
// //       _image.add(File(pickedFile!.path));
// //     });
// //     if (pickedFile!.path == null) {
// //       retrieveLostData();
// //     }
// //   }

// //   Future<void> retrieveLostData() async {
// //     final LostData response = await picker.getLostData();
// //     if (response.isEmpty) {
// //       return;
// //     }
// //     if (response.file != null) {
// //       setState(() {
// //         _image.add(File(response.file!.path));
// //       });
// //     } else {
// //       print(response.file);
// //     }
// //   }
// // }


// // // Padding(
// // //                   padding: const EdgeInsets.all(8.0),
// // //                   child: ElevatedButton(
// // //                     // ignore: sort_child_properties_last
// // //                     child: const Text('Upload Image'),
// // //                     style: ElevatedButton.styleFrom(
// // //                         // ignore: deprecated_member_use
// // //                         primary: Palette.appBarColor,
// // //                         shape: RoundedRectangleBorder(
// // //                             borderRadius: BorderRadius.circular(20)),
// // //                         textStyle: const TextStyle(
// // //                             fontSize: 15, fontWeight: FontWeight.bold)),
// // //                     onPressed: () async {
// // //                       final results = await FilePicker.platform.pickFiles(
// // //                         allowMultiple: false,
// // //                         type: FileType.custom,
// // //                         allowedExtensions: ['png', 'jpg'],
// // //                       );

// // //                       if (results == null) {
// // //                         ScaffoldMessenger.of(context)
// // //                             .showSnackBar(const SnackBar(
// // //                           content: Text('No File Selected'),
// // //                         ));
// // //                       }
// // //                       final path = results!.files.single.path;
// // //                       final fileName = results.files.single.name;

// // //                       storage
// // //                           .uploadFile(path!, fileName)
// // //                           .then((value) => print('Done'));
// // //                     },
// // //                   ),
// // //                 ),