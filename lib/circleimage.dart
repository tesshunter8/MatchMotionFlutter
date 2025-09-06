import 'package:flutter/cupertino.dart';

class CircleImage extends StatelessWidget {
  const CircleImage({super.key,required this.imageurl});
  final String imageurl;
  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.all(50),
      width: 500,
      height: 400,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(1000),
        child: Image.network(
          imageurl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
