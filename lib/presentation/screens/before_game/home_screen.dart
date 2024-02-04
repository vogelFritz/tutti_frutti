import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import 'package:tutti_frutti/presentation/providers/socket_provider.dart';
import 'package:tutti_frutti/presentation/widgets/widgets.dart';

class HomeScreen extends ConsumerWidget {
  static const String name = 'home_screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serverStatus = ref.watch(socketProvider);
    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme.titleLarge;
    return Scaffold(
        body: Stack(
      children: [
        Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: const EdgeInsets.only(top: 35),
              child: Column(
                children: [
                  serverStatus == ServerStatus.online
                      ? const Icon(Icons.check, color: Colors.blue)
                      : const Icon(Icons.close, color: Colors.red),
                  IconButton(
                    onPressed: serverStatus == ServerStatus.online
                        ? null
                        : () {
                            ref.read(socketProvider.notifier).connect();
                          },
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
            )),
        Positioned(
          width: size.width,
          top: size.height * 0.3,
          child: Column(
            children: [
              Text('Tutti Frutti', style: textStyle),
              const SizedBox(height: 30),
              SizedBox(
                  width: 300,
                  height: 60,
                  child: ListTile(
                    titleAlignment: ListTileTitleAlignment.center,
                    title: const Center(child: Text('Jugar')),
                    onTap: serverStatus == ServerStatus.online
                        ? () {
                            context.push('/game_options');
                          }
                        : () {
                            showDialog(
                              context: context,
                              builder: (context) => const NoConnectionDialog(),
                            );
                          },
                  )),
            ],
          ),
        ),
      ],
    ));
  }
}
