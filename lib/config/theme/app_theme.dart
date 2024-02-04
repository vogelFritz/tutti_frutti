import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

const Color backgroundColor = Color(0xff292d36);

class AppTheme {
  ThemeData getTheme() => ThemeData(
        useMaterial3: true,
        textTheme: TextTheme(
            titleLarge:
                TextStyle(color: Colors.deepOrange, fontSize: 50, shadows: [
              Shadow(color: Colors.black, offset: Offset.fromDirection(2.7, 5))
            ]),
            displaySmall: const TextStyle(
              color: Colors.orangeAccent,
              fontSize: 35,
            ),
            displayLarge: const TextStyle(
              color: Colors.orangeAccent,
              fontSize: 80,
            )),
        scaffoldBackgroundColor: backgroundColor,
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: backgroundColor,
        ),
      );
}
