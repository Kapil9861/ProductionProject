import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.height = 40,
    this.width = 300,
    this.fontSize = 20,
    required this.onPressed,
    required this.buttonText,
  });
  final int height;
  final int width;
  final double fontSize;
  final void Function() onPressed;
  final String buttonText;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height
          .toDouble(), // Convert height to double as SizedBox height expects double
      width: width
          .toDouble(), // Convert width to double as SizedBox width expects double
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              Theme.of(context).colorScheme.onPrimaryContainer),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: fontSize,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
