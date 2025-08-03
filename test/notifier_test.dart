import 'package:atom_notifier/atom_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    "GetxAtomNotifier: ",
    () {
      test(
        "sut should executes listener successfully",
        () {
          final sut = GetxAtomNotifier<int>(1);
          bool listenerRan = false;
          sut.listen((_) {
            listenerRan = true;
          });

          sut.set(2);

          expect(listenerRan, true);
        },
      );

      test(
        "sut should remove listener successfully when calling removeListener",
        () {
          final sut = GetxAtomNotifier<int>(1);
          bool listenerRan = false;
          // ignore: prefer_function_declarations_over_variables
          final callback = () {
            listenerRan = !listenerRan;
          };

          sut.addListener(callback);
          sut.set(2);
          sut.removeListener(callback);
          sut.set(3);

          expect(listenerRan, true);
        },
      );
    },
  );
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
        "sut should executes listener successfully when adding it from addListener method",
        () {
          final sut = AtomNotifier<int>(1);
          bool listenerRan = false;
          sut.addListener(() {
            listenerRan = true;
          });

          sut.set(2);

          expect(listenerRan, true);
        },
      );

      test(
        "sut should remove listener successfully when calling removeListener",
        () {
          final sut = AtomNotifier<int>(1);
          bool listenerRan = false;
          // ignore: prefer_function_declarations_over_variables
          final callback = () {
            listenerRan = !listenerRan;
          };

          sut.addListener(callback);
          sut.set(2);
          sut.removeListener(callback);
          sut.set(3);

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
        sut.set(RightState());
        expect(listenerRan, isFalse);
        expect(sut.value, isA<WrongState>());
      });

      test("sut should remove non-filtered listener successfully", () async {
        final sut = AtomNotifier<int>(0);
        int counter = 0;
        void listener(int value) {
          counter++;
        }

        sut.listen(listener);

        sut.set(1);
        expect(counter, equals(1));

        sut.removeListeners();
        sut.set(2);

        expect(counter, equals(1));
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
          final sut = AtomNotifier<AtomAppState<String, int>>(InitialState());
          sut.onState(
            onError: (e) => counter++,
            onSuccess: (e) => counter--,
            onLoading: () => counter = counter * 2,
          );
          sut.set(LoadingState());

          expect(counter, equals(4));

          sut.fromError("Error");

          expect(counter, equals(5));

          sut.fromSuccess(2);

          expect(counter, equals(4));
        },
      );

      test(
        "sut should render widget according to checking made through TypedState extension",
        () {
          String state = "Initial";
          final sut = AtomNotifier<AtomAppState<String, int>>(InitialState());
          sut.listen((value) {
            if (value.isSuccess()) {
              state = "Success";
            } else if (value.isLoading()) {
              state = "Loading";
            } else if (value.isError()) {
              state = "Error";
            }
          });

          sut.set(LoadingState());
          expect(state, equals("Loading"));

          sut.fromError("Error");
          expect(sut.value.asError().error, equals("Error"));

          sut.set(const SuccessState(2));
          expect(state, equals("Success"));
          expect(sut.value.asSuccess().data, equals(2));
        },
      );
      testWidgets(
        "sut should show dialog on error state",
        (tester) async {
          final sut =
              AtomNotifier<AtomAppState<Exception, String>>(InitialState());

          await tester.pumpWidget(
            MaterialApp(
              home: Builder(builder: (context) {
                sut.onState(
                  onError: (error) {
                    showDialog(
                      context: context,
                      builder: (context) => const Dialog(
                        child: Text("Dialog Widget"),
                      ),
                    );
                  },
                );
                return const Scaffold();
              }),
            ),
          );

          expect(find.byType(Dialog), findsNothing);

          sut.set(ErrorState(Exception("Error")));

          await tester.pumpAndSettle();

          expect(find.byType(Dialog), findsOneWidget);
          expect(find.text("Dialog Widget"), findsOneWidget);
        },
      );
    },
  );
}

abstract class State {}

class RightState extends State {}

class WrongState extends State {}
