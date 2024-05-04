import 'package:flutter/cupertino.dart';

class CustomImages extends StatelessWidget {
  const CustomImages({
    super.key,
    required this.image,
    this.height = 280,
    this.width = 220,
  });
  final AssetImage image;
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
          height: width,
          width: height,
          child: Image(image: image),
        ),
      ),
    );
  }
}
