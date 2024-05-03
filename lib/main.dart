import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:sajilo_hisab/widgets/screens/start_screen.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 36, 17, 66),
);
var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 32, 44, 47),
);

void main() async {
  await Hive.initFlutter();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,
        cardTheme: CardTheme(
          color: kDarkColorScheme.primaryContainer,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: kDarkColorScheme.onPrimaryContainer),
          bodySmall: TextStyle(color: kDarkColorScheme.onPrimaryContainer),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: kDarkColorScheme.primaryContainer),
        ),
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kDarkColorScheme.onPrimary,
          foregroundColor: kDarkColorScheme.onPrimaryContainer,
        ),
      ),
      theme: ThemeData().copyWith(
        //Those that doesn't change change it manually
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorScheme.onPrimaryContainer,
          foregroundColor: kColorScheme.onPrimary,
        ),
        cardTheme: const CardTheme().copyWith(
          color: kColorScheme.primaryContainer,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: kColorScheme.primaryContainer),
        ),
        textTheme: const TextTheme().copyWith(
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: kColorScheme.onPrimaryContainer, //for manual and import use
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: kColorScheme.onPrimaryContainer, //for manual and import use
          ),
          bodyMedium: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: kColorScheme.onPrimaryContainer,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            // this is not required as this will be overridden in the AppBar by its foreground Color
            color: kColorScheme.onPrimaryContainer,
          ),
        ),
        dialogTheme: const DialogTheme().copyWith(
          backgroundColor: kColorScheme.primaryContainer,
          //can't set foreground color so need to do it manually
          //or from the text theme
        ),
      ),
      home: const StartScreen(),
    );
  }
}
