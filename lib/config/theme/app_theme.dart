import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  ThemeData getTheme() => ThemeData(
          textTheme: TextTheme(
              titleLarge: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 50,
                  shadows: [
            Shadow(color: Colors.black, offset: Offset.fromDirection(2.7, 5))
          ])));
}
