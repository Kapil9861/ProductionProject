import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sajilo_hisab/widgets/screens/about_us_screen.dart';
import 'package:sajilo_hisab/widgets/screens/call_break/call_break_player_rules.dart';
import 'package:sajilo_hisab/widgets/screens/game_rules.dart';
import 'package:sajilo_hisab/widgets/buttons/custom_button.dart';
import 'package:sajilo_hisab/widgets/screens/marriage/marriage_players_rules.dart';
import 'package:sajilo_hisab/widgets/screens/settings_screen.dart';
import 'package:sajilo_hisab/widgets/screens/help_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  String appBarTitle = "Sajilo Hisab";
  Widget? content;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    Widget home = Center(
      child: SingleChildScrollView(
        child: Column(
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
                selectScreen("Marriage Points Rules");
              },
              buttonText: "Marriage Points Calculator",
              width: 300,
              height: 40,
              fontSize: 19,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
              onPressed: () {
                selectScreen("CallBreak Points Rules");
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
              fontSize: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
              onPressed: () {
                selectScreen("Games Rules");
              },
              buttonText: "Games Rules",
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
              fontSize: 20,
            )
          ],
        ),
      ),
    );

    switch (appBarTitle) {
      case "Marriage Points Rules":
        content = const MarriagePlayerRules();
        break;
      case "CallBreak Points Rules":
        content = const CallBreakPlayerRules();
        break;
      case "Settings":
        content = SettingsScreen();
        break;
      case "Help (Tutorial)":
        content = HelpScreen();
        break;
      case "Games Rules":
        content = GamesRules();
        break;
      case "About Us":
        content = AboutUsScreen();
        break;
      default:
        content = home;
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Text(
              appBarTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 21),
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: GestureDetector(
              onTap: () {
                // Handle tap event to load the main screen
                setState(() {
                  appBarTitle =
                      "Sajilo Hisab"; // Set the title to main screen title
                  content = home;
                });
              },
              child: Image.asset(
                'assets/images/logo.png',
                width: 30,
                height: 30,
              ),
            ),
          ),
        ),
        body: SizedBox(
          child: content,
        ),
      ),
    );
  }

  void selectScreen(String buttonName) {
    setState(() {
      appBarTitle = buttonName;
    });
  }
}
