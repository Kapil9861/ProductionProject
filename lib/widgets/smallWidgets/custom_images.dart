import 'package:flutter/cupertino.dart';

class CustomImages extends StatelessWidget {
  const CustomImages({
    super.key,
    required this.image,
    this.height = 220,
    this.width = 110,
  });
  final AssetImage image;
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5, left: 5),
        child: SizedBox(
          height: height,
          width: width,
          child: Image(
            image: image,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
