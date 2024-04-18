import 'package:flutter/material.dart';
import 'package:sajilo_hisab/widgets/buttons/custom_button.dart';
import 'package:sajilo_hisab/widgets/screens/marriage/marriage_home.dart';

class MarriagePointsCalculator extends StatefulWidget {
  const MarriagePointsCalculator({Key? key, required this.playerNames})
      : super(key: key);
  final List<String> playerNames;

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

  double _amountValue = 0.0;
  int individualPoints = 0;
  @override
  void initState() {
    super.initState();
    _initializeNameControllers();
    _initializePlayerResults();
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

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double playerNameFont = 18;
    double playerNameArea = 95;
    double pointsArea = 85;
    double padding = 10;

    if (screenWidth < 393) {
      playerNameFont = 14;
      playerNameArea = 65;
      pointsArea = 90;
      padding = 6;
    }
    // Check if playerNames list is empty
    if (widget.playerNames.isEmpty || widget.playerNames.length < 2) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const MarriageHomeScreen(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marriage Points Calculator'),
      ),
      body: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: TextFormField(
                      focusNode: amountNode,
                      maxLength: 4,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "0.01-99999",
                        errorText: "Amount Per Point 0.01 - 99999!",
                      ),
                      controller: _amountController,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20, right: 10),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 2),
                        child: CustomButton(
                          onPressed: () {
                            _validateAmount();
                          },
                          buttonText: buttonText,
                          width: 161,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                )
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
                              fontSize: 14,
                              height: 45,
                              width: 93,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 0, left: 7, right: 7),
                              child: SizedBox(
                                width: pointsArea,
                                child: TextFormField(
                                  controller: _individualPointsController![i],
                                  decoration: const InputDecoration(
                                    helperText: "Points",
                                    border: OutlineInputBorder(
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
                              fontSize: 14,
                              height: 45,
                              width: 100,
                            ),
                          ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              "NOTES: ",
                              style: TextStyle(
                                  fontSize: 18, fontStyle: FontStyle.italic),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: padding),
                            child: SizedBox(
                              height: 200,
                              width: 280,
                              child: TextFormField(
                                controller: _notesController,
                                maxLength: 300,
                                maxLines: 6,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.grey),
                                  ),
                                  helperText:
                                      "Incomplete Transaction or Foul Played",
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: CustomButton(
                        onPressed: _submitData,
                        buttonText: "Calulate",
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
                              color: Theme.of(context)
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
                                    style: const TextStyle(color: Colors.white),
                                  )),
                                );
                              }).toList(),
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10, top: 6),
                                  child: Text(
                                    "EDIT",
                                    style: TextStyle(
                                      fontSize: 15,
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
                                color: i % 2 == 0
                                    ? Colors.white
                                    : const Color.fromARGB(255, 79, 23, 135),
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
    );
  }

  void _submitData() {
    final List<List<String>> playerNames =
        _nameControllersList.map((controllers) {
      return controllers.map((controller) => controller.text).toList();
    }).toList();

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
