import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../../Models/Palette.dart';
import '../../../resources/firestore_methods.dart';

class FriendMap extends StatefulWidget {
  const FriendMap({super.key});

  @override
  State<FriendMap> createState() => _FriendMapState();
}

class _FriendMapState extends State<FriendMap> {
  List _friendList = [];

  void _reloadPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => FriendMap()),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadFriendList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Friend Map',
          style: TextStyle(fontFamily: 'Muller', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Palette.normalBlue,
      ),
      body: ListView.builder(
        itemCount: _friendList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(_friendList[index]),
          );
        },
      ),
    );
  }

  Future<void> _loadFriendList() async {
    List friendList = await FireStoreMethods()
        .getFriendsList(FirebaseAuth.instance.currentUser!.uid);
    setState(() {
      _friendList = friendList;
      print("fr: " + friendList.toString());
    });
  }
}
