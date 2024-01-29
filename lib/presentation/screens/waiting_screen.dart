import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutti_frutti/presentation/providers/socket_provider.dart';

class WaitingScreen extends ConsumerWidget {
  static String name = 'waiting_screen';
  const WaitingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final socket = ref.watch(socketProvider);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          height: 600,
          width: 300,
          color: Colors.blueGrey,
          child: Column(
            children: [
              Text(ref.read(socketProvider.notifier).nombre),
              SingleChildScrollView(
                child: SizedBox(
                  height: 400,
                  width: 300,
                  child: ListView.builder(
                      itemCount: socket.nombresSalas.length,
                      itemBuilder: (_, i) {
                        final nombreSala = socket.nombresSalas[i];
                        return ListTile(title: Text(nombreSala));
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
