// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';

import '../../../models/Palette.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  DiscoverPageState createState() => DiscoverPageState();
}

class DiscoverPageState extends State<DiscoverPage> {
  List<String> imageUrls = [];

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
      backgroundColor: Palette.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Discover',
          style: TextStyle(
            fontFamily: 'Muller',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Palette.normalBlue,
      ),
      body: StaggeredGridView.countBuilder(
        crossAxisCount: 2,
        itemCount: imageUrls.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(1.5),
            child: Image.network(imageUrls[index]),
          );
        },
        staggeredTileBuilder: (int index) =>
            StaggeredTile.count(1, index.isEven ? 1 : 1.3),
        mainAxisSpacing: 1.0,
        crossAxisSpacing: 1.0,
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