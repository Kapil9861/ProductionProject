import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

class CustomLink extends StatelessWidget {
  const CustomLink({super.key, required this.link});
  final String link;
  @override
  Widget build(BuildContext context) {
    return Link(
      uri: Uri.parse(link),
      builder: (BuildContext context, FollowLink? followLink) => ElevatedButton(
        onPressed: followLink,
        child: Text(link),
      ),
    );
  }
}
