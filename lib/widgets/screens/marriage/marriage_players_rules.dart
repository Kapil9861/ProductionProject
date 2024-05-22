import 'package:flutter/material.dart';
import 'package:sajilo_hisab/main.dart';
import 'package:sajilo_hisab/widgets/screens/marriage/marriage_home.dart';
import 'package:sajilo_hisab/widgets/screens/marriage/marriage_rules.dart';
import 'package:sajilo_hisab/widgets/styled_text.dart';

class MarriagePlayerRules extends StatefulWidget {
  const MarriagePlayerRules({super.key});

  @override
  State<MarriagePlayerRules> createState() => _MarriagePlayerRulesState();
}

class _MarriagePlayerRulesState extends State<MarriagePlayerRules> {
  List<bool> isSwitched = [true, true, true, false, false];

  void _toggleSwitch(bool value, int index) {
    setState(() {
      if (index < isSwitched.length) {
        isSwitched[index] = value;
      }
      if (index == 0 && !isSwitched[0]) {
        isSwitched[3] = false;
      } else if (index == 3 && isSwitched[3]) {
        isSwitched[0] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    Color color = Theme.of(context).colorScheme.onPrimaryContainer;
    if (Theme.of(context).brightness == Brightness.dark) {
      color = Theme.of(context).colorScheme.onPrimary;
    }
    Color buttonColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : kColorScheme.onPrimaryContainer;

    String getTitle(int index) {
      switch (index) {
        case 0:
          return "Murder";
        case 1:
          return "Dublee";
        case 2:
          return "Dublee Point Less";
        case 3:
          return "Kidnap";
        default:
          return "Fine System";
      }
    }

    String getInfoText(int index) {
      switch (index) {
        case 0:
          return "The Maal of Unseen Players Doesn't Count.";
        case 1:
          return "The Player With Dublee gets 5 Points Bonus, if the Player Finishes the Game.";
        case 2:
          return "The Player with Dublee Should not Pay 3 Points to the Winner.";
        case 3:
          return "The Unseen Player/s Should Pay for Their Points too.";
        default:
          return "Pay Fine Amount in the Same Game.";
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(
                "Marriage Players Rule",
                style: TextStyle(fontSize: width < 340 ? 26 : 30),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemCount: isSwitched.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SizedBox(
                      height: width < 340 ? 150 : 101,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getTitle(index),
                                  style: TextStyle(
                                      fontSize: width < 340 ? 18 : 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  getInfoText(index),
                                  style: TextStyle(
                                      fontSize: width < 340 ? 11 : 14),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color,
                            ),
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const MarriageRules(),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.question_mark_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: screenSize.width > 340
                                ? screenSize.width - 340
                                : 0,
                          ),
                          Switch(
                            activeTrackColor:
                                Theme.of(context).brightness == Brightness.dark
                                    ? kDarkColorScheme.onPrimaryContainer
                                    : kColorScheme.onPrimaryContainer
                                        .withOpacity(0.6),
                            value: isSwitched[index],
                            onChanged: (newValue) {
                              _toggleSwitch(newValue, index);
                            },
                            activeColor: color,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          MarriageHomeScreen(conditions: isSwitched),
                    ),
                  );
                },
                child: StyledText(
                  text: "Proceed",
                  color: buttonColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
