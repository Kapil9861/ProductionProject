// Inside your Flutter Dart code

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class YourWidget extends StatelessWidget {
  static const platform = MethodChannel('com.example/url_launcher');

  Future<void> _launchURL(String url) async {
    try {
      await platform.invokeMethod('launchURL', {'url': url});
    } on PlatformException catch (e) {
      print("Failed to launch: '$e'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        _launchURL('https://example.com');
      },
      child: Text('Open Website'),
    );
  }
}
