import 'package:atom_notifier/atom_notifier.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    "AtomNotifier: ",
    () {
      test(
        "sut should executes listener successfully",
        () {
          final sut = AtomNotifier<int>(1);
          bool listenerRan = false;
          sut.listen((_) {
            listenerRan = true;
          });

          sut.set(2);

          expect(listenerRan, true);
        },
      );

      test(
        "sut should executes listener successfully when using on()",
        () {
          final sut = AtomNotifier<State?>(null);
          bool listenerRan = false;
          sut.on<RightState>((_) => listenerRan = true);
          sut.on<WrongState>((_) => listenerRan = false);

          sut.set(RightState());

          expect(listenerRan, true);
        },
      );

      test("sut should stop all atom usage after being disposed", () {
        final sut = AtomNotifier<State?>(null);
        bool listenerRan = true;
        sut.on<WrongState>((_) => listenerRan = false);

        sut.set(WrongState());
        sut.dispose();

        expect(listenerRan, isFalse);

        expect(() => sut.set(RightState()), throwsFlutterError);
      });
    },
  );

  group(
    "AtomAppState: ",
    () {
      test(
        "sut should support AtomAppState with DefaultState mixin successfully ",
        () async {
          int counter = 2;
          final atom = AtomNotifier<AtomAppState<String, int>>(InitialState());
          atom.onState(
            onError: (e) => counter++,
            onSuccess: (e) => counter--,
            onLoading: () => counter = counter * 2,
          );
          atom.set(LoadingState());

          expect(counter, equals(4));

          atom.fromError("Error");

          expect(counter, equals(5));

          atom.fromSuccess(2);

          expect(counter, equals(4));
        },
      );
    },
  );
}

abstract class State {}

class RightState extends State {}

class WrongState extends State {}
