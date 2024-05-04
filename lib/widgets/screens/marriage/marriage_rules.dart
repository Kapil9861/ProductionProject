import 'package:flutter/material.dart';
import 'package:sajilo_hisab/widgets/smallWidgets/footer.dart';
import 'package:sajilo_hisab/widgets/smallWidgets/link.dart';
import 'package:sajilo_hisab/widgets/smallWidgets/styled_text.dart';

class MarriageRules extends StatelessWidget {
  const MarriageRules({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 40),
          child: Text(
            "Marriage Game Rules",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 21),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          child: ListView(
            children: const [
              SizedBox(
                height: 200,
                // ignore: prefer_interpolation_to_compose_strings
                child: Text(
                    "Marriage (Also called as Myarrich or 21 Patti or 21 Rummy Card Game), a famous card game played all over Nepal and in India and Bhutan by the people of the Nepalese Origin. Additionally, all around the world by Nepalsese and few Indian descendents. The games are widely played on the festivals and or some occasional gatherings and all over the year by the admirers."),
              ),
              SizedBox(
                child: StyledText(text: "Marriage Card Game", textSize: 24),
              ),
              Padding(
                padding: EdgeInsets.only(top: 6),
                child: SizedBox(
                  child: Text(
                      "In marriage card game, depending on your luck and skill you can receive points (Maal) from the deck and from the players alognside. The more the points the more you will win and vice versa."),
                ),
              ),
              ListTile(
                leading: Icon(Icons.circle),
                title: Text(
                  'Murder',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text(
                    "If a player/s is unable to see the Joker Card Either by Dublees or Sequences or Tunellas, the Maal or Points of the Unseen player will not count."),
              ),
              ListTile(
                leading: Icon(Icons.circle),
                title: Text(
                  'Dublee Bonus',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text(
                    "Dublee is a pair or exactly same cards. The Player With Dublee get's 5 Points Bonus, if the Player Finishes the Game."),
              ),
              ListTile(
                leading: Icon(Icons.circle),
                title: Text(
                  'Dublee Point Less',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text(
                    "The Player with Dublee Should not Pay 3 Points to the Winner. If he/she is not the Winner."),
              ),
              ListTile(
                leading: Icon(Icons.circle),
                title: Text(
                  'Kidnap',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text(
                    "The Unseen Player/s Should Pay for Their Points too. The points will be added to the points of the Winner."),
              ),
              ListTile(
                leading: Icon(Icons.circle),
                title: Text(
                  'Fine System',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text(
                    "When a play commits foul knowingly or unknowingly the player must pay fine amount as per the agreement between the players. Originally, 15 points is set as the fine points which may vary according to location or players."),
              ),
              ListTile(
                title: Text(
                  'Few Examples of Fouls',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text(
                    "Some famous and common fouls are:\n1. If a player cuts the deck for joker card if it's already cut by a player previously.\n\n2. If player cuts the deck for joker with incomplete or invalid sequence or joker.\n\n 3. If a player tries to complete the game with invalid trials, invalid jokers or sequences or dublees.\n \n4. If a seen player intentionally reveals the joker to the unseen player and if the same unseen player protests the player with the joker card info. (If the joker card is not as per claimed the player who protests will be fined).\n\n 5. If the seen player with doublee picks a card from the player before him/her and is unable to complete the game. That is, even if the card is any joker, if picked must complete the game otherwise he/she can't pick the card.\n\n* More importantly there might be some rules that are mutually agreed between the players as per the locations and players."),
              ),
              Text(
                  "For more information about the marriage card game and rules, visit the site given below by bhoos.com,\n"),
              CustomLink(
                link:
                    "https://www.bhoos.com/blog/learn-to-play-the-best-marriage-card-game/",
              ),
              Text(
                  "is the blog by Deb Mahato Upadted on: Sep 29,2023 (Last Seen)"),
              MyFooter()
            ],
          ),
        ),
      ),
    );
  }
}
