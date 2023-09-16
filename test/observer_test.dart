import 'package:atom_notifier/atom_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    "Observer: ",
    () {
      testWidgets(
        "sut should rebuild child when atom value changes",
        (tester) async {
          final sut = AtomNotifier<int>(0);
          final widget = MaterialApp(
            home: Material(
              child: AtomObserver<int>(
                atom: sut,
                builder: (context, state) {
                  return Text(state.toString());
                },
              ),
            ),
          );
          await tester.pumpWidget(widget);

          expect(find.text("0"), findsOneWidget);
          expect(find.text("1"), findsNothing);

          sut.set(1);
          await tester.pumpAndSettle();

          expect(find.text("1"), findsOneWidget);
          expect(find.text("0"), findsNothing);
        },
      );

      testWidgets(
        "sut should rebuild child when one of the given atoms changed",
        (tester) async {
          final index = AtomNotifier<int>(0);
          final character = AtomNotifier<String>("Harry Potter");
          final widget = MaterialApp(
            home: Material(
              child: MultiAtomObserver(
                atoms: [index, character],
                builder: (context) {
                  final name = character.value;
                  final id = index.value;
                  return Text("$id: $name");
                },
              ),
            ),
          );
          await tester.pumpWidget(widget);

          expect(find.text("0: Harry Potter"), findsOneWidget);

          index.set(1);
          await tester.pumpAndSettle();

          expect(find.text("1: Harry Potter"), findsOneWidget);

          character.set("Hermione Granger");
          index.set(2);

          await tester.pumpAndSettle();
          expect(find.text("2: Hermione Granger"), findsOneWidget);
        },
      );

      testWidgets(
        "sut should rebuild widget according to atom value",
        (tester) async {
          final sut = AtomNotifier<Character?>(null);
          await tester.pumpWidget(
            MaterialApp(
              home: Material(
                child: PolymorphicAtomObserver<Character?>(
                  atom: sut,
                  defaultBuilder: (value) => const Text("It is null"),
                  types: [
                    TypedAtomHandler(
                      type: Player,
                      builder: (context, value) => const Text("Player"),
                    ),
                    TypedAtomHandler(
                      type: NPC,
                      builder: (context, value) => const Text("NPC"),
                    ),
                  ],
                ),
              ),
            ),
          );

          expect(find.text("It is null"), findsOneWidget);

          sut.set(Player());
          await tester.pumpAndSettle();

          expect(find.text("Player"), findsOneWidget);
          expect(find.text("It is null"), findsNothing);
          expect(find.text("NPC"), findsNothing);

          sut.set(NPC());
          await tester.pumpAndSettle();

          expect(find.text("Player"), findsNothing);
          expect(find.text("It is null"), findsNothing);
          expect(find.text("NPC"), findsOneWidget);
        },
      );
    },
  );
}

abstract class Character {}

class Player extends Character {}

class NPC extends Character {}
