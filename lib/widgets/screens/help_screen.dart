import 'package:flutter/material.dart';
import 'package:sajilo_hisab/widgets/smallWidgets/custom_images.dart';
import 'package:sajilo_hisab/widgets/smallWidgets/footer.dart';
import 'package:sajilo_hisab/widgets/styled_text.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomImages(
              image: AssetImage('assets/images/logo/logo.png'),
            ),
            const SizedBox(
              child: StyledText(
                  text: "Welcome to Sajilo Hisab's Tutorial!", textSize: 24),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: StyledText(
                text: "Learn how to use the Sajilo Hisab in details!",
                color: color,
                textSize: 22,
              ),
            ),
            const SizedBox(
              child: StyledText(text: "For Marriage Card Game", textSize: 24),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8),
              child: Text(
                "Step 1:",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const CustomImages(
              image: AssetImage('assets/images/screenshots/1-min.png'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: StyledText(
                text: "Select Marriage Point Calculator",
                textSize: 20,
                color: color,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8),
              child: Text(
                "Step 2:",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const CustomImages(
              image: AssetImage('assets/images/screenshots/3-min.png'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: StyledText(
                color: color,
                text:
                    "Select the rules as per your decisions and comfortability and click on proceed.",
                textSize: 20,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8),
              child: Text(
                "Step 3:",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const CustomImages(
              image: AssetImage('assets/images/screenshots/4-min.png'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: StyledText(
                color: color,
                text:
                    "Enter the players playing with you, keep in mind that the minimum player is 2 and maximum 6 players can play together.",
                textSize: 20,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8),
              child: Text(
                "Step 4:",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const CustomImages(
              image: AssetImage('assets/images/screenshots/5-min.png'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: StyledText(
                color: color,
                text:
                    "Enter the players name of the individual players it does not matter where you sit while playing you will get absolutely reliable and correct results.",
                textSize: 20,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8),
              child: Text(
                "Step 5:",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(
              child: SingleChildScrollView(
                child: Row(
                  children: [
                    Expanded(
                      child: CustomImages(
                        image:
                            AssetImage('assets/images/screenshots/6-min.png'),
                      ),
                    ),
                    Expanded(
                      child: CustomImages(
                        image:
                            AssetImage('assets/images/screenshots/7-min.png'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: StyledText(
                color: color,
                text:
                    "Bravo!\n you have reached the calculator now! Now put the points per amount that you want to play with your friends and do not forget to input the fine amount and remember it will be the same if you pay the fine on the same game or another! Do not forget that you have minimum and maximum limit on both price per amount and fine amount. In price per point, it must be between 0.01 to 99999 and in fine points it must be between 5 and 100! Click at the Start button, to know that the game is running this will also ensure that there are not any invalid values entered in the fine points and per amount section. However, it will also be checked once clicked the calculate button.",
                textSize: 20,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8),
              child: Text(
                "Step 6:",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: StyledText(
                color: color,
                text:
                    "Now, press on the button to change the winner as shown in Second Image of Step: 5, remember there can be only one winner and if the player has not seen, is on hold or has committed foul in the same game he/she cannot win the game and after that input the win points by individual player and remember 3 points will be counted by the calculator itself so you must not add 3 points if you win! Then change if the player has seen, seen with dublee, is on hold, unseen or has committed foul then press the calculate button!",
                textSize: 20,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8),
              child: Text(
                "Step 7:",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: StyledText(
                color: color,
                text:
                    "Now you will see the points updated on the table below, here you cannot update the points of previous games, but you can delete the row if the game was cancelled after the game was completed in mutual understanding, by clicking on the data 3 times! And can provide entry if points are entered incorrectly.",
                textSize: 20,
              ),
            ),
            const SizedBox(
              child: SingleChildScrollView(
                child: Row(
                  children: [
                    Expanded(
                      child: CustomImages(
                        image: AssetImage('assets/images/screenshots/26.png'),
                      ),
                    ),
                    Expanded(
                      child: CustomImages(
                        image: AssetImage('assets/images/screenshots/27.png'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: StyledText(
                color: color,
                text:
                    "Below the table you can see the chart in which you can see who is winning the more than another.",
                textSize: 20,
              ),
            ),
            const CustomImages(
              image: AssetImage('assets/images/screenshots/31.png'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: StyledText(
                color: color,
                text:
                    "Remember if you have negative points your bar will be at 0 meaning you have not won anything may have lost instead.",
                textSize: 20,
              ),
            ),
            const SizedBox(
              child: StyledText(text: "For Call Break Card Game", textSize: 24),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8),
              child: Text(
                "Step 1:",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const CustomImages(
              image: AssetImage('assets/images/screenshots/2-min.png'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: StyledText(
                color: color,
                text: "Select CallBreak Point Calculator",
                textSize: 20,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8),
              child: Text(
                "Step 2:",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const CustomImages(
              image: AssetImage('assets/images/screenshots/8-min.png'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: StyledText(
                color: color,
                text:
                    "Now you are in the players rule screen which is similar to the player rule screen for marriage. Here, you have to choose the rules according to your group's preferences. After you press the proceed button, you will be taken to the call break home screen.",
                textSize: 20,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8),
              child: Text(
                "Step 3:",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const CustomImages(
              image: AssetImage('assets/images/screenshots/9-min.png'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: StyledText(
                color: color,
                text:
                    "In this screen you must provide the individual players' name and if two players have same name don't forget to provide with some number or any characters you want so that you can identify the players. Now, click on the start calculator to move to the calculator screen.",
                textSize: 20,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8),
              child: Text(
                "Step 4:",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const CustomImages(
              image: AssetImage('assets/images/screenshots/10-min.png'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: StyledText(
                color: color,
                text:
                    "Good Job!\n Now you are in the call break points calculator. Here you must provide the amount that must be paid by the losers. The amount should be for the 2nd, 3rd and the 4th players respectively. The amount must be greater than 5 and must be less than 100000! Click at the Start button, to know that the game is running this will also ensure that there is not any invalid values entered in the amount section for the players that comes 2nd, 3rd and 4th respectively. However, it will also be checked once clicked the calculate button. Then you should provide the initial haat(Haat Bolnu), before starting the game after distributing the cards. Then you should lock the initial haat so that the points cannot be changed while the game is running and after the game. Then provide the final points after the game is finished. Then you can calculate the points clicking on the calculate button and all the tasks will be handled by the calculator itself. Remember! you can directly calculate points without clicking the lock button however, if done so the points can be changed by any player unknowingly.",
                textSize: 20,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8),
              child: Text(
                "Step 5:",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(
              child: SingleChildScrollView(
                child: Row(
                  children: [
                    Expanded(
                      child: CustomImages(
                        image:
                            AssetImage('assets/images/screenshots/11-min.png'),
                      ),
                    ),
                    Expanded(
                      child: CustomImages(
                        image:
                            AssetImage('assets/images/screenshots/12-min.png'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: StyledText(
                color: color,
                text:
                    "As in the marriage points calculator you cannot change the points in here after entering the points and you can change the initial points once locked clicking in the same button once again. However, you can delete the game info if agreed between the players by swiping the data row right or left or you can just change the initial and final points without calculating the points.",
                textSize: 20,
              ),
            ),
            const SizedBox(
              child: SingleChildScrollView(
                child: Row(
                  children: [
                    Expanded(
                      child: CustomImages(
                        image: AssetImage('assets/images/screenshots/24.png'),
                      ),
                    ),
                    Expanded(
                      child: CustomImages(
                        image: AssetImage('assets/images/screenshots/28.png'),
                      ),
                    ),
                    Expanded(
                      child: CustomImages(
                        image: AssetImage('assets/images/screenshots/29.png'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8),
              child: Text(
                "Step 6:",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const CustomImages(
              image: AssetImage('assets/images/screenshots/32.png'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: StyledText(
                color: color,
                text:
                    "You can see the real time winner, between you and other player in a chart at the bottom of your screen once you scroll to the end as in marriage points calculator.",
                textSize: 20,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8),
              child: Text(
                "**Note: You will be assisted by some dialog box with information to guide you if you make some major errors. Also, for minor errors or for some valid information you will be guided by the form controls and snackbars as given below:",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(
              child: SingleChildScrollView(
                child: Row(
                  children: [
                    Expanded(
                      child: CustomImages(
                        image:
                            AssetImage('assets/images/screenshots/13-min.png'),
                      ),
                    ),
                    Expanded(
                      child: CustomImages(
                        image:
                            AssetImage('assets/images/screenshots/14-min.png'),
                      ),
                    ),
                    Expanded(
                      child: CustomImages(
                        image:
                            AssetImage('assets/images/screenshots/15-min.png'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8),
              child: Text(
                "\n**Finally: You can share the results of the both marriage card game and call-break points calculator with your friends on different platforms, clicking the button below the Results table.",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(
              child: SingleChildScrollView(
                child: Row(
                  children: [
                    Expanded(
                      child: CustomImages(
                        image: AssetImage('assets/images/screenshots/20.png'),
                      ),
                    ),
                    Expanded(
                      child: CustomImages(
                        image: AssetImage('assets/images/screenshots/22.png'),
                      ),
                    ),
                    Expanded(
                      child: CustomImages(
                        image: AssetImage('assets/images/screenshots/23.png'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: StyledText(
                color: color,
                text:
                    "Congratulations!\n You have completed the tutorial, you are fully capable to use the Sajilo Hisab app while playing the game.",
                textSize: 22,
              ),
            ),
            const MyFooter()
          ],
        ),
      ),
    );
  }
}
