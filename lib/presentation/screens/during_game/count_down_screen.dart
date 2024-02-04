import 'package:flutter/material.dart';

class CountDownScreen extends StatefulWidget {
  static const String name = 'count_down_screen';

  const CountDownScreen({super.key});

  @override
  State<CountDownScreen> createState() => _CountDownScreenState();
}

class _CountDownScreenState extends State<CountDownScreen> {
  int _count = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(builder: (_) {
      return Text('e');
    }));
  }
}
