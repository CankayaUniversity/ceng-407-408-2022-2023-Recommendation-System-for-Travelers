// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rec4trav/Models/Palette.dart';
import 'package:rec4trav/Screens/AuthPages/AuthPage.dart';
import 'package:rec4trav/Utils/utils.dart';
import 'package:rec4trav/Widgets/button_widget.dart';
import 'package:rec4trav/resources/auth_methods.dart';

import '../../../resources/firestore_methods.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var userData = {};
  int postLength = 0;
  int followers = 0;
  int following = 0;

  bool isFollowing = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('RegUser')
          .doc(widget.uid)
          .get();

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLength = postSnap.docs.length;

      userData = userSnap.data()!;

      followers = userSnap.data()!['followers'].length;

      following = userSnap.data()!['following'].length;

      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);

      setState(() {});
    } catch (err) {
      if (mounted) {
        showSnackBar(context, err.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.color21,
        title: Text(
          userData['username'] ?? 'Unknown',
        ),
        centerTitle: false,
      ),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage:
                        NetworkImage(userData['photoUrl'].toString()),
                    radius: 40,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            buildStateColumn(postLength, "post"),
                            buildStateColumn(followers, "followers"),
                            buildStateColumn(following, "following"),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FirebaseAuth.instance.currentUser?.uid == widget.uid
                                ? FollowButton(
                                    text: 'Sign Out',
                                    backgroundColor: Palette.color21,
                                    textColor: Colors.black,
                                    borderColor: Colors.grey,
                                    function: () async {
                                      await AuthMethods().signOut();
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AuthPage()));
                                    },
                                  )
                                : isFollowing
                                    ? FollowButton(
                                        text: 'Unfollow',
                                        backgroundColor: Palette.appBarColor,
                                        textColor: Colors.white,
                                        borderColor: Colors.grey,
                                        function: () async {
                                          await FireStoreMethods().followUser(
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                            userData['uid'],
                                          );

                                          setState(() {
                                            isFollowing = false;
                                            followers--;
                                          });
                                        },
                                      )
                                    : FollowButton(
                                        text: 'Follow',
                                        backgroundColor: Palette.appBarColor,
                                        textColor: Colors.white,
                                        borderColor: Colors.grey,
                                        function: () async {
                                          await FireStoreMethods().followUser(
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                            userData['uid'],
                                          );

                                          setState(() {
                                            isFollowing = true;
                                            followers++;
                                          });
                                        },
                                      ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  userData['username'] ?? 'Unknown Username',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 1),
                child: Text(
                  userData['fullname'] ?? 'Unknown Fullname',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }

  Column buildStateColumn(int num, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:rec4trav/Models/colors.dart';
// import 'package:rec4trav/Pages/AuthPages/AuthPage.dart';

// import '../../../Utils/utils.dart';
// import '../../../Widgets/button_widget.dart';
// import '../../../recources/auth_methods.dart';
// import '../../../recources/firestore_methods.dart';

// class ProfilePage extends StatefulWidget {
//   final String uid;
//   const ProfilePage({Key? key, required this.uid}) : super(key: key);

//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   var userData = {};
//   int postLen = 0;
//   int followers = 0;
//   int following = 0;
//   bool isFollowing = false;
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     getData();
//   }

//   getData() async {
//     setState(() {
//       isLoading = true;
//     });
//     try {
//       var userSnap = await FirebaseFirestore.instance
//           .collection('RegUser')
//           .doc(widget.uid)
//           .get();

//       // get post lENGTH
//       var postSnap = await FirebaseFirestore.instance
//           .collection('posts')
//           .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//           .get();

//       postLen = postSnap.docs.length;
//       userData = userSnap.data()!;
//       followers = userSnap.data()!['followers'].length;
//       following = userSnap.data()!['following'].length;
//       isFollowing = userSnap
//           .data()!['followers']
//           .contains(FirebaseAuth.instance.currentUser!.uid);
//       setState(() {});
//     } catch (e) {
//       // showSnackBar(
//       //   context,
//       //   e.toString(),
//       // );
//     }
//     setState(() {
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return isLoading
//         ? const Center(
//             child: CircularProgressIndicator(),
//           )
//         : Scaffold(
//             appBar: AppBar(
//               backgroundColor: Palette.appBarColor,
//               title: Text(
//                 userData['username'],
//               ),
//               centerTitle: false,
//             ),
//             body: ListView(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     children: [
//                       Row(
//                         children: [
//                           CircleAvatar(
//                             backgroundColor: Colors.grey,
//                             backgroundImage: NetworkImage(
//                               userData['photoUrl'],
//                             ),
//                             radius: 40,
//                           ),
//                           Expanded(
//                             flex: 1,
//                             child: Column(
//                               children: [
//                                 Row(
//                                   mainAxisSize: MainAxisSize.max,
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceEvenly,
//                                   children: [
//                                     buildStatColumn(postLen, "posts"),
//                                     buildStatColumn(followers, "followers"),
//                                     buildStatColumn(following, "following"),
//                                   ],
//                                 ),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceEvenly,
//                                   children: [
//                                     FirebaseAuth.instance.currentUser!.uid ==
//                                             widget.uid
//                                         ? FollowButton(
//                                             text: 'Sign Out',
//                                             backgroundColor:
//                                                 Palette.appBarColor,
//                                             textColor: Colors.black,
//                                             borderColor: Colors.grey,
//                                             function: () async {
//                                               await AuthMethods().signOut();
//                                               Navigator.of(context)
//                                                   .pushReplacement(
//                                                 MaterialPageRoute(
//                                                   builder: (context) =>
//                                                       AuthPage(),
//                                                 ),
//                                               );
//                                             },
//                                           )
//                                         : isFollowing
//                                             ? FollowButton(
//                                                 text: 'Unfollow',
//                                                 backgroundColor: Colors.white,
//                                                 textColor: Colors.black,
//                                                 borderColor: Colors.grey,
//                                                 function: () async {
//                                                   await FireStoreMethods()
//                                                       .followUser(
//                                                     FirebaseAuth.instance
//                                                         .currentUser!.uid,
//                                                     userData['uid'],
//                                                   );

//                                                   setState(() {
//                                                     isFollowing = false;
//                                                     followers--;
//                                                   });
//                                                 },
//                                               )
//                                             : FollowButton(
//                                                 text: 'Follow',
//                                                 backgroundColor: Colors.blue,
//                                                 textColor: Colors.white,
//                                                 borderColor: Colors.blue,
//                                                 function: () async {
//                                                   await FireStoreMethods()
//                                                       .followUser(
//                                                     FirebaseAuth.instance
//                                                         .currentUser!.uid,
//                                                     userData['uid'],
//                                                   );

//                                                   setState(() {
//                                                     isFollowing = true;
//                                                     followers++;
//                                                   });
//                                                 },
//                                               )
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       Container(
//                         alignment: Alignment.centerLeft,
//                         padding: const EdgeInsets.only(
//                           top: 15,
//                         ),
//                         child: Text(
//                           userData['username'],
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       Container(
//                         alignment: Alignment.centerLeft,
//                         padding: const EdgeInsets.only(
//                           top: 1,
//                         ),
//                         child: Text(
//                           userData['bio'],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const Divider(),
//                 FutureBuilder(
//                   future: FirebaseFirestore.instance
//                       .collection('posts')
//                       .where('uid', isEqualTo: widget.uid)
//                       .get(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     }

//                     return GridView.builder(
//                       shrinkWrap: true,
//                       itemCount: (snapshot.data! as dynamic).docs.length,
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 3,
//                         crossAxisSpacing: 5,
//                         mainAxisSpacing: 1.5,
//                         childAspectRatio: 1,
//                       ),
//                       itemBuilder: (context, index) {
//                         DocumentSnapshot snap =
//                             (snapshot.data! as dynamic).docs[index];

//                         return Container(
//                           child: Image(
//                             image: NetworkImage(snap['postUrl']),
//                             fit: BoxFit.cover,
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 )
//               ],
//             ),
//           );
//   }

//   Column buildStatColumn(int num, String label) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           num.toString(),
//           style: const TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Container(
//           margin: const EdgeInsets.only(top: 4),
//           child: Text(
//             label,
//             style: const TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.w400,
//               color: Colors.grey,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }












// // ignore: file_names
// // ignore_for_file: file_names, duplicate_ignore

// import 'dart:io';

// // ignore: unused_import
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// // ignore: depend_on_referenced_packages
// import 'package:path/path.dart';
// import 'package:rec4trav/Models/colors.dart';
// import '../../../recources/auth_methods.dart';
// import '../../AuthPages/AuthPage.dart';

// class ProfilePage extends StatefulWidget {
//   ProfilePage();

//   @override
//   // ignore: library_private_types_in_public_api
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   final User? user = AuthMethods().currentUser;

//   firebase_storage.FirebaseStorage storage =
//       firebase_storage.FirebaseStorage.instance;

//   File? _photo;
//   final ImagePicker _picker = ImagePicker();

//   Future imgFromGallery() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       if (pickedFile != null) {
//         _photo = File(pickedFile.path);
//         uploadFile();
//       } else {
//         print('No image selected.');
//       }
//     });
//   }

//   Future<void> signOut() async {
//     await AuthMethods().signOut();
//   }

//   Future imgFromCamera() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.camera);

//     setState(() {
//       if (pickedFile != null) {
//         _photo = File(pickedFile.path);
//         uploadFile();
//       } else {
//         print('No image selected.');
//       }
//     });
//   }

//   Future uploadFile() async {
//     if (_photo == null) return;
//     final fileName = basename(_photo!.path);
//     final destination = '/profile_images/';

//     try {
//       final ref = firebase_storage.FirebaseStorage.instance
//           .ref(destination)
//           .child(user!.uid.toString());
//       await ref.putFile(_photo!);
//     } catch (e) {
//       print('error occured');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Column(
//       children: [
//         _signOutButton(),
//         _profileImage(context),
//         const SizedBox(
//           height: 30,
//         ),
//         info('Email : '),
//         const SizedBox(
//           height: 30,
//         ),
//         info('Full Name : '),
//         const SizedBox(
//           height: 30,
//         ),
//         info('Username : '),
//         const SizedBox(
//           height: 30,
//         ),
//         info('Phone Number : '),
//       ],
//     ));
//   }

//   Widget _profileImage(BuildContext context) {
//     return Center(
//       child: GestureDetector(
//         onTap: () {
//           _showPicker(context);
//         },
//         child: CircleAvatar(
//           radius: 84,
//           backgroundColor: Palette.color21,
//           child: _photo != null
//               ? ClipRRect(
//                   borderRadius: BorderRadius.circular(70),
//                   child: Image.file(
//                     _photo!,
//                     width: 150,
//                     height: 150,
//                     fit: BoxFit.cover,
//                   ),
//                 )
//               : Container(
//                   decoration:
//                       BoxDecoration(borderRadius: BorderRadius.circular(70)),
//                   width: 150,
//                   height: 150,
//                   child: const Icon(
//                     size: 45,
//                     Icons.camera_alt,
//                     color: Palette.color11,
//                   ),
//                 ),
//         ),
//       ),
//     );
//   }

//   Widget _signOutButton() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 270, right: 20, top: 20, bottom: 20),
//       child: Container(
//         alignment: Alignment.topRight,
//         child: ElevatedButton(
//           onPressed: () {
//             signOut;
//             Get.offAll(AuthPage());
//           },
//           child: Row(
//             children: const [
//               Text('Sign Out'),
//               SizedBox(
//                 width: 5,
//               ),
//               Icon(Icons.exit_to_app),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget info(String title) {
//     return Container(
//       width: 350,
//       height: 60,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(40), color: Palette.color31),
//       child: Row(
//         children: [
//           const SizedBox(
//             width: 20,
//           ),
//           Text(
//             title,
//             style: const TextStyle(color: Palette.color11),
//           )
//         ],
//       ),
//     );
//   }

//   void _showPicker(context) {
//     showModalBottomSheet(
//         context: context,
//         builder: (BuildContext bc) {
//           return SafeArea(
//             child: Wrap(
//               children: <Widget>[
//                 ListTile(
//                     leading: const Icon(Icons.photo_library),
//                     title: const Text('Gallery'),
//                     onTap: () {
//                       imgFromGallery();
//                       Navigator.of(context).pop();
//                     }),
//                 ListTile(
//                   leading: const Icon(Icons.photo_camera),
//                   title: const Text('Camera'),
//                   onTap: () {
//                     imgFromCamera();
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ],
//             ),
//           );
//         });
//   }
// }
