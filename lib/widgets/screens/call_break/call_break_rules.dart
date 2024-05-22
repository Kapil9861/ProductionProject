import 'package:flutter/material.dart';
import 'package:sajilo_hisab/widgets/smallWidgets/footer.dart';
import 'package:sajilo_hisab/widgets/smallWidgets/link.dart';

class CallBreakRules extends StatelessWidget {
  const CallBreakRules({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 40),
          child: Text(
            "Call Break Game Rules",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 21),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
          child: ListView(
            children: const [
              SizedBox(
                height: 160,
                // ignore: prefer_interpolation_to_compose_strings
                child: Text(
                    "Call Break (13 Patti or Otti), a famous card game played all over Nepal and in India and Bhutan by the people of the Nepalese Origin. Additionally, all around the world by Nepalsese and few Indian descendents. The games are widely played on the festivals and or some occasional gatherings and all over the year by the admirers."),
              ),
              Padding(
                padding: EdgeInsets.only(top: 6),
                child: SizedBox(
                  child: Text(
                      "In call break, the initial points committed is called as Haat Bolnu or Bid Hand or claim hand points. Here, it is referenced as committed points."),
                ),
              ),
              ListTile(
                leading: Icon(Icons.circle),
                title: Text(
                  'Double Pay',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text(
                    "The players who came 2nd, 3rd and 4th have to pay double if the winner crosses 20 points. But if the 2nd or 3rd players also crosses 20 points only the fourth players should pay meaning that if other players have less than 20 points have to pay double the amount as set at the starting of the game."),
              ),
              ListTile(
                leading: Icon(Icons.circle),
                title: Text(
                  'Double Receive',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text(
                    "If the player/s who did not win the game has negative total points have to pay double to the Winner, only if the Winner does not have negative total points."),
              ),
              ListTile(
                leading: Icon(Icons.circle),
                title: Text(
                  'Sum of Nine',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text(
                    "The game is scaped by giving the total points committed before starting the game (BOLEKO HAAT), and every players are awarded a Otti(Additional point/s than the committed point)."),
              ),
              ListTile(
                leading: Icon(Icons.circle),
                title: Text(
                  'Direct Winner',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text(
                    "If a player calls/bids 8 hands points and successfully receives 8 or more points, he/she will automatically win the whole game."),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                    "To learn the call break card games rules in detail visit the site below by firstgames.in:"),
              ),
              CustomLink(
                link:
                    "https://firstgames.in/blog/how-to-play-call-break-call-break-rules-in-detail",
              ),
              Text("Also a blog by Suraj Jayaswal on: Jun 2, 2021 (Last Seen)"),
              MyFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
