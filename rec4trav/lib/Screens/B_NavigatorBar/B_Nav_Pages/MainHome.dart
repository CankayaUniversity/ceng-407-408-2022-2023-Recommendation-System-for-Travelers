// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore, unused_element

import 'package:flutter/material.dart';

import '../../../Models/home_icon_button.dart';
import '../../../models/Palette.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  MainHomePageState createState() => MainHomePageState();
}

class MainHomePageState extends State<MainHomePage>
    with TickerProviderStateMixin {
  late TabController tabController;
  bool appBarCollapsed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.lightBlue,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Column(
              children: [
                Stack(
                  children: [
                    Transform.rotate(
                      origin: const Offset(30, -60),
                      angle: 2.4,
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 75,
                          top: 40,
                        ),
                        height: 400,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80),
                          gradient: const LinearGradient(
                            begin: Alignment.bottomLeft,
                            colors: [Palette.normalBlue, Palette.black],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 70),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: Image.asset('assets/Rec4TravBcPng.png'),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 50),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: const Text(
                                'Recommendation System For Travelers',
                                style: TextStyle(
                                  fontFamily: 'Muller',
                                  color: Colors.white,
                                  fontSize: 23,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 50,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CatigoryW(
                                      image: 'assets/icons/Gallery.png',
                                      text: 'Photos',
                                      color: Palette.color4,
                                    ),
                                    CatigoryW(
                                      image: 'assets/icons/Map.png',
                                      text: 'Maps',
                                      color: const Color.fromARGB(
                                          255, 180, 157, 236),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CatigoryW(
                                      image: 'assets/icons/Recent.png',
                                      text: 'Recent Places',
                                      color: const Color.fromARGB(
                                          255, 31, 172, 148),
                                    ),
                                    CatigoryW(
                                      image: 'assets/icons/Wishlist.png',
                                      text: 'Wishlist',
                                      color: const Color.fromARGB(
                                          255, 150, 19, 106),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(
//             height: 50,
//           ),
//           Padding(
//             padding: const EdgeInsets.all(5),
//             child: Center(
//               child: Wrap(
//                 spacing: 10.0,
//                 runSpacing: 10.0,
//                 children: [
//                   InkWell(
//                     // onTap: () {
//                     //   print("Yellow Button Clicked");
//                     //   Navigator.push(
//                     //     context,
//                     //     MaterialPageRoute(builder: (context) => WantToGoPage()),
//                     //   );
//                     // },
//                     child: buildButtonIndex("Photos", 'assets/rightArrow.png',
//                         Color.fromARGB(255, 139, 139, 18), context),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       // ignore: avoid_print
//                       print("Green Button Clicked");
//                     },
//                     child: buildButtonIndex(
//                       "Map",
//                       'assets/rightArrow.png',
//                       const Color.fromRGBO(178, 255, 89, 1),
//                       context,
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       // ignore: avoid_print
//                       print("Red Button Clicked");
//                     },
//                     child: buildButtonIndex(
//                       "Recent Places",
//                       'assets/rightArrow.png',
//                       const Color.fromRGBO(255, 110, 64, 1),
//                       context,
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       // ignore: avoid_print
//                       print("Purple Button Clicked");
//                     },
//                     child: buildButtonIndex(
//                       "Favorites",
//                       'assets/rightArrow.png',
//                       const Color.fromRGBO(224, 64, 251, 1),
//                       context,
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       // ignore: avoid_print
//                       print("Purple Button Clicked");
//                     },
//                     child: buildButtonIndex(
//                       "Deneme",
//                       'assets/rightArrow.png',
//                       Colors.blue,
//                       context,
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
  Widget buildButtonIndex(
      String text, String image, Color buttonColor, BuildContext context) {
    return SizedBox(
      width: 160,
      height: 160,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 14, 13, 13).withOpacity(.5),
              blurRadius: 20.0, // soften the shadow
              spreadRadius: 1.0, //extend the shadow
              offset: const Offset(
                5.0, // Move to right 10  horizontally
                5.0, // Move to bottom 10 Vertically
              ),
            )
          ],
        ),
        child: GestureDetector(
          //onTap: () => bookFlight(context),
          child: Card(
              color: buttonColor,
              shadowColor: const Color.fromARGB(255, 8, 0, 0),
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Image.asset(
                      image,
                      width: 62,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(text,
                        style: const TextStyle(
                            fontFamily: 'Muller',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  ]),
                ),
              )),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: width,
          child: Image.asset(
            'assets/r4t.png',
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          height: 50,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: const Text(
            'Recommendation System For Travelers',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: TextStyle(
                fontFamily: 'Muller',
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          height: 10,
          color: Colors.grey[100],
        ),
      ],
    );
  }
}
