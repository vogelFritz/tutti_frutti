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
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    _count = 3;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_count > 0) {
        setState(() {
          _count--;
        });
      } else {
        setState(() {
          timer.cancel();
          context.push('/game');
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child:
                Text(_count.toString(), style: const TextStyle(fontSize: 50))));
  }
}
