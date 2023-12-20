import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GoBackButton extends StatelessWidget {
  const GoBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        backgroundColor: Colors.black87,
        onPressed: () {
          context.pop();
        },
        child: const Icon(
          Icons.arrow_back_ios_new_outlined,
          color: Colors.deepOrange,
          size: 50,
        ));
  }
}
