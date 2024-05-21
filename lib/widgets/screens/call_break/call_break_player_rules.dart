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

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: screenSize.width - 10,
            height: screenSize.height + 180,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              "CallBreak Players Rule",
                              style: TextStyle(fontSize: 32),
                            ),
                          ),
                          for (int index = 0;
                              index < isSwitched.length;
                              index++)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: SizedBox(
                                height: 125,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            getTitle(index),
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            getInfoText(index),
                                            style: const TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            color, // Background color of the circle
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
                                            color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(
                                      width: screenSize.width - 340,
                                    ),
                                    Switch(
                                      activeTrackColor: Theme.of(context)
                                                  .brightness ==
                                              Brightness.dark
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
                            ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
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
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
