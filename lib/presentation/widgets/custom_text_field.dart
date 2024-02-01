import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';

class CustomTextField extends ConsumerStatefulWidget {
  const CustomTextField({super.key});

  @override
  ConsumerState<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends ConsumerState<CustomTextField> {
  late TextEditingController _textController;

  @override
  void initState() {
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      decoration:
          const InputDecoration(label: Text('Tu nombre'), hintText: 'Juan'),
      onChanged: (_) {
        ref
            .read(userProvider.notifier)
            .update((state) => state.copyWith(nombre: _textController.text));
      },
    );
  }
}
