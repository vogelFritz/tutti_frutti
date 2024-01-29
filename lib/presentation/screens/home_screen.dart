import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutti_frutti/config/menu_items/menu_items.dart';
import 'package:tutti_frutti/presentation/providers/socket_provider.dart';

class HomeScreen extends ConsumerWidget {
  static const String name = 'home_screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final socket = ref.watch(socketProvider);
    final textStyle = Theme.of(context).textTheme.titleLarge;
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        body: Stack(
          children: [
            Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: const EdgeInsets.only(top: 35),
                  child: Column(
                    children: [
                      socket.serverStatus == ServerStatus.online
                          ? const Icon(Icons.check, color: Colors.blue)
                          : const Icon(Icons.wrong_location, color: Colors.red),
                      IconButton(
                        onPressed: socket.serverStatus == ServerStatus.online
                            ? null
                            : () {
                                ref.read(socketProvider.notifier).connect();
                              },
                        icon: const Icon(Icons.refresh),
                      ),
                    ],
                  ),
                )),
            Center(
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
            ),
          ],
        ));
  }
}
