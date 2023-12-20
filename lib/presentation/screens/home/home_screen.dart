import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tutti_frutti/config/menu_items/menu_items.dart';

class HomeScreen extends StatelessWidget {
  static const String name = 'home_screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleLarge;
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text('Menu', style: textStyle),
                ...menuItems.map((opcion) => SizedBox(
                      width: 300,
                      height: 60,
                      child: ListTile(
                          titleAlignment: ListTileTitleAlignment.center,
                          title: Text(opcion['title']),
                          subtitle: Text(opcion['subTitle']),
                          onTap: () {
                            context.push(opcion['link']);
                          }),
                    ))
              ],
            ),
          ),
        ));
  }
}
