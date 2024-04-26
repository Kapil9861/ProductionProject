import 'dart:collection';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sajilo_hisab/widgets/buttons/custom_button.dart';
import 'package:sajilo_hisab/widgets/screens/marriage/marriage_home.dart';
import 'package:sajilo_hisab/widgets/styled_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class MarriagePointsCalculator extends StatefulWidget {
  const MarriagePointsCalculator(
      {Key? key, required this.playerNames, required this.conditions})
      : super(key: key);
  final List<String> playerNames;
  final List<bool> conditions;

  @override
  State<MarriagePointsCalculator> createState() =>
      _MarriagePointsCalculatorState();
}

class _MarriagePointsCalculatorState extends State<MarriagePointsCalculator> {
  final TextEditingController _notesController = TextEditingController();
  List<List<TextEditingController>> _nameControllersList = [];
  List<TextEditingController> _individualPointsController = [];
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _fineController = TextEditingController();
  String buttonText = "Start";
  String winnerButton = "Didn't Win";
  FocusNode amountNode = FocusNode();
  FocusNode fineNode = FocusNode();
  List<FocusNode> focusNodes = [];
  final List<String> _playersResult = [];
  final List<String> _winOrLoss = [];
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  double _confidenceLevel = 0.0;
  double _amountValue = 0.0;
  int doubleeBonus = 5;
  List<bool> status = [];
  final List<double> pointsCollection = [];
  double totalPoints = 0;
  HashMap<String, int> points = HashMap<String, int>();
  bool fine = false;
  int winnerCount = 0;
  bool breakOperation = false;
  final List<double> forWinnerWinning = [];
  double finePoint = 15;

  @override
  void initState() {
    super.initState();
    _initializeNameControllers();
    _initializePlayerResults();
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _initializeNameControllers() {
    _nameControllersList = List.generate(widget.playerNames.length, (index) {
      return List.generate(
        widget.playerNames.length,
        (index) => TextEditingController(),
      );
    });
    _individualPointsController = List.generate(
      widget.playerNames.length,
      (index) => TextEditingController(),
    );
    focusNodes = List.generate(
      widget.playerNames.length,
      (index) => FocusNode(),
    );
    status = List.generate(
      widget.playerNames.length,
      (index) => true,
    );
  }

  void _initializePlayerResults() {
    for (int index = 0; index < widget.playerNames.length; index++) {
      _playersResult.add("Seen");
      _winOrLoss.add("Didn't Win");
    }
  }

  void changeSeenState(int index) {
    setState(() {
      if (index >= 0 && index < _playersResult.length) {
        if (_playersResult[index] == "Seen") {
          _playersResult[index] = "Unseen";
          _winOrLoss[index] = "Didn't Win";
        } else if (_playersResult[index] == "Unseen") {
          _playersResult[index] = "Dublee";
        } else if (_playersResult[index] == "Dublee") {
          _playersResult[index] = "Foul";
        } else if (_playersResult[index] == "Foul") {
          _playersResult[index] = "Hold";
          _winOrLoss[index] = "Didn't Win";
        } else if (_playersResult[index] == "Hold") {
          _playersResult[index] = "Seen";
        }

        if ((_playersResult[index] == "Unseen" &&
                widget.conditions[3] == false) ||
            (_playersResult[index] == "Unseen" &&
                widget.conditions[0] == true &&
                widget.conditions[3] == false) ||
            _playersResult[index] == "Hold") {
          status[index] = false;
        } else {
          status[index] = true;
        }
      }
    });
  }

  void changeWinner(int index) {
    setState(() {
      if (index >= 0 && index < _playersResult.length) {
        if (_winOrLoss[index] == "Didn't Win") {
          _winOrLoss[index] = "Winner";
          for (int i = 0; i < _playersResult.length; i++) {
            if (i != index) {
              _winOrLoss[i] = "Didn't Win";
            }
          }
        } else {
          _winOrLoss[index] = "Didn't Win";
        }
      }
    });
  }

  void showSnackBar(String message) {
    Color color;
    if (message == "Amount Added!") {
      color = Colors.green;
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

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
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

  void _hasWinner() {
    for (int i = 0; i < widget.playerNames.length; i++) {
      if (_winOrLoss[i] == "Winner") {
        winnerCount = 1;
      }
    }
    if (winnerCount != 1) {
      showSnackBar("Winner is not selected!");
      breakOperation = true;
    }
  }

  void _validateAmount() {
    if (_amountController.text.isEmpty) {
      setState(() {
        FocusScope.of(context).requestFocus(amountNode);
      });
    } else {
      setState(() {
        _amountValue = double.parse(
          _amountController.text.replaceAll(RegExp(r'[^0-9.]'), ''),
        );
      });
    }
    if (_fineController.text.isEmpty && _amountController.text.isNotEmpty) {
      setState(() {
        FocusScope.of(context).requestFocus(fineNode);
      });
    } else {
      finePoint = double.parse(
        _fineController.text.replaceAll(RegExp(r'[^0-9.]'), ''),
      );
      setState(() {
        if ((_amountValue < 100000 && _amountValue > 0) &&
            (finePoint > 4 && finePoint < 101)) {
          buttonText = "Running...";
        } else {
          showDialogBox();
        }
      });
    }
  }

  void _startCalculation() {
    _validateAmount();
    _hasWinner();
    double toAdd;
    double individualWinning;
    if (!breakOperation) {
      int count = 0;
      double pricePerPoint = _amountValue;
      String notes = _notesController.text;
      for (int i = 0; i < widget.playerNames.length; i++) {
        if (status[i] == true || _playersResult[i] == "Unseen") {
          count++;
        }
        if (!status[i]) {
          _individualPointsController[i].text = "0";
          continue;
        }
        // Check if controller is empty
        if (_individualPointsController[i].text.isEmpty) {
          // Show message or perform necessary action
          FocusScope.of(context).requestFocus(focusNodes[i]);
        } else {
          double points = double.parse((_individualPointsController[i]
              .text
              .replaceAll(RegExp(r'[^0-9.]'), '')));
          pointsCollection.add(points);
        }
      }

      // Calculate total sum of the points
      totalPoints = 3.0 +
          pointsCollection.fold(
              0, (total, individualPoints) => total + individualPoints);
      for (int i = 0; i < widget.playerNames.length; i++) {
        double points = double.parse((_individualPointsController[i]
            .text
            .replaceAll(RegExp(r'[^0-9.]'), '')));
        double individualPoints = points * count;
        double individualWinning;
        if (_playersResult[i] == "Unseen") {
          individualWinning = -totalPoints - 7;
          toAdd = -1 * individualWinning;
          if (widget.conditions[0] == false) {
            individualWinning = individualPoints - totalPoints - 7;
          } else if (widget.conditions[3] == true) {
            //winnerResult = points;
          }
          forWinnerWinning.add(toAdd);
          print("Unseen");
          print(individualWinning);
        } else if (_playersResult[i] == "Hold") {
          individualWinning = 0;
          print(individualWinning);
          print("hold");
        } else if (_playersResult[i] == "Seen") {
          if (_winOrLoss[i] != "Winner") {
            individualWinning = individualPoints - totalPoints;
            toAdd = -1 * individualWinning;
            forWinnerWinning.add(toAdd);
            print(individualWinning);
            print("seen");
          }
        } else if (_playersResult[i] == "Dublee") {
          if (_winOrLoss[i] != "Winner") {
            individualWinning = individualPoints - totalPoints + 3;
            if (widget.conditions[2] == false) {
              individualWinning = individualPoints - totalPoints;
            }
            toAdd = -1 * individualWinning;
            forWinnerWinning.add(toAdd);
            print(individualWinning);
            print("dublee see");
          }
        } else {
          if (widget.conditions[4] == true) {
            individualWinning = -totalPoints - 12;
            toAdd = -1 * individualWinning;
            forWinnerWinning.add(toAdd);
            print(individualWinning);
            print("on same garda");
          } else if (widget.conditions[4] == false) {
            if (fine == true) {
              individualWinning = -totalPoints - finePoint + 3;
              toAdd = -1 * individualWinning;
              forWinnerWinning.add(toAdd);
              print(individualWinning);
              print("true");
            }
            individualWinning = -totalPoints + 3;
            toAdd = -1 * individualWinning;
            forWinnerWinning.add(toAdd);
            print(individualWinning);
            print("false");
            fine = true;
          }
        }
      }
      double winnerResult = 0;
      for (double item in forWinnerWinning) {
        winnerResult = winnerResult + item;
      }
      print(winnerResult);
      for (int i = 0; i < widget.playerNames.length; i++) {
        if (_winOrLoss[i] == "Winner") {
          if (_playersResult[i] == "Seen") {
            individualWinning = winnerResult;
          } else if (_playersResult[i] == "Dublee") {
            individualWinning = winnerResult + 5;
            if (widget.conditions[1] == false) {
              individualWinning = winnerResult;
            }
          }
        }
      }

      _clearInputFields();
      pointsCollection.clear();
      forWinnerWinning.clear();
      winnerCount = 0;
    }
    breakOperation = false;
  }

  String? _validAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter an amount';
    }

    double? amount = double.tryParse(value);
    if (amount == null || amount < 0.01 || amount > 99999) {
      return 'Amount must be between 0.01 and 99999';
    }

    return null;
  }

  void showDialogBox() {
    if (Platform.isAndroid) {
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
                  'Fine is for punishment so, it must be a way to remind the player who committed foul not to repeat it again!\nSo it must be between 5 and 100',
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
                  'Fine is for punishment so, it must be a way to remind the player who committed foul not to repeat it again!\nSo it must be between 5 and 100',
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
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    double buttonWidthPercentage = screenSize.width * 0.245;
    double buttonHeightPercentage = screenSize.height * 0.05;
    double notesArea = screenSize.width * 0.70;

    int buttonWidth = buttonWidthPercentage.toInt();
    int buttonHeight = buttonHeightPercentage.toInt();

    double screenWidth = screenSize.width;
    double textError = 14;
    double playerNameFont = 17;
    double playerNameArea = 83;
    double pointsArea = 90;
    double padding = 10;
    int amountButtonWidth = 130;
    int amountButtonHeight = 55;

    if (screenWidth < 393 && screenWidth > 350) {
      playerNameFont = 14;
      playerNameArea = 65;
      pointsArea = 90;
      padding = 8;
      textError = 12;
      amountButtonWidth = 115;
      amountButtonHeight = 45;
    } else if (screenWidth > 321 && screenWidth < 350) {
      playerNameFont = 12;
      playerNameArea = 55;
      pointsArea = 90;
      padding = 7;
      textError = 10;
      amountButtonWidth = 102;
      amountButtonHeight = 40;
    } else if (screenWidth < 321) {
      playerNameFont = 10;
      playerNameArea = 55;
      pointsArea = 70;
      padding = 6;
      textError = 6;
      amountButtonWidth = 90;
      amountButtonHeight = 34;
    }
    // Check if playerNames list is empty
    if (widget.playerNames.isEmpty || widget.playerNames.length < 2) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const MarriageHomeScreen(
            conditions: [true, false, true, true],
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Marriage Points Calculator',
            style: TextStyle(fontSize: playerNameFont + 4),
          ),
        ),
        body: Flex(
          direction: Axis.vertical,
          children: [
            SizedBox(
              height: buttonHeightPercentage * 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: padding * 1.5, top: 10),
                    child: SizedBox(
                      height: 70,
                      width: buttonWidthPercentage * 2.25 - 60,
                      child: TextFormField(
                        onChanged: (value) {
                          _validAmount(value) == null
                              ? showSnackBar("Amount Added!")
                              : {
                                  showSnackBar("Invalid Amount"),
                                  setState(() {
                                    buttonText = "Start";
                                  })
                                };
                        },
                        controller: _amountController,
                        focusNode: amountNode,
                        maxLength: 5,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Amount Per Point",
                          helperText: "Between 0.01-99999!",
                          helperStyle: TextStyle(fontSize: textError - 3),
                          hintStyle: TextStyle(fontSize: textError),
                          errorText: _validAmount(_amountController.text),
                          errorStyle: TextStyle(fontSize: textError),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            gapPadding: 4,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ), // Border radius
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SizedBox(
                      width: buttonHeightPercentage + 40,
                      height: 70,
                      child: TextFormField(
                        controller: _fineController,
                        focusNode: fineNode,
                        maxLength: 3,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "FINE!",
                          helperText: "5-100",
                          helperStyle: TextStyle(fontSize: textError - 3),
                          hintStyle: TextStyle(fontSize: textError),
                          errorStyle: TextStyle(fontSize: textError),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            gapPadding: 4,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ), // Border radius
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 0, bottom: 12, right: 10),
                    child: CustomButton(
                      onPressed: () {
                        _validAmount(_amountController.text) == null
                            ? _validateAmount()
                            : {FocusScope.of(context).requestFocus(amountNode)};
                      },
                      buttonText: buttonText,
                      width: amountButtonWidth - 2,
                      height: amountButtonHeight + 10,
                      fontSize: playerNameFont - 1.5,
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
                      for (int i = 0; i < widget.playerNames.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 10, left: 10),
                                child: SizedBox(
                                  width: playerNameArea,
                                  child: Text(
                                    widget.playerNames[i].toUpperCase(),
                                    style: TextStyle(fontSize: playerNameFont),
                                  ),
                                ),
                              ),
                              CustomButton(
                                onPressed: () {
                                  changeWinner(i);
                                },
                                buttonText: _winOrLoss[i],
                                fontSize: playerNameFont - 2,
                                height: buttonHeight + 4,
                                width: buttonWidth,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 0, left: 7, right: 7),
                                child: SizedBox(
                                  width: pointsArea,
                                  child: TextFormField(
                                    focusNode: focusNodes[i],
                                    enabled: status[i],
                                    controller: _individualPointsController[i],
                                    decoration: InputDecoration(
                                      helperText: "Points",
                                      helperStyle: TextStyle(
                                          fontSize: playerNameFont - 4),
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
                              CustomButton(
                                onPressed: () {
                                  changeSeenState(i);
                                },
                                buttonText: _playersResult[i],
                                fontSize: playerNameFont - 2,
                                height: buttonHeight + 4,
                                width: buttonWidth,
                              ),
                            ],
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 6, right: 6),
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
                                          fontSize: playerNameFont - 1),
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
                                    padding: const EdgeInsets.only(bottom: 20),
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
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 20),
                        child: CustomButton(
                          onPressed: _startCalculation,
                          buttonText: "Calulate",
                          fontSize: playerNameFont,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10, right: 10, left: 10),
                        child: Text(
                          'Game Results:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Table(
                          columnWidths: {
                            for (var i = 0; i < widget.playerNames.length; i++)
                              i: const FlexColumnWidth(1),
                          },
                          border: TableBorder.all(),
                          children: [
                            TableRow(
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                              ),
                              children: [
                                ...widget.playerNames.map((name) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                        child: Text(
                                      name,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: playerNameFont - 1),
                                    )),
                                  );
                                }).toList(),
                                Center(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(left: 10, top: 6),
                                    child: Text(
                                      "EDIT",
                                      style: TextStyle(
                                        fontSize: playerNameFont - 2,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            for (var i = 0;
                                i < widget.playerNames.length - 1;
                                i++)
                              TableRow(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? i % 2 == 0
                                          ? const Color.fromARGB(
                                              255, 87, 87, 87)
                                          : Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer
                                      : i % 2 == 0
                                          ? Colors.white
                                          : const Color.fromARGB(
                                              255, 79, 23, 135),
                                ),
                                children: [
                                  ..._nameControllersList[i].map((controller) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(controller: controller),
                                    );
                                  }).toList(),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.edit),
                                  )
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clearInputFields() {
    for (int i = 0; i < _individualPointsController.length; i++) {
      _notesController.clear();
      _individualPointsController[i].clear();
      _winOrLoss[i] == "Didn't Win";
      _playersResult[i] == "Seen";
    }
  }
}
