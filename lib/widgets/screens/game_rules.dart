import 'package:flutter/material.dart';
import 'package:sajilo_hisab/widgets/smallWidgets/link.dart';
import 'package:sajilo_hisab/widgets/smallWidgets/footer.dart';
import 'package:sajilo_hisab/widgets/styled_text.dart';

class GamesRules extends StatelessWidget {
  const GamesRules({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SizedBox(
        height: 800,
        child: ListView(
          children: const [
            SizedBox(
              height: 230,
              // ignore: prefer_interpolation_to_compose_strings
              child: Text(
                  "Marriage (Also called as Myarrich or 21 Patti or 21 Rummy Card Game) and Call Break (13 Patti or Otti) are the two famous card games played all over Nepal and in India and Bhutan by the people of the Nepalese Origin. Additionally, all around the world by Nepalsese and few Indian descendents. The games are widely played on the festivals and or some occasional gatherings and all over the year by the admirers."),
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
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: SizedBox(
                child: StyledText(text: "Call Break", textSize: 24),
              ),
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
                  "This will help you to notify if the sum of all the players initial points(HAAT) is less than 10. Generally in this situation the rounded is ended providing every player 1 Otti. "),
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
            Text(
                "For more information about the marriage card game and rules, visit the site given below by bhoos.com,\n"),
            CustomLink(
              link:
                  "https://www.bhoos.com/blog/learn-to-play-the-best-marriage-card-game/",
            ),
            Text(
                "is the blog by Deb Mahato Upadted on: Sep 29,2023 (Last Seen)"),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text("And Call Break rules at firstgames.in:"),
            ),
            CustomLink(
              link:
                  "https://firstgames.in/blog/how-to-play-call-break-call-break-rules-in-detail",
            ),
            Text("Also a blog by Suraj Jayaswal on: Jun 2, 2021 (Last Seen)"),
            MyFooter()
          ],
        ),
      ),
    );
  }
}
