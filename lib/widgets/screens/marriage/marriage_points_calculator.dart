import 'dart:collection';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:sajilo_hisab/main.dart';
import 'package:sajilo_hisab/widgets/buttons/custom_button.dart';
import 'package:sajilo_hisab/widgets/chart/chart.dart';
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
  List<TextEditingController> _individualPointsController = [];
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _fineController = TextEditingController();
  String buttonText = "Start";
  String winnerButton = "Didn't Win";
  FocusNode amountNode = FocusNode();
  FocusNode fineNode = FocusNode();
  List<FocusNode> focusNodes = [];
  int calculationRunCount = 0;
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
  bool fine = false;
  int winnerCount = 0;
  bool breakOperation = false;
  final List<double> forWinnerWinning = [];
  double finePoint = 15;
  String foulPlayerName = "";
  LinkedHashMap<String, num> individualWinPoints = LinkedHashMap<String, num>();
  List<LinkedHashMap<String, num>> allIndividualWinPoints = [];
  List<double> allPricePerPoint = [];
  List<double> allFinePoint = [];
  List<List<String>> allPlayerNames = [];
  List<String> allNotes = [];

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
    for (String name in widget.playerNames) {
      individualWinPoints[name] = 0;
    }
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
          _winOrLoss[index] = "Didn't Win";
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
            _playersResult[index] == "Hold" ||
            _playersResult[index] == "Foul") {
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
            } else if (_playersResult[index] == "Unseen" ||
                _playersResult[index] == "Hold" ||
                _playersResult[index] == "Foul") {
              _winOrLoss[i] = "Didn't Win";
              showSnackBar("Invalid Winner!");
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
    Hive.close();
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

  void _startCalculation() async {
    await Hive.initFlutter();

    double kidnapPoint = 0;
    _validateAmount();
    _hasWinner();
    double toAdd;
    if (!breakOperation) {
      int count = 0;
      double pricePerPoint = _amountValue;
      String? notes = _notesController.text;
      for (int i = 0; i < widget.playerNames.length; i++) {
        if (status[i] == true ||
            _playersResult[i] == "Unseen" ||
            _playersResult[i] == "Foul") {
          count++;
        }
        if (!status[i]) {
          _individualPointsController[i].text = "0";
          continue;
        }
        if (_individualPointsController[i].text.isEmpty) {
          // ignore: use_build_context_synchronously
          FocusScope.of(context).requestFocus(focusNodes[i]);
        } else {
          double points = double.parse((_individualPointsController[i]
              .text
              .replaceAll(RegExp(r'[^0-9.]'), '')));
          pointsCollection.add(points);
        }
      }

      totalPoints = 3.0 +
          pointsCollection.fold(
              0, (total, individualPoints) => total + individualPoints);
      for (int i = 0; i < widget.playerNames.length; i++) {
        double points = double.parse((_individualPointsController[i]
            .text
            .replaceAll(RegExp(r'[^0-9.]'), '')));
        double individualPoints = points * count;
        double individualWinning;
        if (foulPlayerName == widget.playerNames[i] &&
            _playersResult[i] == "Winner") {
        } else {
          if (_playersResult[i] == "Unseen") {
            if (widget.conditions[0] == false) {
              individualWinning = individualPoints - totalPoints - 7;
              individualWinPoints[widget.playerNames[i]] = individualWinning;
            } else if (widget.conditions[3] == true) {
              kidnapPoint = individualPoints;
              individualWinPoints[widget.playerNames[i]] = 0;
            } else {
              individualWinning = -totalPoints - 7;
              toAdd = -1 * individualWinning;
              forWinnerWinning.add(toAdd);
            }
          } else if (_playersResult[i] == "Hold") {
            if (foulPlayerName == widget.playerNames[i] &&
                widget.conditions[4] == false) {
              fine = true;
              foulPlayerName = widget.playerNames[i];
            }
            individualWinning = 0;
            individualWinPoints[widget.playerNames[i]] = individualWinning;
          } else if (_playersResult[i] == "Seen") {
            if (_winOrLoss[i] != "Winner") {
              individualWinning = individualPoints - totalPoints;
              toAdd = -1 * individualWinning;
              individualWinPoints[widget.playerNames[i]] = individualWinning;

              forWinnerWinning.add(toAdd);
            }
          } else if (_playersResult[i] == "Dublee") {
            if (_winOrLoss[i] != "Winner") {
              individualWinning = individualPoints - totalPoints + 3;
              if (widget.conditions[2] == false) {
                individualWinning = individualPoints - totalPoints;
              }
              toAdd = -1 * individualWinning;
              individualWinPoints[widget.playerNames[i]] = individualWinning;

              forWinnerWinning.add(toAdd);
            }
          } else if (_playersResult[i] == "Foul") {
            if (widget.conditions[4] == true) {
              individualWinning = -totalPoints + 3 - finePoint;
              toAdd = -1 * individualWinning;
              forWinnerWinning.add(toAdd);
              individualWinPoints[widget.playerNames[i]] = individualWinning;
            } else if (widget.conditions[4] == false &&
                _playersResult[i] != "Winner") {
              if (fine == true && foulPlayerName == widget.playerNames[i]) {
                individualWinning = -totalPoints - finePoint + 3;

                if (_playersResult[i] == "Foul") {
                  fine = true;
                }
                toAdd = -1 * individualWinning;
                forWinnerWinning.add(toAdd);
              } else {
                individualWinning = -totalPoints + 3;
                toAdd = -1 * individualWinning;
                forWinnerWinning.add(toAdd);
                fine = true;
              }
              individualWinPoints[widget.playerNames[i]] = individualWinning;
            }
            foulPlayerName = widget.playerNames[i];
          }
        }
      }
      double winnerResult = 0;
      for (double item in forWinnerWinning) {
        winnerResult = winnerResult + item;
      }
      for (int i = 0; i < widget.playerNames.length; i++) {
        if (_winOrLoss[i] == "Winner") {
          if (widget.playerNames[i] == foulPlayerName &&
              widget.conditions[4] == false) {
            fine = false;
          }
          if (_playersResult[i] == "Seen") {
            winnerResult = winnerResult + kidnapPoint;
            individualWinPoints[widget.playerNames[i]] = winnerResult;
            break;
          } else if (_playersResult[i] == "Dublee") {
            if (widget.conditions[1] == false) {
              winnerResult = winnerResult + kidnapPoint;
              individualWinPoints[widget.playerNames[i]] = winnerResult;
              break;
            } else {
              winnerResult = winnerResult + 5 + kidnapPoint;
              individualWinPoints[widget.playerNames[i]] = winnerResult;
              break;
            }
          }
        }
      }
      //Defining Hive Boxes
      var individualWinPointsBox = await Hive.openBox('individualWinPoints');
      var pricePerPointBox = await Hive.openBox('pricePerPoint');
      var finePointBox = await Hive.openBox('finePoint');
      var playerNamesBox = await Hive.openBox('playerNames');
      var notesBox = await Hive.openBox('notes');
      // Storing the data
      individualWinPointsBox.put(
          'individualWinPoints$calculationRunCount', individualWinPoints);
      pricePerPointBox.put('pricePerPoint$calculationRunCount', pricePerPoint);
      finePointBox.put('finePoint$calculationRunCount', finePoint);
      playerNamesBox.put('playerNames$calculationRunCount', widget.playerNames);
      notesBox.put('notes$calculationRunCount', notes);

      while (true) {
        String individualWinPointsKey =
            'individualWinPoints$calculationRunCount';
        String pricePerPointKey = 'pricePerPoint$calculationRunCount';
        String finePointKey = 'finePoint$calculationRunCount';
        String playerNamesKey = 'playerNames$calculationRunCount';
        String notesKey = 'notes$calculationRunCount';

        // Retrieve values from the boxes
        if (individualWinPointsBox.containsKey(individualWinPointsKey)) {
          allIndividualWinPoints
              .add(individualWinPointsBox.get(individualWinPointsKey));
          allPricePerPoint.add(pricePerPointBox.get(pricePerPointKey));
          allFinePoint.add(finePointBox.get(finePointKey));
          allPlayerNames.add(playerNamesBox.get(playerNamesKey));
          allNotes.add(notesBox.get(notesKey));
          setState(() {
            calculationRunCount++;
            _clearInputFields();
          });
        } else {
          break;
        }
      }

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
    Color textColor = Theme.of(context).brightness == Brightness.dark
        ? kDarkColorScheme.onPrimaryContainer
        : kColorScheme.onPrimaryContainer;
    Size screenSize = MediaQuery.of(context).size;

    double buttonWidthPercentage = screenSize.width * 0.245;
    double buttonHeightPercentage = screenSize.height * 0.05;
    double notesArea = screenSize.width * 0.70;

    int buttonWidth = buttonWidthPercentage.toInt();
    int buttonHeight = buttonHeightPercentage.toInt();
    double screenWidth = screenSize.width;

    double tableWidth = screenSize.width;
    if (widget.playerNames.length == 4) {
      tableWidth = screenSize.width * 1.2;
    } else if (widget.playerNames.length == 5) {
      tableWidth = screenSize.width * 1.4;
    } else if (widget.playerNames.length == 6) {
      tableWidth = screenSize.width * 1.6;
    }
    double textError = 14;
    double playerNameFont = 17;
    double playerNameArea = 83;
    double pointsArea = 90;
    double padding = 10;
    int amountButtonWidth = 130;
    int amountButtonHeight = 55;

    if (screenWidth < 375 && screenWidth > 350) {
      playerNameFont = 14;
      playerNameArea = 65;
      pointsArea = 80;
      padding = 8;
      textError = 12.5;
      amountButtonWidth = 115;
      amountButtonHeight = 45;
    } else if (screenWidth < 393 && screenWidth > 375) {
      playerNameFont = 15;
      playerNameArea = 75;
      pointsArea = 80;
      padding = 8;
      textError = 13.5;
      amountButtonWidth = 115;
      amountButtonHeight = 45;
      buttonHeightPercentage = buttonHeightPercentage - 5;
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
                        style: TextStyle(color: textColor),
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
                          errorStyle: TextStyle(fontSize: textError - 2),
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
                        style: TextStyle(color: textColor),
                        controller: _fineController,
                        focusNode: fineNode,
                        maxLength: 3,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "FINE!",
                          helperText: "5-100",
                          helperStyle: TextStyle(fontSize: textError - 3),
                          hintStyle: TextStyle(fontSize: textError),
                          errorStyle: TextStyle(fontSize: textError - 3),
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
                      fontSize: screenSize.height < 625
                          ? playerNameFont
                          : playerNameFont - 1.5,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 6,
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
                                    style: TextStyle(color: textColor),
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
                                width: screenSize.width > 350 &&
                                        screenSize.width < 390
                                    ? buttonWidth + 1
                                    : buttonWidth,
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
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              SizedBox(
                                width: tableWidth,
                                child: Table(
                                  columnWidths: {
                                    for (var i = 0;
                                        i < widget.playerNames.length;
                                        i++)
                                      i: FixedColumnWidth((tableWidth - 50) /
                                          (widget.playerNames.length + 2)),
                                  },
                                  border: TableBorder.all(),
                                  children: [
                                    TableRow(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Theme.of(context)
                                                .colorScheme
                                                .onPrimary
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
                                                name.toUpperCase(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: playerNameFont - 3,
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, top: 6),
                                            child: Text(
                                              "NOTES",
                                              style: TextStyle(
                                                fontSize: playerNameFont - 2,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 0, top: 6, right: 10),
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
                                  ],
                                ),
                              ),
                            ],
                          ),
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
                              return Dismissible(
                                key: UniqueKey(),
                                onDismissed: (direction) {
                                  // Remove the dismissed item from all lists
                                  setState(() {
                                    allIndividualWinPoints.removeAt(index);
                                    allPricePerPoint.removeAt(index);
                                    allFinePoint.removeAt(index);
                                    allPlayerNames.removeAt(index);
                                    allNotes.removeAt(index);
                                  });
                                },
                                child: ListTile(
                                  title: Text("Item ${index + 1}"),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Individual Win Points: ${allIndividualWinPoints[index]}"),
                                      Text(
                                          "Price Per Point: ${allPricePerPoint[index]}"),
                                      Text(
                                          "Fine Point: ${allFinePoint[index]}"),
                                      Text(
                                          "Player Names: ${allPlayerNames[index].join(', ')}"),
                                      Text("Notes: ${allNotes[index]}"),
                                    ],
                                  ),
                                ),
                              );
                            },
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
    );
  }

  void _clearInputFields() {
    for (int i = 0; i < _individualPointsController.length; i++) {
      _notesController.clear();
      _individualPointsController[i].clear();
    }
  }
}
