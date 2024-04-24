// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:sajilo_hisab/widgets/screens/marriage/marriage_home.dart';

class MarriagePlayerRules extends StatefulWidget {
  const MarriagePlayerRules({super.key});

  @override
  State<MarriagePlayerRules> createState() => _MarriagePlayerRulesState();
}

class _MarriagePlayerRulesState extends State<MarriagePlayerRules> {
  // bool isSwitched = true;
  List<bool> isSwitched = [true, true, true, false, false];

  void _toggleSwitch(bool value, int index) {
    setState(() {
      if (index < isSwitched.length) {
        isSwitched[index] = value;
      }
      if (index == 0 && isSwitched[0] == false) {
        isSwitched[3] = false;
      } else if (index == 3 && isSwitched[3] == true) {
        isSwitched[0] = true;
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
    String getTitle(int index) {
      if (index == 0) {
        return title = "Murder";
      } else if (index == 1) {
        return title = "Dublee";
      } else if (index == 2) {
        return title = "Dublee Point Less";
      } else if (index == 3) {
        return title = "Kidnap";
      } else {
        return title = "Fine System";
      }
    }

    String getInfoText(int index) {
      if (index == 0) {
        return infoText = "The Maal of Unseen Players Doesn't Count.";
      } else if (index == 1) {
        return "The Player With Dublee get's 5 Points Bonus, if the Player Finishes the Game.";
      } else if (index == 2) {
        return infoText =
            "The Player with Dublee Should not Pay 3 Points to the Winner.";
      } else if (index == 3) {
        return infoText =
            "The Unseen Player/s Should Pay for Their Points too.";
      } else {
        return infoText = "Pay Fine Amount in the Same Game.";
      }
    }

    FocusManager.instance.primaryFocus?.unfocus();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: screenSize.height,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              "Marriage Players Rule",
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          for (int index = 0;
                              index < isSwitched.length;
                              index++)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: SizedBox(
                                height: 95,
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
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            getInfoText(index),
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color.fromARGB(255, 201, 199,
                                            199), // Background color of the circle
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const MarriagePlayerRules(),
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                            Icons.question_mark_outlined),
                                      ),
                                    ),
                                    SizedBox(
                                      width: screenSize.width - 340,
                                    ),
                                    Switch(
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
                            padding: const EdgeInsets.only(top: 0.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => MarriageHomeScreen(
                                        conditions: isSwitched),
                                  ),
                                );
                              },
                              child: const Text("Proceed"),
                            ),
                          )
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
