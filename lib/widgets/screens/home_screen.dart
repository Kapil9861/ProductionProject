import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sajilo_hisab/widgets/buttons/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.selectScreen,
  });

  final Function(String buttonName) selectScreen;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double width = size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 220,
          width: 220,
          child: Image(
            image: AssetImage('assets/images/logo.png'),
          ),
        ),
        const SizedBox(
          height: 35,
        ),
        CustomButton(
          onPressed: () {
            selectScreen("Marriage Points Calculator");
          },
          buttonText: "Marriage Points Calculator",
          width: 300,
          height: 40,
          fontSize: width < 350 ? 16 : 19,
        ),
        const SizedBox(
          height: 20,
        ),
        CustomButton(
          onPressed: () {
            selectScreen("CallBreak Points Calculator");
          },
          buttonText: "CallBreak Points Calculator",
          width: 300,
          height: 40,
          fontSize: 19,
        ),
        const SizedBox(
          height: 20,
        ),
        CustomButton(
          onPressed: () {
            selectScreen("Settings");
          },
          buttonText: "Settings",
          width: 300,
          height: 40,
          fontSize: 20,
        ),
        const SizedBox(
          height: 20,
        ),
        CustomButton(
          onPressed: () {
            selectScreen("Help (Tutorial)");
          },
          buttonText: "Help (Tutorial)",
          width: 300,
          height: 40,
          fontSize: 20,
        ),
        const SizedBox(
          height: 20,
        ),
        CustomButton(
          onPressed: () {
            selectScreen("Games Rules");
          },
          buttonText: "Game Rules",
          width: 300,
          height: 40,
          fontSize: 20,
        ),
        const SizedBox(
          height: 20,
        ),
        CustomButton(
          onPressed: () {
            selectScreen("About Us");
          },
          buttonText: "About Us",
          width: 300,
          height: 40,
          fontSize: 20,
        ),
        const SizedBox(
          height: 20,
        ),
        CustomButton(
          onPressed: () {
            exit(0);
          },
          buttonText: "Exit",
          width: 300,
          height: 40,
          fontSize: 20,
        )
      ],
    );
  }
}
