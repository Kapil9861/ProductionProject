import 'dart:collection';
import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:sajilo_hisab/main.dart';
import 'package:sajilo_hisab/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:sajilo_hisab/widgets/chart/chart.dart';
import 'package:sajilo_hisab/widgets/styled_text.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class CallBreakPointsCalculator extends StatefulWidget {
  const CallBreakPointsCalculator({
    super.key,
    required this.playerNames,
    required this.conditions,
  });
  final List<String> playerNames;
  final List<bool> conditions;

  @override
  State<CallBreakPointsCalculator> createState() =>
      _CallBreakPointsCalculatorState();
}

class _CallBreakPointsCalculatorState extends State<CallBreakPointsCalculator> {
  List<TextEditingController> _individualInitialPointsController = [];
  List<TextEditingController> _individualResultPointsController = [];
  List<TextEditingController> _amountController = [];
  final TextEditingController _notesController = TextEditingController();
  final List<num> _individualResults = [];
  final ScreenshotController screenshotController = ScreenshotController();
  Color? textColor;
  String lockButtonText = "Lock";

  List<FocusNode> pointsFocusNodes = [];
  List<FocusNode> amountNode = [];
  double playerNameFont = 17;
  bool _speechEnabled = false;
  double _confidenceLevel = 0.0;
  final SpeechToText _speechToText = SpeechToText();
  List<String> helperText = [];

  List<double> amounts = [];
  String buttonText = "Start";
  bool state = false;
  List<FocusNode> focusNodes = [];
  List<FocusNode> focusNodes1 = [];
  bool status = true;
  bool isAmountValid = false;
  String calculateButtonText = "Calculate";

  int calculationRunCount = 0;
  LinkedHashMap<String, num> individualWinPoints = LinkedHashMap<String, num>();
  List<LinkedHashMap<String, num>> allIndividualWinPoints = [];
  List<List<String>> allPlayerNames = [];
  List<String> allNotes = [];
  List<double> allLossAmount = [];
  Map<String, num> semiFinalPoints = {};
  Map<String, num> finalPoints = {};
  Map<String, int> playerRanks = {};
  bool isCalculating = false;

  String information =
      "The individual players commit point (BOLEKO HAAT) must be greater than 0 and less than 13! \n ALso the same for result points (HAAT) and the TOTAL POINTS should not exceed 13!";

  String dialogBoxText = 'Sorry';
  void showSnackBar(String message) {
    Color color;
    if (message == "Amount Added!" ||
        message == "Started Game!" ||
        message == "Game Completed! Please See Results!") {
      color = Colors.green;
    } else if (message == "Succcessfully Added In Results Table!") {
      color = const Color.fromARGB(255, 24, 225, 31);
    } else if (message == "Entered Final Round!") {
      color = const Color.fromARGB(255, 223, 216, 12);
    } else {
      color = Colors.red;
    }
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: color,
      ),
    );
  }

  String? _validAmount(String? value, int index) {
    if (value == null || value.isEmpty) {
      if (index == 0) {
        return "2ND";
      } else if (index == 1) {
        return "3RD";
      } else {
        return "4TH";
      }
    } else {
      double amount = double.parse(
        value.replaceAll(RegExp(r'[^0-9.]'), ''),
      );
      if (amount < 5 || amount > 99999) {
        if (index == 0) {
          return "2ND";
        } else if (index == 1) {
          return "3RD";
        } else {
          return "4TH";
        }
      } else {
        isAmountValid = true;
        return null;
      }
    }
  }

  void _validateAmount(int calculationCount) {
    bool success = false;
    for (int i = 0; i < widget.playerNames.length - 1; i++) {
      String? value = _amountController[i].text;
      if (value.isEmpty) {
        FocusScope.of(context).requestFocus(amountNode[i]);
      } else {
        double amount = double.parse(
          value.replaceAll(RegExp(r'[^0-9.]'), ''),
        );
        if (amount < 5 || amount > 100000) {
          showSnackBar("Amount for looser $i is Invalid!");
        } else {
          double secondValue = double.parse(
            _amountController[1].text.replaceAll(RegExp(r'[^0-9.]'), ''),
          );
          double firstValue = double.parse(
            _amountController[0].text.replaceAll(RegExp(r'[^0-9.]'), ''),
          );
          double thirdValue = double.parse(
            _amountController[2].text.replaceAll(RegExp(r'[^0-9.]'), ''),
          );
          if (i == 2 &&
              secondValue > 4 &&
              secondValue < 100000 &&
              firstValue > 4 &&
              firstValue < 100000 &&
              thirdValue > 4 &&
              thirdValue < 100000) {
            (calculationCount == -1) ? showSnackBar("Started Game!") : null;

            success = true;

            setState(() {
              buttonText = "Running";
            });
          }
          if (success) {
            amounts.add(firstValue);
            amounts.add(secondValue);
            amounts.add(thirdValue);
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initSpeech();
  }

  @override
  void dispose() {
    super.dispose();
    Hive.deleteFromDisk();
    Hive.close();
    allIndividualWinPoints.clear();
    allLossAmount.clear();
    allNotes.clear();
    allPlayerNames.clear();
  }

  void _initializeControllers() {
    _individualInitialPointsController = List.generate(
      widget.playerNames.length,
      (index) => TextEditingController(),
    );
    _individualResultPointsController = List.generate(
      widget.playerNames.length,
      (index) => TextEditingController(),
    );
    _amountController = List.generate(
      widget.playerNames.length - 1,
      (index) => TextEditingController(),
    );
    amountNode = List.generate(
      widget.playerNames.length - 1,
      (index) => FocusNode(),
    );
    focusNodes = List.generate(
      widget.playerNames.length,
      (index) => FocusNode(),
    );
    focusNodes1 = List.generate(
      widget.playerNames.length,
      (index) => FocusNode(),
    );
    for (int i = 0; i < widget.playerNames.length; i++) {
      individualWinPoints[widget.playerNames[i]] = 0;
    }
    _individualResults.add(0);
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _confidenceLevel = result.confidence;
      if (result.finalResult) {
        _notesController.text = result.recognizedWords;
      }
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _confidenceLevel = 0;
    });
  }

  int _checkFinalPoints() {
    double totalPoints = 0;
    for (int i = 0; i < _individualResultPointsController.length; i++) {
      if (_individualResultPointsController[i].text.isNotEmpty) {
        double individualPoint = double.parse(
          _individualResultPointsController[i]
              .text
              .replaceAll(RegExp(r'[^0-9.]'), ''),
        );
        if (individualPoint.isNegative ||
            individualPoint < 0 ||
            individualPoint > 13) {
          showDialogBox(
              "Players' result point should not exceed 13 and cannot be negative!");
          FocusScope.of(context).requestFocus(focusNodes1[i]);
          return 1;
        } else {
          totalPoints += individualPoint;
        }
      } else {
        showSnackBar("Player $i Field is Empty!");
        FocusScope.of(context).requestFocus(focusNodes1[i]);
        return 1;
      }
    }
    if (totalPoints != 13) {
      showDialogBox(
          "Players' total result point should be exactly be 13, currently it is $totalPoints!");
      return 1;
    } else {
      return 0;
    }
  }

  int _checkInitialPoints() {
    for (int i = 0; i < _individualInitialPointsController.length; i++) {
      if (_individualInitialPointsController[i].text.isNotEmpty) {
        double individualPoint = double.parse(
          _individualInitialPointsController[i]
              .text
              .replaceAll(RegExp(r'[^0-9.]'), ''),
        );
        if (individualPoint.isNegative ||
            individualPoint < 1 ||
            individualPoint > 13) {
          showDialogBox(
              "Players must commit a point, minimum of 1 to maximum 13!");
          FocusScope.of(context).requestFocus(focusNodes[i]);
          return 1;
        }
      } else {
        showSnackBar("Empty points for player $i");
        FocusScope.of(context).requestFocus(focusNodes[i]);
        return 1;
      }
    }
    return 0;
  }

  Future _startCalculation() async {
    if (calculateButtonText == "Continue Playing") {
      setState(() {
        calculateButtonText = "Calculate";
      });
      allIndividualWinPoints.clear();
      allLossAmount.clear();
      allNotes.clear();
      allPlayerNames.clear();
      Hive.deleteFromDisk();
      return 0;
    }
    _lock();
    amounts.clear();
    _validateAmount(calculationRunCount);

    if (_checkFinalPoints() != 0 || _checkInitialPoints() != 0) {
      return 1;
    }
    int initialPointsStatus = 0;

    if (isAmountValid) {
      if (calculateButtonText == "Continue Playing") {}
      String? notes = _notesController.text;
      int sumOftotal = 0;
      for (int i = 0; i < widget.playerNames.length; i++) {
        int initialPoints = int.parse(
          _individualInitialPointsController[i]
              .text
              .replaceAll(RegExp(r'[^0-9.]'), ''),
        );
        initialPointsStatus += initialPoints;

        int finalPoints = int.parse(
          _individualResultPointsController[i]
              .text
              .replaceAll(RegExp(r'[^0-9.]'), ''),
        );

        int otti = finalPoints - initialPoints;
        if (otti < 0) {
          textColor = Colors.red;
        }

        num individualResult =
            otti < 0 ? -initialPoints : double.parse("$initialPoints.$otti");

        individualWinPoints[widget.playerNames[i]] = individualResult;
        if (individualResult >= 8 && widget.conditions[3] == true) {
          dialogBoxText = "Game Complete By ${widget.playerNames[i]}";
          showDialogBox(
              "            Congratulations!\nPlayer ${widget.playerNames[i].toUpperCase()} successfully completed the game by achieving $individualResult points.");
          setState(() {
            calculateButtonText = "Continue Playing";
          });
        }
        sumOftotal = initialPointsStatus;
      }
      if (sumOftotal < 10 && widget.conditions[2] == true) {
        bool isOkClicked = false;
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: StyledText(
                text: "Warning!",
                textSize: 20,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
              content: StyledText(
                text:
                    "Your initial points is less than 10\n Please provide points again or continue like this.",
                textSize: 14,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                    isOkClicked = false;
                  },
                  child: const Text('Continue'),
                ),
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                    isOkClicked = true;
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        if (isOkClicked == true) {
          return 1;
        }
      }

      var individualCallBreakPointsBox =
          await Hive.openBox('individualCallBreakPoints');

      var playerNamesBox = await Hive.openBox('playerNames');
      var notesBox = await Hive.openBox('notes');
      var loosersAmountBox = await Hive.openBox("loosersAmount");
      //Storing data
      individualCallBreakPointsBox.put(
          'individualCallBreakPoints$calculationRunCount', individualWinPoints);
      playerNamesBox.put('playerNames$calculationRunCount', widget.playerNames);
      notesBox.put('notes$calculationRunCount', notes);
      loosersAmountBox.put('loosersAmount', amounts);
      individualCallBreakPointsBox
          .get('individualCallBreakPoints$calculationRunCount');
      String individualWinPointsKey =
          'individualCallBreakPoints$calculationRunCount';
      String playerNamesKey = 'playerNames$calculationRunCount';
      String notesKey = 'notes$calculationRunCount';
      String loosersAmountKey = 'loosersAmount';

      // Retrieve values from the boxes
      if (individualCallBreakPointsBox.containsKey(individualWinPointsKey)) {
        LinkedHashMap<String, num> individualWinPointsCopy =
            LinkedHashMap<String, num>.from(individualWinPoints);
        allIndividualWinPoints.add(individualWinPointsCopy);
        allPlayerNames.add(playerNamesBox.get(playerNamesKey));

        allNotes.add(notesBox.get(notesKey));
        allLossAmount = loosersAmountBox.get(loosersAmountKey);
        if (calculationRunCount == 3) {
          semiFinalPoints = aggregatePlayerWinnings(allIndividualWinPoints);
          showSnackBar("Entered Final Round!");
        } else if (calculationRunCount == 4) {
          setState(() {
            calculateButtonText = "Continue Playing";
          });
          finalPoints = aggregatePlayerWinnings(allIndividualWinPoints);
          calculationRunCount = -1;
          var sortedEntries = finalPoints.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));
          int rank = 1;
          for (int i = 0; i < sortedEntries.length; i++) {
            if (i > 0 && sortedEntries[i].value != sortedEntries[i - 1].value) {
              rank = i + 1;
            }
            playerRanks[sortedEntries[i].key] = rank;
          }
          num maxPoints = finalPoints.values.reduce((a, b) => a > b ? a : b);
          if (widget.conditions[1] == true && maxPoints >= 20) {
            setState(() {
              for (int i = 0; i < allLossAmount.length; i++) {
                allLossAmount[i] *= 2;
              }
            });
          } else if (widget.conditions[0] == true) {
            for (String key in finalPoints.keys) {
              if (playerRanks.containsKey(key) && finalPoints[key]! < 0) {
                if (playerRanks[key] != 1) {
                  int index = playerRanks[key]!;
                  allLossAmount[index - 2] *= 2;
                }
              }
            }
          }
          showSnackBar("Game Completed! Please See Results!");
        } else {
          showSnackBar("Succcessfully Added In Results Table!");
        }
        setState(() {
          calculationRunCount++;
          lockButtonText = "Lock";
        });
      }

      status = true;
      clearControllers();
      return 0;
    } else {
      showSnackBar("Amounts Cannot Be Empty!");
      return 1;
    }
  }

  Map<String, num> aggregatePlayerWinnings(
      List<Map<String, num>> allIndividualWinPoints) {
    Map<String, num> totalWinnings = {};

    for (var gameResults in allIndividualWinPoints) {
      gameResults.forEach((playerName, winnings) {
        if (totalWinnings.containsKey(playerName)) {
          totalWinnings[playerName] = totalWinnings[playerName]! + winnings;
        } else {
          totalWinnings[playerName] = winnings;
        }
      });
    }

    return totalWinnings;
  }

  void clearControllers() {
    for (int i = 0; i < widget.playerNames.length; i++) {
      _notesController.clear();
      _individualInitialPointsController[i].clear();
      _individualResultPointsController[i].clear();
    }
  }

  void _lock() {
    setState(() {
      _checkInitialPoints() == 0 ? status = false : true;
      if (status == false) {
        lockButtonText = "Locked";
      }
    });
  }

  void _unlock() {
    setState(() {
      if (status == false && lockButtonText == "Locked") {
        lockButtonText = "Lock";
        status = true;
      }
    });
  }

  void showDialogBox(String information) {
    if (Platform.isIOS) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: StyledText(
              text: dialogBoxText,
              textSize: 20,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
            content: StyledText(
              text: information,
              textSize: 14,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
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
            title: StyledText(
              text: dialogBoxText,
              textSize: 20,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
            content: StyledText(
              text: information,
              textSize: 14,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color textColor = isDarkMode
        ? kDarkColorScheme.onPrimaryContainer
        : kColorScheme.onTertiaryContainer;
    Color tileColor = isDarkMode
        ? kDarkColorScheme.onPrimaryContainer
        : kColorScheme.inversePrimary;
    Color totalTileColor = isDarkMode
        ? kDarkColorScheme.onPrimary.withGreen(70)
        : kColorScheme.onPrimaryContainer.withBlue(110);
    Color totalsColor = Colors.white;

    Color backgroundColor =
        isDarkMode ? const Color.fromARGB(255, 27, 29, 27) : Colors.white;
    Size screenSize = MediaQuery.of(context).size;

    double buttonWidthPercentage = screenSize.width * 0.245;
    double buttonHeightPercentage = screenSize.height * 0.05;
    double notesArea = screenSize.width * 0.70;
    double individualColumnWidth = (screenSize.width - 50) / 5;

    double textError = 14;
    double playerNameFont = 16;
    double playerNameArea = 83;
    double pointsArea = 95;
    double padding = 10;
    int amountButtonWidth = 125;
    int amountButtonHeight = 55;
    if (screenSize.width > 400) {
      textError = 15;
    }

    Future<void> shareScreenshot() async {
      if (allIndividualWinPoints.isNotEmpty) {
        Future.delayed(const Duration(seconds: 2));
        Uint8List? image = await screenshotController.capture();
        Share.shareXFiles([
          XFile.fromData(
            image!,
            mimeType: "png",
            name: "CallBreak Points Report",
          ),
        ]);
      } else {
        showSnackBar("Nothing To Share");
      }
    }

    Future<bool?> showBackDialog() {
      if (allIndividualWinPoints.isNotEmpty) {
        return showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return Platform.isIOS
                ? CupertinoAlertDialog(
                    title: StyledText(
                      text: 'Are you sure?',
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    content: const Center(
                      child: Text(
                        'Are you sure you?\n Your game data will be removed!',
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: const Text('Nevermind'),
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: const Text('Leave'),
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                      ),
                    ],
                  )
                : AlertDialog(
                    title: StyledText(
                      text: 'Are you sure?',
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    content: const Text(
                      'Are you sure you want to leave this page?',
                    ),
                    actions: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: const Text('Nevermind'),
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: const Text('Leave'),
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                      ),
                    ],
                  );
          },
        );
      } else {
        return Future.value(true);
      }
    }

    Widget toShareWidget(BuildContext context) {
      return Screenshot(
        controller: screenshotController,
        child: SizedBox(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 10, right: 10, left: 10),
                child: Text(
                  'Game Results:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Table(
                  columnWidths: {
                    for (var i = 0; i < widget.playerNames.length; i++)
                      i: const FlexColumnWidth(1),
                  },
                  border: TableBorder.all(),
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      children: [
                        ...widget.playerNames.map((name) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: Text(
                              name.toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: playerNameFont - 1),
                            )),
                          );
                        }).toList(),
                        const Padding(
                          padding: EdgeInsets.only(left: 5, top: 8, right: 5),
                          child: StyledText(
                            text: "NOTES",
                            textSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 10, right: 5, left: 5),
                child: SizedBox(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: allIndividualWinPoints.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Dismissible(
                            key: UniqueKey(),
                            direction: DismissDirection.horizontal,
                            confirmDismiss: (direction) async {
                              return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: StyledText(
                                      text: "Delete Item",
                                      color: textColor,
                                    ),
                                    content: const Text(
                                      "              Are you sure?\n You want to delete this item?",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text("No"),
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                      ),
                                      TextButton(
                                        child: const Text("Yes"),
                                        onPressed: () {
                                          setState(() {
                                            allIndividualWinPoints
                                                .removeAt(index);
                                            allPlayerNames.removeAt(index);
                                            allNotes.removeAt(index);
                                            allLossAmount.clear();
                                            calculationRunCount--;
                                            semiFinalPoints =
                                                aggregatePlayerWinnings(
                                                    allIndividualWinPoints);
                                          });
                                          Navigator.of(context).pop(true);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Column(
                              children: [
                                ListTile(
                                  tileColor: index % 2 != 0 ? tileColor : null,
                                  subtitle: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      for (int i = 0;
                                          i < widget.playerNames.length;
                                          i++)
                                        SizedBox(
                                          width: individualColumnWidth,
                                          child: StyledText(
                                            text: allIndividualWinPoints[index]
                                                    [widget.playerNames[i]]
                                                .toString(),
                                            color: index % 2 != 0
                                                ? kColorScheme.inverseSurface
                                                : isDarkMode
                                                    ? kDarkColorScheme
                                                        .inversePrimary
                                                    : kColorScheme
                                                        .inverseSurface,
                                          ),
                                        ),
                                      SizedBox(
                                        width: individualColumnWidth,
                                        child: StyledText(
                                          text: allNotes[index],
                                          textSize: 13,
                                          color: index % 2 != 0
                                              ? kColorScheme.inverseSurface
                                              : isDarkMode
                                                  ? kDarkColorScheme
                                                      .inversePrimary
                                                  : kColorScheme.inverseSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (index == 3)
                            ListTile(
                              tileColor: totalTileColor,
                              subtitle: Row(
                                children: [
                                  for (var i = 0; i < 4; i++)
                                    SizedBox(
                                      width: individualColumnWidth,
                                      child: StyledText(
                                        text: semiFinalPoints[
                                                widget.playerNames[i]]!
                                            .toStringAsFixed(1),
                                        textSize: 18,
                                        color: totalsColor,
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: StyledText(
                                      text: "TOTAL",
                                      textSize: 16,
                                      color: totalsColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (index == 4)
                            ListTile(
                              tileColor: totalTileColor,
                              subtitle: Row(
                                children: [
                                  for (var i = 0; i < 4; i++)
                                    SizedBox(
                                      width: individualColumnWidth,
                                      child: StyledText(
                                        text:
                                            finalPoints[widget.playerNames[i]]!
                                                .toStringAsFixed(1),
                                        textSize: 18,
                                        color: totalsColor,
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: StyledText(
                                      text: "TOTAL",
                                      textSize: 16,
                                      color: index % 2 != 0
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (index == 4)
                            ListTile(
                              tileColor: totalTileColor,
                              subtitle: Row(
                                children: [
                                  for (var i = 0; i < 4; i++)
                                    SizedBox(
                                      width: individualColumnWidth,
                                      child: StyledText(
                                        text: playerRanks[
                                                    widget.playerNames[i]] ==
                                                1
                                            ? "Winner"
                                            : playerRanks[widget
                                                        .playerNames[i]] ==
                                                    2
                                                ? "2ND (-${allLossAmount[0]})"
                                                : playerRanks[widget
                                                            .playerNames[i]] ==
                                                        3
                                                    ? "3RD (-${allLossAmount[1]})"
                                                    : "4TH (-${allLossAmount[2]})",
                                        textSize: 14,
                                        color: totalsColor,
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: StyledText(
                                      text: "Results",
                                      textSize: 14,
                                      color: totalsColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      child: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) async {
          if (didPop) {
            return;
          }
          final bool shouldPop = await showBackDialog() ?? false;
          if (context.mounted && shouldPop) {
            Navigator.pop(context);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Call Break Points Calculator',
              style: TextStyle(fontSize: playerNameFont + 4),
            ),
          ),
          body: Flex(
            direction: Axis.vertical,
            children: [
              Container(
                color: backgroundColor,
                height: buttonHeightPercentage * 4 - 20,
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          for (int i = 0;
                              i < widget.playerNames.length - 1;
                              i++)
                            Padding(
                              padding: EdgeInsets.only(
                                  left: screenSize.width > 400
                                      ? padding + 3
                                      : padding - 4,
                                  top: 10),
                              child: SizedBox(
                                height: 70,
                                width: screenSize.width < 390 &&
                                        screenSize.width > 350
                                    ? buttonWidthPercentage - 13
                                    : buttonWidthPercentage - 20,
                                child: TextFormField(
                                  style: TextStyle(color: textColor),
                                  onChanged: (value) {
                                    _validAmount(value, i) == null
                                        ? showSnackBar("Amount Added!")
                                        : {
                                            showSnackBar("Invalid Amount"),
                                            setState(() {
                                              buttonText = "Start ";
                                            })
                                          };
                                  },
                                  controller: _amountController[i],
                                  focusNode: amountNode[i],
                                  maxLength: 5,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: "Amount",
                                    helperText: i == 0
                                        ? "2ND"
                                        : i == 1
                                            ? "3RD"
                                            : "4TH",
                                    helperStyle:
                                        TextStyle(fontSize: textError - 2.5),
                                    hintStyle:
                                        TextStyle(fontSize: textError - 2.5),
                                    errorText: _validAmount(
                                        _amountController[i].text, i),
                                    errorStyle:
                                        TextStyle(fontSize: textError - 2),
                                    border: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                      gapPadding: 4,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 0,
                                bottom: 15,
                                left: 5,
                                right: screenSize.width < 390 &&
                                        screenSize.width > 350
                                    ? 5
                                    : 10),
                            child: CustomButton(
                              onPressed: () {
                                _validateAmount(-1);
                              },
                              buttonText: buttonText,
                              width: amountButtonWidth - 20,
                              height: screenSize.height < 625
                                  ? amountButtonHeight - 20
                                  : amountButtonHeight - 7,
                              fontSize: playerNameFont - 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 6, right: 11, left: 11),
                      child: Text(
                        "Amount For Players Those Lost! Min-5 Max-99999!",
                        style: TextStyle(
                          color: Color.fromARGB(255, 60, 125, 179),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 8,
                child: SingleChildScrollView(
                  child: SizedBox(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: screenSize.width > 400
                                    ? 10
                                    : screenSize.height < 625
                                        ? 55
                                        : 26,
                              ),
                              Text(
                                "INITIAL POINTS",
                                style: TextStyle(
                                    fontSize: playerNameFont - 4,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Text(
                                "FINAL POINTS",
                                style: TextStyle(
                                    fontSize: playerNameFont - 4,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        for (int i = 0; i < widget.playerNames.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  child: SizedBox(
                                    width: playerNameArea,
                                    child: Text(
                                      widget.playerNames[i].toUpperCase(),
                                      style:
                                          TextStyle(fontSize: playerNameFont),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0, left: 7, right: 7),
                                  child: SizedBox(
                                    width: pointsArea,
                                    child: TextFormField(
                                      style: TextStyle(color: textColor),
                                      enabled: status,
                                      focusNode: focusNodes[i],
                                      controller:
                                          _individualInitialPointsController[i],
                                      decoration: InputDecoration(
                                        helperText: "MAX-13",
                                        hintText: "MIN-1",
                                        hintStyle: TextStyle(
                                            fontSize: playerNameFont - 4),
                                        helperStyle: TextStyle(
                                            fontSize: playerNameFont - 5),
                                        border: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                          gapPadding: 4,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(6),
                                          ), // Border radius
                                        ),
                                      ),
                                      maxLength: 3,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^[0-9]*$')),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0, left: 7, right: 7),
                                  child: SizedBox(
                                    width: pointsArea,
                                    child: TextFormField(
                                      style: TextStyle(color: textColor),
                                      focusNode: focusNodes1[i],
                                      controller:
                                          _individualResultPointsController[i],
                                      decoration: InputDecoration(
                                        helperText: "MAX-13",
                                        hintText: "MIN-0",
                                        hintStyle: TextStyle(
                                            fontSize: playerNameFont - 4),
                                        helperStyle: TextStyle(
                                            fontSize: playerNameFont - 5),
                                        border: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                          gapPadding: 4,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(6),
                                          ), // Border radius
                                        ),
                                      ),
                                      maxLength: 3,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^[0-9]*$')),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Padding(
                          padding: EdgeInsets.only(
                              right: screenSize.height < 625 ? 45 : 75),
                          child: CustomButton(
                            onPressed: () {
                              lockButtonText == "Locked" ? _unlock() : _lock();
                            },
                            buttonText: lockButtonText,
                            width: 105,
                            fontSize: playerNameFont - 1.5,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 6, right: 6),
                                child: Text(
                                  "NOTES: ",
                                  style: TextStyle(
                                      fontSize: playerNameFont,
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: padding),
                                    child: SizedBox(
                                      height: 150,
                                      width: notesArea,
                                      child: TextFormField(
                                        style: TextStyle(
                                            fontSize: playerNameFont - 1,
                                            color: textColor),
                                        controller: _notesController,
                                        maxLength: 150,
                                        maxLines: 6,
                                        onTap: () {
                                          _startListening();
                                        },
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                            borderSide: BorderSide(
                                                width: 2, color: Colors.grey),
                                          ),
                                          hintText: _speechToText.isListening
                                              ? "Listening..."
                                              : _speechEnabled
                                                  ? "Please tap on the microphone to start the voice assistant"
                                                  : "Permission denied for the microphone",
                                          hintStyle: TextStyle(
                                              fontSize: playerNameFont - 3),
                                          helperText:
                                              "Incomplete Transaction or Foul Play",
                                          helperStyle: TextStyle(
                                              fontSize: playerNameFont - 5),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (_speechToText.isNotListening &&
                                      _confidenceLevel > 0)
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: Text(
                                        "Confidence : ${(_confidenceLevel * 100).toStringAsFixed(1)}%",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        FloatingActionButton(
                          tooltip: 'Listen',
                          onPressed: _speechToText.isListening
                              ? _stopListening
                              : _startListening,
                          child: Icon(_speechToText.isNotListening
                              ? Icons.mic_off
                              : Icons.mic),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 20),
                          child: CustomButton(
                            onPressed: _startCalculation,
                            buttonText: calculateButtonText,
                            fontSize: playerNameFont,
                          ),
                        ),
                        toShareWidget(context),
                        Container(
                          height: 40,
                          width: 180,
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? kDarkColorScheme.onTertiary.withOpacity(0.6)
                                : kColorScheme.onPrimaryContainer
                                    .withOpacity(0.6),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50)),
                          ),
                          child: Center(
                            child: InkWell(
                              onTap: shareScreenshot,
                              child: Container(
                                height: 30,
                                width: 167,
                                decoration: const BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                ),
                                child: const Center(
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 10.0, right: 5),
                                        child: Icon(Icons.mobile_screen_share),
                                      ),
                                      Text(
                                        'Share Results',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: screenSize.height * 0.01,
                            right: screenSize.height * 0.01,
                          ),
                          child: SizedBox(
                            height: screenSize.height * 0.40,
                            width: screenSize.width * 0.95,
                            child: Chart(
                                playerNames: widget.playerNames,
                                individualWinPoints: individualWinPoints),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
