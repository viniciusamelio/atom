import 'dart:async';
import 'interfaces.dart';

typedef Debouncer<T> = void Function(T value);

extension DebounceableAtom<T> on ListenableAtom<T> {
  void debounce(
    Debouncer<T> debounceFunction, {
    Duration interval = const Duration(
      milliseconds: 400,
    ),
  }) {
    Timer? timer;

    on<T>(
      (value) async {
        if (timer != null) {
          timer!.cancel();
        }

        timer = Timer(
          interval,
          () => debounceFunction(value),
        );
      },
    );
  }
}
