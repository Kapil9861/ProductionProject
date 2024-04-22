import 'package:flutter/material.dart';
import 'package:sajilo_hisab/widgets/buttons/custom_button.dart';
import 'package:sajilo_hisab/widgets/screens/marriage/marriage_home.dart';
import 'package:sajilo_hisab/widgets/screens/modals/show_bottom_modal.dart';
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
  List<TextEditingController>? _individualPointsController = [];
  final TextEditingController _amountController = TextEditingController();
  String buttonText = "Start Calculation";
  String winnerButton = "Didn't Win";
  FocusNode amountNode = FocusNode();
  List<FocusNode>? focusNodes;
  final List<String> _playersResult = [];
  final List<String> _winOrLoss = [];
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  double _confidenceLevel = 0.0;
  double _amountValue = 0.0;
  int individualPoints = 0;
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
          widget.playerNames.length, (index) => TextEditingController());
    });
    _individualPointsController = List.generate(
        widget.playerNames.length, (index) => TextEditingController());
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
        } else if (_playersResult[index] == "Unseen") {
          _playersResult[index] = "Dublee";
        } else if (_playersResult[index] == "Dublee") {
          _playersResult[index] = "Foul";
        } else if (_playersResult[index] == "Foul") {
          _playersResult[index] = "Hold";
        } else if (_playersResult[index] == "Hold") {
          _playersResult[index] = "Seen";
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

  void _validateAmount() {
    setState(() {
      if (_amountController.text.isEmpty) {
        FocusScope.of(context).requestFocus(amountNode);
      } else {
        _amountValue = double.parse(_amountController.text);
      }
      if (_amountValue < 100000 && _amountValue > 0) {
        buttonText = "Game Running";
      }
    });
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

    Color color = Theme.of(context).colorScheme.onPrimaryContainer;
    if (Theme.of(context).brightness == Brightness.dark) {
      color = Theme.of(context).colorScheme.onPrimary;
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Marriage Points Calculator',
            style: TextStyle(fontSize: playerNameFont + 4),
          ),
          actions: [],
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
                      width: buttonWidthPercentage * 2.25,
                      child: TextFormField(
                        controller: _amountController,
                        focusNode: amountNode,
                        maxLength: 5,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Amount Per Point",
                          errorText: "Between 0.01 - 99999!",
                          errorStyle: TextStyle(fontSize: textError),
                          hintStyle: TextStyle(fontSize: textError),
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
                        _validateAmount();
                      },
                      buttonText: buttonText,
                      width: amountButtonWidth + 15,
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
                                    controller: _individualPointsController![i],
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
                                    height: 200,
                                    width: notesArea,
                                    child: TextFormField(
                                      style: TextStyle(
                                          fontSize: playerNameFont - 1),
                                      controller: _notesController,
                                      maxLength: 300,
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
                                            fontSize: playerNameFont - 3),
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
                          onPressed: _submitData,
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

  void _submitData() {
    _clearInputFields();
  }

  void _clearInputFields() {
    for (var controllersList in _nameControllersList) {
      for (var controller in controllersList) {
        controller.clear();
      }
    }
    _notesController.clear();
  }
}
