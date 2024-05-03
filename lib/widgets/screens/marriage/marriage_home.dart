import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sajilo_hisab/main.dart';
import 'package:sajilo_hisab/widgets/screens/marriage/marriage_points_calculator.dart';
import 'package:sajilo_hisab/widgets/styled_text.dart';

class MarriageHomeScreen extends StatefulWidget {
  const MarriageHomeScreen({Key? key, required this.conditions})
      : super(key: key);
  final List<bool> conditions;
  @override
  State<MarriageHomeScreen> createState() => _MarriageHomeScreenState();
}

class _MarriageHomeScreenState extends State<MarriageHomeScreen> {
  int numberOfFields = 0;
  List<String> fieldNames = [];
  List<TextEditingController>? controllers;
  List<FocusNode>? focusNodes;

  TextEditingController numberController = TextEditingController();

  bool isPlayerCountGood = true;

  void checkPlayers() {
    setState(() {
      int? numberOfPlayers = int.tryParse(numberController.text);
      if (numberOfPlayers == null ||
          numberOfPlayers < 2 ||
          numberOfPlayers > 6) {
        if (Platform.isIOS) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: const StyledText(
                  text: 'Sorry',
                  textSize: 20,
                ),
                content: const StyledText(
                  text:
                      'There must be atleast 2 or less than 6 players to start the game. Please Provide the number of players playing with you!',
                  textSize: 16,
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const StyledText(
                  text: "Sorry",
                  textSize: 20,
                ),
                content: const StyledText(
                  text:
                      'There must be atleast 2  or less than 6 players to start the game. Please Provide the number of players playing with you!',
                  textSize: 16,
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
        isPlayerCountGood = false;
      } else {
        isPlayerCountGood = true;
      }
    });
  }

  void _showSnackBar(String message, int index) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );
    FocusScope.of(context).requestFocus(focusNodes![index]);
  }

  void _startCalculation() {
    bool allFieldsFilled = true;
    Set<String> uniqueNames = {}; // Keep track of unique names
    List<String> duplicateNames = []; // Store duplicate names

    if (controllers != null && focusNodes != null) {
      for (int i = 0; i < controllers!.length; i++) {
        String playerName = controllers![i]
            .text
            .trim(); // Trim leading and trailing whitespaces
        if (playerName.isEmpty) {
          _showSnackBar('Player ${i + 1} name is empty', i);
          allFieldsFilled = false;
          break;
        } else if (playerName.length < 3) {
          _showSnackBar(
              'Player ${i + 1} name must have 3 or more characters', i);
          allFieldsFilled = false;
          break;
        } else if (!uniqueNames.add(playerName)) {
          // If the name is already in the set, it's a duplicate
          duplicateNames.add(playerName);
        }
      }
    } else {
      allFieldsFilled = false;
    }

    if (!allFieldsFilled) {
      return; // Exit function if not all fields are filled
    }

    if (duplicateNames.isNotEmpty) {
      _showSnackBar(
          'Duplicate player names found: ${duplicateNames.join(', ')}',
          1); // Show duplicates in Snackbar
      return; // Exit function if duplicate names are found
    }

    // Proceed to calculator if all conditions are met
    List<String> playerNames =
        controllers!.map((controller) => controller.text.trim()).toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MarriagePointsCalculator(
          playerNames: playerNames,
          conditions: widget.conditions,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = Theme.of(context).brightness == Brightness.dark
        ? kDarkColorScheme.onPrimaryContainer
        : kColorScheme.onPrimary;

    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double textSize = 16.5;
    double padding = 10;

    if (screenWidth < 350 && screenWidth > 321) {
      textSize = 10;
      padding = 4;
    } else if (screenWidth < 321) {
      textSize = 9;
      padding = 0;
    } else if (screenWidth < 394 && screenWidth > 350) {
      textSize = 12;
      padding = 8;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 15),
          child: Text(
            "Marriage Calculator Home",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 21),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    maxLength: 1,
                    controller: numberController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: textColor),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      FilteringTextInputFormatter.allow(RegExp(r'[1-6]')),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Number Of Players',
                      labelStyle: TextStyle(
                        fontSize: textSize + 4,
                      ),
                      hintText: '(Minimum-2 Maximum-6) Players',
                      hintStyle: TextStyle(
                        fontSize: textSize,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(right: padding),
                  child: ElevatedButton(
                    onPressed: () {
                      checkPlayers();
                      if (isPlayerCountGood) {
                        setState(() {
                          numberOfFields =
                              int.tryParse(numberController.text) ?? 0;
                          fieldNames = List.generate(
                            numberOfFields,
                            (index) => 'Player ${index + 1} Name',
                          );
                          controllers = List.generate(
                            numberOfFields,
                            (index) => TextEditingController(),
                          );
                          focusNodes = List.generate(
                            numberOfFields,
                            (index) => FocusNode(),
                          );
                        });
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: numberOfFields,
                itemBuilder: (context, index) {
                  if (controllers != null && focusNodes != null) {
                    return TextField(
                      style: TextStyle(
                        color: textColor,
                      ),
                      controller: controllers![index],
                      focusNode: focusNodes![index],
                      maxLength: 15,
                      decoration: InputDecoration(
                        labelText: fieldNames.isNotEmpty
                            ? fieldNames[index]
                            : 'Player ${index + 1} Name',
                      ),
                    );
                  } else {
                    return const SizedBox(); // Return an empty widget if lists are not initialized
                  }
                },
              ),
            ),
            Visibility(
              visible: controllers != null && focusNodes != null,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ElevatedButton(
                  onPressed: _startCalculation,
                  child: const Text('Start Calculator'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
