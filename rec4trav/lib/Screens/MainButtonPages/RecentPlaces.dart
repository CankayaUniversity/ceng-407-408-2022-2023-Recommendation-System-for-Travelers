// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rec4trav/models/Palette.dart';

import '../../resources/firestore_methods.dart';

class RecentPlacesPage extends StatefulWidget {
  const RecentPlacesPage({super.key});

  @override
  State<RecentPlacesPage> createState() => _RecentPlacesPageState();
}

class _RecentPlacesPageState extends State<RecentPlacesPage> {
  late Future<List<Map<String, dynamic>>> recentPlacesList;
  String _name = "";
  void _reloadPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => RecentPlacesPage()),
    );
  }

  @override
  void initState() {
    super.initState();
    recentPlacesList = FireStoreMethods()
        .getRecentPlacesData(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: AppBar(
        backgroundColor: Palette.normalBlue,
        title: const Text(
          "Recent Places",
          style: TextStyle(
            fontFamily: 'Muller',
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: recentPlacesList,
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

                      title: Text(item["placeName"] ?? ''),
                      subtitle: Text(item["date"].toDate().day.toString() +
                          "." +
                          item["date"].toDate().month.toString() +
                          "." +
                          item["date"].toDate().year.toString()),
                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                        IconButton(
                          onPressed: () {
                            _showEditDialog(context).then((value) {
                              setState(() {
                                _name = value!;
                                FireStoreMethods().updaterecentplaces(
                                    FirebaseAuth.instance.currentUser!.uid,
                                    item["id"],
                                    _name);
                                _reloadPage();
                              });
                            });
                          },
                          color: Colors.black54,
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              FireStoreMethods().deleterecentplaces(
                                  FirebaseAuth.instance.currentUser!.uid,
                                  item["id"]);

                              recentPlacesList = FireStoreMethods()
                                  .getRecentPlacesData(
                                      FirebaseAuth.instance.currentUser!.uid);
                            });
                            _reloadPage();
                          },
                          color: Colors.black54,
                          icon: Icon(Icons.remove_circle),
                        ),
                      ]),
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
    );
  }
}

Future<String?> _showEditDialog(BuildContext context) async {
  final nameController = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('İsim Düzenle'),
        content: TextField(
          controller: nameController,
        ),
        actions: <Widget>[
          TextButton(
            child: Text('İptal'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Tamam'),
            onPressed: () {
              Navigator.of(context).pop(nameController.text);
            },
          ),
        ],
      );
    },
  );
}
