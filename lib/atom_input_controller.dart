import 'package:flutter/widgets.dart';

class AtomInputController extends TextEditingController {
  void listen(
    void Function(String? value) listener,
  ) {
    addListener(() {
      listener(text);
    });
  }
}
