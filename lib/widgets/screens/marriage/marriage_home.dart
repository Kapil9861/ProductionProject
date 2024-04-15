import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sajilo_hisab/widgets/styled_text.dart';

class MarriageHomeScreen extends StatefulWidget {
  const MarriageHomeScreen({Key? key}) : super(key: key);

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
                  text: 'This is a warning message for iOS.',
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
                  text: 'This is a warning message for Android.',
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
    FocusScope.of(context).requestFocus(focusNodes![index]);
  }

  void _startCalculation() {
    bool allFieldsFilled = true;
    if (controllers != null && focusNodes != null) {
      for (int i = 0; i < controllers!.length; i++) {
        if (controllers![i].text.isEmpty) {
          _showSnackBar('Player ${i + 1} name is empty', i);
          allFieldsFilled = false;
          break;
        } else if (controllers![i].text.length < 3) {
          _showSnackBar(
              'Player ${i + 1} name must have 3 or more characters', i);
          allFieldsFilled = false;
          break;
        }
      }
    } else {
      allFieldsFilled = false;
    }
    if (allFieldsFilled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Success'),
          duration: Duration(seconds: 2),
        ),
      );
      // Add your logic for calculation or navigation here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      FilteringTextInputFormatter.allow(RegExp(r'[1-6]')),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Number Of Players (Min-2 Max-6)',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
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
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: numberOfFields,
                itemBuilder: (context, index) {
                  if (controllers != null && focusNodes != null) {
                    return TextField(
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
                    return SizedBox(); // Return an empty widget if lists are not initialized
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: ElevatedButton(
                onPressed: _startCalculation,
                child: const Text('Start Calculation'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
