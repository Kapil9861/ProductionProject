import 'package:flutter/material.dart';
import 'package:sajilo_hisab/widgets/smallWidgets/link.dart';

class MyFooter extends StatelessWidget {
  const MyFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 40, bottom: 20),
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Visit Official Site: ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            CustomLink(link: "https://sajilohisab-production.up.railway.app/"),
            Text(
              '\nCopyright @2024, All Rights Reserved',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Developed by Kapil Aryal',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
