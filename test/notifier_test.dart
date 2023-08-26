import 'package:atom/atom.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    "AtomNotifier: ",
    () {
      test(
        "sut should executes listener successfully",
        () {
          final atom = AtomNotifier<int>(1);
          bool listenerRan = false;
          atom.listen((_) {
            listenerRan = true;
          });

          atom.set(2);

          expect(listenerRan, true);
        },
      );

      test(
        "sut should executes listener successfully when using on()",
        () {
          final atom = AtomNotifier<State?>(null);
          bool listenerRan = false;
          atom.on<RightState>((_) => listenerRan = true);
          atom.on<WrongState>((_) => listenerRan = false);

          atom.set(RightState());

          expect(listenerRan, true);
        },
      );

      test("sut should stop all atom usage after being disposed", () {
        final atom = AtomNotifier<State?>(null);
        bool listenerRan = true;
        atom.on<WrongState>((_) => listenerRan = false);

        atom.set(WrongState());
        atom.dispose();

        expect(listenerRan, isFalse);

        expect(() => atom.set(RightState()), throwsFlutterError);
      });
    },
  );
}

abstract class State {}

class RightState extends State {}

class WrongState extends State {}
