// ignore: file_names
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:rec4trav/Models/colors.dart';
import 'package:flutter/material.dart';

class DiscoverPage extends StatefulWidget {
  DiscoverPage();

  @override
  DiscoverPageState createState() => DiscoverPageState();
}

class DiscoverPageState extends State<DiscoverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.color31,
      body: SafeArea(
          child: GridView.custom(
              gridDelegate: SliverQuiltedGridDelegate(
                  crossAxisCount: 4,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  pattern: [
                    const QuiltedGridTile(4, 2),
                    const QuiltedGridTile(2, 2),
                    const QuiltedGridTile(2, 2),
                    const QuiltedGridTile(2, 2),
                    const QuiltedGridTile(2, 2),
                    const QuiltedGridTile(4, 2),
                    const QuiltedGridTile(2, 2),
                    const QuiltedGridTile(2, 2),
                    const QuiltedGridTile(2, 2),
                    const QuiltedGridTile(2, 2),
                  ]),
              childrenDelegate: SliverChildBuilderDelegate(
                  childCount: 10,
                  (context, index) => Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    'https://picsum.photos/500/500?random=$index'))),
                      )))),
    );
  }
}
