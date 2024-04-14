import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sajilo_hisab/widgets/styled_text.dart';

class MarriageHomeScreen extends StatefulWidget {
  const MarriageHomeScreen({super.key});

  @override
  State<MarriageHomeScreen> createState() {
    return _MarriageHomeScreenState();
  }
}

class _MarriageHomeScreenState extends State<MarriageHomeScreen> {
  int numberOfFields = 0;
  List<String> fieldNames = [];

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
                    maxLength: 1, // Set maximum length to 1 digit
                    controller: numberController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter
                          .digitsOnly, // Allow only digits
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[1-6]')), // Allow only numbers from 1 to 6
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
                      if (isPlayerCountGood == true) {
                        setState(() {
                          numberOfFields =
                              int.tryParse(numberController.text) ?? 0;
                          fieldNames = List.generate(
                            numberOfFields,
                            (index) => 'Player ${index + 1} Name',
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
                  return TextField(
                    decoration: InputDecoration(
                      labelText: fieldNames.isNotEmpty
                          ? fieldNames[index]
                          : 'Player${index + 1} Name',
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Start Calculation'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: MarriageHomeScreen(),
  ));
}
