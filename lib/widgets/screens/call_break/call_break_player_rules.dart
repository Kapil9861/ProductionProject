// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:sajilo_hisab/main.dart';
import 'package:sajilo_hisab/widgets/screens/call_break/call_break_home.dart';
import 'package:sajilo_hisab/widgets/screens/call_break/call_break_rules.dart';
import 'package:sajilo_hisab/widgets/styled_text.dart';

class CallBreakPlayerRules extends StatefulWidget {
  const CallBreakPlayerRules({super.key});

  @override
  State<CallBreakPlayerRules> createState() => _CallBreakPlayerRulesState();
}

class _CallBreakPlayerRulesState extends State<CallBreakPlayerRules> {
  // bool isSwitched = true;
  List<bool> isSwitched = [false, false, true, true];

  void _toggleSwitch(bool value, int index) {
    setState(() {
      if (index < isSwitched.length) {
        isSwitched[index] = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String title;
    String infoText;
    Size screenSize = MediaQuery.of(context).size;
    Color color = Theme.of(context).colorScheme.onPrimaryContainer;
    if (Theme.of(context).brightness == Brightness.dark) {
      color = Theme.of(context).colorScheme.onPrimary;
    }
    Color buttonColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : kColorScheme.onPrimaryContainer;

    String getTitle(int index) {
      if (index == 0) {
        return title = "Double Pay";
      } else if (index == 1) {
        return title = "Double Receive";
      } else if (index == 2) {
        return title = "Sum Of Nine";
      } else {
        return title = "Direct Winner";
      }
    }

    String getInfoText(int index) {
      if (index == 0) {
        return infoText = "Pay Double When You Get Negative Total Points.";
      } else if (index == 1) {
        return infoText = "Receive Double When You Cross Total of 20 Points.";
      } else if (index == 2) {
        return infoText =
            "This will help you to notify if the sum of all the players initial points(HAAT) is less than 10.";
      } else {
        return infoText =
            "Finish the complete round (whole game) if player receives 8 or more successful points(HAAT)";
      }
    }

    double width = screenSize.width;

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
                      height: width < 340 ? 160 : 115,
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
                                    builder: (context) =>
                                        const CallBreakRules(),
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
                          CallBreakHome(conditions: isSwitched),
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
