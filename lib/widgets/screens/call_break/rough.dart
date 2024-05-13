import 'package:flutter/material.dart';

class YourListViewWidget extends StatefulWidget {
  @override
  _YourListViewWidgetState createState() => _YourListViewWidgetState();
}

class _YourListViewWidgetState extends State<YourListViewWidget> {
  List<String> allIndividualWinPoints = [
    "Point 1",
    "Point 2",
    "Point 3",
  ]; // Sample data
  List<String> allPricePerPoint = [
    "Price 1",
    "Price 2",
    "Price 3"
  ]; // Sample data
  List<String> allFinePoint = ["Fine 1", "Fine 2", "Fine 3"]; // Sample data
  List<List<String>> allPlayerNames = [
    ["Player 1"],
    ["Player 2"],
    ["Player 3"]
  ]; // Sample data
  List<String> allNotes = ["Note 1", "Note 2", "Note 3"]; // Sample data

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: allIndividualWinPoints.length,
        itemBuilder: (context, index) {
          int tapCount = 0; // Counter to keep track of tap count
          return ListTile(
            onTap: () {
              // Increment tap count on each tap
              tapCount++;
              // Show dialog when tapped three times
              if (tapCount == 3) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Delete Item?"),
                      content: Text("Do you want to delete this item?"),
                      actions: <Widget>[
                        TextButton(
                          child: Text("No"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text("Yes"),
                          onPressed: () {
                            setState(() {
                              allIndividualWinPoints.removeAt(index);
                              allPricePerPoint.removeAt(index);
                              allFinePoint.removeAt(index);
                              allPlayerNames.removeAt(index);
                              allNotes.removeAt(index);
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
            title: Text("Item ${index + 1}"),
            subtitle: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Individual Win Points: ${allIndividualWinPoints[index]}"),
                Text("Price Per Point: ${allPricePerPoint[index]}"),
                Text("Fine Point: ${allFinePoint[index]}"),
                Text("Player Names: ${allPlayerNames[index].join(', ')}"),
                Text("Notes: ${allNotes[index]}"),
              ],
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text('ListView with Dialog')),
      body: YourListViewWidget(),
    ),
  ));
}
