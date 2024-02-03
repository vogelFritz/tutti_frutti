import 'package:flutter/material.dart';

class CountDownScreen extends StatelessWidget {
  static const String name = 'count_down_screen';

  const CountDownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('numbers')),
    );
  }
}
