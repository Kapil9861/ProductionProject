import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.height = 40,
    this.width = 305,
    this.fontSize = 12,
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
    Color color = Theme.of(context).colorScheme.onPrimaryContainer;
    if (Theme.of(context).brightness == Brightness.dark) {
      color = Theme.of(context).colorScheme.onPrimary;
    }
    return SizedBox(
      height: height
          .toDouble(), // Convert height to double as SizedBox height expects double
      width: width
          .toDouble(), // Convert width to double as SizedBox width expects double
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(color),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: fontSize,
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ),
    );
  }
}
