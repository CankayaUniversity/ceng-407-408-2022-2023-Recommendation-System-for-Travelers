// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore

import 'package:flutter_masonry_view/flutter_masonry_view.dart';
import 'package:flutter/material.dart';

import '../../../Models/Palette.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  DiscoverPageState createState() => DiscoverPageState();
}

class DiscoverPageState extends State<DiscoverPage> {
  final _items = [
    'assets/images/intro1.jpg',
    'assets/images/intro2.jpg',
    'assets/images/intro3.jpg',
    'assets/images/intro4.jpg',
    'assets/images/intro5.jpg',
    'assets/images/intro1.jpg',
    'assets/images/intro3.jpg',
    'assets/images/intro4.jpg',
    'assets/images/intro5.jpg',
    'assets/images/intro2.jpg',
    'assets/images/intro1.jpg',
    'assets/images/intro3.jpg',
    'assets/images/intro4.jpg',
    'assets/images/intro5.jpg',
    'assets/images/intro2.jpg',
    'assets/images/intro1.jpg',
    'assets/images/intro3.jpg',
    'assets/images/intro4.jpg',
    'assets/images/intro5.jpg',
    'assets/images/intro2.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.color41,
      appBar: AppBar(
        title: const Text('Discover'),
        backgroundColor: Palette.color21,
      ),
      body: SingleChildScrollView(
        child: MasonryView(
          listOfItem: _items,
          numberOfColumn: 2,
          itemBuilder: (item) {
            return Image.asset(item);
          },
        ),
      ),
    );
  }
}

// @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Palette.color31,
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