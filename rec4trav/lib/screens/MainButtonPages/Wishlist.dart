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
                    return Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(children: [
                        ListTile(
                          splashColor: Palette.lightBlue2,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 0.5),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          tileColor: Palette.lightBlue,
                          leading: Container(
                            padding: EdgeInsets.only(right: 12),
                            decoration: new BoxDecoration(
                              border: new Border(
                                  right: new BorderSide(
                                      width: 1, color: Colors.white)),
                            ),
                            child: item["profilePic"] ==
                                    'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=&key=APIKEY'
                                ? Icon(Icons.view_carousel)
                                : CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Palette.color4,
                                    backgroundImage:
                                        NetworkImage(item["profilePic"]),
                                    child: item["profilePic"] == null
                                        ? Icon(Icons.people)
                                        : null,
                                  ),
                          ),
                          title: Text(
                            item["name"] ?? '',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Palette.black,
                              fontFamily: 'Muller',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            item["lat"].toString() +
                                ", " +
                                item["lng"].toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Palette.black,
                              fontFamily: 'Muller',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    FireStoreMethods().deletewishlist(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        item["name"]);
                                    wishlist = wishlist = FireStoreMethods()
                                        .getWishlistData(FirebaseAuth
                                            .instance.currentUser!.uid);
                                    FireStoreMethods().addrecentplaces(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        item["lat"],
                                        item["lng"],
                                        item["name"],
                                        item["profilePic"].toString());
                                  });
                                  _reloadPage();
                                },
                                color: Colors.black54,
                                icon: Icon(Icons.done_outlined),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    FireStoreMethods().deletewishlist(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        item["name"]);
                                    wishlist = FireStoreMethods()
                                        .getWishlistData(FirebaseAuth
                                            .instance.currentUser!.uid);
                                  });
                                  _reloadPage();
                                },
                                color: Colors.black54,
                                icon: Icon(Icons.remove_circle_outline_rounded),
                              ),
                            ],
                          ),
                        ),
                      ]),
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
    );
  }
}
