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
  TextEditingController _amountController = TextEditingController();
  String buttonText = "Start Calculation";

  String _playersResult = "Seen";
  double _amountValue = 0.0;
  @override
  void initState() {
    super.initState();
    _initializeNameControllers();
  }

  void _initializeNameControllers() {
    _nameControllersList = List.generate(widget.playerNames.length, (index) {
      return List.generate(
          widget.playerNames.length, (index) => TextEditingController());
    });
  }

  void changeButtonState() {
    setState(() {
      if (_playersResult == "Seen") {
        _playersResult = "Unseen";
      } else if (_playersResult == "Unseen") {
        _playersResult = "Winner";
      } else {
        _playersResult = "Seen";
      }
    });
  }

  void _validateAmount() {
    setState(() {
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
          title: Text('Marriage Points Calculator'),
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
                        maxLength: 4,
                        decoration: const InputDecoration(
                          hintText: "0.01-99999",
                          errorText: "Amount Range 0.01 - 99999!",
                        ),
                        controller: _amountController,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, right: 10),
                    child: CustomButton(
                      onPressed: _validateAmount,
                      buttonText: buttonText,
                      width: 161,
                      fontSize: 15,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 8,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Enter Players Points and Notes:'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Table(
                        columnWidths: {
                          for (var i = 0; i < widget.playerNames.length; i++)
                            i: FlexColumnWidth(1),
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
                                    "Seen/Unseen/Winner",
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
                                ElevatedButton(
                                  onPressed: () {
                                    changeButtonState();
                                  },
                                  child: Text(
                                    _playersResult,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _submitData,
                      child: Text('Submit'),
                    ),
                    Row(
                      children: [
                        Text("data"),
                        Text("data"),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  void _submitData() {
    final List<List<String>> playerNames =
        _nameControllersList.map((controllers) {
      return controllers.map((controller) => controller.text).toList();
    }).toList();
    final String notes = _notesController.text;
    // You can do further processing or saving of data here
    print('Player Names: $playerNames');
    print('Notes: $notes');
    // Clear input fields after submission
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
