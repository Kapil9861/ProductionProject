import 'package:flutter/material.dart';
import 'package:sajilo_hisab/widgets/screens/call_break/call_break_points_calculator.dart';
import 'package:sajilo_hisab/widgets/screens/marriage/marriage_points_calculator.dart';

class CallBreakHome extends StatefulWidget {
  const CallBreakHome({Key? key, required this.conditions}) : super(key: key);
  final List<bool> conditions;

  @override
  State<CallBreakHome> createState() => _CallBreakHomeState();
}

class _CallBreakHomeState extends State<CallBreakHome> {
  int numberOfPlayers = 4;
  List<TextEditingController> playerControllers = [];
  List<FocusNode> playerFocusNodes = [];

  @override
  void initState() {
    super.initState();
    // Initialize controllers and focus nodes
    for (int i = 0; i < numberOfPlayers; i++) {
      playerControllers.add(TextEditingController());
      playerFocusNodes.add(FocusNode());
    }
  }

  @override
  void dispose() {
    // Dispose controllers and focus nodes
    for (int i = 0; i < numberOfPlayers; i++) {
      playerControllers[i].dispose();
      playerFocusNodes[i].dispose();
    }
    super.dispose();
  }

  void _showSnackBar(String message, int index) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
    FocusScope.of(context).requestFocus(playerFocusNodes[index]);
  }

  void _proceedToCalculator() {
    bool allFieldsFilled = true;
    for (int i = 0; i < numberOfPlayers; i++) {
      if (playerControllers[i].text.isEmpty) {
        _showSnackBar('Player ${i + 1} name is empty', i);
        allFieldsFilled = false;
        break;
      } else if (playerControllers[i].text.length < 3) {
        _showSnackBar('Player ${i + 1} name must have 3 or more characters', i);
        allFieldsFilled = false;
        break;
      }
    }
    if (allFieldsFilled) {
      List<String> playerNames =
          playerControllers.map((controller) => controller.text).toList();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallBreakPointsCalculator(
            playerNames: playerNames,
            conditions: widget.conditions,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 40),
          child: Text(
            "Marriage Points Home",
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
            // Generate text fields for player names
            for (int i = 0; i < numberOfPlayers; i++)
              TextFormField(
                controller: playerControllers[i],
                focusNode: playerFocusNodes[i],
                decoration: InputDecoration(
                  labelText: 'Player ${i + 1} Name',
                ),
              ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: ElevatedButton(
                onPressed: _proceedToCalculator,
                child: const Text('Start Calculator'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}