import 'package:atom_notifier/debounce.dart';
import 'package:atom_notifier/notifier.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    "Debounceable Atom: ",
    () {
      test(
        "debounced listener should run callback after given duration",
        () async {
          final sut = AtomNotifier<int>(0);
          final counter = GetxAtomNotifier<int>(0);
          sut.debounce(
            (value) => counter.set(value),
            interval: const Duration(
              milliseconds: 500,
            ),
          );

          sut.set(3);

          await Future.delayed(const Duration(milliseconds: 200));
          expect(counter.value, equals(0));

          await Future.delayed(const Duration(milliseconds: 300));
          expect(counter.value, equals(3));
        },
      );

      test(
        "debounced listener should cancel previous calls when made within interval range",
        () async {
          int changedNTimes = 0;
          final sut = GetxAtomNotifier<int>(0);
          final counter = AtomNotifier<int>(0);
          counter.on((_) => changedNTimes++);
          sut.debounce(
            (value) => counter.set(value),
            interval: const Duration(
              milliseconds: 500,
            ),
          );

          sut.set(3);
          sut.set(4);
          sut.set(5);

          await Future.delayed(const Duration(milliseconds: 200));
          expect(counter.value, equals(0));
          sut.set(6);

          await Future.delayed(const Duration(milliseconds: 300));
          expect(counter.value, equals(0));

          await Future.delayed(const Duration(milliseconds: 200));
          expect(counter.value, equals(6));
          expect(changedNTimes, equals(1));
        },
      );

      test(
        "debounced listener should not run callback if value didn't change",
        () async {
          int changedNTimes = 0;
          final sut = AtomNotifier<int>(0);
          final counter = GetxAtomNotifier<int>(0);
          counter.on((_) => changedNTimes++);
          sut.debounce(
            (value) => counter.set(value),
          );

          sut.set(0);
          await Future.delayed(const Duration(milliseconds: 400));

          expect(changedNTimes, equals(0));

          sut.set(1);
          await Future.delayed(const Duration(milliseconds: 400));

          expect(changedNTimes, equals(1));
        },
      );

      test(
        "debounced listener should not run callback after removing listeners",
        () async {
          int changedNTimes = 0;
          final sut = AtomNotifier<int>(0);
          final counter = GetxAtomNotifier<int>(0);
          counter.on((_) => changedNTimes++);
          sut.debounce(
            (value) => counter.set(value),
          );

          sut.set(0);
          await Future.delayed(const Duration(milliseconds: 400));

          expect(changedNTimes, equals(0));
          sut.removeListeners();
          sut.set(1);
          await Future.delayed(const Duration(milliseconds: 400));

          expect(changedNTimes, equals(0));
        },
      );
    },
  );
}
