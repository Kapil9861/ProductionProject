import 'package:flutter/material.dart';

class ShowBottomModalSheet extends StatefulWidget {
  const ShowBottomModalSheet({
    super.key,
    required this.widgets,
    required this.onDataReceived,
  });
  final Widget widgets;
  final void Function(List<bool>) onDataReceived;
  @override
  State<ShowBottomModalSheet> createState() => ShowBottomModalSheetState();
}

class ShowBottomModalSheetState extends State<ShowBottomModalSheet> {
  @override
  Widget build(context) {
    Color color = Theme.of(context).colorScheme.onPrimaryContainer;
    if (Theme.of(context).brightness == Brightness.dark) {
      color = Theme.of(context).colorScheme.onPrimary;
    }
    bool isSwitched = false;

    void _toggleSwitch(bool value) {
      setState(() {
        isSwitched = value;
      });
    }

    return IconButton(
      icon: const Icon(Icons.more_vert),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          List<bool> booleanList = [
                            true,
                            false,
                            true
                          ]; // Example list of boolean values
                          widget.onDataReceived(booleanList);
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(color),
                        ),
                        child: const Text(
                          "Save and Go Back",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Padding(
                              padding: const EdgeInsets.all(28.0),
                              child: Container(
                                height: 200,
                                width: 400,
                                child: Switch(
                                  value: isSwitched,
                                  onChanged: _toggleSwitch,
                                  activeTrackColor: Colors.lightGreenAccent,
                                  activeColor: Colors.green,
                                ),
                              ),
                            ),
                    ]
                    
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
