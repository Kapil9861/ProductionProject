import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sajilo_hisab/widgets/screens/about_us_screen.dart';
import 'package:sajilo_hisab/widgets/screens/call_break/call_break_player_rules.dart';
import 'package:sajilo_hisab/widgets/screens/game_rules.dart';
import 'package:sajilo_hisab/widgets/buttons/custom_button.dart';
import 'package:sajilo_hisab/widgets/screens/marriage/marriage_players_rules.dart';
import 'package:sajilo_hisab/widgets/screens/help_screen.dart';
import 'package:sajilo_hisab/widgets/smallWidgets/footer.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  String appBarTitle = "Sajilo Hisab";
  Widget? content;
  double padding = 40;
  double fontSize = 20;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double width = size.width;
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
                image: AssetImage('assets/images/logo/logo.png'),
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
              height: 40,
              fontSize: width < 350 ? 14 : 19,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
              onPressed: () {
                selectScreen("CallBreak Points Rules");
              },
              buttonText: "CallBreak Points Calculator",
              height: 40,
              fontSize: width < 350 ? 14 : 19,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
              onPressed: () {
                selectScreen("Help (Tutorial)");
              },
              buttonText: "Help (Tutorial)",
              fontSize: width < 350 ? 14 : 20,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
              onPressed: () {
                selectScreen("Games Rules");
              },
              buttonText: "Games Rules",
              fontSize: width < 350 ? 14 : 20,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
              onPressed: () {
                selectScreen("About Us");
              },
              buttonText: "About Us",
              fontSize: width < 350 ? 14 : 20,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
              onPressed: () {
                exit(0);
              },
              buttonText: "Exit",
              fontSize: width < 350 ? 14 : 20,
            ),
            const MyFooter()
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
      case "Help (Tutorial)":
        content = const HelpScreen();
        break;
      case "Games Rules":
        content = const GamesRules();
        break;
      case "About Us":
        content = const AboutUsScreen();
        break;
      default:
        content = home;
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.only(
              left: appBarTitle == "Sajilo Hisab"
                  ? size.width < 350
                      ? 18
                      : 70
                  : size.width < 350
                      ? 6
                      : 40,
            ),
            child: Text(
              appBarTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: appBarTitle == "Sajilo Hisab"
                    ? size.width < 350
                        ? 16
                        : 24
                    : size.width < 350
                        ? 15
                        : 21,
              ),
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
                'assets/images/logo/logo.png',
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
