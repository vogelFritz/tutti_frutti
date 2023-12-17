import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tutti_frutti/config/menu_items/menu_items.dart';

class HomeScreen extends StatelessWidget {
  static const String name = 'home_screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Menu'),
        ),
        body: ListView(
          children: [
            ...menuItems.map((opcion) => ListTile(
                title: Text(opcion['title']),
                subtitle: Text(opcion['subTitle']),
                leading: opcion['icon'],
                onTap: () {
                  context.push(opcion['link']);
                }))
          ],
        ));
  }
}
