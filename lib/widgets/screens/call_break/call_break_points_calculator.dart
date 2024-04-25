import 'package:flutter/services.dart';
import 'package:sajilo_hisab/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';
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
  List<TextEditingController> _individualPointsController = [];
  List<TextEditingController> _individualPointsController1 = [];
  List<TextEditingController> _amountController = [];
  final TextEditingController _notesController = TextEditingController();
  final List<List<TextEditingController>> _nameControllersList = [];

  List<FocusNode> pointsFocusNodes = [];
  List<FocusNode> amountNode = [];
  double playerNameFont = 17;
  bool _speechEnabled = false;
  double _confidenceLevel = 0.0;
  final SpeechToText _speechToText = SpeechToText();
  List<String> helperText = [];
  String buttonText = "Start";
  bool state = false;
  List<FocusNode> focusNodes = [];
  List<FocusNode> focusNodes1 = [];
  List<bool> status = [];

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

  String? _validAmount(String? value, int index) {
    if (value == null || value.isEmpty) {
      return index == 0
          ? "2ND"
          : index == 1
              ? "3RD"
              : "4TH";
    }

    double amount = double.parse(
      value.replaceAll(RegExp(r'[^0-9.]'), ''),
    );
    if (amount < 4 || amount > 99999) {
      return index == 0
          ? "2ND"
          : index == 1
              ? "3RD"
              : "4TH";
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initSpeech();
  }

  void _initializeControllers() {
    _individualPointsController = List.generate(
      widget.playerNames.length - 1,
      (index) => TextEditingController(),
    );
    _individualPointsController1 = List.generate(
      widget.playerNames.length - 1,
      (index) => TextEditingController(),
    );
    _amountController = List.generate(
      widget.playerNames.length - 1,
      (index) => TextEditingController(),
    );
    pointsFocusNodes = List.generate(
      widget.playerNames.length - 1,
      (index) => FocusNode(),
    );
    amountNode = List.generate(
      widget.playerNames.length - 1,
      (index) => FocusNode(),
    );
    focusNodes = List.generate(
      widget.playerNames.length - 1,
      (index) => FocusNode(),
    );
    focusNodes1 = List.generate(
      widget.playerNames.length - 1,
      (index) => FocusNode(),
    );
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

  void _startCalculation() {}

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    double buttonWidthPercentage = screenSize.width * 0.245;
    double buttonHeightPercentage = screenSize.height * 0.05;
    double notesArea = screenSize.width * 0.70;

    double textError = 14;
    double playerNameFont = 17;
    double playerNameArea = 83;
    double pointsArea = 90;
    double padding = 10;
    int amountButtonWidth = 125;
    int amountButtonHeight = 55;

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
              height: buttonHeightPercentage * 3 - 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (int i = 0; i < widget.playerNames.length - 1; i++)
                    Padding(
                      padding: EdgeInsets.only(left: padding, top: 10),
                      child: SizedBox(
                        height: 70,
                        width: buttonWidthPercentage - 20,
                        child: TextFormField(
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
                            helperStyle: TextStyle(fontSize: textError - 2.5),
                            hintStyle: TextStyle(fontSize: textError - 2.5),
                            errorText:
                                _validAmount(_amountController[i].text, i),
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
                        const EdgeInsets.only(top: 0, bottom: 15, right: 10),
                    child: CustomButton(
                      onPressed: () {
                        for (int i = 0;
                            i < widget.playerNames.length - 1;
                            i++) {
                          _validAmount(_amountController[i].text, i) == null
                              ? setState(() {
                                  buttonText = "Running";
                                })
                              : FocusScope.of(context)
                                  .requestFocus(amountNode[i]);
                        }
                      },
                      buttonText: buttonText,
                      width: amountButtonWidth - 20,
                      height: amountButtonHeight - 7,
                      fontSize: playerNameFont - 2,
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              "Amount For Players Those Lost! Min-5 Max-99999!",
              style: TextStyle(
                color: Color.fromARGB(255, 60, 125, 179),
              ),
            ),
            Expanded(
              flex: 8,
              child: SingleChildScrollView(
                child: SizedBox(
                  child: Column(
                    children: [
                      for (int i = 0; i < widget.playerNames.length - 1; i++)
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
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 0, left: 7, right: 7),
                                child: SizedBox(
                                  width: pointsArea,
                                  child: TextFormField(
                                    focusNode: focusNodes[i],
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
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 0, left: 7, right: 7),
                                child: SizedBox(
                                  width: pointsArea,
                                  child: TextFormField(
                                    focusNode: focusNodes1[i],
                                    controller: _individualPointsController1[i],
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
                            for (var i = 0;
                                i < widget.playerNames.length - 1;
                                i++)
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
                                  ...widget.playerNames.map((controller) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(controller: null),
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
}
