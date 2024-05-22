import 'package:flutter/material.dart';
import 'package:sajilo_hisab/widgets/smallWidgets/footer.dart';
import 'package:sajilo_hisab/widgets/styled_text.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});
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
            const SizedBox(
              child: StyledText(text: "Welcome to Sajilo Hisab!", textSize: 24),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: StyledText(
                  color: color,
                  text:
                      "Welcome to Sajilo Hisab, your ultimate point calculating application designed to enhance your experience playing the marriage card game and call break. Say goodbye to mind-boggling and hectic calculations that can sometimes dampen the fun of these beloved games. With Sajilo Hisab, you can enjoy seamless and accurate calculations, allowing you to focus on the excitement and strategy of the game itself."),
            ),
            const SizedBox(
              child: StyledText(text: "About Sajilo Hisab", textSize: 24),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: StyledText(
                  color: color,
                  text:
                      "Sajilo Hisab is more than just a point calculating app – it's your companion for making the marriage card game and call break even more interesting and enjoyable. Whether you're a seasoned player or new to the game, our app is here to simplify the scoring process, ensuring fair and accurate results every time."),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8),
              child: SizedBox(
                child: StyledText(text: "Features", textSize: 24),
              ),
            ),
            SizedBox(
              height: 1050,
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  ListTile(
                    leading: Icon(Icons.circle),
                    title: Text(
                      'Streamlined Point Calculation',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text(
                        "Sajilo Hisab takes the hassle out of scorekeeping by providing a user-friendly interface for entering and calculating points during the game. No more mental arithmetic or confusion – our app does the hard work for you.",
                        style: TextStyle(
                          fontSize: 16,
                        )),
                  ),
                  ListTile(
                    leading: Icon(Icons.circle),
                    title: Text(
                      'Smart Note Taking Facility',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text(
                        "Take note in every game when there is some foul committed by any player. You can utilize this facility for keeping records of the completed or incompleted transactions.",
                        style: TextStyle(
                          fontSize: 16,
                        )),
                  ),
                  ListTile(
                    leading: Icon(Icons.circle),
                    title: Text(
                      'Customizable Settings/Rules',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text(
                        "Tailor the app to suit your preferences with customizable settings for point values, game rules, and more. Sajilo Hisab adapts to your gameplay, ensuring a personalized experience every time.",
                        style: TextStyle(fontSize: 16)),
                  ),
                  ListTile(
                    leading: Icon(Icons.circle),
                    title: Text(
                      'Real-time Updates',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text(
                        "Stay up-to-date with real-time point updates as the game progresses. Know exactly where you stand and strategize accordingly to secure victory.",
                        style: TextStyle(fontSize: 16)),
                  ),
                  ListTile(
                    leading: Icon(Icons.circle),
                    title: Text(
                      'Intuitive Design',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text(
                        "Our app features an intuitive design that's easy to navigate, allowing you to focus on the game without distractions. Whether you're playing with friends or family, Sajilo Hisab keeps the fun flowing.",
                        style: TextStyle(fontSize: 16)),
                  ),
                  ListTile(
                    leading: Icon(Icons.circle),
                    title: Text(
                      'Share Game Results',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text(
                        "You will see the results of your game records you can share these data across multiple social platforms and also from drives and e-mails.",
                        style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8),
              child: SizedBox(
                child: StyledText(text: "Mission", textSize: 24),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: StyledText(
                  color: color,
                  text:
                      "At Sajilo Hisab, our mission is simple: to enhance your gaming experience by providing a reliable and efficient solution for point calculation. We believe that every player deserves a stress-free and enjoyable gaming experience, and our app is designed to make that a reality."),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: SizedBox(
                child: StyledText(
                  text: "Developed By: Kapil Aryal",
                  textSize: 22,
                  color: color,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
              ),
              child: SizedBox(
                child: StyledText(
                  text: "Special Thanks To:",
                  textSize: 20,
                  color: color,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: SizedBox(
                child: StyledText(
                    color: color,
                    text:
                        "Mr. Rohit Pandey (Supervisor and Helping in Report)\nAryal Family (Hari Prasad Aryal, Sudarsan Prasad Aryal, Krishna Prasad Aryal, Narayan Aryal, Kushal Aryal) For Helping During the Debugging\n\nShiwam Paudel(Helping during Development of Application)\n\n Pabitra Aryal and Sudeep Puri (Providing Moral Support) ",
                    textSize: 16),
              ),
            ),
            const MyFooter()
          ],
        ),
      ),
    );
  }
}
