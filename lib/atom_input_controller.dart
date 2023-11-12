import 'package:flutter/widgets.dart';

class AtomInputController extends TextEditingController {
  void set(
    void Function(String? value) listener,
  ) {
    addListener(() {
      listener(text);
    });
  }
}
