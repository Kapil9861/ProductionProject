import 'package:flutter/material.dart';

class StyledText extends StatelessWidget {
  const StyledText(
      {super.key,
      required this.text,
      this.textSize = 16,
      this.color = Colors.black});
  const StyledText.title(
      {super.key,
      required this.text,
      this.textSize = 24,
      this.color = Colors.black});
  final String text;
  final double textSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
          color: textSize == 24
              ? Theme.of(context).colorScheme.onPrimaryContainer
              : color,
          fontSize: textSize,
          fontWeight: textSize == 24 ? FontWeight.bold : FontWeight.normal,
        ),
        textAlign: TextAlign.center);
  }
}
