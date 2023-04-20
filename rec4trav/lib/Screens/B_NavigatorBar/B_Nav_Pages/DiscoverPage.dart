// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:rec4trav/screens/B_NavigatorBar/B_Nav_Pages/ProfilePage.dart';

import '../../../models/Palette.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  DiscoverPageState createState() => DiscoverPageState();
}

class DiscoverPageState extends State<DiscoverPage> {
  List<String> imageUrls = [];
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;
  @override
  void initState() {
    super.initState();
    getImages();
  }

  Future<void> getImages() async {
    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child('/profile_images');
    final ListResult result = await ref.listAll();

    for (final item in result.items) {
      final url = await item.getDownloadURL();
      setState(() {
        imageUrls.add(url);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.normalBlue,
        title: Form(
          child: TextFormField(
            style: const TextStyle(color: Palette.white, fontFamily: 'Muller'),
            cursorColor: Palette.lightBlue,
            controller: searchController,
            decoration: const InputDecoration(
              prefixIcon: const Icon(Icons.search_outlined),
              prefixIconColor: Palette.white,
              labelText: 'Search for a user...',
              labelStyle:
                  const TextStyle(color: Palette.white, fontFamily: 'Muller'),
            ),
            onFieldSubmitted: (String _) {
              setState(() {
                isShowUsers = true;
              });
              print(_);
            },
          ),
        ),
      ),
      body: isShowUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('RegUser')
                  .where(
                    'username',
                    isGreaterThanOrEqualTo: searchController.text,
                  )
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(
                            uid: (snapshot.data! as dynamic).docs[index]['uid'],
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            (snapshot.data! as dynamic).docs[index]['photoUrl'],
                          ),
                          radius: 16,
                        ),
                        title: Text(
                          (snapshot.data! as dynamic).docs[index]['username'],
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('postsFlutter')
                  .orderBy('datePublished')
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) => Image.network(
                    (snapshot.data! as dynamic).docs[index]['postUrl'],
                    fit: BoxFit.cover,
                  ),
                  staggeredTileBuilder: (index) => MediaQuery.of(context)
                              .size
                              .width >
                          0.5
                      ? StaggeredTile.count(
                          (index % 7 == 0) ? 1 : 1, (index % 7 == 0) ? 1 : 1)
                      : StaggeredTile.count(
                          (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                );
              },
            ),
    );
  }
}

// @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Palette.color3,
//       body: SafeArea(
//           child: GridView.custom(
//               gridDelegate: SliverQuiltedGridDelegate(
//                   crossAxisCount: 4,
//                   mainAxisSpacing: 4,
//                   crossAxisSpacing: 4,
//                   pattern: [
//                     const QuiltedGridTile(4, 2),
//                     const QuiltedGridTile(2, 2),
//                     const QuiltedGridTile(2, 2),
//                     const QuiltedGridTile(2, 2),
//                     const QuiltedGridTile(2, 2),
//                     const QuiltedGridTile(4, 2),
//                     const QuiltedGridTile(2, 2),
//                     const QuiltedGridTile(2, 2),
//                     const QuiltedGridTile(2, 2),
//                     const QuiltedGridTile(2, 2),
//                   ]),
//               childrenDelegate: SliverChildBuilderDelegate(
//                   childCount: 10,
//                   (context, index) => Container(
//                         decoration: BoxDecoration(
//                             image: DecorationImage(
//                                 image: NetworkImage(
//                                     'https://picsum.photos/500/500?random=$index'))),
//                       )))),
//     );
//   }