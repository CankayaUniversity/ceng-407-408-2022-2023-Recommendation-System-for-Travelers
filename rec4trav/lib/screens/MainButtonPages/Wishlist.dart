// ignore_for_file: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rec4trav/models/Palette.dart';
import '../../resources/firestore_methods.dart';

class WishListPage extends StatefulWidget {
  const WishListPage({super.key});

  @override
  State<WishListPage> createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  late Future<List<Map<String, dynamic>>> wishlist;
  void _reloadPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => WishListPage()),
    );
  }

  @override
  void initState() {
    super.initState();
    wishlist = FireStoreMethods()
        .getWishlistData(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: AppBar(
        backgroundColor: Palette.normalBlue,
        title: const Text(
          "Wishlist",
          style: TextStyle(
            fontFamily: 'Muller',
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: wishlist,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                  child: Text('An error occurred: ${snapshot.error}'));
            } else {
              return SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    var item = snapshot.data![index];
                    return ListTile(
                      // title: Text(item["name"]),

                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 0.5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Palette.color4,
                        backgroundImage: NetworkImage(item["profilePic"]),
                      ),
                      title: Text(item["name"] ?? ''),
                      subtitle: Text(item["lat"].toString() +
                              ", " +
                              item["lng"].toString() ??
                          ''),
                      trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            FireStoreMethods().deletewishlist(
                                FirebaseAuth.instance.currentUser!.uid,
                                item["name"]);
                            wishlist = FireStoreMethods().getWishlistData(
                                FirebaseAuth.instance.currentUser!.uid);
                          });
                          _reloadPage();
                        },
                        color: Colors.black54,
                        icon: Icon(Icons.remove_circle),
                      ),
                      //
                    );
                  },
                ),
              );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      // FutureBuilder<List<Map<String, dynamic>>>(
      //   future: FireStoreMethods()
      //       .getWishlistData(FirebaseAuth.instance.currentUser!.uid),
      //   builder: (BuildContext context,
      //       AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
      //     if (snapshot.hasData) {
      //       List<Map<String, dynamic>> wishlistData = snapshot.data!;
      //       return SingleChildScrollView(
      //         child: ListView.builder(
      //           shrinkWrap: true,
      //           physics: NeverScrollableScrollPhysics(),
      //           itemCount: wishlistData.length,
      //           itemBuilder: (BuildContext context, int index) {
      //             return ListTile(
      //               shape: RoundedRectangleBorder(
      //                 side: BorderSide(width: 0.5),
      //                 borderRadius: BorderRadius.circular(2),
      //               ),
      //               leading: CircleAvatar(
      //                 backgroundColor: Palette.color4,
      //                 backgroundImage: NetworkImage(wishlistData[index]
      //                         ["profilePic"] ??
      //                     'https://cdn.pixabay.com/photo/2016/08/07/15/34/do-not-take-photos-1576438_960_720.png'),
      //               ),
      //               title: Text(wishlistData[index]["name"] ?? ''),
      //               subtitle: Text(wishlistData[index]["lat"].toString() +
      //                       ", " +
      //                       wishlistData[index]["lng"].toString() ??
      //                   ''),
      //               trailing: IconButton(
      //                 onPressed: () {
      //                   FireStoreMethods().deletewishlist(
      //                       FirebaseAuth.instance.currentUser!.uid,
      //                       wishlistData[index]["name"]);
      //                   Navigator.pushReplacement(
      //                       context,
      //                       MaterialPageRoute(
      //                           builder: (BuildContext context) =>
      //                               super.widget));
      //                 },
      //                 color: Colors.black54,
      //                 icon: Icon(Icons.remove_circle),
      //               ),
      //             );
      //           },
      //         ),
      //       );
      //     } else {
      //       return CircularProgressIndicator();
      //     }
      //   },
    );
    // body: FutureBuilder<List<String>>(
    //   future: FireStoreMethods()
    //       .getWishlistData(FirebaseAuth.instance.currentUser!.uid),
    //   builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
    //     if (snapshot.hasData) {
    //       List<String> wishlistNames = snapshot.data!;
    //       print("saa");
    //       return SingleChildScrollView(
    //         child: ListView.builder(
    //           shrinkWrap: true,
    //           physics: NeverScrollableScrollPhysics(),
    //           itemCount: wishlistNames.length,
    //           itemBuilder: (BuildContext context, int index) {
    //             return ListTile(
    //               leading: Netw,
    //               title: Text(wishlistNames[index]),
    //             );
    //           },
    //         ),
    //       );
    //     } else {
    //       return Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     }
    //   },
    // ),
  }
}
