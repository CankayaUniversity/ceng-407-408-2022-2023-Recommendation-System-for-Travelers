import 'package:flutter/material.dart';
import '../../../Utils/utils.dart';

class LikedButton extends StatelessWidget {
  const LikedButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: likedWidgetDecoration,
      child: IconButton(
        icon: Icon(Icons.face_4),
        onPressed: () {},
      ),
    );
  }
}
