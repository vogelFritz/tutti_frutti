import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CountDownScreen extends StatefulWidget {
  static const String name = 'count_down_screen';

  const CountDownScreen({super.key});

  @override
  State<CountDownScreen> createState() => _CountDownScreenState();
}

class _CountDownScreenState extends State<CountDownScreen> {
  late int _count;
  @override
  void initState() {
    _count = 3;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _count--;
      });
      if (_count < 1) {
        timer.cancel();
        context.push('/game');
      }
    });
    return Scaffold(
        body: Center(
            child:
                Text(_count.toString(), style: const TextStyle(fontSize: 50))));
  }
}
